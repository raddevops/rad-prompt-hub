#!/usr/bin/env bash
set -euo pipefail
echo "[check_prompt_index] Verifying prompt index matches generated output..."
ORIG=prompts/index.json
if [[ ! -f "$ORIG" ]]; then
  echo "Missing prompts/index.json" >&2; exit 1; fi
TMP=$(mktemp)
cp "$ORIG" "$TMP.orig"
python scripts/build_prompts_index.py >/dev/null 2>&1 || { echo "Index rebuild failed" >&2; exit 1; }
if ! diff -q "$ORIG" "$TMP.orig" >/dev/null; then
  echo "Index drift detected. Run: python scripts/build_prompts_index.py and commit prompts/index.json" >&2
  echo "--- diff (new vs committed) ---" >&2
  diff -u "$TMP.orig" "$ORIG" || true
  exit 1
fi
echo "Index OK."
