---
title: "Add Copilot Instructions"
tags: ["meta", "copilot", "best-practices", "repository-improvement", "automation"]
author: "raddevops"
last_updated: "2025-09-06"
---

# Add Copilot Instructions Prompt (About)

Slug: add-copilot-instructions  
Category: meta  
Version: 2.1.0  
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

### Fast & Safe Behaviors (v1)
1. Plan-Then-Act (internal 3–5 step plan before heavy/tool actions)
2. Deterministic Output Contract (self-check schema & minification, one retry)
3. Minimal Necessary Surface (tag OUT_OF_SCOPE instead of expanding scope)
4. Fail Fast & Explain (missing critical input → QUESTIONS schema)
5. Security-First Redaction ([REDACTED] secrets/tokens, never echo)
6. Evidence-Based Mapping (each rec cites file path or marks ASSUMED)
7. No Hidden Reasoning (no chain-of-thought language)
8. Sampling Discipline (declare sampling criteria & mark generalized inferences)
9. Resource-Aware Efficiency (respect max_scan_depth & file_globs)
10. Anti-Hallucination Gate (uncertain artifacts prefixed ASSUMED_)
11. Output Self-Test (keys, arrays, minified; one retry then QUESTIONS)
12. Safety Escalation (unsafe requests refused via open_questions entries)

Enforcement: If >3 behaviors would be violated due to missing inputs, emit QUESTIONS schema listing blockers.

## Assumptions
Read-only scan; may sample large repos; network access may be disabled.

## Risks
Practice source may change; sampling can miss edge cases.

## Example Invocation
Provide project summary, stack, constraints, and set network_access true; request full plan + prompts library.

## Change Log
- 2.1.0: Added Fast & Safe Behaviors v1 (non-breaking), versioned behavior assumptions, clarified enforcement language.
- 2.0.0 (BREAKING): Switched output from Markdown to minified JSON-only contract; tightened guardrails; lowered verbosity.
- 1.0.0: Initial migration into structured meta category.
