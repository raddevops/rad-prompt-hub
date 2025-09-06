# Agent Guide: Applying Copilot Best Practices

Use with `prompts/meta/add-copilot-instructions.json` to produce repo-tailored improvements.

## What to Deliver
1) Repo Snapshot
2) Best-Practices Extraction (from the referenced page; 1–2 lines each)
3) Practice-to-Project Mapping Table
4) Actionable Changes (P0/P1/P2) with file paths and concrete edits
5) Prompts & Patterns Library tailored to this repo
6) Review & Verification Plan (tests/linters/CI + acceptance criteria)
7) PR Plan (branch names, commit scopes, titles/descriptions, reviewers, checklist)
8) Open Questions & Assumptions

## Ground Rules
- Be explicit and deterministic; use checklists/tables.
- No chain-of-thought; provide conclusions and artifacts only.
- Only ask targeted questions when truly blocked; otherwise proceed with 1–2 logged assumptions.
- Do not invent secrets or bypass security controls; flag unsafe patterns.
- If the repo is large, sample representatively and mark generalizations.

## References
- `.github/copilot-instructions.md`
- `prompts/meta/add-copilot-instructions.json`