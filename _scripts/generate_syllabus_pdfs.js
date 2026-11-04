// Prints every syllabus print page of the Jekyll build (teaching/<course>/syllabus-print/)
// to the PDF path that its course page lists as `syllabus`, under the output folder.
// Usage: node _scripts/generate_syllabus_pdfs.js [output folder, default: the build folder]
// With the default, the PDFs replace the copies of the posted syllabi in the build.
// To update the committed PDFs after a schedule change, build the site and run
// SYLLABUS_BUILD_DIR=<build folder> node _scripts/generate_syllabus_pdfs.js .
const puppeteer = require('puppeteer');
const crypto = require('crypto');
const path = require('path');
const fs = require('fs');
const { pathToFileURL } = require('url');

// The text is Times New Roman, as in the CV (Liberation Serif, of the same widths, on the deploy server),
// and the header block Georgia (Gelasio, of the same widths, kept in assets/fonts/syllabus/, on the server).
const FONT_GROUPS = [
  { families: ['Times New Roman', 'Liberation Serif'], selectors: ['h1', 'h2', 'h3', 'p:not(.instructor)', 'li', 'strong', 'em', 'a:not(.info a)', '.grading td', 'table.schedule th', 'table.schedule td div'] },
  { families: ['Georgia', 'Gelasio'], selectors: ['p.instructor', 'table.info td', 'table.info i', 'table.info a'] }
];
const MIN_SHARE = 0.98;
// Page number as in the posted syllabus: Times New Roman 10pt, centered, about 0.25in above the page edge.
const FOOTER = '<div style="width:100%;text-align:center;font-family:\'Times New Roman\',Times,serif;font-size:10pt;color:#000;margin-bottom:2.2pt;"><span class="pageNumber"></span></div>';

async function checkFonts(page) {
  const client = await page.createCDPSession();
  await client.send('DOM.enable');
  await client.send('CSS.enable');
  const { root } = await client.send('DOM.getDocument', { depth: -1 });
  const report = [];
  for (const group of FONT_GROUPS) {
    const glyphs = {};
    const seen = new Set();
    for (const selector of group.selectors) {
      const { nodeIds } = await client.send('DOM.querySelectorAll', { nodeId: root.nodeId, selector });
      for (const nodeId of nodeIds) {
        if (seen.has(nodeId)) continue;
        seen.add(nodeId);
        const { fonts } = await client.send('CSS.getPlatformFontsForNode', { nodeId });
        for (const font of fonts) glyphs[font.familyName] = (glyphs[font.familyName] || 0) + font.glyphCount;
      }
    }
    const total = Object.values(glyphs).reduce((a, b) => a + b, 0);
    const expected = group.families.reduce((sum, name) => sum + (glyphs[name] || 0), 0);
    const summary = Object.entries(glyphs).sort((a, b) => b[1] - a[1]).map(([name, count]) => `${name} ${count}`).join(', ');
    if (total === 0 || expected / total < MIN_SHARE) {
      throw new Error(`Font check failed: expected ${group.families.join(' or ')}, got ${summary || 'no text'}`);
    }
    report.push(`${group.families[0]} group: ${summary}`);
  }
  await client.detach();
  return report;
}

// The course page opens course PDFs through the material loader, which checks each file against
// the manifest made at build time and may fetch the committed copy from a mirror. A PDF replaced
// after the build therefore needs its manifest entry updated and its mirror dropped.
function updateManifest(buildDir, sitePath, file) {
  const manifestPath = path.join(buildDir, 'assets', 'data', 'course-materials.json');
  if (!fs.existsSync(manifestPath)) return;
  const manifest = JSON.parse(fs.readFileSync(manifestPath, 'utf8'));
  const entry = manifest.materials && manifest.materials[sitePath];
  if (!entry) return;
  const bytes = fs.readFileSync(file);
  entry.bytes = bytes.length;
  entry.sha256 = crypto.createHash('sha256').update(bytes).digest('hex');
  entry.mirror_url = null;
  fs.writeFileSync(manifestPath, JSON.stringify(manifest));
  console.log(`Updated the material manifest entry for ${sitePath}`);
}

(async () => {
  const buildDir = path.resolve(process.env.SYLLABUS_BUILD_DIR || '_site');
  const outputDir = path.resolve(process.argv[2] || buildDir);
  const teachingDir = path.join(buildDir, 'teaching');
  const pages = fs.existsSync(teachingDir) ? fs.readdirSync(teachingDir).sort()
    .map(name => path.join(teachingDir, name, 'syllabus-print', 'index.html'))
    .filter(file => fs.existsSync(file)) : [];
  if (pages.length === 0) throw new Error(`Build the Jekyll site first: no syllabus print pages in ${teachingDir}`);

  const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  try {
    for (const htmlPath of pages) {
      const label = path.relative(buildDir, htmlPath);
      const page = await browser.newPage();
      await page.goto(pathToFileURL(htmlPath).href, { waitUntil: 'networkidle0' });
      await page.evaluate(() => document.fonts.ready);
      const info = await page.evaluate(() => {
        const meta = name => (document.querySelector(`meta[name="${name}"]`) || {}).content || '';
        // Site plugins can leave site-relative links (e.g. the course material loader); a PDF needs absolute ones.
        for (const a of document.querySelectorAll('a[href]')) a.href = new URL(a.getAttribute('href'), meta('site-url')).href;
        return { pdf: meta('syllabus-pdf'), weeks: document.querySelectorAll('table.schedule tr.week').length };
      });
      // Refuse to publish an incomplete syllabus; the posted PDF then stays in place.
      if (!info.pdf) throw new Error(`${label}: the course page has no syllabus path`);
      if (info.weeks === 0) throw new Error(`${label}: the weekly schedule has no weeks`);
      const fontReport = await checkFonts(page);

      const outputPath = path.join(outputDir, info.pdf);
      fs.mkdirSync(path.dirname(outputPath), { recursive: true });
      await page.pdf({
        path: outputPath,
        format: 'Letter',
        preferCSSPageSize: true,
        printBackground: true,
        displayHeaderFooter: true,
        headerTemplate: '<div></div>',
        footerTemplate: FOOTER,
        margin: { top: '1in', right: '0.5in', bottom: '1in', left: '0.5in' }
      });
      console.log(`${label}: ${info.weeks} weeks; ${fontReport.join('; ')}`);
      console.log(`Generated ${outputPath}`);
      if (outputDir === buildDir) updateManifest(buildDir, info.pdf, outputPath);
      await page.close();
    }
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error.message); process.exitCode = 1; });
