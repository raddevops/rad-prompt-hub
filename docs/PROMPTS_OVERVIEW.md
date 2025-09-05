## Prompts Overview

Canonical layout (authoritative): JSON + About docs live together under `prompts/<category>/<slug>.{json,md}`. The JSON file is the source of truth; the Markdown file is a concise "About" doc (purpose, inputs, outputs, guardrails, usage).

### Categories
- Engineering
- Product
- Research
- Writing
- Meta

### Add a New Prompt
1. Author JSON (fields: target_model, parameters, messages, assumptions, risks_or_notes).
2. Create `prompts/<category>/<slug>.md` About file.
3. Run `python scripts/build_prompts_index.py` and commit `prompts/index.json`.
4. Commit with semantic message (e.g., `feat(prompt): add <slug>`).

### Conventions
- Placeholders: `{{VARIABLE}}` or with default `{{NAME:=default}}`.
- No chain-of-thought; prompts request results + concise reasoning only.
- Research prompts: cite every non-obvious claim (URL + retrieval date).

### Parameter Guidance
- reasoning_effort: raise for complex synthesis/scoring.
- verbosity: keep low; raise only when longer narrative needed.

### Tooling
- `scripts/validate_prompts.sh` basic structural checks.
- `scripts/schema_validate_prompts.py` schema + pairing checks.
- `scripts/build_prompts_index.py` generates `prompts/index.json`.
- CI workflow `.github/workflows/prompt-guardrails.yml` runs all of the above.

### Deprecated
- `prompts_json/` (removed). Do not reintroduce; CI will fail PRs if present.

### Versioning
Add a `version` field in JSON if external integrations require deterministic behavior; bump on breaking changes.

### Contact
Open an issue for enhancements or new prompt requests.
