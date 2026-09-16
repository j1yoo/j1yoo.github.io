# Maintaining the website and automatic CV

The CV is a view of the website's structured records. Do not edit the generated PDF, duplicate a factual correction in its HTML output, or scrape the live site to rebuild those records.

## Canonical records and views

| Edit here | Used by |
| --- | --- |
| `assets/json/resume.json` | Contact/address, appointments, grouped education in `/cv_print/`; loaded as `site.data.resume` by jekyll-get-json |
| `_bibliography/papers.bib` | Research page and CV research lists, including status, author order and selection |
| `_data/academic_profile.yml` → `service` | Full CV journal/conference reviewing, editorial service and organizing roles |
| Same file → `awards` | Full CV honors list; selected About news uses the relevant record |
| Same file → `grants` | CV funding and Research/CV paper metadata linked by `paper_key` |
| Same file → `paper_notes` | Additional presentation history in Research and the CV |
| Same file → `mentoring_awards` | Research/CV paper metadata and Supervision/CV student notes, linked through `paper_key` and `mentoring_award_id` |
| `_pages/about.md` | Independently authored homepage introduction, including its selected service examples |
| `_data/talks.yml` | Talks page and chronological CV presentation list |
| `_data/supervision.yml` | Supervision page and CV, including enrollment periods and thesis details |
| `_teaching/*` | Course pages and current CV teaching entries; intentionally hidden archive excluded |
| `_data/cv_links.yml` | CV link labels and header profile selection, a presentation setting rather than a second factual record |

About remains a selected, authored introduction. It need not reproduce every CV service record, award or grant. Preserve its wording, links and selection; do not generate its reviewer paragraph by looping over the full CV records. Maintain the structured records so the CV includes the homepage's factual content and any approved additional detail. Approval to add a CV record does not authorize rewriting the homepage. If a factual correction also affects authored prose, identify that separately before changing it. The full web CV is `/cv_print/`.

Keep private correspondence, message identifiers and verification notes outside this public repository. Display records may include public source URLs, but hidden YAML fields are still visible in GitHub. Successful rendering does not independently verify a claim. Preserve the author's deliberate order and wording unless a change is approved. Use yearless BibTeX keys for unpublished work as required in `CLAUDE.md`.

## Generation and release

1. Edit the canonical records within the approved scope. Change independently authored About prose only when that change is approved.
2. Run `bundle exec jekyll build`.
3. Run `bundle exec ruby _scripts/check_cv_sources.rb`.
4. Run `npm ci` if dependencies have not been installed, then `npm run pdf`.
5. Inspect the generated PDF, especially page breaks, link annotations, recent changes and the final footer.

`_scripts/generate_pdf.js` reads `_site/cv_print/index.html`, makes a Letter PDF, and places the identical PDF in `assets/pdf/cv_jaewon.pdf` and `_site/assets/pdf/cv_jaewon.pdf`. The last path is the one actually deployed. `CV_BUILD_DIR` selects another built tree; an optional positional argument selects another output PDF. Every generated tree must use its own corresponding HTML.

`deploy.yml` builds the site, runs the source check and generates the PDF before deploying that same `_site`. An unsuccessful check or generation prevents deployment. There is no separate bot commit of the PDF that relies on triggering another build. `generate-pdf.yml` is manual and uploads a review artifact only; it does not commit or publish.

Local review and a successful compile are not permission to publish. Obtain the author's release approval before pushing preview changes. For each release, check the deploying workflow, the subsequent GitHub Pages deployment and the live HTML/PDF; a local success alone is not a production verification.

## Check limitations

`check_cv_sources.rb` compares selected required fields from the shared records with the generated pages: award/grant titles, service names, paper notes, talks, student names/theses/awards, appointments, degree names and education details. Full service lists are required only in the CV; About is checked against its own authored reviewer paragraph. It catches missing view connections and several accidental omissions. It is not an audit of historical completeness, date accuracy, manuscript status, all record-to-record relationships or visual layout. Repeated wording elsewhere on a page can satisfy a text check. Source evidence and PDF inspection remain necessary.
