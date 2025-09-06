# Repository instructions for GitHub Copilot

This repository intentionally keeps certain JSON artifacts minified and machine-generated. Please follow these guidelines during reviews:

- Do not suggest pretty-printing or reformatting `prompts/index.json`. It is minified by design for token efficiency and diff stability. Changes to this file should only come from our generator.
- Treat `prompts/index.json` as generated output. Focus on whether it was rebuilt (hashes/paths updated) rather than human readability.
- Prefer suggestions that improve guardrails, validation, or safety over stylistic changes that increase noise.
- Respect our branch naming convention: `<type>/<slug>-YYYYMMDD` with allowed types `feat|fix|chore|docs|refactor|test|perf|ci`.

---

## Coding Agent guidance (repository-specific)

When acting as a coding agent or assistant proposing changes, follow these rules:

- Be explicit and deterministic. Prefer checklists, tables, and file-path-anchored actions over prose.
- No chain-of-thought. Provide conclusions, steps, and artifacts only.
- Ask only targeted questions if a blocker prevents accurate output; otherwise proceed with 1–2 reasonable assumptions and log them.
- Security & safety: never invent secrets/keys; don’t suggest disabling security controls; flag unsafe patterns.
- Scope discipline: if the repo is large, sample representative modules/folders, state sampling criteria, and mark generalizations.

### Deliverables for best-practices work
When asked to apply Copilot best practices, produce in order:
1) Repo Snapshot (short): purpose, main components, languages, frameworks, entry points, critical configs.
2) Best-Practices Extraction from the referenced page (1–2 lines each).
3) Practice-to-Project Mapping Table with columns: `Practice | Where it applies (paths/code) | Current state (evidence) | Gap/Risk | Recommended change`.
4) Actionable Changes (Prioritized): P0 (this week), P1 (this sprint), P2 (later) with file paths and exact edits/examples.
5) Prompts & Patterns Library tailored to this repo (snippets with placeholders, constraints, success criteria, example I/O).
6) Review & Verification Plan: tests/linters/CI checks and acceptance criteria.
7) PR Plan: branch names, commit scopes, PR titles/descriptions, reviewer roles, and an ordered checklist.
8) Open Questions & Assumptions.

Source prompt: `prompts/meta/add-copilot-instructions.json`.

---

Thank you.
