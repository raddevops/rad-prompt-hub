# Implementation Checklist: GitHub Ruleset with Path-Based Branch Protection

This checklist provides step-by-step instructions for implementing Option C from the original issue: path-based branch protection using GitHub Rulesets.

## Prerequisites

- [ ] Repository admin access
- [ ] Understanding of current required status checks
- [ ] List of workflows that should be path-conditional

## Current State Analysis

### Workflows with Path Filters

Current workflows that use path-based triggers:

1. **prompt-guardrails.yml**
   - Triggers on: `prompts/**`, `scripts/**`, `.github/workflows/prompt-guardrails.yml`
   - Jobs:
     - `validate-prompts`
     - `branch-name-policy` (PR only)

2. **validate-prompts.yml**
   - Triggers on: all pull requests and pushes to main
   - Jobs:
     - `validate`

### Status Checks to Require

Based on workflow analysis, these checks should be required when relevant paths are modified:

- `validate-prompts / validate` (universal check)
- `Prompt Guardrails / validate-prompts` (path-conditional)
- `Prompt Guardrails / branch-name-policy` (path-conditional)

## Implementation Steps

### Phase 1: Review Current Configuration

- [x] Document current branch protection rules
- [x] Identify required status checks
- [x] List path-based workflows
- [x] Determine which checks should be path-conditional

### Phase 2: Create Ruleset Documentation

- [x] Create comprehensive ruleset guide (`docs/BRANCH_PROTECTION_RULESET.md`)
- [x] Create quick start guide (`docs/RULESET_QUICK_START.md`)
- [x] Update README.md with ruleset references
- [x] Update CONTRIBUTING.md with CI information

### Phase 3: Configure GitHub Ruleset (Manual Steps - To Be Performed by Repository Admin)

**Important:** The following steps must be performed manually in the GitHub web UI by a repository administrator. Rulesets with path conditions cannot be fully created via API at this time.

#### Step 3.1: Create Path-Conditional Ruleset

- [ ] Navigate to repository Settings → Rules → Rulesets
- [ ] Click "New ruleset" → "New branch ruleset"
- [ ] Configure basic settings:
  - [ ] Name: `Prompt & Script Protection`
  - [ ] Enforcement: Active
  - [ ] Bypass list: (Optional) Add repository administrators
- [ ] Configure target branches:
  - [ ] Click "Add target"
  - [ ] Select "Include by pattern"
  - [ ] Enter pattern: `main`
- [ ] **Configure path conditions (THIS IS THE KEY FEATURE):**
  - [ ] Scroll to "Path conditions" section
  - [ ] Click "Add path condition"
  - [ ] Click "Add inclusion pattern" and add each:
    - [ ] `prompts/**`
    - [ ] `scripts/**`
    - [ ] `.github/workflows/prompt-guardrails.yml`
    - [ ] `.github/workflows/validate-prompts.yml`
- [ ] Configure branch protections:
  - [ ] Enable "Require a pull request before merging"
    - [ ] Check "Require review from Code Owners"
    - [ ] Check "Dismiss stale pull request approvals when new commits are pushed"
    - [ ] Check "Require conversation resolution before merging"
  - [ ] Enable "Require status checks to pass"
    - [ ] Check "Require branches to be up to date before merging"
    - [ ] Click "Add checks" and search for each check:
      - [ ] `validate-prompts / validate`
      - [ ] `Prompt Guardrails / validate-prompts`
      - [ ] `Prompt Guardrails / branch-name-policy`
  - [ ] Enable "Block force pushes"
  - [ ] Enable "Restrict deletions"
- [ ] Click "Create" to save the ruleset

#### Step 3.2: Create Base Protection Ruleset (Optional)

If you want universal protections that apply regardless of files changed:

- [ ] Navigate to Settings → Rules → Rulesets
- [ ] Click "New ruleset" → "New branch ruleset"
- [ ] Configure:
  - [ ] Name: `Base Branch Protection`
  - [ ] Enforcement: Active
  - [ ] Target branches: `main`
  - [ ] Path conditions: (Leave empty to apply to all files)
  - [ ] Enable basic protections:
    - [ ] Require pull request before merging
    - [ ] Block force pushes
    - [ ] Restrict deletions
  - [ ] Add any universal checks (e.g., CodeQL, secrets scanning)
- [ ] Click "Create"

#### Step 3.3: Remove Legacy Branch Protection

- [ ] Navigate to Settings → Branches
- [ ] Find the rule for `main` branch (if any)
- [ ] Click "Delete" to remove the old configuration
- [ ] Confirm that rulesets are now the only protection mechanism

### Phase 4: Testing and Validation

#### Test Case 1: Prompt Changes

- [ ] Create test branch: `test/prompt-validation-YYYYMMDD`
- [ ] Modify a file in `prompts/` directory
- [ ] Create pull request
- [ ] Verify required checks appear:
  - [ ] `validate-prompts / validate`
  - [ ] `Prompt Guardrails / validate-prompts`
  - [ ] `Prompt Guardrails / branch-name-policy`
- [ ] Verify checks run and complete
- [ ] Close/delete test PR

#### Test Case 2: Documentation-Only Changes

- [ ] Create test branch: `test/docs-only-YYYYMMDD`
- [ ] Modify only files in `docs/` directory
- [ ] Create pull request
- [ ] Verify prompt-specific checks **do NOT** appear as required
- [ ] Verify only base protections apply
- [ ] Verify PR can be merged without prompt validation
- [ ] Close/delete test PR

#### Test Case 3: Mixed Changes

- [ ] Create test branch: `test/mixed-changes-YYYYMMDD`
- [ ] Modify files in both `docs/` and `prompts/` directories
- [ ] Create pull request
- [ ] Verify all required checks appear (because `prompts/` is touched)
- [ ] Verify checks run and complete
- [ ] Close/delete test PR

#### Test Case 4: Script Changes

- [ ] Create test branch: `test/script-changes-YYYYMMDD`
- [ ] Modify a file in `scripts/` directory
- [ ] Create pull request
- [ ] Verify required checks appear
- [ ] Close/delete test PR

#### Test Case 5: Workflow Changes

- [ ] Create test branch: `test/workflow-changes-YYYYMMDD`
- [ ] Modify `.github/workflows/prompt-guardrails.yml`
- [ ] Create pull request
- [ ] Verify required checks appear
- [ ] Close/delete test PR

### Phase 5: Verification Commands

Run these commands to verify configuration:

- [ ] List rulesets:
  ```bash
  gh api "/repos/raddevops/rad-prompt-hub/rulesets" | jq '.[] | {id, name, enforcement}'
  ```

- [ ] Get ruleset details (replace `{id}` with actual ID):
  ```bash
  gh api "/repos/raddevops/rad-prompt-hub/rulesets/{id}" | jq '.'
  ```

- [ ] Verify no legacy branch protection (should error or return empty):
  ```bash
  gh api "/repos/raddevops/rad-prompt-hub/branches/main/protection" 2>&1 | head -5
  ```

### Phase 6: Documentation and Communication

- [x] Create implementation guide
- [x] Update README.md
- [x] Update CONTRIBUTING.md
- [ ] Communicate changes to contributors (GitHub Discussion or Issue)
- [ ] Update any external documentation that references CI requirements

## Success Criteria

The implementation is successful when:

- [ ] Path-conditional ruleset is active and enforced
- [ ] Required checks appear only for PRs modifying relevant paths
- [ ] Documentation-only PRs don't wait for prompt validation checks
- [ ] All test cases pass as expected
- [ ] No "expected" checks appear for unrelated PRs
- [ ] Contributors understand the new CI behavior
- [ ] Documentation is complete and accessible

## Rollback Plan

If issues arise:

1. **Disable the ruleset:**
   - Go to Settings → Rules → Rulesets
   - Click on the ruleset name
   - Change Enforcement to "Disabled"
   - Investigate the issue

2. **Revert to legacy branch protection:**
   - Go to Settings → Branches
   - Add branch protection rule for `main`
   - Configure required status checks manually
   - Disable or delete the ruleset

3. **Communicate the issue:**
   - Open a GitHub issue describing the problem
   - Tag repository maintainers
   - Document observed behavior vs. expected behavior

## Troubleshooting

### Issue: Required checks still appearing for unrelated PRs

**Diagnosis:**
- Check ruleset enforcement status
- Verify path patterns match exactly
- Confirm workflow file paths match conditions

**Solution:**
- Ensure enforcement is "Active"
- Double-check path inclusion patterns
- Clear browser cache and refresh PR page

### Issue: Checks not appearing when they should

**Diagnosis:**
- Check workflow trigger paths
- Verify required check names match workflow job names exactly
- Ensure PR modifies files matching path conditions

**Solution:**
- Update workflow `paths:` filters if needed
- Correct required check names in ruleset
- Verify files changed in PR

### Issue: Legacy branch protection conflicts

**Diagnosis:**
- Check if old branch protection rules exist
- Verify rulesets are active

**Solution:**
- Remove legacy branch protection rules
- Ensure only rulesets are active

## Maintenance

### Regular Reviews

Perform these reviews quarterly:

- [ ] Review ruleset effectiveness
- [ ] Check for new workflows requiring path conditions
- [ ] Update path patterns if repository structure changes
- [ ] Verify required check names match current workflows
- [ ] Update documentation as needed

### Adding New Workflows

When adding new workflows with path-based triggers:

1. Update the ruleset to include new required checks (if needed)
2. Ensure workflow has appropriate `paths:` filters
3. Test with sample PR
4. Update documentation

### Modifying Path Patterns

When repository structure changes:

1. Review affected rulesets
2. Update path inclusion/exclusion patterns
3. Test with sample PRs
4. Document changes in PR description

## References

- [GitHub Rulesets Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets-for-a-branch)
- [Repository Documentation: BRANCH_PROTECTION_RULESET.md](BRANCH_PROTECTION_RULESET.md)
- [Repository Documentation: RULESET_QUICK_START.md](RULESET_QUICK_START.md)
- [Original Issue: Implement GitHub ruleset with path-based branch protection](https://github.com/raddevops/rad-prompt-hub/issues/XXX)

## Notes

- Rulesets with path conditions require manual configuration via GitHub web UI
- GitHub API support for path conditions in rulesets is limited as of 2025
- Path patterns use glob syntax (`**` matches all subdirectories)
- Ruleset changes may take a few minutes to propagate
- Testing is critical - always verify with sample PRs before relying on the configuration
