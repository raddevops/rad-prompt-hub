#!/usr/bin/env bash
# convert.sh
#
# Convert Markdown prompt files into JSON (frontmatter + body) or raw YAML.
#
# Usage:
#   ./tools/convert.sh json   # Outputs JSON objects to stdout (one per file)
#   ./tools/convert.sh yaml   # Extracts just frontmatter YAML for each file
#
# Notes:
# - Lightweight implementation using awk / sed; not robust for complex YAML.
# - Future enhancement: replace with a Python script + strict schema validation.

set -euo pipefail

MODE="${1:-json}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROMPT_DIR="$ROOT_DIR/prompts"

if [[ ! -d "$PROMPT_DIR" ]]; then
  echo "Prompts directory not found: $PROMPT_DIR" >&2
  exit 1
fi

process_file() {
  local file="$1"
  # Extract frontmatter (line-based parsing to avoid unsupported non-greedy regex)
  local fm=""
  local body=""
  local in_fm=0
  local in_body=0
  while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$in_fm" -eq 0 && "$line" == "---" ]]; then
      in_fm=1
      continue
    fi
    if [[ "$in_fm" -eq 1 && "$line" == "---" ]]; then
      in_fm=0
      in_body=1
      continue
    fi
    if [[ "$in_fm" -eq 1 ]]; then
      fm+="$line"$'\n'
    elif [[ "$in_body" -eq 1 ]]; then
      body+="$line"$'\n'
    fi
  done < "$file"
  # Remove trailing newlines
  fm="${fm%$'\n'}"
  body="${body%$'\n'}"

      echo
    else
      # naive YAML to JSON-ish (only handles simple key: value & list inline)
      local json="{"
      while IFS= read -r line; do
        [[ -z "$line" ]] && continue
        if [[ "$line" =~ ^([a-zA-Z0-9_]+):[[:space:]]*(.*)$ ]]; then
          key="${BASH_REMATCH[1]}"
          val="${BASH_REMATCH[2]}"
            # Validate and re-serialize array value using Python
            if [[ "$val" =~ ^\[.*\]$ ]]; then
              valid_json=""
              if valid_json=$(echo "$val" | python3 -c 'import sys, json; s=sys.stdin.read().strip(); 
try: 
    arr=json.loads(s)
    if isinstance(arr, list):
        print(json.dumps(arr))
    else:
        sys.exit(1)
except Exception: 
    sys.exit(1)'); then
                json+="\"$key\": $valid_json, "
              else
                echo "Warning: Invalid JSON array for key '$key' in file '$file': $val" >&2
              fi
            else
              # Not an array, treat as string
              json+="\"$key\": \"${val//\"/\\\"}\", "
            fi
          else
            val="${val%\"}"; val="${val#\"}"
            json+="\"$key\": \"${val//\"/\\\"}\", "
          fi
        fi
      done <<< "$fm"
      json="${json%, }"
      json+="}"
      # Escape body newlines and double quotes minimally for JSON
      body_escaped=$(printf "%s" "$body" | sed ':a;N;$!ba;s/"/\\"/g;s/\n/\\n/g')
      echo "{\"file\": \"${file}\", \"metadata\": $json, \"body\": \"${body_escaped}\"}"
    fi
  else
    echo "Skipping (no frontmatter): $file" >&2
  fi
}

export -f process_file

find "$PROMPT_DIR" -type f -name "*.md" ! -path "*/templates/*" -print0 | while IFS= read -r -d '' f; do
  process_file "$f"
done