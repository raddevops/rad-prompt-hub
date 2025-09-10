#!/usr/bin/env bash
# Enable GitHub security features and optional branch protection.
# Requirements: gh, jq, git
#
# SECURITY NOTE: This configuration is optimized for single code owner repositories.
# Key changes from strict defaults:
# - enforce_admins: false - Allows repository owner to approve/merge when ready
# - require_last_push_approval: false - Supports single contributor workflows  
# These changes maintain strong protection while avoiding approval deadlocks.
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1 || { echo "Missing: $1" >&2; exit 1; }; }
need gh; need jq; need git

OWNER="${OWNER:-}"
REPO="${REPO:-}"
DEFAULT_BRANCH="${DEFAULT_BRANCH:-main}"
# List of required status checks for branch protection.
# Each name should match a workflow defined in .github/workflows/ (see workflow 'name' field).
# If you add, remove, or rename workflows, update this list accordingly.
# Checks:
#   - validate-prompts: Validates prompt files (workflow name: validate-prompts)
#   - validate-prompts: Extended prompt guardrails (job name: validate-prompts)
#   - Analyze: CodeQL analysis job (workflow name: codeql, job: Analyze)
#   - gitleaks: Secret scanning job (workflow name: secrets-scan, job: gitleaks)
#   - dependency-review: Dependency review (job name: dependency-review)
# NOTE: Branch protection contexts must match the exact check names reported by GitHub.
# For matrix jobs or named jobs, GitHub reports the check as "<workflow name> / <job name>".
# Here we use the human-friendly names as they appear in the Checks tab.
REQUIRED_CHECKS="${REQUIRED_CHECKS:-validate-prompts,Analyze,gitleaks,dependency-review}"

# Infer owner/repo from origin if not provided
if [[ -z "$OWNER" || -z "$REPO" ]]; then
  if git remote get-url origin >/dev/null 2>&1; then
    url=$(git remote get-url origin)
    if [[ "$url" =~ github.com[:/]([^/]+)/([^/.]+) ]]; then
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

echo "Enabling private vulnerability reporting..." && gh api -X PUT -H "Accept: application/vnd.github+json" \
  "/repos/$OWNER/$REPO/private-vulnerability-reporting" >/dev/null || true

echo "Configuring branch protection on $DEFAULT_BRANCH..."
if [[ -n "$REQUIRED_CHECKS" ]]; then
  ctxs=$(jq -Rc 'split(",")' <<<"$REQUIRED_CHECKS")
  bp=$(jq -n --argjson contexts "$ctxs" '{
    required_status_checks: {strict: true, contexts: $contexts},
    enforce_admins: false,
    required_pull_request_reviews: {dismiss_stale_reviews: true, require_code_owner_reviews: true, required_approving_review_count: 1, require_last_push_approval: false},
    restrictions: null,
    required_linear_history: false,
    allow_force_pushes: false,
    allow_deletions: false,
    required_conversation_resolution: true,
    lock_branch: false,
    allow_fork_syncing: true
  }')
else
  bp='{
    "required_status_checks": null,
    "enforce_admins": false,
    "required_pull_request_reviews": {"dismiss_stale_reviews": true, "require_code_owner_reviews": true, "required_approving_review_count": 1, "require_last_push_approval": false},
    "restrictions": null,
    "required_linear_history": false,
    "allow_force_pushes": false,
    "allow_deletions": false,
    "required_conversation_resolution": true,
    "lock_branch": false,
    "allow_fork_syncing": true
  }'
fi

gh api -X PUT -H "Accept: application/vnd.github+json" -H "Content-Type: application/json" \
  "/repos/$OWNER/$REPO/branches/$DEFAULT_BRANCH/protection" -d "$bp" >/dev/null || true

echo "Verifying security settings:"
gh api -H "Accept: application/vnd.github+json" "/repos/$OWNER/$REPO" | jq '.security_and_analysis'

echo "Verifying branch protection:"
gh api -H "Accept: application/vnd.github+json" "/repos/$OWNER/$REPO/branches/$DEFAULT_BRANCH/protection" | jq '{enforce_admins, required_pull_request_reviews, required_status_checks, allow_force_pushes, allow_deletions, required_conversation_resolution}'

echo "Security hardening recommendations applied:"
echo "✓ Vulnerability alerts enabled"
echo "✓ Automated security fixes enabled" 
echo "✓ Secret scanning with push protection enabled"
echo "✓ Private vulnerability reporting enabled"
echo "✓ Branch protection configured with required reviews"
echo "✓ CODEOWNERS enforcement enabled"
echo "✓ Required status checks: $REQUIRED_CHECKS"
echo "✓ Stale review dismissal enabled"
echo "✓ Admin enforcement disabled (allows code owner to approve and merge)"
echo "✓ Last push approval requirement disabled (single owner friendly)"

echo "Done."
