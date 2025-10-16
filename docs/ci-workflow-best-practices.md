# CI Workflow Best Practices

This document explains best practices for GitHub Actions workflows based on issues we've encountered and resolved.

## Issue: Pending Checks That Never Complete

### Problem Description
We experienced "pending" CI checks that would never complete or report a status. This blocked PR merges and created confusion about build status.

### Root Causes Identified

#### 1. Missing Timeouts (Primary Issue)
**Symptom**: Workflows appear "pending" for hours or never complete  
**Cause**: No `timeout-minutes` configured on jobs  
**Impact**: Jobs could hang for up to 6 hours (GitHub's default timeout for hosted runners)

**Solution**: Add `timeout-minutes` to every job
```yaml
jobs:
  my-job:
    runs-on: ubuntu-latest
    timeout-minutes: 10  # Choose appropriate value
    steps:
      # ...
```

**Recommended Timeout Values**:
- Quick validation scripts: 5 minutes
- Python schema validation: 10 minutes
- Code scanning (CodeQL): 10 minutes
- Dependency review: 5 minutes
- Secret scanning: 10 minutes

#### 2. Logical Errors with continue-on-error
**Symptom**: Expected messages don't appear; workflow logic doesn't work as intended  
**Cause**: Using `continue-on-error: true` with `if: failure()`  
**Impact**: The `if: failure()` condition never triggers because `continue-on-error` prevents the step from failing

**Broken Pattern** ❌:
```yaml
- name: Check something
  continue-on-error: true
  run: ./might-fail.sh
- name: Report failure
  if: failure()  # This NEVER runs!
  run: echo "Check failed"
```

**Fixed Pattern** ✅:
```yaml
- name: Check something
  id: check
  continue-on-error: true
  run: ./might-fail.sh
- name: Report failure
  if: steps.check.outcome == 'failure'
  run: echo "Check failed"
```

#### 3. Silent Failures
**Symptom**: Action fails but no indication in logs or status  
**Cause**: `continue-on-error: true` without outcome reporting  
**Impact**: Failures go unnoticed

**Solution**: Always report outcomes for non-blocking steps
```yaml
- name: Non-critical action
  id: action
  continue-on-error: true
  uses: some/action@v1
- name: Report outcome
  if: steps.action.outcome == 'failure'
  run: echo "::warning::Action failed but not blocking"
```

## Best Practices for Workflow Design

### 1. Always Set Timeouts
Every job should have a `timeout-minutes` value appropriate for its expected duration.

### 2. Use Step Outcomes Correctly
When using `continue-on-error: true`:
- Add an `id` to the step
- Check `steps.<id>.outcome` not `failure()`
- Report the outcome clearly

### 3. Report Non-Blocking Failures
If a step is non-blocking, still log when it fails:
```yaml
run: echo "::warning::Check failed but not blocking merge"
```

### 4. Test Workflow Changes
Before merging workflow changes:
1. Test on a branch/PR
2. Verify all expected jobs run
3. Verify failure paths work correctly
4. Check timeout values are appropriate

### 5. Path Filters
When using `paths:` filters, be aware:
- The workflow won't run if paths don't match
- Don't set as required check if it's conditional
- Document why the filter exists

### 6. Use Appropriate Permissions
Set minimal required permissions:
```yaml
permissions:
  contents: read
  pull-requests: write  # Only if needed
```

## Quick Reference: Step Outcomes

GitHub Actions provides these step outcome values:
- `success` - Step completed successfully
- `failure` - Step failed
- `cancelled` - Workflow was cancelled
- `skipped` - Step was skipped

Access via: `steps.<step_id>.outcome`

## Related Files
- `.github/workflows/prompt-guardrails.yml` - Fixed branch-name-policy logic
- `.github/workflows/pr-labeler.yml` - Fixed silent failure reporting
- All workflow files - Added timeout values

## Resources
- [GitHub Actions: timeout-minutes](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idtimeout-minutes)
- [GitHub Actions: continue-on-error](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idstepscontinue-on-error)
- [GitHub Actions: steps context](https://docs.github.com/en/actions/learn-github-actions/contexts#steps-context)
