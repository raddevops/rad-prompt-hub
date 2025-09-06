#!/usr/bin/env python3
"""
build_tools_index.py

Regenerate tools/index.json from markdown prompt files with YAML frontmatter.
This script scans all .md files in the prompts/ directory, extracts their frontmatter,
and writes a fresh tools/index.json.
"""
import json
import pathlib
import re
import sys
from datetime import datetime, timezone
from typing import Dict, Any, List

FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)

def extract_frontmatter(text: str) -> Dict[str, Any]:
    """Extract YAML frontmatter from markdown text."""
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
                # Parse array: ["item1", "item2", "item3"]
                items = [x.strip().strip('"').strip("'") for x in val[1:-1].split(",") if x.strip()]
                meta[key] = items
            else:
                # Remove quotes if present
                meta[key] = val.strip('"').strip("'")
            current_key = key
        elif re.match(r"^\s*-\s", line) and current_key:
            # Handle multi-line array format:
            # key:
            #   - item1
            #   - item2
            dash_index = line.find("-")
            if current_key not in meta:
                meta[current_key] = []
            meta[current_key].append(line[dash_index + 1:].strip())
    return meta

def extract_metadata_from_content(text: str) -> Dict[str, Any]:
    """Extract metadata from markdown content structure for files without frontmatter."""
    lines = text.split('\n')
    meta = {}
    
    # Look for title in first few lines (usually ## Title or # Title)
    for i, line in enumerate(lines[:5]):
        line = line.strip()
        if line.startswith('## ') or line.startswith('# '):
            title = line.lstrip('#').strip()
            # Remove "(About)" suffix if present
            if title.endswith(' (About)'):
                title = title[:-8].strip()
            # Extract the main title part before " Prompt"
            if ' Prompt' in title:
                title = title.split(' Prompt')[0].strip()
            meta['title'] = title
            break
    
    # Look for category in early lines
    for i, line in enumerate(lines[:10]):
        line = line.strip()
        if line.startswith('Category: '):
            category = line[10:].strip().lower()
            meta['category'] = category
            break
    
    return meta

def scan_prompts(root: pathlib.Path) -> List[Dict[str, Any]]:
    """Scan all markdown files in prompts directory and extract metadata."""
    results = []
    for path in sorted(root.rglob("*.md")):
        # Skip template files
        if "templates" in path.parts:
            continue
        
        try:
            content = path.read_text(encoding="utf-8")
        except Exception as e:
            print(f"WARN: Could not read {path}: {e}", file=sys.stderr)
            continue
        # Extract frontmatter once
        meta = extract_frontmatter(content)
        # Always compute content-derived metadata once; use as fallback only
        content_meta = extract_metadata_from_content(content)

        # Determine category from the first subdirectory under 'prompts'
        # e.g., prompts/engineering/code-review/file.md -> category = 'engineering'
        parts = list(path.parts)
        try:
            p_idx = parts.index("prompts")
            category = parts[p_idx + 1] if len(parts) > p_idx + 1 else "uncategorized"
        except ValueError:
            category = "uncategorized"
        
        # Warn if frontmatter or content category mismatches parent directory
        fm_category = meta.get("category")
        content_category = content_meta.get("category")
        expected_category = category
        if fm_category and fm_category != expected_category:
            print(
                f"WARN: {path} frontmatter category '{fm_category}' does not match directory '{expected_category}'",
                file=sys.stderr,
            )
        if content_category and content_category != expected_category:
            print(
                f"WARN: {path} content-derived category '{content_category}' does not match directory '{expected_category}'",
                file=sys.stderr,
            )

        # Get title from frontmatter or content
        title = meta.get("title", content_meta.get("title", ""))
        
        # For files without complete metadata, generate some reasonable defaults
        tags = meta.get("tags", [category] if category != "uncategorized" else [])
        if isinstance(tags, str):
            tags = [tags]  # Ensure tags is always a list
            
        results.append({
            "path": str(path),
            "title": title,
            "tags": tags,
            "category": category,
            "last_updated": meta.get("last_updated", ""),
            "author": meta.get("author", ""),
        })
    
    return results

def main():
    """Main function to regenerate tools/index.json."""
    root = pathlib.Path("prompts")
    if not root.exists():
        print("Error: prompts directory not found.", file=sys.stderr)
        sys.exit(1)
    
    # Scan all markdown files
    prompts = scan_prompts(root)
    
    # Generate index data
    index_data = {
        "generated_at": datetime.now(timezone.utc).strftime("%Y-%m-%dT%H:%M:%SZ"),
        "prompts": prompts
    }
    
    # Write to tools/index.json
    tools_dir = pathlib.Path("tools")
    tools_dir.mkdir(exist_ok=True)
    index_path = tools_dir / "index.json"
    
    with open(index_path, 'w', encoding='utf-8') as f:
        # Minified JSON output (no pretty-printing, no trailing newline)
        json.dump(index_data, f, ensure_ascii=False, separators=(",", ":"))
    
    print(f"Wrote {index_path} with {len(prompts)} entries")

if __name__ == "__main__":
    main()