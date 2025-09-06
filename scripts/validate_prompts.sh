#!/usr/bin/env bash
set -euo pipefail
fail=0
while IFS= read -r -d '' jf; do
  base="$(basename "$jf")"
  # Skip index.json (catalog)
  if [[ "$base" == "index.json" ]]; then
    continue
  fi
  md="${jf%.json}.md"
  if [[ ! -f "$md" ]]; then
    echo "Missing MD doc for $jf" >&2
    fail=1
  fi
  python scripts/schema_validate_prompts.py "$jf" || fail=1
done < <(find prompts -type f -name '*.json' -print0)
if [[ $fail -eq 0 ]]; then
  echo "All prompts valid."
else
  echo "Validation failed." >&2
  exit 1
fi
