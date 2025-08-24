#!/usr/bin/env python3
"""
search.py

Simple tag / keyword search over prompt metadata.
"""
import argparse
import pathlib
import re
import sys
import json
from typing import List, Dict, Any

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)

def extract_frontmatter(text: str) -> Dict[str, Any]:
    m = FRONTMATTER_RE.match(text)
    if not m:
        return {}
    raw = m.group(1)
    meta = {}
    current_key = None
    for line in raw.splitlines():
        if not line.strip():
            continue
        if re.match(r"^[a-zA-Z0-9_]+:", line):
            key, val = line.split(":", 1)
            key = key.strip()
            val = val.strip()
            if val.startswith("[") and val.endswith("]"):
                items = [x.strip().strip('"').strip("'") for x in val[1:-1].split(",") if x.strip()]
                meta[key] = items
            else:
                meta[key] = val.strip('"').strip("'")
            current_key = key
        elif line.startswith("  -") and current_key:
            meta.setdefault(current_key, []).append(line[3:].strip())
    return meta

def scan_prompts(root: pathlib.Path) -> List[Dict[str, Any]]:
    results = []
    for path in root.rglob("*.md"):
        if "templates" in path.parts:
            continue
        content = path.read_text(encoding="utf-8")
        meta = extract_frontmatter(content)
        if meta:
            results.append({
                "path": str(path),
                "title": meta.get("title"),
                "tags": meta.get("tags", []),
                "last_updated": meta.get("last_updated"),
            })
    return results

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--tags", nargs="*", help="Filter by any of these tags")
    parser.add_argument("--all-tags", action="store_true", help="Require all provided tags to match")
    parser.add_argument("--keyword", help="Filter by keyword in title")
    parser.add_argument("--json", action="store_true", help="Output JSON")
    parser.add_argument("--all", action="store_true", help="Return all prompts (ignore other filters)")
    args = parser.parse_args()

    base = pathlib.Path(__file__).parent.parent / "prompts"
    if not base.exists():
        print("Error: prompts directory not found.", file=sys.stderr)
        sys.exit(1)

    prompts = scan_prompts(base)

    def matches(p):
        if args.all:
            return True
        if args.keyword and args.keyword.lower() not in (p.get("title") or "").lower():
            return False
        if args.tags:
            p_tags = set(p.get("tags") or [])
            q_tags = set(args.tags)
            if args.all_tags:
                return q_tags.issubset(p_tags)
            else:
                return bool(p_tags & q_tags)
        return True

    filtered = [p for p in prompts if matches(p)]

    if args.json:
        print(json.dumps(filtered, indent=2))
        return

    if not filtered:
        print("No prompts found matching criteria.")
        return

    width_path = max(len(p["path"]) for p in filtered)
    width_title = max(len(p["title"] or "") for p in filtered)
    print(f"{'Path'.ljust(width_path)}  {'Title'.ljust(width_title)}  Tags")
    print("-" * (width_path + width_title + 8))
    for p in filtered:
        print(f"{p['path'].ljust(width_path)}  {p['title'].ljust(width_title)}  {', '.join(p['tags'])}")

if __name__ == "__main__":
    main()