# Add Copilot Instructions Prompt (About)

Slug: add-copilot-instructions  
Category: meta  
Version: 1.0.0  
Model: gpt-5-thinking

## Purpose
Analyze a repository and the Copilot Coding Agent best-practices page, then produce tailored implementation artifacts: improved guardrail docs, prompt snippets, and a PR execution plan.

## Inputs
- Repository context (location, summary, stack, constraints, priorities, sampling hint)
- Best practices source URL (or pasted content if no network)
- Optional tool capability list

## Outputs
1. Repo Snapshot  
2. Best-Practices Extraction  
3. Practice→Project Mapping Table  
4. Prioritized Actionable Changes (P0/P1/P2)  
5. Prompts & Patterns Library  
6. Review & Verification Plan  
7. PR Plan  
8. Open Questions & Assumptions

## Guardrails
Evidence-based; explicit file paths; no secrets; deterministic tables & checklists.

## Assumptions
Read-only scan; may sample large repos; network access may be disabled.

## Risks
Practice source may change; sampling can miss edge cases.

## Example Invocation
Provide project summary, stack, constraints, and set network_access true; request full plan + prompts library.

## Change Log
- 1.0.0: Initial migration into structured meta category.
