# PLAN.md — Open Source Readiness Plan

Inputs
- ORG_OR_USER={{ORG_OR_USER}}; REPO={{REPO}}; DEFAULT_BRANCH={{DEFAULT_BRANCH|main}}
- CODEOWNERS={{CODEOWNERS}}
- PRIMARY_TECH={{PRIMARY_TECH}}
- LICENSE_INTENT={{LICENSE_INTENT}}
- WORKFLOWS_USED={{WORKFLOWS_USED}}
- SENSITIVE_HISTORY_RISK={{SENSITIVE_HISTORY_RISK}}
- PROJECT_BOARD={{PROJECT_BOARD|optional}}

Phases

M1: Pre-flight & History
- Why: Verify ownership, IP, and risk before public exposure.
- Tasks:
  - Inventory third-party code, licenses, and generated artifacts.
  - Confirm license intent and compatibility.
  - History & secrets assessment ({{SENSITIVE_HISTORY_RISK}}).
  - Decide governance minimums and CODEOWNERS.
  - Draft/refresh community health files (README w/ AI notice, SECURITY, SUPPORT, COC, CONTRIBUTING, LICENSE).
  - Define label schema, milestones, issue templates, PR template.
- Acceptance Criteria:
  - [ ] LICENSE chosen and text staged.
  - [ ] CODEOWNERS defined (only CODEOWNERS can merge to {{DEFAULT_BRANCH}}).
  - [ ] All community files drafted and reviewed.
  - [ ] labels.json and milestones.txt created.
  - [ ] If risk ≥ medium: remediation plan approved.

M2: Hardening & Policies
- Why: Enforce safe contribution and release posture.
- Tasks:
  - Enable repo security features: Secret Scanning, Push Protection, Dependabot (alerts + security updates), CodeQL (if applicable).
  - Branch protection/rulesets: require PRs, block force pushes, enforce for admins, CODEOWNERS review, ≥1 approval, resolve conversations, dismiss stale reviews, signed commits (optional), status checks.
  - CI/linters match {{WORKFLOWS_USED}}; build must pass on PRs.
  - Prompt workspace quality: directory conventions, metadata schema, semantic versioning, sample I/O, eval harness, safety notes, licensing caveats, TOU reminders.
- Acceptance Criteria:
  - [ ] Rulesets active; protections applied to {{DEFAULT_BRANCH}}.
  - [ ] Security features enabled and green.
  - [ ] CI required checks enforced in branch protection.
  - [ ] Prompt metadata schema + example published; tests validate.

M3: Community Health
- Why: Smooth onboarding and governance predictability.
- Tasks:
  - Finalize CONTRIBUTING (fork-and-PR only), governance, SUPPORT channels, triage policy, issue/PR templates.
  - Set project board {{PROJECT_BOARD|optional}} and default labels.
  - Add description, topics, shields/badges to README.
- Acceptance Criteria:
  - [ ] Templates live and referenced in README.
  - [ ] Project board (if used) created and linked.
  - [ ] Governance & SUPPORT docs merged.

M4: Public Launch
- Why: Transition from private to public safely.
- Tasks:
  - Final history scan; tag v0.x.0; publish initial CHANGELOG and RELEASE.md.
  - Flip repo visibility to public; post announcement (README/Discussions).
  - Create roadmap and contribution “good first issue”s.
- Acceptance Criteria:
  - [ ] Repo public; release tagged; CHANGELOG populated.
  - [ ] Announcements posted; issues seeded.

M5: Post-launch Polish
- Why: Sustain health and responsiveness.
- Tasks:
  - Automate link checks, license checks, prompt validations.
  - Quarterly policy review; rotate tokens; security response SLAs measured.
  - Community metrics and maintenance guidelines refined.
- Acceptance Criteria:
  - [ ] Scheduled automations running.
  - [ ] Response metrics tracked and reviewed quarterly.
