#!/usr/bin/env python3
import json, pathlib, hashlib, sys
root = pathlib.Path('prompts')
index = []
for jf in root.rglob('*.json'):
    # Skip the index file to avoid self-reference
    if jf.name == 'index.json':
        continue
    try:
        data = json.loads(jf.read_text())
    except Exception as e:
        print(f"WARN: skip {jf}: {e}", file=sys.stderr)
        continue
    slug = jf.stem
    category = jf.parent.name
    h = hashlib.sha256(json.dumps(data, sort_keys=True).encode()).hexdigest()[:12]
    index.append({
        "slug": slug,
        "category": category,
        "path": str(jf),
        "hash": h,
        "model": data.get("target_model"),
        "reasoning_effort": data.get("parameters", {}).get("reasoning_effort"),
        "verbosity": data.get("parameters", {}).get("verbosity")
    })
index_path = pathlib.Path('prompts/index.json')
index_path.parent.mkdir(parents=True, exist_ok=True)
index_path.write_text(json.dumps({"prompts": index}, separators=(',',':')) + '\n')
print(f"Wrote {index_path} with {len(index)} entries")
