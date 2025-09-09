---
title: "Add Copilot Instructions"
tags: ["meta", "copilot", "best-practices", "repository-improvement", "automation"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Add Copilot Instructions Prompt (About)

Slug: add-copilot-instructions  
Category: meta  
Version: 2.0.0  
Model: gpt-5-thinking

## Purpose
Analyze a repository and the Copilot Coding Agent best-practices page, then produce tailored implementation artifacts: improved guardrail docs, prompt snippets, and a PR execution plan.

## Inputs
- Repository context (location, summary, stack, constraints, priorities, sampling hint)
- Best practices source URL (or pasted content if no network)
- Optional tool capability list

## Output Contract (JSON)
Return a single minified JSON object with keys:
- repo_snapshot (object)
- best_practices (array)
- mapping (array of objects: practice, where, evidence, gap_risk, recommendation)
- prioritized_changes (object with arrays P0, P1, P2)
- prompts_library (array of objects with name, snippet, placeholders, constraints, success_criteria)
- verification_plan (object)
- pr_plan (object)
- open_questions (array)

## Guardrails
JSON-only response; no prose/markdown/code fences; single-line minified output. Evidence-based; explicit file paths; no secrets; deterministic tables & checklists.

## Assumptions
Read-only scan; may sample large repos; network access may be disabled.

## Risks
Practice source may change; sampling can miss edge cases.

## Example Invocation
Provide project summary, stack, constraints, and set network_access true; request full plan + prompts library.

## Change Log
- 2.0.0 (BREAKING): Switched output from Markdown to minified JSON-only contract; tightened guardrails; lowered verbosity.
- 1.0.0: Initial migration into structured meta category.
