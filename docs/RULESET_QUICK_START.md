# Quick Start: GitHub Ruleset Implementation

This is a quick reference for implementing path-based branch protection using GitHub Rulesets.

## TL;DR

GitHub Rulesets allow you to require status checks only when specific files are modified. This prevents "expected" checks from appearing on PRs that don't need validation.

## Quick Implementation

### Option 1: GitHub Web UI (Recommended)

1. Go to **Settings** → **Rules** → **Rulesets** → **New ruleset** → **New branch ruleset**

2. Configure:
   ```
   Name: Prompt & Script Protection
   Enforcement: Active
   Target branches: main
   
   Path conditions (Include):
   - prompts/**
   - scripts/**
   - .github/workflows/prompt-guardrails.yml
   - .github/workflows/validate-prompts.yml
   
   Required status checks:
   - validate-prompts / validate
   - Prompt Guardrails / validate-prompts
   - Prompt Guardrails / branch-name-policy
   
   Other protections:
   ✓ Require pull request before merging
   ✓ Require review from Code Owners
   ✓ Dismiss stale reviews
   ✓ Require conversation resolution
   ✓ Block force pushes
   ✓ Restrict deletions
   ```

3. Click **Create**

### Option 2: GitHub CLI

Create a JSON file with ruleset configuration, then:

```bash
gh api -X POST "/repos/{owner}/{repo}/rulesets" --input ruleset.json
```

See `docs/BRANCH_PROTECTION_RULESET.md` for detailed JSON structure.

## Verification

Test with two PRs:

**Test 1:** Modify `prompts/test/test.json` → Required checks appear ✓  
**Test 2:** Modify `docs/test.md` → No prompt checks appear ✓

## Path Patterns

Use these patterns for common scenarios:

| Files to Protect | Pattern |
|------------------|---------|
| All prompts | `prompts/**` |
| Specific prompt category | `prompts/engineering/**` |
| All scripts | `scripts/**` |
| Workflow files | `.github/workflows/**` |
| Specific workflow | `.github/workflows/prompt-guardrails.yml` |
| Root config files | `*.json`, `*.yaml` |
| Combination | Multiple inclusion patterns |

## Common Issues

**Q: Checks still appear for unrelated PRs**  
A: Verify ruleset enforcement is "Active" and path patterns match changed files

**Q: Checks not appearing when they should**  
A: Ensure workflow job names exactly match required check names

**Q: Legacy branch protection conflict**  
A: Remove old branch protection rules under Settings → Branches

## Full Documentation

See [`docs/BRANCH_PROTECTION_RULESET.md`](BRANCH_PROTECTION_RULESET.md) for:
- Detailed implementation steps
- Complete testing procedures
- Troubleshooting guide
- Maintenance instructions
- API examples

## Related Files

- `.github/workflows/prompt-guardrails.yml` - Main validation workflow
- `.github/workflows/validate-prompts.yml` - Prompt validation workflow
- `CONTRIBUTING.md` - Contribution guidelines
