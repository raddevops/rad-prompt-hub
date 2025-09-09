---
title: "Audit Action Plan Generator"
tags: ["audit", "planning", "github", "project-management", "automation"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Audit Action Plan Prompt (About)

Slug: audit-action-plan  
Category: audit  
Version: 1.0.1  
Model: gpt-5-thinking

## Purpose
Transform an existing repository audit into structured, deduplicated GitHub issues, epics, and project planning assets (CLI script, JSONL, CSV), plus rollout plan.

## Parameters
- **reasoning_effort: high** - Complex dependency analysis, priority balancing, and issue deduplication require substantial reasoning to ensure quality output
- **verbosity: low** - Optimized for automation consumption, produces actionable artifacts over lengthy explanations

## Input Variables

| Variable | Required | Description | Example |
|----------|----------|-------------|---------|
| `{{AUDIT_REPORT}}` | ✅ Required | Markdown audit with findings, priorities, evidence citations | Repository security assessment report |
| `{{BACKLOG_YAML}}` | Optional | Structured task list with title, priority, estimate, owner, description | Existing action items in YAML format |
| `{{GH_OWNER}}` | ✅ Required | GitHub username or organization | raddevops |
| `{{GH_REPO}}` | ✅ Required | Repository name | rad-prompt-hub |
| `{{DEFAULT_ASSIGNEE}}` | Optional | Fallback assignee for unassigned issues | @maintainer |
| `{{GH_PROJECT_NAME}}` | Optional | GitHub Projects v2 board name | Q4-2025-Security-Improvements |
| `{{MILESTONES}}` | Optional | Comma-separated milestone list | v1.0,v1.1,v2.0 |
| `{{P0_LABEL}}` | Optional | Critical priority label | urgent |
| `{{P1_LABEL}}` | Optional | Important priority label | important |  
| `{{P2_LABEL}}` | Optional | Standard priority label | enhancement |
| `{{CATEGORY_LABELS}}` | Optional | Issue categorization tags | arch,test,ci,security,docs,ops |
| `{{STATUS_WORKFLOW}}` | Optional | Project workflow states | Backlog→In Progress→In Review→Done |
| `{{TARGET_WINDOWS}}` | Optional | Time bucket labels | Now,30d,60d,90d |
| `{{ESTIMATE_SIZES}}` | Optional | Effort sizing labels | XS,S,M,L,XL |
| `{{EXPORTS}}` | Optional | Output format list | gh_cli,rest_jsonl,projects_csv |
| `{{MAX_ISSUES}}` | Optional | Safety limit for bulk operations | 100 |
| `{{EPIC_PREFIX}}` | Optional | Epic naming convention | [EPIC] |
| `{{INCLUDE_ROLLOUT_PLAN}}` | Optional | Include rollout section | yes/no |
| `{{INCLUDE_CHANGE_LOG}}` | Optional | Include changelog section | yes/no |

## Outputs
1. **Planning Overview** - Executive summary of transformation approach
2. **Epic & Workstream Topology** - Dependency mapping and organization  
3. **Issue Specs** - YAML blocks ready for gh CLI consumption
4. **Exports** - Automation scripts (gh CLI, JSONL, CSV as requested)  
5. **Rollout Plan** - Phased implementation strategy (optional)  
6. **Change Log** - Version tracking documentation (optional)

## Prerequisites
- **gh CLI** installed with repository access and issue creation permissions
- **GitHub Projects v2** available with automation permissions enabled  
- **jq** for JSON processing in export scripts
- Repository admin access for bulk operations

## Integration Examples

### Basic Usage
```bash
# Prepare input with audit report and basic context
export AUDIT_REPORT="$(cat repository-audit-2025.md)"
export GH_OWNER="myorg"
export GH_REPO="myproject"

# Run prompt through LLM API or interface
# Output: Structured planning with ready-to-run gh CLI scripts
```

### Advanced Configuration
```bash
# Full configuration with custom labels and workflows
export CATEGORY_LABELS="architecture,testing,ci-cd,security,documentation,operations"
export STATUS_WORKFLOW="Triage→In Progress→Review→Done"
export EXPORTS="gh_cli,rest_jsonl,projects_csv"
export MAX_ISSUES="50"
```

## Guardrails
- **Evidence-driven** - Each issue references specific audit findings
- **Deduplication** - Similar items are merged and cross-linked
- **Task splitting** - Large P0/P1 tasks are broken into manageable pieces  
- **Priority balance** - <30% P0 issues unless explicitly specified
- **Safety limits** - MAX_ISSUES prevents runaway issue creation
- **Read-only analysis** - No destructive repository operations

## Common Use Cases
- **Security audit remediation** - Transform security findings into tracked issues
- **Technical debt planning** - Convert technical debt assessment into project plan  
- **Compliance gap closure** - Structure compliance findings into actionable work
- **Repository modernization** - Plan systematic improvements with dependencies

## Assumptions
- Audit reports contain prioritized findings with sufficient detail
- GitHub repository has standard issue/project permissions configured
- User has appropriate CLI tools and API access for automation
- Input formats follow expected markdown/YAML structures

## Risks & Limitations
- **Bulk operations** - Large issue creation may create repository noise
- **API rate limits** - GitHub API constraints may require paced execution  
- **Permissions** - Projects v2 automation requires specific token scopes
- **Context limits** - Very large audits may need chunking for processing
- **Sensitive data** - Manual review required for any secrets/PII in outputs

## Change Log
- **1.0.1** Enhanced parameter documentation, expanded placeholder explanations, improved assumptions and risk documentation
- **1.0.0** Initial migration from workspace action plan JSON

