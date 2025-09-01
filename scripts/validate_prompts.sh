#!/usr/bin/env bash
set -euo pipefail
fail=0
while IFS= read -r -d '' jf; do
  md="${jf%.json}.md"
  if [[ ! -f "$md" ]]; then
    echo "Missing MD doc for $jf" >&2
    fail=1
  fi
  python - "$jf" <<'PY' || fail=1
import json,sys
path=sys.argv[1]
with open(path) as f:
    data=json.load(f)
required={'target_model','parameters','messages'}
missing=required-set(data)
if missing:
    print(f"{path}: missing top-level keys: {missing}"); sys.exit(1)
params=data.get('parameters',{})
if 'reasoning_effort' not in params:
    print(f"{path}: parameters.reasoning_effort missing"); sys.exit(1)
msgs=data.get('messages')
if not isinstance(msgs,list) or not msgs:
    print(f"{path}: messages invalid"); sys.exit(1)
PY
done < <(find prompts -type f -name '*.json' -print0)
if [[ $fail -eq 0 ]]; then
  echo "All prompts valid."
else
  echo "Validation failed." >&2
  exit 1
fi
