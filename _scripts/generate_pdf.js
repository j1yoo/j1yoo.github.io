const puppeteer = require('puppeteer');
const path = require('path');
const fs = require('fs');
const { pathToFileURL } = require('url');

(async () => {
  const buildDir = path.resolve(process.env.CV_BUILD_DIR || '_site');
  const htmlPath = path.join(buildDir, 'cv_print', 'index.html');
  const outputPath = path.resolve(process.argv[2] || 'assets/pdf/cv_jaewon.pdf');
  if (!fs.existsSync(htmlPath)) throw new Error(`Build the Jekyll site first: missing ${htmlPath}`);

  const browser = await puppeteer.launch({ headless: true, args: ['--no-sandbox', '--disable-setuid-sandbox'] });
  try {
    const page = await browser.newPage();
    await page.goto(pathToFileURL(htmlPath).href, { waitUntil: 'networkidle0' });
    await page.evaluate(() => document.fonts.ready);

    // Fail rather than publish a PDF whose Chinese institution name silently
    // falls back to different system fonts on macOS and the Linux build server.
    const institutionName = await page.$eval('.institution-local', node => node.textContent.trim());
    const client = await page.createCDPSession();
    await client.send('DOM.enable');
    await client.send('CSS.enable');
    const { root } = await client.send('DOM.getDocument');
    const { nodeId } = await client.send('DOM.querySelector', { nodeId: root.nodeId, selector: '.institution-local' });
    const { fonts } = await client.send('CSS.getPlatformFontsForNode', { nodeId });
    const renderedFonts = fonts.filter(font => font.glyphCount > 0);
    if (renderedFonts.length !== 1 || !renderedFonts[0].isCustomFont ||
        !renderedFonts[0].postScriptName.startsWith('NotoSerifTC-') ||
        renderedFonts[0].glyphCount !== [...institutionName].length) {
      throw new Error(`Chinese institution font verification failed: ${JSON.stringify(renderedFonts)}`);
    }
    console.log(`Verified ${institutionName}: ${renderedFonts[0].postScriptName}, ${renderedFonts[0].glyphCount} glyphs`);
    await client.detach();

    fs.mkdirSync(path.dirname(outputPath), { recursive: true });
    await page.pdf({
      path: outputPath,
      format: 'Letter',
      preferCSSPageSize: true,
      printBackground: true,
      displayHeaderFooter: true,
      headerTemplate: '<div></div>',
      footerTemplate: '<div style="font-size:9px;font-family:Times New Roman;width:100%;text-align:center;color:#555;"><span class="pageNumber"></span></div>',
      margin: { top: '17mm', right: '17mm', bottom: '18mm', left: '17mm' }
    });
    // The deployed tree must contain the PDF made from this same HTML build.
    const deployedPath = path.join(buildDir, 'assets/pdf/cv_jaewon.pdf');
    fs.mkdirSync(path.dirname(deployedPath), { recursive: true });
    if (deployedPath !== outputPath) fs.copyFileSync(outputPath, deployedPath);
    console.log(`Generated ${outputPath}`);
    console.log(`Placed the same PDF in ${deployedPath}`);
  } finally {
    await browser.close();
  }
})().catch(error => { console.error(error.message); process.exitCode = 1; });
