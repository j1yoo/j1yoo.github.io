#!/usr/bin/env node
/*
 * Browser fault tests for the course-material loader.
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
  if (url.pathname === pdfPath || url.pathname === rPath) {
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

async function main() {
  assert.ok(fs.existsSync(path.join(site, "teaching/material/index.html")), `Build the site first; missing ${site}/teaching/material/index.html`);
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

  console.log("All 13 course-material browser fault tests passed.");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
}).finally(async () => {
  if (browser) await browser.close();
  for (const socket of sockets) socket.destroy();
  server.close();
});
