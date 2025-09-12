---
title: "Diátaxis + Lifecycle Documentation Audit"
tags: ["documentation", "architecture", "diataxis", "lifecycle"]
author: "raddevops"
last_updated: "2025-09-11"
---

## Purpose
Audit and reorganize documentation using the Diátaxis framework (tutorial/how-to/reference/explanation) plus internal lifecycle types (PRD/design/ADR/RFC/runbook/postmortem) for optimal discoverability and maintenance.

## Documentation Lifecycle Audit Prompt (About)
Category: Product  
JSON Spec: `product/doc-lifecycle/doc-lifecycle.json`

### Purpose
Systematically inventories, classifies, and reorganizes documentation sets using Diátaxis framework for user-facing docs and structured lifecycle types for internal engineering artifacts.

### Inputs
- `DOC_ROOT_OR_URL`: Documentation root path or URL
- `GLOBS_EG`: File patterns to include (e.g., `docs/**, *.md, /wiki/**`)
- `E.G., node_modules/**, vendor/**, build/**`: Exclusion patterns
- `E.G., internal engineers, external integrators, end-users`: Primary audiences
- `E.G., install product, configure SSO, build first app`: Primary user tasks
- `E.G., keep existing URL slugs; preserve sections A/B in nav`: Migration constraints
- `e.g., type, audience, product_area, version`: Front-matter preferences

### Outputs
Comprehensive JSON audit containing:
- **Inventory**: Every document classified with Diátaxis types, issues, and fixes
- **Internal Inventory**: Engineering artifacts (PRDs, designs, ADRs, runbooks, etc.)
- **Target Structure**: Reorganized folder hierarchy with navigation and redirects
- **Templates**: Standardized formats for each document type
- **Migration Plan**: Phased approach with acceptance criteria and risk mitigation
- **Quality Gates**: CI checks and PR templates to prevent regression

### Guardrails
- Output only structured JSON (no prose)
- Strict type separation (no mixing tutorial/reference/how-to modes)
- Practical, actionable recommendations with file-level moves
- Preserve existing popular URLs via redirects

### Parameters
`model: gpt-5-thinking`, `reasoning_effort: high`, `temperature: 0.2`, `verbosity: low`.

### Diátaxis Framework
- **Tutorials**: Guided learning paths to first success
- **How-to**: Task completion guides with clear prerequisites and steps
- **Reference**: Authoritative lookup facts mirroring product structure
- **Explanation**: Concepts, rationale, and trade-offs without task lists

### Internal Lifecycle Types
- **PRD**: Product requirements (problem, outcomes, scope, no solution detail)
- **Design-HLD**: High-level architecture (C4 views, data flows, SLOs)
- **Design-LLD**: Low-level design (modules, interfaces, schemas, tests)
- **ADR**: Architecture decisions with context and consequences
- **RFC**: Change proposals with motivation and compatibility analysis
- **Runbook**: Operational procedures with steps, verification, rollback
- **Postmortem**: Incident analysis with timeline, root cause, actions

### Usage
```bash
# Audit existing documentation structure
model.call(doc_lifecycle_prompt, variables={
  "DOC_ROOT_OR_URL": "/docs",
  "GLOBS_EG": "docs/**, *.md, README.md",
  "PRIMARY_AUDIENCES": "developers, product managers, operations",
  "PRIMARY_TASKS": "setup development environment, deploy services, troubleshoot issues"
})
```

### Example Output Structure
```json
{
  "inventory": [
    {
      "path": "docs/getting-started.md",
      "detected_type": "tutorial",
      "issues": ["mixing_types"],
      "suggested_fix": "split",
      "confidence": 0.8
    }
  ],
  "target_structure": {
    "folders": [
      {"path": "docs/tutorials/", "purpose": "guided learning paths"},
      {"path": "docs/how-to/", "purpose": "task guides"},
      {"path": "docs/reference/", "purpose": "lookup facts"},
      {"path": "docs/explanation/", "purpose": "concepts/rationale"}
    ]
  },
  "migration_plan": {
    "phases": [
      {"name": "Phase 1 — Audit & classification"},
      {"name": "Phase 2 — Restructure & routing"},
      {"name": "Phase 3 — Rewrite & fill gaps"}
    ]
  }
}
```

### Extend
- Add domain-specific document types beyond standard lifecycle
- Include accessibility and internationalization audits
- Integrate with content management systems
- Generate automated quality metrics and dashboards

### Benefits
- **Clarity**: Users find the right type of information quickly
- **Maintainability**: Consistent structure reduces documentation debt
- **Completeness**: Systematic gaps identification and filling
- **Quality**: Automated checks prevent regression
- **Scalability**: Framework scales from small teams to large organizations