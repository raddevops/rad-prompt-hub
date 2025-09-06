## Prompts Overview

**Architecture**: This repository follows a **tool-first, JSON-centric design** with strict separation of concerns.

Each prompt has its own folder under `prompts/<category>/<prompt-name>/` containing:
- **JSON specification** (single source of truth for executable prompts) 
- **Markdown documentation** (human context ABOUT the prompt)
- **Test script** (validation and usage examples)

### Separation of Concerns

**JSON files** = Executable content (tools consume these)
**MD files** = Documentation about prompts (humans read these for context)

This architecture enforces DRY principles: executable content lives in JSON only, never duplicated in markdown.

### Categories
- Engineering
- Product
- Research
- Writing
- Meta

### Add a New Prompt (JSON-First Workflow)

**1. Create JSON specification first** (single source of truth):
   - Fields: target_model, parameters, messages, assumptions, risks_or_notes
   - Contains all executable prompt logic and content

**2. Create folder structure**: `prompts/<category>/<prompt-name>/` with JSON, markdown, and test script

**3. Document in markdown** (about the prompt, never duplicating JSON content):
   - Purpose and use cases
   - Integration guidance  
   - Parameter recommendations
   - Usage examples and context

**4. Add validation**: Test script validates JSON structure and functionality

**5. Commit**: Semantic message (e.g., `feat(prompt): add <name>`)

**Key principle**: JSON contains executable content, MD documents the context and purpose.

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

### Versioning & Changelog
Add a `version` field in JSON if external integrations require deterministic behavior; bump on breaking changes following [semantic versioning](VERSIONING_CHANGELOG.md).

For comprehensive guidelines on when to version, how to maintain changelogs, and managing backward compatibility, see [VERSIONING_CHANGELOG.md](VERSIONING_CHANGELOG.md).

### Contact
Open an issue for enhancements or new prompt requests.
