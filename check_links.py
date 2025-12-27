import os
import re
import urllib.parse
from pathlib import Path

def get_links_from_file(filepath):
    """Extracts hrefs from HTML content."""
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
            # Simple regex to find hrefs, robust enough for static site
            links = re.findall(r'href=["\'](.*?)["\']', content)
            return links
    except Exception as e:
        print(f"Error reading {filepath}: {e}")
        return []

def check_link(link, source_file, site_root):
    """Checks if a link is valid."""
    
    # Ignore external links, mailto, tel, etc.
    if link.startswith(('http:', 'https:', 'mailto:', 'tel:', '#', 'javascript:')):
        return True # Assume external/special are fine for now (we care about internal 404s)
    
    # Ignore anchors within the same page (simplified)
    if link.startswith('#'):
        return True

    # Normalize path
    # Handle absolute paths relative to site root
    if link.startswith('/'):
        target_path = site_root / link.lstrip('/')
    else:
        # Handle relative paths
        target_path = source_file.parent / link
    
    # Remove query params and anchors from target_path string for checking existence
    target_path_str = str(target_path).split('#')[0].split('?')[0]
    target_path_obj = Path(target_path_str)

    # Check if file exists
    if target_path_obj.exists():
        return True
    
    # Check if it's a directory with index.html
    if target_path_obj.is_dir() and (target_path_obj / 'index.html').exists():
        return True
        
    return False

def crawl_site(site_dir):
    """Crawls the _site directory and reports broken links."""
    site_root = Path(site_dir).resolve()
    broken_links = []

    print(f"Crawling {site_root}...")

    for root, dirs, files in os.walk(site_root):
        for file in files:
            if file.endswith('.html'):
                filepath = Path(root) / file
                links = get_links_from_file(filepath)
                
                for link in links:
                    if not check_link(link, filepath, site_root):
                        broken_links.append((str(filepath.relative_to(site_root)), link))

    return broken_links

if __name__ == "__main__":
    broken = crawl_site("_site")
    if broken:
        print(f"Found {len(broken)} broken internal links:")
        for source, link in broken:
            print(f"  {source} -> {link}")
    else:
        print("No broken internal links found.")
