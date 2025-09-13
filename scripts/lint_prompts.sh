#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMA="${ROOT_DIR}/scripts/prompt.schema.json"
PROMPTS_DIR="${ROOT_DIR}/prompts"

fail() { echo "❌ $1" >&2; exit 1; }
info() { echo "🔍 $1"; }
ok() { echo "✅ $1"; }

command -v jq >/dev/null 2>&1 || fail "jq is required"
command -v python3 >/dev/null 2>&1 || fail "python3 is required"

info "Collecting prompt JSON files..."
# Collect files (portable, no bash array built-ins assumption)
FILES_TMP=$(mktemp)
find "$PROMPTS_DIR" -mindepth 2 -maxdepth 6 -type f -name '*.json' | sort > "$FILES_TMP"
TOTAL_FILES=$(wc -l < "$FILES_TMP" | tr -d ' ')
if [ "$TOTAL_FILES" -eq 0 ]; then
  fail "No prompt JSON files found"
fi
ok "Found $TOTAL_FILES prompt files"

PY_SCHEMA_CHECK="${ROOT_DIR}/scripts/schema_validate_prompts.py"
if [[ ! -f "$PY_SCHEMA_CHECK" ]]; then
  fail "Missing schema validation script: $PY_SCHEMA_CHECK"
fi

info "Running schema validation (python)..."
python3 "$PY_SCHEMA_CHECK" >/dev/null && ok "Schema validation passed" || fail "Schema validation failed"

TOTAL=0; ERR=0
declare -a PROBLEMS

# POSIX ERE compatible semver (no non-capturing groups): MAJOR.MINOR.PATCH(-PRERELEASE)?(+BUILD)?
semver_regex='^([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?(\+[0-9A-Za-z-]+(\.[0-9A-Za-z-]+)*)?$'

info "Applying custom lint rules..."
while IFS= read -r f; do
  ((TOTAL++))
  raw_line_count=$(wc -l < "$f" | tr -d ' ')
  name="${f#$ROOT_DIR/}"

  # Basic parse
  if ! jq -e . "$f" >/dev/null 2>&1; then
    PROBLEMS+=("$name: invalid JSON parse")
    ((ERR++))
    continue
  fi

  # Minified expectation: encourage <= 2 lines
  if (( raw_line_count > 2 )); then
    PROBLEMS+=("$name: not minified (lines=$raw_line_count)")
    ((ERR++))
  fi

  version=$(jq -r '.version // empty' "$f")
  if [[ -n "$version" && ! $version =~ $semver_regex ]]; then
    PROBLEMS+=("$name: version not valid semver -> $version")
    ((ERR++))
  fi

  # Required top-level fields per schema
  for req in target_model parameters messages; do
    if ! jq -e ".$req" "$f" >/dev/null 2>&1; then
      PROBLEMS+=("$name: missing required key '$req'")
      ((ERR++))
    fi
  done

  # parameters sub-keys
  for p in reasoning_effort verbosity; do
    if ! jq -e ".parameters.$p" "$f" >/dev/null 2>&1; then
      PROBLEMS+=("$name: missing parameters.$p")
      ((ERR++))
    fi
  done

  # Messages roles restriction check (system/user only)
  invalid_roles=$(jq -r '.messages[].role' "$f" | grep -vE '^(system|user)$' || true)
  if [[ -n "$invalid_roles" ]]; then
    PROBLEMS+=("$name: invalid message roles: $(echo "$invalid_roles" | tr '\n' ' ')")
    ((ERR++))
  fi

  # Guard: discourage trailing spaces (sample heuristic) – only for minified (single line) prompts
  if (( raw_line_count <= 2 )); then
    if grep -qE ' +$' "$f"; then
      PROBLEMS+=("$name: trailing spaces detected")
      ((ERR++))
    fi
  fi
done < "$FILES_TMP"

if (( ERR > 0 )); then
  echo "\n❌ Lint failed ($ERR issues across $TOTAL files):"
  for p in "${PROBLEMS[@]}"; do
    echo " - $p"
  done
  exit 1
fi

ok "All $TOTAL prompt files passed custom lint rules"
exit 0