## Prompts Overview

Each prompt has its own folder under `prompts/<category>/<prompt-name>/` containing the JSON specification, human-oriented markdown documentation, and a test script. The JSON file is authoritative; markdown is for quick discovery and understanding.

### Categories
- Engineering
- Product
- Research
- Writing
- Meta

### Add a New Prompt
1. Author JSON (fields: target_model, parameters, messages, assumptions, risks_or_notes).
2. Create folder: `prompts/<category>/<prompt-name>/` with JSON, markdown, and test script.
3. Create `prompts/<category>/<name>/<name>.md` About file.
4. Commit with semantic message (e.g., `feat(prompt): add <name>`).

### Conventions
- Placeholders: `{{VARIABLE}}` or with default `{{NAME:=default}}`.
- No chain-of-thought; prompts request results + concise reasoning only.
- Research prompts: cite every non-obvious claim (URL + retrieval date).

### Parameter Guidance
- reasoning_effort: raise for complex synthesis/scoring.
- verbosity: keep low; raise only when longer narrative needed.

### Tooling Ideas
- Linter to validate placeholder syntax & required keys.
- Token size reporter to catch oversized system messages.

### Versioning
Add a `version` field in JSON if external integrations require deterministic behavior; bump on breaking changes.

### Contact
Open an issue for enhancements or new prompt requests.
