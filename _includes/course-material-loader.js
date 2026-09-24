(function () {
  "use strict";

  const MANIFEST_URL = "{{ '/assets/data/course-materials.json' | relative_url }}";
  const HEDGE_MS = 700;
  const IDLE_MS = 12000;
  const TRANSFER_MS = 120000;
  const MAX_VERSION_CHANGES = 2;
  const params = new URLSearchParams(location.search);
  const materialPath = params.get("file");
  const fragment = (params.get("fragment") || location.hash.slice(1)).slice(0, 256);
  const ui = {};
  ["material-title", "status", "progress", "progress-text", "loading-panel", "actions", "pdf-viewer", "download-file", "open-direct", "retry"].forEach(function (id) {
    ui[id] = document.getElementById(id);
  });
  let active = null;
  let objectUrl = null;

  function failure(message, kind) {
    const error = new Error(message);
    error.kind = kind;
    return error;
  }

  function isCurrent(run) { return active === run && !run.stopped; }

  function stop(run) {
    if (!run) return;
    run.stopped = true;
    run.controllers.forEach(function (controller) { controller.abort(); });
    run.timers.forEach(function (timer) { clearTimeout(timer); });
    run.controllers.clear();
    run.timers.clear();
  }

  function controllerFor(run) {
    const controller = new AbortController();
    run.controllers.add(controller);
    return controller;
  }

  function validEntry(manifest) {
    if (!manifest || manifest.schema !== 1 || !manifest.materials || !Object.prototype.hasOwnProperty.call(manifest.materials, materialPath)) {
      throw failure("This material is not available. Please return to the course page.", "manifest");
    }
    const entry = manifest.materials[materialPath];
    if (!entry || entry.path !== materialPath || !/^\/assets\/courses\/pba\/[^/]+\.(pdf|r)$/i.test(entry.path) ||
        !/^[a-f0-9]{64}$/.test(entry.sha256) || !Number.isSafeInteger(entry.bytes) || entry.bytes <= 0 ||
        typeof entry.filename !== "string" || entry.filename.includes("/")) {
      throw failure("The material details could not be checked. Please try again.", "manifest");
    }
    return entry;
  }

  async function latestEntry(run) {
    const controller = controllerFor(run);
    const timeout = setTimeout(function () { controller.abort(); }, IDLE_MS);
    const url = new URL(MANIFEST_URL, location.origin);
    url.searchParams.set("check", Date.now().toString(36) + Math.random().toString(36).slice(2));
    try {
      const response = await fetch(url.href, { cache: "no-store", credentials: "omit", signal: controller.signal });
      if (!response.ok) throw failure("The latest material could not be checked. Please try again.", "manifest");
      return validEntry(await response.json());
    } finally {
      clearTimeout(timeout);
      run.controllers.delete(controller);
    }
  }

  function mirrorUrl(entry) {
    if (typeof entry.mirror_url !== "string") return null;
    try {
      const url = new URL(entry.mirror_url);
      const expected = /^\/gh\/j1yoo\/j1yoo\.github\.io@[a-f0-9]{40}(\/assets\/courses\/pba\/[^/]+)$/;
      const match = decodeURIComponent(url.pathname).match(expected);
      if (url.protocol === "https:" && url.hostname === "gcore.jsdelivr.net" && !url.search && !url.hash && match && match[1] === entry.path) return url.href;
    } catch (error) { /* An unusable mirror does not disable the original. */ }
    return null;
  }

  function showProgress(run, received, expected) {
    if (!isCurrent(run)) return;
    run.received = Math.max(run.received || 0, received);
    ui.progress.max = expected;
    ui.progress.value = run.received;
    ui["progress-text"].textContent = (run.received / 1000000).toFixed(1) + " / " + (expected / 1000000).toFixed(1) + " MB";
  }

  async function verifiedBytes(url, entry, run, controller) {
    let idle;
    const resetIdle = function () {
      clearTimeout(idle);
      idle = setTimeout(function () { controller.abort(); }, IDLE_MS);
    };
    const total = setTimeout(function () { controller.abort(); }, TRANSFER_MS);
    resetIdle();
    try {
      const response = await fetch(url, { cache: "no-store", credentials: "omit", signal: controller.signal });
      if (!response.ok) throw failure("The material could not be loaded.", "network");
      resetIdle();
      const chunks = [];
      let received = 0;
      if (!response.body || !response.body.getReader) throw failure("This browser could not load the material automatically.", "network");
      const reader = response.body.getReader();
      while (true) {
        const part = await reader.read();
        if (part.done) break;
        received += part.value.byteLength;
        if (received > entry.bytes) throw failure("The material has changed. Please try again.", "integrity");
        chunks.push(part.value);
        showProgress(run, received, entry.bytes);
        resetIdle();
      }
      if (received !== entry.bytes) throw failure("The material was incomplete. Please try again.", "integrity");
      const bytes = new Uint8Array(received);
      let offset = 0;
      chunks.forEach(function (chunk) { bytes.set(chunk, offset); offset += chunk.byteLength; });
      const digest = await crypto.subtle.digest("SHA-256", bytes);
      const hash = Array.from(new Uint8Array(digest)).map(function (b) { return b.toString(16).padStart(2, "0"); }).join("");
      if (hash !== entry.sha256) throw failure("The material has changed. Please try again.", "integrity");
      return bytes;
    } finally {
      clearTimeout(idle);
      clearTimeout(total);
      controller.abort();
      run.controllers.delete(controller);
    }
  }

  function receive(entry, run) {
    const origin = new URL(entry.path, location.origin);
    origin.searchParams.set("v", entry.sha256);
    const mirror = mirrorUrl(entry);
    return new Promise(function (resolve, reject) {
      let finished = false;
      let mirrorStarted = false;
      let pending = 0;
      let lastError;
      let hedge;
      const transfers = [];

      function launch(url) {
        pending++;
        const controller = controllerFor(run);
        transfers.push(controller);
        verifiedBytes(url, entry, run, controller).then(function (bytes) {
          if (finished) return;
          finished = true;
          clearTimeout(hedge);
          run.timers.delete(hedge);
          transfers.forEach(function (other) { other.abort(); });
          resolve(bytes);
        }).catch(function (error) {
          pending--;
          lastError = error;
          if (finished) return;
          if (mirror && !mirrorStarted) startMirror();
          if (pending === 0) {
            finished = true;
            clearTimeout(hedge);
            run.timers.delete(hedge);
            reject(lastError);
          }
        });
      }

      function startMirror() {
        if (finished || mirrorStarted || !isCurrent(run)) return;
        mirrorStarted = true;
        clearTimeout(hedge);
        run.timers.delete(hedge);
        launch(mirror);
      }

      launch(origin.href);
      if (mirror) {
        hedge = setTimeout(startMirror, HEDGE_MS);
        run.timers.add(hedge);
      }
    });
  }

  function present(bytes, entry, run) {
    if (!isCurrent(run)) return;
    const isPdf = /\.pdf$/i.test(entry.path);
    objectUrl = URL.createObjectURL(new Blob([bytes], { type: isPdf ? "application/pdf" : "text/plain;charset=utf-8" }));
    ui["download-file"].href = objectUrl;
    ui["download-file"].download = entry.filename;
    ui["download-file"].hidden = false;
    ui["loading-panel"].hidden = true;
    ui.status.textContent = isPdf ? "Ready." : "Your download is ready.";
    if (isPdf) {
      const viewerUrl = objectUrl + (fragment ? "#" + fragment : "");
      ui["open-direct"].href = viewerUrl;
      ui["open-direct"].hidden = false;
      ui["pdf-viewer"].src = viewerUrl;
      ui["pdf-viewer"].title = entry.filename;
      ui["pdf-viewer"].hidden = false;
    } else {
      ui["download-file"].click();
    }
  }

  async function start() {
    stop(active);
    const run = { controllers: new Set(), timers: new Set(), stopped: false, received: 0 };
    active = run;
    ui["pdf-viewer"].hidden = true;
    ui["pdf-viewer"].removeAttribute("src");
    if (objectUrl) { URL.revokeObjectURL(objectUrl); objectUrl = null; }
    ["download-file", "open-direct", "retry"].forEach(function (id) { ui[id].hidden = true; });
    ui["loading-panel"].hidden = false;
    ui.progress.hidden = false;
    ui.progress.removeAttribute("value");
    ui["progress-text"].textContent = "Checking the latest material…";
    ui.status.textContent = "Opening course material…";
    try {
      if (!window.crypto || !crypto.subtle || !window.AbortController || !materialPath) throw failure("This material could not be opened automatically. Please use a current browser and the course link.", "browser");
      let entry = await latestEntry(run);
      for (let changes = 0; changes <= MAX_VERSION_CHANGES; changes++) {
        if (!isCurrent(run)) return;
        ui["material-title"].textContent = entry.filename;
        document.title = entry.filename;
        run.received = 0;
        let bytes;
        let transferError;
        try { bytes = await receive(entry, run); } catch (error) { transferError = error; }
        if (!isCurrent(run)) return;
        // Never show an older verified download if a new version was published while receiving it.
        const latest = await latestEntry(run);
        if (!isCurrent(run)) return;
        if (latest.sha256 !== entry.sha256 || latest.bytes !== entry.bytes) {
          entry = latest;
          ui.status.textContent = "The material was updated. Opening the latest version…";
          continue;
        }
        if (transferError) throw transferError;
        present(bytes, latest, run);
        return;
      }
      throw failure("The material is being updated. Please try again.", "version");
    } catch (error) {
      if (!isCurrent(run)) return;
      ui.status.textContent = "Could not open the latest material. Please try again.";
      ui["progress-text"].textContent = "No unverified or older copy has been opened.";
      ui.progress.hidden = true;
      ui.retry.hidden = false;
    }
  }

  ui.retry.addEventListener("click", function () { ui.progress.hidden = false; start(); });
  window.addEventListener("pagehide", function () { stop(active); });
  window.addEventListener("pageshow", function (event) { if (event.persisted) start(); });
  start();
})();
