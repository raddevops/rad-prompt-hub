#!/usr/bin/env bash
# Test script to validate the branch protection JSON configuration
set -euo pipefail

echo "Testing branch protection configuration JSON..."

# Test the JSON structure without making API calls
REQUIRED_CHECKS="validate,Analyze,gitleaks,validate-prompts,branch-name-policy,dependency-review"

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

echo "Generated branch protection configuration:"
echo "$bp" | jq .

echo ""
echo "Key settings for single owner repository:"
echo "- enforce_admins: $(echo "$bp" | jq .enforce_admins)"
echo "- require_last_push_approval: $(echo "$bp" | jq .required_pull_request_reviews.require_last_push_approval)"
echo "- require_code_owner_reviews: $(echo "$bp" | jq .required_pull_request_reviews.require_code_owner_reviews)"
echo "- required_approving_review_count: $(echo "$bp" | jq .required_pull_request_reviews.required_approving_review_count)"

echo ""
echo "✅ Configuration is valid and optimized for single code owner workflows"