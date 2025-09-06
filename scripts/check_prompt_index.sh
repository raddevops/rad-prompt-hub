#!/usr/bin/env bash
set -euo pipefail
echo "[check_prompt_index] Verifying prompt index accurately reflects actual prompt files..."

INDEX=prompts/index.json
if [[ ! -f "$INDEX" ]]; then
  echo "Missing prompts/index.json" >&2; exit 1; fi

# Get list of actual prompt files (excluding index.json itself)
actual_files=$(find prompts -type f -name '*.json' ! -name 'index.json' | sort)

# Get list of files referenced in the index
if ! indexed_files=$(jq -r '.prompts[].path' "$INDEX" 2>/dev/null | sort); then
  echo "Failed to parse prompts/index.json" >&2; exit 1; fi

# Compare the two lists
if [[ "$actual_files" != "$indexed_files" ]]; then
  echo "Index-to-file mismatch detected." >&2
  echo "Actual prompt files:" >&2
  echo "$actual_files" >&2
  echo "Files listed in index:" >&2  
  echo "$indexed_files" >&2
  echo "Run: python scripts/build_prompts_index.py and commit prompts/index.json" >&2
  exit 1
fi

echo "Index OK - accurately reflects all prompt files."
