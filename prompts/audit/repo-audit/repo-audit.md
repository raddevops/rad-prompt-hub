---
title: "Repository Audit Engine"
tags: ["audit", "repository-assessment", "governance", "compliance", "evidence-based"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Repository Audit Prompt (About)

Slug: repo-audit  
Category: audit  
Version: 1.0.1  
Model: gpt-5-thinking

## Purpose
Comprehensive, evidence-based repository maturity audit plus prioritized remediation and guardrail artifacts. Operates in read-only mode to assess architecture, code quality, testing strategy, CI/CD, security posture, and documentation completeness.

## Parameters
- **reasoning_effort: high** - Complex cross-cutting analysis across architecture, security, compliance, traceability requires substantial reasoning to synthesize findings and provide evidence-based prioritized recommendations
- **verbosity: medium** - Balanced approach providing comprehensive coverage while maintaining executive-ready, actionable format for both technical teams and management

## Input Variables

| Variable | Required | Description | Example Values |
|----------|----------|-------------|----------------|
| `{{REPO_URL_OR_PATH}}` | ✅ Required | Repository location (filesystem path or URL) | `/path/to/repo`, `https://github.com/org/repo` |
| `{{PRIMARY_LANGUAGES}}` | ✅ Required | Technology stack identification | `Python,JavaScript`, `Go,TypeScript,React` |
| `{{APP_TYPE}}` | ✅ Required | Application category classification | `web-app`, `cli-tool`, `library`, `microservice`, `mobile-app` |
| `{{CRITICAL_AREAS}}` | Optional | Specific audit focus areas | `security,performance`, `compliance,testing,documentation` |
| `{{NFRS}}` | Optional | Non-functional requirements priorities | `scalability`, `security`, `maintainability`, `performance` |
| `{{COMPLIANCE}}` | Optional | Regulatory/compliance constraints | `SOC2`, `GDPR`, `HIPAA`, `PCI-DSS`, `ISO27001`, `none` |
| `{{KNOWN_ISSUES}}` | Optional | Existing identified pain points | `slow-tests`, `deployment-issues`, `technical-debt` |
| `{{SUCCESS_CRITERIA}}` | Optional | Audit success measures | `security-compliance`, `technical-debt-reduction` |
| `{{DEPTH}}` | Optional | Analysis depth level (default: standard) | `light`, `standard`, `deep` |
| `{{MAX_TOKENS_OR_PAGES}}` | Optional | Output size constraints | `5000-tokens`, `10-pages`, `comprehensive` |

### Deliverable Flags
- `audit_plan` - Include structured action plan
- `backlog_yaml` - Generate task backlog YAML
- `copilot_instructions` - Propose Copilot-instructions.md draft
- `templates` - Include PR/Issue template proposals  
- `codeowners` - Generate CODEOWNERS file proposal
- `security_doc` - Create SECURITY.md proposal
- `small_diffs` - Include minimal safe configuration improvements

## Analysis Depth Guide
- **light** - Surface analysis, structure review, major gaps identification
- **standard** - Comprehensive analysis with prioritized recommendations (recommended)
- **deep** - Detailed examination with specific implementation suggestions

## Outputs
1. **Executive Summary** (≤12 bullets) - Key findings and recommendations
2. **Current-State Overview** - Architecture, traceability, quality assessment
3. **Prioritized Action Plan** - P0-P2 table with effort, impact, evidence
4. **Task Backlog (YAML)** - Structured actionable items
5. **Copilot-instructions.md draft** - Project-specific AI guidelines
6. **Optional Templates & Diffs** - Governance and configuration improvements

## Audit Methodology
**6-Step Systematic Scan:**
1. **Repository Spine** - README, docs/, design/, specs/, ADRs, governance files
2. **Build & Quality Configs** - Package manifests, linting, formatting rules
3. **CI/CD Workflows** - Automation, quality gates, deployment processes
4. **Core Code Flows** - Architecture boundaries, patterns, dependencies
5. **Testing Strategy** - Test types, coverage, structure, reliability signals
6. **Security & Dependencies** - Vulnerability patterns, dependency management

## Assessment Framework
**8-Domain Scoring (0-5 scale):**
- Requirements Traceability
- Architecture Soundness  
- Code Quality
- Test Strategy & Depth
- CI/CD & Quality Gates
- Documentation & Onboarding
- Security & Dependencies
- Operational Readiness

## Prerequisites
- **Repository Access** - Read-only filesystem or repository API access
- **Static Analysis** - No code execution or network access required
- **Token Budget** - Adequate for repository size (large repos use sampling)

## Integration Examples

### Basic Repository Audit
```bash
# Provide essential context
export REPO_URL_OR_PATH="/path/to/project"
export PRIMARY_LANGUAGES="Python,JavaScript"
export APP_TYPE="web-app"
export DEPTH="standard"

# Run audit through LLM interface
# Output: Comprehensive audit report with action plan
```

### Compliance-Focused Audit  
```bash
# Security and compliance emphasis
export CRITICAL_AREAS="security,compliance,documentation"
export COMPLIANCE="SOC2,GDPR"
export SUCCESS_CRITERIA="security-compliance,documentation-completeness"
export DEPTH="deep"

# Additional deliverables
# Include: audit_plan, security_doc, copilot_instructions flags
```

### Technical Debt Assessment
```bash
# Focus on code quality and maintainability
export CRITICAL_AREAS="architecture,testing,performance"
export KNOWN_ISSUES="technical-debt,slow-tests"
export SUCCESS_CRITERIA="technical-debt-reduction,test-coverage-improvement"
export NFRS="maintainability,scalability"
```

## Guardrails & Safety
- **Read-only operation** - No code execution or destructive changes
- **Evidence-based findings** - All recommendations cite specific file paths
- **Secret protection** - Automatic redaction and critical escalation
- **Sampling strategy** - Large repositories analyzed systematically with coverage logging
- **Legal boundaries** - Compliance findings flagged for expert validation

## Assumptions
- Repository access is read-only without execution capabilities
- Missing artifacts are inferred cautiously with gaps explicitly logged
- Large repositories may require sampling with documented coverage
- Security and compliance findings are preliminary pending external validation

## Risks & Limitations
- **Static analysis scope** - Runtime issues and dynamic behavior not detected
- **Dependency scanning** - External vulnerability scanners needed for comprehensive assessment
- **Compliance accuracy** - Domain expert validation required for regulatory requirements
- **Architecture context** - Team knowledge and business constraints may override recommendations
- **Test coverage estimates** - Actual coverage metrics require test execution
- **Secret detection limits** - Manual security review recommended for sensitive repositories

## Common Use Cases
- **Pre-acquisition due diligence** - Assess technical debt and security posture
- **Security compliance preparation** - Identify gaps for SOC2, GDPR, HIPAA readiness
- **Technical debt prioritization** - Systematic analysis with impact-based recommendations
- **Onboarding acceleration** - New team member repository understanding
- **Architecture review** - Cross-cutting analysis of design decisions and patterns

## Change Log
- **1.0.1** Enhanced parameter documentation, comprehensive placeholder explanations, expanded risk assessment, improved methodology documentation
- **1.0.0** Initial migration from workspace audit report JSON
