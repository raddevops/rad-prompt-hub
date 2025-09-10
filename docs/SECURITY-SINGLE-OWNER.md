# Security Configuration for Single Owner Repositories

This document explains the security configuration choices made for single code owner repositories and provides guidelines for maintaining security while enabling efficient workflows.

## Problem Statement

Standard GitHub branch protection with `enforce_admins: true` and `require_last_push_approval: true` creates approval deadlocks in single contributor repositories:

1. **Admin Enforcement Deadlock**: When `enforce_admins: true`, even repository owners cannot bypass branch protection rules
2. **Last Push Approval Deadlock**: When `require_last_push_approval: true`, the person making changes cannot approve their own PR
3. **Single Owner Paradox**: The code owner needs to approve changes, but strict settings prevent self-approval

## Security Solution

Our configuration in `tools/enable-security.sh` maintains strong security while resolving single-owner deadlocks:

### Changed Settings

| Setting | Standard Value | Single Owner Value | Rationale |
|---------|---------------|-------------------|-----------|
| `enforce_admins` | `true` | `false` | Allows repository owner to approve/merge when ready |
| `require_last_push_approval` | `true` | `false` | Enables self-approval in single contributor workflows |

### Maintained Protections

All other security controls remain in place:

- ✅ **Required Code Owner Reviews**: Still enforced via CODEOWNERS file
- ✅ **Required Status Checks**: CI/CD must pass before merge
- ✅ **Dismiss Stale Reviews**: Ensures reviews reflect current code state
- ✅ **Required Conversation Resolution**: All discussions must be resolved
- ✅ **No Force Pushes**: Prevents history rewriting on protected branch
- ✅ **No Deletions**: Protects branch from accidental removal
- ✅ **Secret Scanning**: Monitors for exposed credentials
- ✅ **Vulnerability Alerts**: Notifications for security issues
- ✅ **Dependency Review**: Automated scanning of new dependencies

## Security Risk Assessment

### Risk Mitigation Achieved
- Repository owner retains full control and approval authority
- All automated security scanning and checks remain active
- Code review process is preserved through CODEOWNERS requirement
- Branch history protection prevents unauthorized changes

### Remaining Considerations
- Repository owner has ultimate authority to bypass reviews (by design)
- External collaborators would still require proper approval flows
- Multi-owner repositories should reassess these settings

## Best Practices

1. **Regular Security Reviews**: Periodically audit repository access and permissions
2. **Status Checks**: Maintain comprehensive CI/CD validation before merge approval
3. **CODEOWNERS Maintenance**: Keep CODEOWNERS file updated as repository structure changes
4. **Access Monitoring**: Review repository access logs and collaborator list regularly

## Migration Path for Multi-Owner Repositories

If the repository gains additional maintainers:

1. Re-evaluate `enforce_admins: false` setting
2. Consider enabling `require_last_push_approval: true` 
3. Implement role-based branch restrictions if needed
4. Update CODEOWNERS file for appropriate review distribution

## Validation Commands

To verify current branch protection settings:

```bash
gh api "/repos/OWNER/REPO/branches/main/protection" | jq '{enforce_admins, required_pull_request_reviews}'
```

To apply these settings:

```bash
OWNER=raddevops REPO=rad-prompt-hub ./tools/enable-security.sh
```