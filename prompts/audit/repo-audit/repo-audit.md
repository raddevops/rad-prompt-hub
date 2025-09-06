---
title: "Repository Audit Engine"
tags: ["audit", "repository-assessment", "governance", "compliance", "evidence-based"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Repository Audit Prompt (About)

Slug: repo-audit  
Category: audit  
Version: 1.0.0  
Model: gpt-5-thinking

## Purpose
Comprehensive, evidence-based repository maturity audit plus prioritized remediation and guardrail artifacts.

## Inputs
Context (repo path, languages, app type, focus areas, priorities, compliance, pain points, success criteria). Depth & deliverable flags.

## Outputs
1. Executive Summary  
2. Current-State Overview (architecture, traceability, quality, tests, CI/CD, security, docs)  
3. Prioritized Action Plan table  
4. Task Backlog (YAML)  
5. Copilot-instructions.md draft  
6. Optional templates & minimal diffs

## Guardrails
Read-only; cite evidence; redact secrets; no fabricated metrics or legal claims; concise bullets.

## Assumptions
Partial artifacts possible; sampling allowed; security signals preliminary.

## Risks
May under-report hidden runtime issues; dependency risk provisional.

## Example Invocation
Provide README, manifest(s), workflows, representative code dirs, test layout. Ask for standard-depth audit & action plan.

## Change Log
- 1.0.0 Initial migration from workspace audit report JSON.
