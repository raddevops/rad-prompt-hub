#!/usr/bin/env bash
# Enable GitHub security features and optional branch protection.
# Requirements: gh, jq, git
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }; }
need gh; need jq; need git

OWNER="${OWNER:-}"
REPO="${REPO:-}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
REQUIRED_CHECKS="${REQUIRED_CHECKS:-}"  # CSV, e.g. validate-prompts,codeql

# Infer owner/repo from origin if not provided
if [[ -z "$OWNER" || -z "$REPO" ]]; then
  if git remote get-url origin >/dev/null 2>&1; then
    url=$(git remote get-url origin)
    if [[ "$url" =~ github.com[:/]{1}([^/]+)/([^/.]+) ]]; then
      OWNER="${OWNER:-${BASH_REMATCH[1]}}"
      REPO="${REPO:-${BASH_REMATCH[2]}}"
    fi
  fi
fi

if [[ -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: OWNER=<org_or_user> REPO=<repo> [DEFAULT_BRANCH=main] [REQUIRED_CHECKS=a,b] $0" >&2
  exit 1
fi

echo "== Repo: $OWNER/$REPO (branch: $DEFAULT_BRANCH) =="

echo "Enabling vulnerability alerts..." && gh api -X PUT -H "Accept: application/vnd.github+json" \
  "/repos/$OWNER/$REPO/vulnerability-alerts" >/dev/null || true

echo "Enabling automated security fixes..." && gh api -X PUT -H "Accept: application/vnd.github+json" \
  "/repos/$OWNER/$REPO/automated-security-fixes" >/dev/null || true

echo "Enabling secret scanning + push protection (if available)..." && gh api -X PATCH \
  -H "Accept: application/vnd.github+json" -H "Content-Type: application/json" \
  "/repos/$OWNER/$REPO" -d '{"security_and_analysis":{"secret_scanning":{"status":"enabled"},"secret_scanning_push_protection":{"status":"enabled"}}}' >/dev/null || true

echo "Configuring branch protection on $DEFAULT_BRANCH..."
if [[ -n "$REQUIRED_CHECKS" ]]; then
  ctxs=$(jq -Rc 'split(",")' <<<"$REQUIRED_CHECKS")
  bp=$(jq -n --argjson contexts "$ctxs" '{
    required_status_checks: {strict: true, contexts: $contexts},
    enforce_admins: true,
    required_pull_request_reviews: {dismiss_stale_reviews: true, require_code_owner_reviews: true, required_approving_review_count: 1},
    restrictions: null,
    required_linear_history: false,
    allow_force_pushes: false,
    allow_deletions: false,
    required_conversation_resolution: true
  }')
else
  bp='{
    "required_status_checks": null,
    "enforce_admins": true,
    "required_pull_request_reviews": {"dismiss_stale_reviews": true, "require_code_owner_reviews": true, "required_approving_review_count": 1},
    "restrictions": null,
    "required_linear_history": false,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "required_conversation_resolution": true
  }'
fi

gh api -X PUT -H "Accept: application/vnd.github+json" -H "Content-Type: application/json" \
  "/repos/$OWNER/$REPO/branches/$DEFAULT_BRANCH/protection" -d "$bp" >/dev/null || true

echo "Verifying security settings:"
gh api -H "Accept: application/vnd.github+json" "/repos/$OWNER/$REPO" | jq '.security_and_analysis'

echo "Verifying branch protection:"
gh api -H "Accept: application/vnd.github+json" "/repos/$OWNER/$REPO/branches/$DEFAULT_BRANCH/protection" | jq '{enforce_admins, required_pull_request_reviews, required_status_checks, allow_force_pushes, allow_deletions, required_conversation_resolution}'

echo "Done."
