#!/usr/bin/env python3
"""
check-last-updated.py

Pre-commit hook to enforce last_updated field updates when prompt body changes.

This script:
1. Identifies modified .md files in the prompts/ directory
2. Compares the content body (excluding frontmatter) with the previous version
3. If body content has changed, ensures last_updated field reflects today's date
4. Fails if last_updated is not current when body changes
"""

import argparse
import pathlib
import re
import subprocess
import sys
from datetime import date
from typing import Dict, Any, Optional, Tuple


FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n(.*)", re.DOTALL)


def extract_frontmatter_and_body(text: str) -> Tuple[Dict[str, Any], str]:
    """Extract YAML frontmatter and body content from markdown text."""
    match = FRONTMATTER_RE.match(text)
    if not match:
        return {}, text
    
    frontmatter_text, body = match.groups()
    metadata = {}
    
    # Simple YAML parsing for basic key: value pairs and arrays
    for line in frontmatter_text.strip().split('\n'):
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        
        if ':' not in line:
            continue
            
        key, value = line.split(':', 1)
        key = key.strip()
        value = value.strip()
        
        # Handle quoted strings
        if value.startswith('"') and value.endswith('"'):
            value = value[1:-1]
        elif value.startswith("'") and value.endswith("'"):
            value = value[1:-1]
        # Handle arrays
        elif value.startswith('[') and value.endswith(']'):
            # Simple array parsing - split by comma and clean quotes
            items = []
            for item in value[1:-1].split(','):
                item = item.strip()
                if item.startswith('"') and item.endswith('"'):
                    item = item[1:-1]
                elif item.startswith("'") and item.endswith("'"):
                    item = item[1:-1]
                items.append(item)
            value = items
            
        metadata[key] = value
    
    return metadata, body.strip()


def get_git_staged_content(file_path: str) -> Optional[str]:
    """Get the staged content of a file from git."""
    try:
        result = subprocess.run(
            ['git', 'show', f':{file_path}'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError:
        # File might be newly added
        return None


def get_git_head_content(file_path: str) -> Optional[str]:
    """Get the HEAD content of a file from git."""
    try:
        result = subprocess.run(
            ['git', 'show', f'HEAD:{file_path}'],
            capture_output=True,
            text=True,
            check=True
        )
        return result.stdout
    except subprocess.CalledProcessError:
        # File might be newly added
        return None


def get_modified_prompt_files() -> list[str]:
    """Get list of modified .md files in prompts/ directory that are staged."""
    try:
        result = subprocess.run(
            ['git', 'diff', '--cached', '--name-only', '--diff-filter=AM'],
            capture_output=True,
            text=True,
            check=True
        )
        
        files = []
        for line in result.stdout.strip().split('\n'):
            if line and line.endswith('.md') and line.startswith('prompts/'):
                files.append(line)
        return files
    except subprocess.CalledProcessError:
        return []


def check_file_last_updated(file_path: str) -> Tuple[bool, str]:
    """
    Check if a file's last_updated field is current when body content has changed.
    
    Returns:
        (passed, message) - passed is True if check passes, message explains result
    """
    # Get current staged content
    current_content = get_git_staged_content(file_path)
    if current_content is None:
        return False, f"Could not read staged content for {file_path}"
    
    # Get previous content from HEAD
    previous_content = get_git_head_content(file_path)
    
    # Parse current content
    current_metadata, current_body = extract_frontmatter_and_body(current_content)
    
    # If this is a new file (no previous content), check that last_updated is today
    if previous_content is None:
        current_last_updated = current_metadata.get('last_updated', '')
        today = date.today().isoformat()
        
        if current_last_updated != today:
            return False, (
                f"New file {file_path} must have last_updated set to today ({today}). "
                f"Found: {current_last_updated}"
            )
        return True, f"New file {file_path} has correct last_updated date"
    
    # Parse previous content
    previous_metadata, previous_body = extract_frontmatter_and_body(previous_content)
    
    # Check if body content has changed
    if current_body == previous_body:
        return True, f"No body changes in {file_path}, last_updated check skipped"
    
    # Body has changed, check if last_updated is current
    current_last_updated = current_metadata.get('last_updated', '')
    today = date.today().isoformat()
    
    if current_last_updated != today:
        return False, (
            f"Body content changed in {file_path} but last_updated is not today's date. "
            f"Expected: {today}, Found: {current_last_updated}"
        )
    
    return True, f"Body changed in {file_path} and last_updated is current ({today})"


def main():
    parser = argparse.ArgumentParser(
        description="Check last_updated field when prompt body content changes"
    )
    parser.add_argument(
        "--verbose", "-v", 
        action="store_true", 
        help="Show detailed output for all files checked"
    )
    args = parser.parse_args()
    
    modified_files = get_modified_prompt_files()
    
    if not modified_files:
        if args.verbose:
            print("No modified prompt files found in staging area.")
        return 0
    
    failed_files = []
    
    for file_path in modified_files:
        passed, message = check_file_last_updated(file_path)
        
        if args.verbose or not passed:
            status = "✓" if passed else "✗"
            print(f"{status} {message}")
        
        if not passed:
            failed_files.append(file_path)
    
    if failed_files:
        print("\nPre-commit check failed!")
        print("\nTo fix these issues:")
        print("1. Update the last_updated field to today's date (YYYY-MM-DD)")
        print("2. Add a changelog entry describing your changes")
        print("3. Re-stage your files: git add <file>")
        print("\nSee CONTRIBUTING.md for more details on updating prompts.")
        return 1
    
    if args.verbose:
        print(f"\n✓ All {len(modified_files)} modified prompt files passed last_updated check")
    
    return 0


if __name__ == "__main__":
    sys.exit(main())