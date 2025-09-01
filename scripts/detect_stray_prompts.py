#!/usr/bin/env python3
"""Fail if there are stray prompt-like JSON files outside canonical locations."""
from __future__ import annotations
import pathlib, sys, json

ROOT = pathlib.Path('.').resolve()
allowed_dirs = {ROOT / 'prompts', ROOT / 'archive', ROOT / 'scripts', ROOT / '.github'}
errors = []
for p in ROOT.glob('*.json'):
    # allow root level non-prompt tooling indexes etc if needed later; currently no root prompts allowed
    try:
        data = json.loads(p.read_text())
    except Exception:
        continue
    if {'target_model','messages'} <= set(data):
        errors.append(f"Stray prompt spec at repo root: {p}")

# Detect any nested prompts_json leftovers
legacy_dir = ROOT / 'prompts_json'
if legacy_dir.exists():
    errors.append("Legacy directory present: prompts_json (should be removed)")

if errors:
    for e in errors:
        print(e, file=sys.stderr)
    sys.exit(1)
print("No stray prompt specs detected.")
