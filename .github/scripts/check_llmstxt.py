#!/usr/bin/env python3
"""Check that the llmstxt plugin sections in mkdocs.yml cover exactly the pages in the nav.

Every Markdown page in `nav` must be matched by an entry under
`plugins: llmstxt: sections`, and every entry there must match a page in `nav`.
"""

import fnmatch
import sys

import yaml


class _Loader(yaml.SafeLoader):
    """SafeLoader that ignores !!python/* tags (e.g. the mermaid fence format)."""


_Loader.add_multi_constructor("tag:yaml.org,2002:python/", lambda loader, suffix, node: None)


def nav_pages(nav, group=None):
    """Yield (page path, top-level nav group) for every Markdown page in the nav."""
    for item in nav:
        if isinstance(item, str):
            entries = [(None, item)]
        else:
            entries = item.items()
        for title, value in entries:
            if isinstance(value, list):
                yield from nav_pages(value, group or title)
            elif isinstance(value, str) and value.endswith(".md") and "://" not in value:
                yield value, group or title


def llmstxt_patterns(plugins):
    """Return the path patterns listed under the llmstxt plugin's sections."""
    for plugin in plugins:
        if isinstance(plugin, dict) and "llmstxt" in plugin:
            sections = (plugin["llmstxt"] or {}).get("sections") or {}
            break
    else:
        sys.exit("ERROR: llmstxt plugin with sections not found in mkdocs.yml")

    patterns = []
    for entries in sections.values():
        for entry in entries:
            patterns.append(next(iter(entry)) if isinstance(entry, dict) else entry)
    return patterns


def main(config_path="mkdocs.yml"):
    with open(config_path, encoding="utf-8") as f:
        config = yaml.load(f, Loader=_Loader)

    pages = dict(nav_pages(config["nav"]))
    patterns = llmstxt_patterns(config.get("plugins", []))

    missing = [(page, group) for page, group in pages.items()
               if not any(fnmatch.fnmatch(page, pattern) for pattern in patterns)]
    extra = [pattern for pattern in patterns
             if not any(fnmatch.fnmatch(page, pattern) for page in pages)]

    for page, group in missing:
        print(f"ERROR: '{page}' (nav section '{group}') is in the nav "
              f"but not in the llmstxt sections")
    for pattern in extra:
        print(f"ERROR: '{pattern}' is in the llmstxt sections but does not match any nav page")

    if missing or extra:
        print(f"\nUpdate 'plugins: llmstxt: sections' in {config_path} to match 'nav'.")
        return 1

    print(f"OK: all {len(pages)} nav pages are listed in the llmstxt sections")
    return 0


if __name__ == "__main__":
    sys.exit(main(*sys.argv[1:]))
