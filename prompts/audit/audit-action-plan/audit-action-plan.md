# Audit Action Plan Prompt (About)

Slug: audit-action-plan  
Category: audit  
Version: 1.0.0  
Model: gpt-5-thinking

## Purpose
Transform an existing repository audit into structured, deduplicated GitHub issues, epics, and project planning assets (CLI script, JSONL, CSV), plus rollout plan.

## Inputs
- Audit report (findings + prioritized actions + backlog YAML)  
- Repository context (owner/repo, defaults, labels, milestones, workflow)  
- Export preferences (formats, limits, rollout/change log toggles)

## Outputs
1. Planning Overview  
2. Epic & Workstream Topology  
3. Issue Specs (YAML blocks)  
4. Exports (gh CLI / JSONL / CSV)  
5. Rollout Plan (optional)  
6. Change Log (optional)

## Guardrails
Evidence-linked issues; dedupe near-duplicates; split large P0/P1 tasks; priority balance (<30% P0 by default).

## Assumptions
Audit artifacts are coherent; missing mappings get placeholders & triage-needed label.

## Risks
Overproduction of low-impact tasks; permission barriers for project automation.

## Example Invocation
Provide audit markdown + backlog YAML; request gh_cli + rest_jsonl exports with rollout plan.

## Change Log
- 1.0.0 Initial migration from workspace action plan JSON.
