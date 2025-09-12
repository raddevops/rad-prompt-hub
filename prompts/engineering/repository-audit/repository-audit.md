---
title: "Repository Audit Engine"
tags: ["engineering", "audit", "repository-assessment", "maturity-evaluation"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Repository Audit Prompt (About)

Slug: repository-audit  
Category: engineering  
Model: gpt-5-thinking  
Version: 1.1.0

## Purpose
Advanced evidence-based repository assessment tool for senior engineering auditors producing comprehensive maturity snapshots and prioritized improvement roadmaps (no speculative redesign).

## When To Use
- New ownership / due diligence.
- Planning a modernization or reliability push.
- Establishing baseline before large initiative.

## Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `REPO_SUMMARY` | String | ✅ Yes | Short repository description providing context for assessment scope | `"React e-commerce platform"`, `"Python ML pipeline"` |
| `OBJECTIVES` | String | ❓ Optional | Assessment objectives and success criteria | `"baseline maturity & prioritize improvements"` (default) |
| `PROVIDED_ARTIFACTS` | String | ✅ Yes | List of supplied evidence files for analysis | `"file tree, package.json, test summary, CI yaml"` |
| `FOCUS_AREAS` | String | ❓ Optional | Assessment scope limitation for targeted analysis | `"all"` (default), `"quality"`, `"architecture"`, `"testing"`, `"security"`, `"ops"`, `"docs"` |

## Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"high"` | High reasoning effort essential for comprehensive repository analysis requiring deep technical assessment, contradiction detection, risk evaluation, and multi-dimensional capability synthesis across architecture, security, testing, and operational domains |
| `verbosity` | `"low"` | Low verbosity optimized for executive and technical lead audience requiring concise, actionable insights and decision-enabling recommendations without verbose explanations that reduce clarity and impact |

## Output Sections
1. Summary  
2. Architecture & Modularity  
3. Code Quality  
4. Testing  
5. Security & Dependencies  
6. Operational Readiness  
7. Documentation & Onboarding  
8. Risk & Priority Matrix (table)  
9. 30/60/90 Plan  
10. Quick Wins  
11. Assumptions & Gaps

Sections with inadequate data are replaced by `Insufficient evidence`.

## Key Guardrails
- Evidence-only; no invention of metrics.
- Each bullet ≤25 words.
- Measurable phrasing where possible.
- Chain-of-thought suppressed.

## Assumptions & Limitations

**Assessment Assumptions:**
1. Repository represents production or production-candidate codebase requiring enterprise-grade assessment
2. Evidence artifacts provided are current and representative of actual repository state and development practices
3. Assessment consumer has technical authority to implement recommended improvements and resource allocation decisions
4. Time-phased improvement plan assumes standard enterprise development cycles and resource availability

**Assessment Limitations:**
- Assessment accuracy directly limited by completeness and currency of supplied artifacts
- Security posture evaluation cannot be assured without SCA/SAST scan results, secret scanning reports, and dependency vulnerability assessments
- Test depth and effectiveness analysis uncertain without coverage metrics, flake rates, and test quality indicators beyond basic count statistics
- Operational maturity assessment requires runbooks, SLOs, monitoring configurations, and incident response documentation for complete evaluation

## Example Invocation

**Enterprise Repository Assessment:**
```
REPO_SUMMARY: "Node.js microservice handling payment processing with 50K+ daily transactions"
OBJECTIVES: "Pre-acquisition technical due diligence focusing on security and scalability risks"
PROVIDED_ARTIFACTS: "package.json, jest.config.js, .github/workflows/ci.yml, Dockerfile, k8s/*, test coverage report (85%), sample transaction handlers, README.md, dependency vulnerability scan"
FOCUS_AREAS: "security,architecture,testing,ops"
```

**Expected Output:** Structured 11-section assessment including risk matrix, 30/60/90-day improvement plan prioritizing security hardening and operational readiness.

## Change Log
- 1.1.0: Enhanced metadata, parameter reasoning, input variable documentation, improved assumptions and risk documentation
- 1.0.0: Initial addition next to JSON spec.
