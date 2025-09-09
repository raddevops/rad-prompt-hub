#!/bin/bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROMPT_FILE="$SCRIPT_DIR/promptsmith.json"

echo "🔎 Schema validate"
python3 "$(git rev-parse --show-toplevel)/scripts/schema_validate_prompts.py" "$PROMPT_FILE"

# Minified single-line check (0-1 line breaks)
LC=$(wc -l < "$PROMPT_FILE" | tr -d ' ')
if [[ "$LC" -le 1 ]]; then echo "✅ Minified (0-1 lines)"; else echo "❌ Not minified"; exit 1; fi
