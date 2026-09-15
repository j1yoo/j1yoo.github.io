# CV institution font

`NotoSerifTC-nthu.ttf` is the Noto Serif TC Regular (400) subset for the six
characters `國立清華大學`. The CV uses it only for the Chinese institution name;
Latin text retains the existing font stack.

- Source: https://fonts.google.com/noto/specimen/Noto+Serif+TC
- Downloaded September 15, 2026 using the Google Fonts CSS API's `text` subset.
- SHA-256: `8e29a2b327299c28c0265f6d66a0b5eac2065828dc3512a54d613faf298fff78`
- License: SIL Open Font License 1.1; see `OFL.txt`.

The font is served locally and embedded by Puppeteer, so PDF builds do not
depend on a remote font service or the server's installed CJK fonts. The PDF
generator verifies that every character uses this face. If the Chinese name
changes, regenerate the subset to include any new characters.
