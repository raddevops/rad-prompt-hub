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
    for k in ('reasoning_effort',):
        if k not in params:
            return [f"{path}: parameters.{k} missing"]
    if not isinstance(data['messages'], list) or not data['messages']:
        return [f"{path}: messages invalid"]
    for m in data['messages']:
        if not isinstance(m, dict) or 'role' not in m or 'content' not in m:
            return [f"{path}: message entry invalid"]
    # Validate version field if present (semantic versioning)
    if 'version' in data:
        version = data['version']
        if not isinstance(version, str):
            return [f"{path}: version must be a string"]
        # Basic semantic version pattern check: MAJOR.MINOR.PATCH
        import re
        semver_pattern = r'^([0-9]+)\.([0-9]+)\.([0-9]+)(?:-([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?(?:\+([0-9A-Za-z-]+(?:\.[0-9A-Za-z-]+)*))?$'
        if not re.match(semver_pattern, version):
            return [f"{path}: version must follow semantic versioning (e.g., '1.0.0', '2.1.3-beta.1')"]
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
