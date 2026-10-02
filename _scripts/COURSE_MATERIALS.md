# PBA and ECI material delivery

Keep editing the PDF and R files under `assets/courses/pba/` and
`assets/courses/eci/` and publish through the normal GitHub/Jekyll deployment.
No mirror URLs or hashes need manual edits.
The existing deployment filters include course assets, HTML, JS, and Markdown.
A future Ruby-plugin-only maintenance commit needs a manual Deploy site run
or an accompanying change covered by those filters.

`_plugins/course-materials.rb` generates `assets/data/course-materials.json` on
every build and rewrites PBA and ECI material links in the shared course layout
to the stable `/teaching/material/?file=...` loader. Materials and Schedule use
the same loader, including links opened in a new tab.

The manifest records each file's byte length and SHA-256. A jsDelivr mirror is
enabled only for a tracked file of at most 20,000,000 bytes whose source matches
the Git blob exactly. The mirror is pinned to a commit, never `@main`. Dirty
local and untracked files remain origin-only until committed. In a shallow
checkout, the checked-out commit is used when it contains those exact bytes.
The deploy workflow checks out full history without blobs (`fetch-depth: 0`,
`filter: blob:none`), so each material is pinned to the commit that last
changed it. Its jsDelivr URL then stays the same across deploys, and the CDN
copy stays warm.

The loader fetches a cache-busted manifest with `cache: no-store`, then begins
the origin transfer. A mirror transfer starts after 700 ms if needed, or sooner
if the origin fails. A transfer wins only after receiving and checking every
byte; the other request is aborted. Before display, another fresh manifest
check ensures the file did not change during the transfer. Changed versions
restart at most twice. Manifest failure and integrity mismatch never trigger a
silent fallback to an older cached file.

Freshness means the latest **published deployment** returned by the origin,
not an unpushed edit or a deployment still in progress. Already open PDF views
are not forcibly refreshed during teaching. Opening the course link again
checks the current deployment. New pages and refreshed existing course pages
use the loader; legacy direct PDF URLs retain GitHub Pages behavior.

The loader uses the browser PDF viewer and supplies a verified download with
the original filename. R files download automatically and retain a manual
Download link. With JavaScript disabled, the loader lists direct original links.
No service worker or long-lived application cache is installed.
The loader page picks its colors from the `file` path before the first paint:
ECI magenta for `assets/courses/eci/` and the PBA teal for everything else.

`gcore.jsdelivr.net` is the measured emergency mirror, not a promise of a
permanent provider endpoint. Origin delivery remains available independently.
A managed Cloudflare mirror can replace it later; update both the generator
and the loader's mirror allowlist. If GitHub Pages cannot serve the loader or
fresh manifest at all, the loader fails closed instead of opening stale data.

## Analytics

The loader page loads the same GA4 property as the course pages, with the file
name as the page title, and stays silent when the host is not `*.github.io`
(local previews). It sends `material_view` once a verified file is shown
(`file_name`, `file_extension`, `link_url`, `course`, `source` = origin or
mirror, `load_ms`, `file_size`), `file_download` when the Download link is used
(`trigger` = button, or auto for R files), and `material_error` with
`error_kind` when a file cannot be opened. On the course pages,
`enhanced-tracking.js` reads `data-material-path`, so `pdf_download` keeps the
real file name and course. These events reach BigQuery without any setup; to
see `course`, `source`, or `load_ms` in GA4 reports, register them as custom
definitions.

## Local validation

Build with the repository's Ruby environment, then run:

```sh
node _scripts/test_course_materials.cjs /path/to/built/site
```

The test script accepts `PLAYWRIGHT_MODULE` and `CHROME_EXECUTABLE`. It uses local
fixtures rather than live CDN calls, including real partially sent HTTP bodies,
wrong-version files with matching size, both manifest checks, bounded update
retries, request cancellation, and R download contents and filenames.
