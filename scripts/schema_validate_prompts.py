#!/usr/bin/env python3
"""Validate prompt JSON files against prompt.schema.json and pairing rules."""
from __future__ import annotations
import json, pathlib, sys

ROOT = pathlib.Path('prompts')
SCHEMA = json.loads(pathlib.Path('scripts/prompt.schema.json').read_text())

def validate_schema(data, path):
    # Minimal manual validation to avoid external deps (jsonschema)
    missing = [k for k in ('target_model','parameters','messages') if k not in data]
    if missing:
        return [f"{path}: missing keys {missing}"]
    params = data.get('parameters', {})
    for k in ('reasoning_effort','verbosity'):
        if k not in params:
            return [f"{path}: parameters.{k} missing"]
    if not isinstance(data['messages'], list) or not data['messages']:
        return [f"{path}: messages invalid"]
    for m in data['messages']:
        if not isinstance(m, dict) or 'role' not in m or 'content' not in m:
            return [f"{path}: message entry invalid"]
    return []

errors = []
for jf in ROOT.rglob('*.json'):
    if jf.name == 'index.json':
        continue
    try:
        data = json.loads(jf.read_text())
    except Exception as e:
        errors.append(f"{jf}: JSON parse error: {e}")
        continue
    errors.extend(validate_schema(data, jf))
    # Pairing rule: must have .md sibling
    md = jf.with_suffix('.md')
    if not md.exists():
        errors.append(f"{jf}: missing markdown doc {md.name}")

if errors:
    for e in errors:
        print(e, file=sys.stderr)
    sys.exit(1)
print("Schema + pairing validation passed.")
