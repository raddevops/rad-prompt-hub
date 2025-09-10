# Security Checklist

This document provides a comprehensive security checklist for the rad-prompt-hub repository. Use this for regular security reviews and when onboarding new contributors.

## GitHub Repository Security Settings

### Branch Protection ✅
- [ ] Branch protection enabled on `main` branch
- [ ] Required status checks configured
- [ ] Require pull request reviews from CODEOWNERS
- [ ] Dismiss stale reviews when new commits pushed
- [ ] Require conversation resolution before merge
- [ ] Enforce for administrators
- [ ] No force pushes allowed
- [ ] No branch deletion allowed
- [ ] Require last push approval

### Access Controls ✅
- [ ] CODEOWNERS file covers all security-critical paths
- [ ] Two-factor authentication enforced for organization
- [ ] Minimum required permissions for collaborators
- [ ] Regular access review conducted

### Security Features ✅
- [ ] Secret scanning enabled with push protection
- [ ] Vulnerability alerts enabled
- [ ] Automated security fixes enabled
- [ ] Private vulnerability reporting enabled
- [ ] Dependabot security updates configured

## GitHub Actions Security

### Workflow Security ✅
- [ ] All actions pinned to commit SHAs (not tags)
- [ ] No `pull_request_target` with write permissions
- [ ] Minimal permissions principle applied
- [ ] Sensitive workflows restricted to main branch
- [ ] Fork pull requests require approval

### Action Inventory
Review and update SHA pins quarterly:

| Action | Current SHA | Purpose | Last Updated |
|--------|-------------|---------|--------------|
| actions/checkout | 692973e3d937129bcbf40652eb9f2f61becf3332 | Repository checkout | 2024-06-01 |
| actions/setup-python | f677139bbe7f9c59b41e40162b753c062f5d49a3 | Python setup | 2024-06-01 |
| actions/labeler | 8558fd74291d67161a8a78ce36a881fa63b766a9 | PR labeling | 2024-06-01 |
| github/codeql-action/init | 8214744c546c1e5c8f03dde8fab3a7353211988d | CodeQL analysis | 2024-06-01 |
| github/codeql-action/analyze | 8214744c546c1e5c8f03dde8fab3a7353211988d | CodeQL analysis | 2024-06-01 |
| gitleaks/gitleaks-action | cb7149b9db0aeca090dc68d348861ad4b72d0e67 | Secret scanning | 2024-06-01 |
| lycheeverse/lychee-action | 2b973e86fc7b1f6b36a93795fe2c9c6ae1118621 | Link checking | 2024-06-01 |
| actions/add-to-project | 244f685bbc3b7adfa8466e08b698b5577571133e | Project management | 2024-06-01 |
| actions/dependency-review-action | 5a2ce3f5b92ee19cbb1541a4984c76d921601d7c | Dependency review | 2024-06-01 |

## Security Monitoring

### Automated Scans ✅
- [ ] CodeQL static analysis on main/PR
- [ ] Gitleaks secret scanning on all commits
- [ ] Dependency review on PRs
- [ ] Nightly link and schema validation

### Manual Reviews
- [ ] Quarterly security review of all workflows
- [ ] Monthly review of CODEOWNERS file
- [ ] Regular audit of repository permissions
- [ ] Annual review of security policy

## Incident Response

### Immediate Actions
1. **Secret Exposure**: Rotate compromised secrets immediately
2. **Vulnerability Report**: Acknowledge within 72 hours
3. **Security Breach**: Contact repository administrators
4. **Dependency Alert**: Review and update within 1 week

### Communication
- Use GitHub Security Advisories for coordinated disclosure
- Update SECURITY.md with any policy changes
- Document incidents in security changelog

## Security Tools and Commands

### Security Script
Run the security hardening script:
```bash
cd tools/
OWNER=raddevops REPO=rad-prompt-hub ./enable-security.sh
```

### Manual Checks
```bash
# Check workflow syntax
python3 -c "import glob, yaml; [yaml.safe_load(open(f)) for f in glob.glob('.github/workflows/*.yml')]"

# Validate prompt schemas
python3 scripts/schema_validate_prompts.py

# Check for secrets
git log --oneline | head -10 | xargs -I {} git show {} | grep -i -E "(password|token|key|secret)" || echo "No obvious secrets found"
```

### Action SHA Updates
Use this command to find latest commit SHA for an action:
```bash
# Example: Get latest SHA for actions/checkout@v4
gh api /repos/actions/checkout/commits/v4 | jq -r '.sha[:40]'
```

## Compliance and Governance

### Documentation
- [ ] Security policy up to date
- [ ] Contributing guidelines include security practices  
- [ ] Code of conduct addresses security concerns
- [ ] Governance model includes security roles

### Training
- [ ] Contributors educated on secure coding practices
- [ ] Maintainers trained on incident response
- [ ] Regular security awareness updates

## Risk Assessment

### Current Risk Level: **LOW** ✅

**Mitigated Risks:**
- Supply chain attacks (actions pinned to SHAs)
- Fork PRs with malicious code (approval required)  
- Secret exposure (scanning + push protection)
- Unauthorized changes (branch protection + CODEOWNERS)

**Residual Risks:**
- Social engineering attacks on maintainers
- Compromised maintainer accounts
- Zero-day vulnerabilities in dependencies

### Next Review Date
Schedule next comprehensive security review for: **<REVIEW_DATE>**  <!-- Update this during each review -->