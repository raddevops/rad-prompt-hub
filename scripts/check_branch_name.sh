#!/usr/bin/env bash
set -euo pipefail

# Enforce branch naming convention similar to: chore/gitignore-hardening-20250906
# Pattern: <type>/<slug>-YYYYMMDD
# - type: one of feat|fix|chore|docs|refactor|test|perf|ci
# - slug: kebab-case, 1..60 chars, [a-z0-9-], must start with a letter, no consecutive hyphens
# - date: required 8-digit UTC date (YYYYMMDD)

BRANCH="${1:-}"
if [[ -z "$BRANCH" ]]; then
  # Try to discover current branch
  if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
  fi
fi

if [[ -z "$BRANCH" || "$BRANCH" == "HEAD" ]]; then
  echo "Could not determine branch name. Skipping check." >&2
  exit 0
fi

# Allow main and release/x.y.z style branches
if [[ "$BRANCH" == "main" || "$BRANCH" =~ ^release/[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  exit 0
fi

# Use a bash-compatible regex and disallow consecutive hyphens in slug
# Slug part: starts with a letter, then zero or more of (alphanumerics or hyphen+alphanumerics)
# This enforces hyphens must be followed by one or more [a-z0-9], preventing "--"
re='^(feat|fix|chore|docs|refactor|test|perf|ci)/([a-z][a-z0-9]*(-[a-z0-9]+)*)-([0-9]{8})$'
if [[ ! "$BRANCH" =~ $re ]]; then
  cat >&2 <<'EOF'
Branch name does not follow convention.
Expected: <type>/<slug>-YYYYMMDD
Where:
  - type: feat|fix|chore|docs|refactor|test|perf|ci
  - slug: kebab-case [a-z0-9-], starts with a letter
  - date: 8 digits (YYYYMMDD)
Examples:
  - feat/new-search-api-20250906
  - fix/guardrail-npe-20250906
  - chore/gitignore-hardening-20250906
EOF
  exit 2
fi

exit 0
