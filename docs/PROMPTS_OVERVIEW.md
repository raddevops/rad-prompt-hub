## Prompts Overview

Each prompt follows a **three-file architecture** with strict separation of concerns to enforce DRY principles:

- **`prompt-name.json`**: **EXECUTABLE** - Single source of truth for prompt specification (tools consume this)
- **`prompt-name.md`**: **DOCUMENTATION** - Human context about the prompt (never contains prompt content)  
- **`test.sh`**: **VALIDATION** - Automated testing and integration examples

**Key Principle**: JSON files are authoritative; markdown is for developer understanding only.

### Architecture Benefits
- **No Duplication**: Prompt content exists in exactly one place
- **Tool Optimized**: Direct JSON consumption by LLMs and applications
- **Maintainable**: Changes only require JSON updates
- **Portable**: Works on any system without hardcoded paths

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
1. **Create JSON specification** (executable prompt with target_model, parameters, messages, assumptions, risks_or_notes)
2. **Create folder**: `prompts/<category>/<prompt-name>/` 
3. **Document in MD**: Create `<name>.md` with purpose, integration examples, and variable explanations (do NOT copy prompt content)
4. **Add validation**: Create `test.sh` with functionality testing
5. **Rebuild index**: Run `python scripts/build_prompts_index.py`
6. **Commit**: Use semantic message (e.g., `feat(prompt): add <name>`)

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

### Remediation Required: DRY Violations

The following MD files currently contain prompt content and need remediation to comply with DRY principles:

**Files needing cleanup** (contain "## Prompt" sections with executable content):
- `prompts/product/acceptance-criteria/acceptance-criteria.md`
- `prompts/product/requirements-draft/requirements-draft.md`  
- `prompts/product/user-story/user-story.md`

**Remediation process**:
1. Remove "## Prompt" sections from MD files
2. Replace with integration examples and variable documentation
3. Verify JSON files contain the complete prompt specification
4. Update MD files to focus on purpose and usage context only

### Contact
Open an issue for enhancements or new prompt requests.
