#!/usr/bin/env bash
set -euo pipefail

echo "[check_tools_index] Verifying tools index matches generated output..."

ORIG="tools/index.json"

if [[ ! -f "$ORIG" ]]; then
  echo "Missing tools/index.json" >&2
  exit 1
fi

# Create temp file to store original index
TMP=$(mktemp)
cp "$ORIG" "$TMP.orig"

# Generate new index
if ! python scripts/build_tools_index.py >/dev/null 2>&1; then
  echo "Tools index rebuild failed" >&2
  exit 1
fi

# Compare with original (ignoring generated_at timestamp)
if ! diff -u <(jq --sort-keys 'del(.generated_at)' "$TMP.orig") <(jq --sort-keys 'del(.generated_at)' "$ORIG") >/dev/null; then
  echo "Tools index drift detected. Run: python scripts/build_tools_index.py and commit tools/index.json" >&2
  echo "--- diff (committed vs new) ---" >&2
  diff -u <(jq --sort-keys 'del(.generated_at)' "$TMP.orig") <(jq --sort-keys 'del(.generated_at)' "$ORIG") || true
  # Restore original file
  cp "$TMP.orig" "$ORIG"
  exit 1
fi

echo "Tools index OK."
rm -f "$TMP" "$TMP.orig"