"""Right after a push, ask the jsDelivr mirror for each changed course file at the address the loader will use.

GitHub Pages takes 3 to 4 minutes to deploy. The mirror address of a brand-new commit can refuse requests for a few
minutes (about 3 minutes on 2026-10-05), and students who open the file then load it from GitHub Pages, which can be
much slower. Asking at push time lets the mirror fetch the new version while the site deploys.

The rules follow _plugins/course-materials.rb: course PDFs and R files, other downloads of 1 to 20 MB directly inside
an assets/ folder, no CV files, and nothing above 20 MB, which the mirror refuses.

Usage: python3 _scripts/warm_course_mirror.py <commit before the push> <pushed commit>
"""

import hashlib
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from concurrent.futures import ThreadPoolExecutor

MIRROR_BASE = "https://gcore.jsdelivr.net/gh/j1yoo/j1yoo.github.io"
MIRROR_LIMIT = 20_000_000
SITE_MIN_BYTES = 1_000_000
COURSE_FILE = re.compile(r"assets/courses/(pba|eci)/.+\.(pdf|r)", re.I)
SITE_FILE = re.compile(r"assets/[A-Za-z0-9_-]+/[^/]+\.(pdf|pptx|ppt|docx|doc|xlsx|zip|r|rmd|qmd|ipynb)", re.I)
CV_NAME = re.compile(r"^cv|resume", re.I)
DEADLINE = 600  # seconds
RETRY_AFTER = 15  # seconds


def git(*args):
    result = subprocess.run(["git", *args], capture_output=True)
    return result.stdout if result.returncode == 0 else None


def targets(before, after):
    base = before if before and git("cat-file", "-e", f"{before}^{{commit}}") is not None else f"{after}~1"
    changed = git("diff", "--name-only", "--no-renames", "--diff-filter=AM", "-z", base, after, "--", "assets") or b""
    found = []
    for path in filter(None, changed.decode().split("\0")):
        content = git("cat-file", "blob", f"{after}:{path}")
        if content is None or len(content) > MIRROR_LIMIT:
            continue
        name = path.rsplit("/", 1)[-1]
        site_file = SITE_FILE.fullmatch(path) and not CV_NAME.search(name) and len(content) >= SITE_MIN_BYTES
        if not (COURSE_FILE.fullmatch(path) or site_file):
            continue
        # The deploy pins each file to the last commit that changed it, as the loader's manifest does.
        commit = git("log", "-1", "--format=%H", after, "--", path).decode().strip()
        escaped = "/".join(urllib.parse.quote(part, safe="*").replace("~", "%7E") for part in path.split("/"))
        found.append({"path": path, "bytes": len(content), "sha256": hashlib.sha256(content).hexdigest(), "url": f"{MIRROR_BASE}@{commit}/{escaped}"})
    return found


def warm(target):
    started = time.monotonic()
    tries = 0
    while True:
        tries += 1
        try:
            request = urllib.request.Request(target["url"], headers={"User-Agent": "j1yoo.github.io mirror warm-up"})
            with urllib.request.urlopen(request, timeout=120) as response:
                body = response.read()
            if len(body) == target["bytes"] and hashlib.sha256(body).hexdigest() == target["sha256"]:
                return True, f"ready after {time.monotonic() - started:.0f} s ({tries} tries)"
            status = f"a different copy ({len(body)} bytes)"
        except Exception as error:  # refusals, timeouts, and dropped connections are all retried
            status = str(error)
        if time.monotonic() - started + RETRY_AFTER > DEADLINE:
            return False, f"not ready after {time.monotonic() - started:.0f} s ({tries} tries; last: {status})"
        time.sleep(RETRY_AFTER)


def main(before, after):
    found = targets(before, after)
    if not found:
        print("No changed file has a mirror address.")
        return
    for target in found:
        print(f"Asking the mirror for {target['url']}")
    with ThreadPoolExecutor(max_workers=8) as pool:
        results = list(pool.map(warm, found))
    for target, (ready, message) in zip(found, results):
        print(f"{target['path']}: {message}")
        if not ready:
            print(f"::warning file={target['path']}::The mirror did not serve this version in time; students load it from GitHub Pages until it does.")


if __name__ == "__main__":
    main(sys.argv[1] if len(sys.argv) > 1 else "", sys.argv[2] if len(sys.argv) > 2 else "HEAD")
