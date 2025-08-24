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
  local content
  content="$(cat "$file")"

  # Extract frontmatter
  if [[ "$content" =~ ^---$'\n'(.+?)$'\n'---$'\n'(.*) ]]; then
    local fm="${BASH_REMATCH[1]}"
    local body="${BASH_REMATCH[2]}"

    if [[ "$MODE" == "yaml" ]]; then
      echo "# $file"
      echo "$fm"
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
            valid_json=$(echo "$val" | python3 -c 'import sys, json; import re; s=sys.stdin.read().strip(); 
try: 
    arr=json.loads(s)
    print(json.dumps(arr))
except Exception: 
    sys.exit(1)')
            if [[ $? -eq 0 ]]; then
              json+="\"$key\": $valid_json, "
            else
              echo "Warning: Invalid JSON array for key '$key' in file '$file': $val" >&2
            fi
          else
            val="${val%\"}"; val="${val#\"}"
            json+="\"$key\": \"${val//\"/\\\"}\", "
          fi
        fi
      done <<< "$fm"
      json="${json%, }"
      json+="}"
      # Escape body newlines minimally
      body_escaped=$(printf "%s" "$body" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read()))')
      echo "{\"file\": \"${file}\", \"metadata\": $json, \"body\": $body_escaped}"
    fi
  else
    echo "Skipping (no frontmatter): $file" >&2
  fi
}

export -f process_file

find "$PROMPT_DIR" -type f -name "*.md" ! -path "*/templates/*" -print0 | while IFS= read -r -d '' f; do
  process_file "$f"
done