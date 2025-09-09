# Public Readiness Checklist

Repository Settings
- [ ] Description and topics set
- [ ] Default branch: {{DEFAULT_BRANCH}}
- [ ] Private → Public (at launch)
- [ ] Secret Scanning enabled
- [ ] Push Protection enabled
- [ ] Dependabot alerts + security updates enabled
- [ ] CodeQL enabled (if applicable)

Branch Protection / Rulesets
- [ ] Require PRs; block force pushes; enforce for admins
- [ ] Require ≥1 approving review
- [ ] Require CODEOWNERS review
- [ ] Require conversation resolution
- [ ] Dismiss stale reviews on new commits
- [ ] Required status checks set ({{WORKFLOWS_USED}})
- [ ] Require signed commits (optional)
- [ ] Restrict who can push to protected branches

Community Health
- [ ] README includes exact AI notice
- [ ] CONTRIBUTING (fork-and-PR, no direct pushes)
- [ ] CODE_OF_CONDUCT (Contributor Covenant 2.1)
- [ ] SECURITY (private disclosure, supported versions, response window)
- [ ] SUPPORT (issues vs discussions)
- [ ] LICENSE present and referenced
- [ ] CODEOWNERS file
- [ ] Issue/PR templates
- [ ] GOVERNANCE.md
- [ ] CHANGELOG.md and RELEASE.md

Prompt Workspace Quality
- [ ] Directory convention and 3-file structure per prompt
- [ ] Minified JSON prompt specs only; docs in Markdown
- [ ] Metadata schema applied; versions semantic
- [ ] Sample I/O provided
- [ ] Evaluation harness included
- [ ] Safety notes and licensing caveats per provider
- [ ] Usage TOU reminders in docs

History & Secrets (if {{SENSITIVE_HISTORY_RISK}} ≥ medium)
- [ ] Scan with gitleaks/trufflehog
- [ ] Purge via filter-repo/BFG
- [ ] Rotate/invalidate credentials
- [ ] Document actions and dates
