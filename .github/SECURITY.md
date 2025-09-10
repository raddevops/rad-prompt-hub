# Security Policy

## Supported Versions

- **Supported**: main branch and latest two tagged minor releases
- **Security updates**: Applied to supported versions within our SLA

## Reporting Vulnerabilities

- **Private disclosure**: Use GitHub Security Advisories or contact maintainers privately
- **Target response**: Acknowledge within 72 hours; initial assessment within 7 days
- **Do not** create public issues for security vulnerabilities
- **If secrets are exposed**: Rotate immediately and notify maintainers

## Security Measures

This repository implements the following security controls:

### Branch Protection
- Required status checks (validate workflow must pass)
- Require pull request reviews from CODEOWNERS
- Dismiss stale reviews when new commits are pushed
- Require conversation resolution before merge
- No force pushes or deletions allowed
- Enforce for administrators

### Automated Security Scanning
- **Secret scanning**: Enabled with push protection
- **CodeQL**: Static analysis on main branch and PRs
- **Dependency review**: Automated review of dependency changes
- **Gitleaks**: Secret scanning on all commits
- **Nightly health checks**: Regular validation of repository integrity

### Access Controls
- CODEOWNERS enforced for all security-critical files
- GitHub Actions use minimal required permissions
- All actions pinned to specific commit SHAs
- No `pull_request_target` with write permissions

### Workflow Security
- All GitHub Actions pinned to commit SHAs (not tags)
- Minimal permissions principle applied to all workflows
- Fork contributions require approval for workflow execution
- Sensitive workflows run only on main branch

## Remediation Process

- **CVSS scoring** to prioritize vulnerabilities
- **Coordinated disclosure** where applicable
- **Public advisory** after fix is available
- **Security updates** documented in changelog
