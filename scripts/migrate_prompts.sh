#!/usr/bin/env bash
set -euo pipefail
# Migrate prompts_json/*/*.json -> prompts/<category>/<file>.json placing next to existing MD About docs.
SRC_ROOT="prompts_json"
DEST_ROOT="prompts"
if [[ ! -d "$SRC_ROOT" ]]; then
  echo "Source $SRC_ROOT does not exist" >&2; exit 1; fi
find "$SRC_ROOT" -type f -name '*.json' | while read -r file; do
  rel="${file#$SRC_ROOT/}" # e.g. engineering/refactor-helper.json
  category="${rel%%/*}"    # part before first slash
  mkdir -p "$DEST_ROOT/$category"
  dest="$DEST_ROOT/$rel"
  # Ensure the full destination directory exists (including subdirectories)
  mkdir -p "$(dirname "$dest")"
  if [[ -f "$dest" ]]; then
    echo "Skipping existing $dest"; continue; fi
  if ! git mv "$file" "$dest"; then
    echo "Error: Failed to move $file to $dest" >&2
    exit 1
  fi
  echo "Moved $file -> $dest"
done
echo "Migration complete. Run scripts/build_prompts_index.py next, then remove empty prompts_json directory when satisfied."
