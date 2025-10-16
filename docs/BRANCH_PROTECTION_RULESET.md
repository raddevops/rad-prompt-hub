# GitHub Branch Protection Ruleset Configuration

This document describes the path-based branch protection ruleset configuration for the `rad-prompt-hub` repository. This approach ensures required status checks only appear when relevant files are modified, eliminating perpetually "expected" jobs for unrelated PRs.

## Problem Statement

Previously, required status checks (like "Prompt Guardrails") would appear as "expected" for all PRs, even when they modified files that don't require validation (e.g., documentation-only changes in `docs/` that don't touch prompts or scripts). This created confusion and unnecessary waiting for checks that would never run.

## Solution: Path-Based Rulesets

GitHub Rulesets allow you to configure branch protections that apply conditionally based on file paths. This enables us to require specific checks only when relevant files are changed.

## Ruleset Configuration

### Ruleset 1: Prompt and Script Changes

**Name:** `Prompt & Script Protection`

**Target:** Branch `main` (and optionally other protected branches)

**Path Conditions:**
- Include paths:
  - `prompts/**`
  - `scripts/**`
  - `.github/workflows/prompt-guardrails.yml`
  - `.github/workflows/validate-prompts.yml`

**Required Status Checks:**
- `validate-prompts / validate`
- `Prompt Guardrails / validate-prompts`
- `Prompt Guardrails / branch-name-policy`

**Additional Rules:**
- Require pull request before merging: Yes
- Require review from Code Owners: Yes
- Dismiss stale reviews: Yes
- Require conversation resolution: Yes
- Block force pushes: Yes
- Restrict deletions: Yes

### Ruleset 2: Base Protection (All Changes)

**Name:** `Base Branch Protection`

**Target:** Branch `main`

**Path Conditions:** Apply to all files

**Required Status Checks:**
- Any universal checks (e.g., security scans that should run on all PRs)

**Additional Rules:**
- Require pull request before merging: Yes
- Block force pushes: Yes
- Restrict deletions: Yes

## Implementation Steps

### Step 1: Access Repository Settings

1. Navigate to your repository on GitHub
2. Go to **Settings** → **Rules** → **Rulesets**
3. Click **New ruleset** → **New branch ruleset**

### Step 2: Create Prompt & Script Protection Ruleset

1. **Ruleset name:** `Prompt & Script Protection`
2. **Enforcement status:** Active
3. **Bypass list:** Add repository administrators if needed (for emergency fixes)
4. **Target branches:**
   - Click **Add target** → **Include by pattern**
   - Enter pattern: `main`
   - (Optional) Add other branches like `release/**`

5. **Path conditions:**
   - Click **Add path condition**
   - Click **Add inclusion pattern** and add:
     - `prompts/**`
     - `scripts/**`
     - `.github/workflows/prompt-guardrails.yml`
     - `.github/workflows/validate-prompts.yml`

6. **Branch protections:**
   - Enable **Require a pull request before merging**
     - Check **Require review from Code Owners**
     - Check **Dismiss stale pull request approvals when new commits are pushed**
     - Check **Require conversation resolution before merging**
   - Enable **Require status checks to pass**
     - Click **Add checks** and search for:
       - `validate-prompts / validate`
       - `Prompt Guardrails / validate-prompts`
       - `Prompt Guardrails / branch-name-policy`
     - Check **Require branches to be up to date before merging**
   - Enable **Block force pushes**
   - Enable **Restrict deletions**

7. Click **Create**

### Step 3: Create Base Protection Ruleset (Optional)

If you want universal protections that apply regardless of files changed:

1. **Ruleset name:** `Base Branch Protection`
2. **Enforcement status:** Active
3. **Target branches:** `main`
4. **Path conditions:** Leave empty (applies to all files)
5. **Branch protections:**
   - Enable **Require a pull request before merging**
   - Enable **Block force pushes**
   - Enable **Restrict deletions**
   - Add any universal status checks (e.g., CodeQL, secrets scanning)

6. Click **Create**

### Step 4: Disable Legacy Branch Protection Rules

If you previously had branch protection rules configured:

1. Go to **Settings** → **Branches**
2. Find the rule for `main` branch
3. Click **Edit** or **Delete** to remove the old configuration
4. Rulesets will take over the protection

**Note:** Rulesets and classic branch protection rules can coexist, but it's recommended to migrate fully to rulesets for consistency.

## Testing the Configuration

### Test Case 1: PR with Prompt Changes

Create a test PR that modifies files in `prompts/`:

```bash
git checkout -b test/prompt-change-20251016
# Create a test prompt directory (following the repository structure)
mkdir -p prompts/test-category/test-prompt
echo '{"target_model":"gpt-4","parameters":{"reasoning_effort":"standard","verbosity":"concise"},"messages":[{"role":"system","content":"Test prompt"}]}' > prompts/test-category/test-prompt/test-prompt.json
echo "# Test Prompt" > prompts/test-category/test-prompt/test-prompt.md
git add prompts/test-category/
git commit -m "test: add test prompt"
git push origin test/prompt-change-20251016
```

**Expected Result:**
- Required checks appear: `validate-prompts / validate`, `Prompt Guardrails / validate-prompts`
- Checks must pass before merge is allowed

### Test Case 2: PR with Documentation-Only Changes

Create a test PR that modifies only documentation files:

```bash
git checkout -b test/docs-change-20251016
echo "# Test Documentation Update" >> docs/test-update.md
git add docs/test-update.md
git commit -m "docs: update test documentation"
git push origin test/docs-change-20251016
```

**Expected Result:**
- Prompt-specific required checks **do not** appear
- Only base protection rules apply (if configured)
- PR can be merged without waiting for prompt validation checks

### Test Case 3: PR with Mixed Changes

Create a test PR that modifies both prompts and documentation:

```bash
git checkout -b test/mixed-change-20251016
echo "# Updated Documentation" >> docs/usage-guide.md
# Modify an existing prompt (to be realistic)
echo "Updated" >> prompts/engineering/code-review/code-review.md
git add docs/usage-guide.md prompts/engineering/code-review/code-review.md
git commit -m "feat: update code review prompt and docs"
git push origin test/mixed-change-20251016
```

**Expected Result:**
- Required checks appear because the PR touches `prompts/`
- All prompt validation checks must pass before merge

## Verification Commands

Check your current ruleset configuration via GitHub CLI:

```bash
# List all rulesets for the repository
gh api "/repos/{owner}/{repo}/rulesets" | jq '.[] | {id, name, enforcement, target}'

# Get details of a specific ruleset
gh api "/repos/{owner}/{repo}/rulesets/{ruleset_id}" | jq '.'
```

Check branch protection status:

```bash
# Check if legacy branch protection exists
gh api "/repos/{owner}/{repo}/branches/main/protection" | jq '.required_status_checks'
```

## Troubleshooting

### Required checks still appearing for unrelated PRs

1. **Verify ruleset is active:** Check that enforcement status is "Active", not "Evaluate" or "Disabled"
2. **Check path patterns:** Ensure path conditions use correct patterns (e.g., `prompts/**` not `prompts/*`)
3. **Clear browser cache:** GitHub UI may cache old protection rules
4. **Wait for propagation:** Ruleset changes may take a few minutes to take effect

### Checks not appearing when they should

1. **Verify workflow triggers:** Ensure workflow files have correct `paths:` filters
2. **Check workflow names:** Required check names must exactly match workflow job names
3. **Branch up-to-date:** Ruleset applies to the target branch; ensure PR branch is tracking it

### Legacy rules conflict

1. **Remove old branch protection:** Navigate to Settings → Branches → Delete old rule for `main`
2. **Consolidate protections:** Migrate all protections to rulesets for consistency

## Benefits

✅ **No more stuck PRs:** Documentation-only PRs don't wait for prompt validation  
✅ **Faster merges:** Contributors see only relevant checks  
✅ **Clear expectations:** Required checks match changed files  
✅ **Improved CI efficiency:** Workflows run only when needed  
✅ **Better developer experience:** Less confusion about missing/pending checks

## Maintenance

### Adding New Check Requirements

When adding new workflows or checks:

1. Update the relevant ruleset to include the new check name
2. Ensure workflow has appropriate `paths:` filters
3. Test with a sample PR to verify behavior

### Modifying Path Patterns

To add or remove protected paths:

1. Navigate to Settings → Rules → Rulesets
2. Click the ruleset name
3. Edit path conditions
4. Save changes
5. Test with sample PRs

### Reviewing Ruleset Effectiveness

Periodically review:

- Are checks appearing as expected?
- Are any PRs getting stuck unnecessarily?
- Are path patterns too broad or too narrow?
- Do new workflows need to be added to required checks?

## References

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets-for-a-branch)
- [GitHub Required Status Checks](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches#require-status-checks-before-merging)
- [GitHub Actions Path Filters](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#onpushpull_requestpull_request_targetpathspaths-ignore)

## Related Documentation

- [SECURITY-SINGLE-OWNER.md](SECURITY-SINGLE-OWNER.md) - Security configuration for single-owner repositories
- [CONTRIBUTING.md](../CONTRIBUTING.md) - Contribution guidelines and validation requirements
- [Prompt Guardrails Workflow](../.github/workflows/prompt-guardrails.yml) - Main validation workflow
