#!/usr/bin/env node
/*
 * Browser fault tests for the course-material and site-file loader, plus a check of the built manifest and CV pages.
 * Run against a built Jekyll site:
 *   node _scripts/test_course_materials.cjs /path/to/_site
 * Uses PLAYWRIGHT_MODULE / CHROME_EXECUTABLE when provided. No live CDN calls.
 */
"use strict";

const assert = require("node:assert/strict");
const crypto = require("node:crypto");
const fs = require("node:fs");
const http = require("node:http");
const path = require("node:path");
const { performance } = require("node:perf_hooks");

const site = path.resolve(process.argv[2] || "/tmp/j1yoo-pba-failover-20260924");
const playwrightModule = process.env.PLAYWRIGHT_MODULE || "/Users/J1Yoo/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules/playwright";
const { chromium } = require(playwrightModule);
const executablePath = process.env.CHROME_EXECUTABLE || "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome";
const pdfPath = "/assets/courses/pba/Fault-Test.pdf";
const rPath = "/assets/courses/pba/Fault-Test.R";
const eciPdfPath = "/assets/courses/eci/Fault-Test.pdf";
const otherPdfPath = "/assets/courses/xyz/Fault-Test.pdf";
const sitePdfPath = "/assets/pdf/Fault-Test.pdf";
const cvPaths = ["/assets/pdf/cv_jaewon.pdf", "/assets/pdf/CV-Fault-Test.pdf", "/assets/pdf/Fault-Test-Resume.pdf"];
const offShapePaths = ["/assets/pdf/talks/Fault-Test.pdf", "/assets/pdf/Fault-Test.html", "/Fault-Test.pdf"];
const originPaths = [pdfPath, rPath, eciPdfPath, otherPdfPath, sitePdfPath, ...cvPaths, ...offShapePaths];
const sha256 = (data) => crypto.createHash("sha256").update(data).digest("hex");

// A complete one-page PDF, so browser PDF handling is exercised too.
function pdf(text) {
  const content = `BT /F1 12 Tf 36 100 Td (${text}) Tj ET\n`;
  const objects = [
    "<< /Type /Catalog /Pages 2 0 R >>",
    "<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
    "<< /Type /Page /Parent 2 0 R /MediaBox [0 0 200 150] /Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
    "<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
    `<< /Length ${Buffer.byteLength(content)} >>\nstream\n${content}endstream`,
  ];
  let body = "%PDF-1.4\n";
  const offsets = [0];
  for (const [i, object] of objects.entries()) {
    offsets.push(Buffer.byteLength(body));
    body += `${i + 1} 0 obj\n${object}\nendobj\n`;
  }
  const xref = Buffer.byteLength(body);
  body += `xref\n0 ${objects.length + 1}\n0000000000 65535 f \n`;
  body += offsets.slice(1).map((offset) => `${String(offset).padStart(10, "0")} 00000 n \n`).join("");
  body += `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${xref}\n%%EOF\n`;
  return Buffer.from(body);
}

const currentPdf = pdf("Current version B");
const previousPdf = pdf("Previousversion A");
assert.equal(currentPdf.length, previousPdf.length, "wrong-hash fixture must have the correct byte count");
const currentR = Buffer.from("# verified course material\nx <- c(1, 2, 3)\nmean(x)\n");

let base;
let active;
let browser;
const sockets = new Set();

function entry(file, bytes) {
  return {
    path: file,
    filename: path.posix.basename(file),
    bytes: bytes.length,
    sha256: sha256(bytes),
    mime: file.endsWith(".pdf") ? "application/pdf" : "text/plain",
    mirror_url: `https://gcore.jsdelivr.net/gh/j1yoo/j1yoo.github.io@${sha256(bytes).slice(0, 40)}${file}`,
  };
}

function manifest(bytes = currentPdf, file = pdfPath) {
  return {
    schema: 1,
    generated_at: "2026-09-24T00:00:00Z",
    revision: sha256(bytes).slice(0, 40),
    materials: { [file]: entry(file, bytes) },
  };
}

function respond(res, body, status = 200, mime = "application/pdf") {
  const bytes = Buffer.isBuffer(body) ? body : Buffer.from(body);
  res.writeHead(status, {
    "Content-Type": mime,
    "Content-Length": bytes.length,
    "Cache-Control": "no-store",
    "Access-Control-Allow-Origin": "*",
  });
  res.end(bytes);
}

function delayedBody(res, bytes, delayMs) {
  const timer = setTimeout(() => {
    if (!res.destroyed) respond(res, bytes);
  }, delayMs);
  res.on("close", () => clearTimeout(timer));
}

const server = http.createServer((req, res) => {
  const url = new URL(req.url, "http://localhost");
  const state = active;
  const record = { path: url.pathname, url: url.href, at: performance.now(), aborted: false };
  if (state) state.requests.push(record);
  res.on("close", () => { record.aborted = !res.writableEnded; });
  if (url.pathname === "/assets/data/course-materials.json") {
    state.manifestCount += 1;
    const result = state.getManifest(state.manifestCount);
    if (typeof result === "number") return respond(res, "manifest unavailable", result, "text/plain");
    return respond(res, JSON.stringify(result), 200, "application/json");
  }
  if (originPaths.includes(url.pathname)) {
    state.originCount += 1;
    return state.origin(req, res, state.originCount);
  }
  if (url.pathname.startsWith("/mirror/")) {
    state.mirrorCount += 1;
    return state.mirror(req, res, state.mirrorCount);
  }
  let resource = path.resolve(site, `.${decodeURIComponent(url.pathname)}`);
  if (!resource.startsWith(`${site}${path.sep}`)) return respond(res, "Forbidden", 403, "text/plain");
  try {
    if (fs.statSync(resource).isDirectory()) resource = path.join(resource, "index.html");
    const mime = { ".html": "text/html", ".js": "text/javascript", ".css": "text/css", ".svg": "image/svg+xml" }[path.extname(resource)] || "application/octet-stream";
    return respond(res, fs.readFileSync(resource), 200, mime);
  } catch {
    return respond(res, "Not found", 404, "text/plain");
  }
});
server.on("connection", (socket) => {
  sockets.add(socket);
  socket.on("close", () => sockets.delete(socket));
});

function defaults() {
  return {
    requests: [],
    manifestCount: 0,
    originCount: 0,
    mirrorCount: 0,
    getManifest: () => manifest(),
    origin: (_req, res) => respond(res, currentPdf),
    mirror: (_req, res) => respond(res, currentPdf),
  };
}

async function open(page, file = pdfPath, fragment = "") {
  await page.goto(`${base}/teaching/material/?file=${encodeURIComponent(file)}${fragment}`, { waitUntil: "domcontentloaded" });
}

async function ready(page) {
  await page.waitForFunction(() => /^(Ready\.|Your download is ready\.)$/.test(document.querySelector("#status")?.textContent.trim() || ""), null, { timeout: 6500 });
}

async function failure(page) {
  await page.waitForFunction(() => /could not|not found|unknown|not available|unavailable|invalid|unsupported|not recognized/i.test(document.querySelector("#status")?.textContent || ""), null, { timeout: 6500 });
  assert.equal(await page.locator("#pdf-viewer").getAttribute("src"), null, "failure must never expose a PDF blob");
  const href = await page.locator("#download-file").getAttribute("href");
  assert.ok(!href || !href.startsWith("blob:"), "failure must never expose a download blob");
}

// GA4 calls the loader queued with gtag(); gtag.js itself is blocked in these offline tests.
async function gaEvents(page) {
  return page.evaluate(() => (window.dataLayer || []).map((call) => Array.from(call))
    .filter((call) => call[0] === "event").map((call) => ({ name: call[1], params: call[2] || {} })));
}

// The owner marker is queued as gtag("set", "user_properties", { site_role }) before the config call.
async function siteRole(page) {
  return page.evaluate(() => {
    const calls = (window.dataLayer || []).map((call) => Array.from(call));
    const set = calls.findIndex((call) => call[0] === "set" && call[1] === "user_properties");
    const config = calls.findIndex((call) => call[0] === "config");
    if (set === -1) return null;
    if (config !== -1 && set > config) throw new Error("site_role must be set before the GA config call");
    return calls[set][2].site_role;
  });
}

async function verifyBlob(page, expected, file = pdfPath) {
  await ready(page);
  const download = page.locator("#download-file");
  assert.equal(await download.getAttribute("download"), path.posix.basename(file));
  const href = await download.getAttribute("href");
  assert.match(href, /^blob:/, "download must use the verified body");
  const bytes = await page.evaluate(async (url) => Array.from(new Uint8Array(await (await fetch(url)).arrayBuffer())), href);
  assert.equal(sha256(Buffer.from(bytes)), sha256(expected), "the published blob must have the expected contents");
  if (file.endsWith(".pdf")) {
    const source = await page.locator("#pdf-viewer").getAttribute("src");
    assert.equal(source.split("#")[0], href, "preview and download must use the same verified body");
  }
  const checks = await page.evaluate(() => window.__materialFetches.filter((item) => item.url.includes("/assets/data/course-materials.json")));
  assert.ok(checks.length >= 2, "a fresh manifest must be read again before display");
  for (const check of checks) {
    assert.equal(check.cache, "no-store", "manifest fetches must bypass HTTP cache");
    assert.ok(new URL(check.url, base).searchParams.get("check"), "manifest fetches must have a cache-busting query");
  }
}

async function run(name, configure, check) {
  active = Object.assign(defaults(), configure || {});
  const state = active;
  const context = await browser.newContext({ acceptDownloads: true });
  // Keep the tests offline except for the local fixture server.
  await context.route("**/*", (route) => {
    const url = new URL(route.request().url());
    if (url.origin === base || url.protocol === "blob:") return route.continue();
    if (url.hostname === "gcore.jsdelivr.net") {
      // A redirect keeps real browser streaming semantics for the CDN body too.
      return route.fulfill({
        status: 302,
        headers: {
          location: `${base}/mirror/${path.posix.basename(url.pathname)}`,
          "access-control-allow-origin": "*",
          "cache-control": "no-store",
        },
        body: "",
      });
    }
    return route.abort();
  });
  await context.addInitScript(() => {
    window.__materialFetches = [];
    const fetchOriginal = window.fetch;
    window.fetch = function (input, init) {
      window.__materialFetches.push({ url: String(input), cache: init?.cache });
      return fetchOriginal.apply(this, arguments);
    };
  });
  const page = await context.newPage();
  const started = performance.now();
  try {
    await check(page, state);
    console.log(`PASS ${name} (${Math.round(performance.now() - started)} ms)`);
  } catch (error) {
    console.error(`FAIL ${name}`);
    console.error("Status:", await page.locator("#status").textContent().catch(() => "missing"));
    console.error("Requests:", JSON.stringify(state.requests.map(({ path: routePath, aborted }) => ({ path: routePath, aborted }))));
    throw error;
  } finally {
    await context.close();
  }
}

// The build itself: outside the course folders the manifest lists only 1 to 20 MB downloads, never a CV,
// and the CV pages (/cv_print/ is printed to the CV PDF) keep direct links.
function checkBuiltSite() {
  const built = JSON.parse(fs.readFileSync(path.join(site, "assets/data/course-materials.json"), "utf8"));
  const siteEntries = Object.values(built.materials).filter((item) => !/^\/assets\/courses\/(pba|eci)\//.test(item.path));
  for (const item of siteEntries) {
    assert.match(item.path, /^\/assets\/[\w-]+\/[^/]+\.(pdf|pptx?|docx?|xlsx|zip|r|rmd|qmd|ipynb)$/i, `${item.path} is not a site download`);
    assert.doesNotMatch(path.posix.basename(item.path), /^cv|resume/i, `${item.path} must stay a direct link`);
    assert.ok(item.bytes >= 1000000 && item.bytes <= 20000000, `${item.path} must be between 1 MB and 20 MB`);
  }
  const cvPages = fs.readdirSync(site).filter((name) => /^cv|resume/i.test(name) && fs.existsSync(path.join(site, name, "index.html")));
  assert.ok(cvPages.includes("cv"), "the CV page must be built");
  for (const name of cvPages) {
    const html = fs.readFileSync(path.join(site, name, "index.html"), "utf8");
    assert.ok(!html.includes("/teaching/material/") && !html.includes("data-material-path"), `/${name}/ must keep direct links`);
  }
  console.log(`PASS the build routes ${siteEntries.length} site file(s) and leaves ${cvPages.map((name) => `/${name}/`).join(" and ")} direct`);
}

async function main() {
  assert.ok(fs.existsSync(path.join(site, "teaching/material/index.html")), `Build the site first; missing ${site}/teaching/material/index.html`);
  checkBuiltSite();
  await new Promise((resolve) => server.listen(0, "127.0.0.1", resolve));
  base = `http://127.0.0.1:${server.address().port}`;
  browser = await chromium.launch({ executablePath, headless: true });

  await run("slow origin headers trigger a verified CDN hedge", {
    origin: () => {},
  }, async (page, state) => {
    await open(page, pdfPath, "#page=2");
    await verifyBlob(page, currentPdf);
    const origin = state.requests.find((item) => item.path === pdfPath);
    const mirror = state.requests.find((item) => item.path.startsWith("/mirror/"));
    assert.ok(mirror, "the hedge must start while the origin is pending");
    assert.ok(mirror.at - origin.at >= 500 && mirror.at - origin.at < 2500, "the hedge should start near its 700 ms deadline");
    await page.waitForTimeout(30);
    assert.ok(origin.aborted, "the losing origin request must be aborted");
    assert.match(await page.locator("#pdf-viewer").getAttribute("src"), /#page=2/, "the PDF page fragment must survive");
  });

  await run("fast headers with a stalled origin body still trigger failover", {
    origin: (_req, res) => {
      res.writeHead(200, { "Content-Type": "application/pdf", "Content-Length": currentPdf.length, "Access-Control-Allow-Origin": "*" });
      res.flushHeaders();
      res.write(currentPdf.subarray(0, 24));
      // Intentionally leave the body incomplete until the browser aborts it.
    },
  }, async (page, state) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    assert.equal(state.mirrorCount, 1);
    await page.waitForTimeout(30);
    assert.ok(state.requests.find((item) => item.path === pdfPath).aborted, "the stalled body must be canceled");
  });

  await run("a failed CDN does not cancel the successful origin", {
    origin: (_req, res) => delayedBody(res, currentPdf, 1100),
    mirror: (_req, res) => respond(res, "unavailable", 503, "text/plain"),
  }, async (page, state) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    assert.equal(state.mirrorCount, 1);
  });

  await run("a valid origin cancels a stalled CDN body", {
    origin: (_req, res) => delayedBody(res, currentPdf, 1100),
    mirror: (_req, res) => {
      res.writeHead(200, { "Content-Type": "application/pdf", "Content-Length": currentPdf.length, "Access-Control-Allow-Origin": "*" });
      res.flushHeaders();
      res.write(currentPdf.subarray(0, 24));
    },
  }, async (page, state) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    await page.waitForTimeout(30);
    assert.ok(state.requests.find((item) => item.path.startsWith("/mirror/")).aborted, "the losing CDN request must be aborted");
  });

  await run("a same-size old CDN copy cannot beat the valid origin", {
    origin: (_req, res) => delayedBody(res, currentPdf, 1150),
    mirror: (_req, res) => respond(res, previousPdf),
  }, async (page, state) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    assert.equal(state.mirrorCount, 1);
  });

  await run("a wrong-hash CDN copy is rejected when origin also fails", {
    origin: (_req, res) => respond(res, "unavailable", 503, "text/plain"),
    mirror: (_req, res) => respond(res, previousPdf),
  }, async (page) => {
    await open(page);
    await failure(page);
  });

  await run("an unavailable initial manifest fails closed", {
    getManifest: () => 503,
  }, async (page, state) => {
    await open(page);
    await failure(page);
    assert.equal(state.originCount + state.mirrorCount, 0, "unverifiable material must not be requested");
  });

  await run("an unavailable final manifest fails closed", {
    getManifest: (number) => number === 1 ? manifest() : 503,
  }, async (page, state) => {
    await open(page);
    await failure(page);
    assert.ok(state.manifestCount >= 2);
  });

  await run("a manifest update during download restarts with current bytes", {
    getManifest: (number) => manifest(number === 1 ? previousPdf : currentPdf),
    origin: (_req, res, number) => respond(res, number === 1 ? previousPdf : currentPdf),
  }, async (page, state) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    assert.ok(state.originCount >= 2, "changed material must be downloaded again");
    assert.ok(state.manifestCount >= 3, "the replacement body needs its own final manifest check");
  });

  await run("continual manifest changes stop after bounded retries", {
    getManifest: (number) => manifest(number % 2 === 1 ? previousPdf : currentPdf),
    origin: (req, res) => respond(res, new URL(req.url, base).searchParams.get("v") === sha256(previousPdf) ? previousPdf : currentPdf),
  }, async (page, state) => {
    await open(page);
    await failure(page);
    assert.ok(state.originCount <= 3, "at most two restarts may occur");
    assert.ok(state.originCount >= 2, "a changed manifest should first retry current bytes");
  });

  await run("unknown material paths cannot bypass the manifest", {}, async (page, state) => {
    await open(page, "/assets/courses/pba/Not-In-Manifest.pdf");
    await failure(page);
    assert.equal(state.originCount + state.mirrorCount, 0);
  });

  await run("unknown manifest schema is rejected", {
    getManifest: () => ({ ...manifest(), schema: 999 }),
  }, async (page, state) => {
    await open(page);
    await failure(page);
    assert.equal(state.originCount + state.mirrorCount, 0);
  });

  await run("R downloads preserve the verified body and filename", {
    getManifest: () => manifest(currentR, rPath),
    origin: (_req, res) => respond(res, currentR, 200, "text/plain"),
  }, async (page) => {
    const pending = page.waitForEvent("download");
    await open(page, rPath);
    await verifyBlob(page, currentR, rPath);
    const download = await pending;
    assert.equal(download.suggestedFilename(), "Fault-Test.R");
    const chunks = [];
    for await (const chunk of await download.createReadStream()) chunks.push(chunk);
    assert.deepEqual(Buffer.concat(chunks), currentR);
  });

  await run("an ECI PDF with a stalled origin is delivered by the verified CDN hedge", {
    getManifest: () => manifest(currentPdf, eciPdfPath),
    origin: () => {},
  }, async (page, state) => {
    await open(page, eciPdfPath);
    await verifyBlob(page, currentPdf, eciPdfPath);
    assert.equal(state.mirrorCount, 1, "the ECI mirror must pass the allowlist");
    await page.waitForTimeout(30);
    assert.ok(state.requests.find((item) => item.path === eciPdfPath).aborted, "the stalled ECI origin must be canceled");
  });

  await run("ECI materials use ECI colors and PBA colors are unchanged", {
    getManifest: () => ({ ...manifest(), materials: { [pdfPath]: entry(pdfPath, currentPdf), [eciPdfPath]: entry(eciPdfPath, currentPdf) } }),
  }, async (page) => {
    for (const [file, course, accent] of [[eciPdfPath, "eci", "rgb(181, 9, 172)"], [pdfPath, null, "rgb(38, 152, 186)"]]) {
      await open(page, file);
      await verifyBlob(page, currentPdf, file);
      const theme = await page.evaluate(() => [document.documentElement.getAttribute("data-course"), getComputedStyle(document.getElementById("progress")).accentColor]);
      assert.deepEqual(theme, [course, accent], `${file} must use its course colors`);
    }
  });

  await run("a manifest entry in another course folder is rejected", {
    getManifest: () => manifest(currentPdf, otherPdfPath),
  }, async (page, state) => {
    await open(page, otherPdfPath);
    await failure(page);
    assert.equal(state.originCount + state.mirrorCount, 0, "materials in other course folders must not be requested");
  });

  await run("a verified view is reported to GA4 with file, course, source, and load time", {}, async (page) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    const views = (await gaEvents(page)).filter((event) => event.name === "material_view");
    assert.equal(views.length, 1, "exactly one material_view per verified open");
    const view = views[0].params;
    assert.equal(view.file_name, "Fault-Test.pdf");
    assert.equal(view.file_extension, "pdf");
    assert.equal(view.course, "pba");
    assert.equal(view.source, "origin");
    assert.equal(view.file_size, currentPdf.length);
    assert.ok(Number.isInteger(view.load_ms) && view.load_ms >= 0, "load_ms must be a whole number of milliseconds");
    assert.ok(await page.evaluate(() => Object.keys(window).some((key) => key.startsWith("ga-disable-") && window[key] === true)), "GA must stay off outside github.io");
  });

  await run("a mirror win is reported as source mirror", {
    getManifest: () => manifest(currentPdf, eciPdfPath),
    origin: () => {},
  }, async (page) => {
    await open(page, eciPdfPath);
    await verifyBlob(page, currentPdf, eciPdfPath);
    const view = (await gaEvents(page)).find((event) => event.name === "material_view");
    assert.ok(view, "material_view must be sent");
    assert.equal(view.params.source, "mirror");
    assert.equal(view.params.course, "eci");
  });

  await run("a Download click is reported once as file_download", {}, async (page) => {
    await open(page);
    await verifyBlob(page, currentPdf);
    const pending = page.waitForEvent("download");
    await page.locator("#download-file").click();
    await pending;
    const downloads = (await gaEvents(page)).filter((event) => event.name === "file_download");
    assert.equal(downloads.length, 1, "one click, one file_download");
    assert.equal(downloads[0].params.trigger, "button");
    assert.equal(downloads[0].params.file_name, "Fault-Test.pdf");
  });

  await run("an R file download is reported once with trigger auto", {
    getManifest: () => manifest(currentR, rPath),
    origin: (_req, res) => respond(res, currentR, 200, "text/plain"),
  }, async (page) => {
    const pending = page.waitForEvent("download");
    await open(page, rPath);
    await verifyBlob(page, currentR, rPath);
    await pending;
    const downloads = (await gaEvents(page)).filter((event) => event.name === "file_download");
    assert.equal(downloads.length, 1, "the automatic R download is counted once");
    assert.equal(downloads[0].params.trigger, "auto");
    assert.equal(downloads[0].params.file_extension, "r");
  });

  await run("a failed open is reported as material_error", {
    origin: (_req, res) => respond(res, "unavailable", 503, "text/plain"),
    mirror: (_req, res) => respond(res, previousPdf),
  }, async (page) => {
    await open(page);
    await failure(page);
    const events = await gaEvents(page);
    const errors = events.filter((event) => event.name === "material_error");
    assert.equal(errors.length, 1, "one failed open, one material_error");
    assert.ok(["integrity", "network"].includes(errors[0].params.error_kind), `unexpected error_kind ${errors[0].params.error_kind}`);
    assert.equal(events.filter((event) => event.name === "material_view").length, 0, "a failed open must not count as a view");
  });

  await run("the owner marker is kept per browser, sent on every page, and can be cleared", {}, async (page) => {
    const address = () => page.evaluate(() => new URL(location.href));
    await open(page, pdfPath, "&site_role=owner");
    await ready(page);
    assert.equal(await siteRole(page), "owner");
    const opened = await address();
    assert.equal(opened.searchParams.get("site_role"), null, "the marker must leave the address bar");
    assert.equal(opened.searchParams.get("file"), pdfPath, "other parameters must stay");
    await page.goto(`${base}/talks/`, { waitUntil: "domcontentloaded" });
    assert.equal(await siteRole(page), "owner", "later pages carry the marker without the link");
    await page.goto(`${base}/talks/?site_role=clear`, { waitUntil: "domcontentloaded" });
    assert.equal(await siteRole(page), "cleared", "clearing is recorded once");
    assert.equal((await address()).search, "", "the clear marker must leave the address bar too");
    await page.goto(`${base}/talks/`, { waitUntil: "domcontentloaded" });
    assert.equal(await siteRole(page), null, "a cleared browser is an ordinary visitor again");
  });

  await run("a large site file opens through the verified CDN hedge in neutral text and site colors", {
    getManifest: () => manifest(currentPdf, sitePdfPath),
    origin: () => {},
  }, async (page, state) => {
    // Hold the first manifest so the page can be checked before it knows the file name.
    let release;
    const released = new Promise((resolve) => { release = resolve; });
    await page.route((url) => url.pathname === "/assets/data/course-materials.json", async (route) => { await released; await route.continue(); }, { times: 1 });
    const texts = () => page.evaluate(() => ["#material-title", "#status", "#progress-text"].map((selector) => document.querySelector(selector).textContent));
    await open(page, sitePdfPath);
    assert.deepEqual(await texts(), ["File", "Opening file…", "Checking the latest version…"]);
    release();
    await page.waitForFunction(() => document.querySelector("#material-title").textContent === "Fault-Test.pdf");
    assert.equal((await texts())[1], "Opening file…", "the status stays neutral while the file loads");
    await verifyBlob(page, currentPdf, sitePdfPath);
    assert.equal(state.mirrorCount, 1, "the site file mirror must pass the allowlist");
    await page.waitForTimeout(30);
    assert.ok(state.requests.find((item) => item.path === sitePdfPath).aborted, "the stalled origin must be canceled");
    const colors = () => page.evaluate(() => [document.documentElement.getAttribute("data-course"),
      getComputedStyle(document.getElementById("progress")).accentColor, getComputedStyle(document.getElementById("download-file")).color]);
    assert.deepEqual(await colors(), ["site", "rgb(181, 9, 172)", "rgb(181, 9, 172)"], "light mode uses the site purple");
    await page.emulateMedia({ colorScheme: "dark" });
    assert.deepEqual(await colors(), ["site", "rgb(217, 70, 239)", "rgb(232, 121, 249)"], "dark mode uses the lighter purples");
    const pending = page.waitForEvent("download");
    await page.locator("#download-file").click();
    await pending;
    const events = await gaEvents(page);
    for (const name of ["material_view", "file_download"]) {
      const sent = events.filter((event) => event.name === name);
      assert.equal(sent.length, 1, `one ${name}`);
      assert.equal(sent[0].params.course, "site", `${name} must report course site`);
    }
    assert.equal(events.find((event) => event.name === "material_view").params.source, "mirror");
  });

  await run("CV-like site files are never fetched, even when a manifest lists them", {
    getManifest: () => ({ ...manifest(), materials: Object.fromEntries(cvPaths.map((file) => [file, entry(file, currentPdf)])) }),
  }, async (page, state) => {
    for (const file of cvPaths) {
      await open(page, file);
      await failure(page);
      const errors = (await gaEvents(page)).filter((event) => event.name === "material_error");
      assert.deepEqual(errors.map((event) => event.params.course), ["site"], `${file} must be reported once as a site file error`);
    }
    assert.equal(state.originCount + state.mirrorCount, 0, "the deployed CV is regenerated after the build, so it must stay a direct link");
  });

  await run("site files in nested folders, of other types, or outside assets are rejected", {
    getManifest: () => ({ ...manifest(), materials: Object.fromEntries(offShapePaths.map((file) => [file, entry(file, currentPdf)])) }),
  }, async (page, state) => {
    for (const file of offShapePaths) {
      await open(page, file);
      await failure(page);
    }
    assert.equal(state.originCount + state.mirrorCount, 0, "files outside the allowed shapes must not be requested");
  });

  console.log("All 26 course-material and site-file loader tests passed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}).finally(async () => {
  if (browser) await browser.close();
  for (const socket of sockets) socket.destroy();
  server.close();
});
