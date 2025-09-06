# rad-prompt-hub

Reusable, well‑structured prompts for Large Language Models (LLMs) that you can copy, adapt, and compose across engineering, product, writing, and research workflows.

This hub emphasizes:
- Consistent metadata (title, tags, author, last_updated)
- Clear intent and modular prompt sections
- Reusability across tools (CLI, API, chat interfaces)
- Ease of discovery (tag search and an index)

## Repository Layout

```
rad-prompt-hub/
├── prompts/                 # Organized prompts by domain, each in its own folder
│   ├── engineering/
│   │   ├── code-review/     # Each prompt folder contains .md, .json, and test.sh
│   │   └── ...
│   ├── product/
│   ├── research/
│   ├── writing/
│   ├── meta/
│   ├── audit/
│   └── index.json           # Generated registry (minified, do not edit)
├── templates/               # Authoring templates + metadata schema
├── docs/                    # Usage, style, best practices
├── tools/                   # Helper scripts (search, convert, index)
└── README.md
```

## Prompt Folder Anatomy

Each prompt lives in its own folder with three essential files:

```
prompts/engineering/code-review/
├── code-review.md      # Human-readable documentation and examples
├── code-review.json    # Minified LLM specification (programmatic use)
└── test.sh             # Quick validation script and usage example
```

- **`.md` file**: Human-friendly documentation with purpose, examples, and variables
- **`.json` file**: Minified, LLM-optimized prompt specification (auto-generated from `.md` file, do not edit manually)
- **`test.sh`**: Validation script that demonstrates usage and tests functionality

## Quick Example (Prompt File)

A prompt file uses YAML frontmatter followed by structured sections:

```markdown
---
title: "Code Review Assistant"
tags: ["engineering", "code-review", "quality"]
author: "raddevops"
last_updated: "2025-08-24"
---

## Purpose
Provide a structured, repeatable code review heuristic emphasizing clarity, safety, performance, and maintainability.

## Prompt
You are an experienced software engineer performing a code review.
Evaluate the submission using the following criteria:
1. Correctness ...
2. Readability ...
(etc.)
Return a structured report with sections: Summary, Strengths, Issues, Suggested Improvements, Risk Assessment.
```

## How to Use a Prompt

There are three ways to use prompts from this repository:

### 1. Human Use (Markdown)
Browse `prompts/<category>/<prompt-name>/` and open the `.md` file:
- Copy just the "Prompt" section for quick use
- Copy the entire file to preserve context and purpose
- Adapt variables like `{{code_snippet}}`, `{{goal}}` as needed

### 2. Programmatic Use (JSON)
Use the `.json` file for programmatic integration:
- JSON files are minified and LLM-optimized (read-only)
- Load directly into your LLM client or API
- All fields follow our canonical schema (see JSON Schema section)

### 3. Quick Validation (test.sh)
Run the test script to see the prompt in action:
- `bash prompts/<category>/<name>/test.sh`
- Validates functionality and shows usage examples
- Useful for understanding prompt behavior before integration

## JSON Schema

All JSON prompt files conform to our **canonical JSON schema** defined in [`scripts/prompt.schema.json`](scripts/prompt.schema.json). This schema is the **source of truth** for prompt validation and is automatically enforced in CI.

### Required Fields
- `target_model`: Target LLM (e.g., "gpt-4", "claude-3")  
- `parameters`: Object containing `reasoning_effort` and `verbosity` (plus any additional parameters)
- `messages`: Array of message objects with `role` ("system"/"user") and `content`

### Optional Fields  
- `version`: Semantic version for prompts requiring deterministic behavior (e.g., "1.2.0")
- `assumptions`: Array of strings documenting prompt assumptions
- `risks_or_notes`: Array of strings for risk assessment or usage notes

### Example Structure
```json
{
  "target_model": "gpt-4",
  "version": "1.0.0",
  "parameters": {
    "reasoning_effort": "thorough",
    "verbosity": "detailed"
  },
  "messages": [
    {
      "role": "system", 
      "content": "You are a helpful assistant..."
    }
  ]
}
```

All prompts are automatically validated against this schema in CI. See [CONTRIBUTING.md](CONTRIBUTING.md) for validation details.

## Programmatic Usage

For automated workflows and integrations:

### Convert to JSON
```bash
# Convert all prompts to a single JSON file
./tools/convert.sh json > build/prompts.json
```

### Search and Filter
```bash
# Find prompts by tags
python tools/search.py --tags code-review --json

# Search by keyword
python tools/search.py --keyword "user story" --json > build/product_prompts.json

# Get all prompts
python tools/search.py --all --json
```

### Quick Discovery
```bash
# List available prompts by category
find prompts -name "*.json" -not -name "index.json" | sort

# Check generated index
cat prompts/index.json | jq '.prompts[] | {slug, category, path}'
```

## Cross-Project Reuse Workflows

Pick a strategy that matches your team's update/stability requirements.

### 1. Git Submodule (commit pin)
```
git submodule add https://github.com/raddevops/rad-prompt-hub.git vendor/rad-prompt-hub
git commit -m "Add prompt hub submodule"
```
Update:
```
cd vendor/rad-prompt-hub && git fetch origin main && git checkout origin/main
cd ../../
git add vendor/rad-prompt-hub && git commit -m "Update prompt hub"
```
Pros: Explicit version pin. Cons: Dev friction.

### 2. Git Subtree (simpler UX)
```
git subtree add --prefix=vendor/rad-prompt-hub https://github.com/raddevops/rad-prompt-hub.git main --squash
```
Update:
```
git subtree pull --prefix=vendor/rad-prompt-hub https://github.com/raddevops/rad-prompt-hub.git main --squash
```
Pros: Familiar workflow. Cons: Harder upstream contributions.

### 3. Vendor Snapshot
```
rsync -av --delete rad-prompt-hub/prompts/ my-app/prompts/
```
Record commit SHA in `PROMPTS_VERSION`.

### 4. Symlink (local dev)
```
ln -s ../rad-prompt-hub/prompts ./prompts_hub
```
Pros: Live updates. Cons: Symlink portability issues.

### 5. Selective Fetch Script
```python
import requests, pathlib
BASE = "https://raw.githubusercontent.com/raddevops/rad-prompt-hub/main/"
```

### 6. Package Artifact
Bundle prompts into an internal package (wheel / npm) exposing loader APIs.

### 7. Programmatic Indexing
```
./tools/convert.sh json > build/prompts.json
python tools/search.py --tags code-review --json > build/code_review.json
```

| Strategy | Pinning | Ease | Contrib Back | Automation |
|----------|---------|------|--------------|------------|
| Submodule | Strong | Medium | Easy | Good |
| Subtree | Strong | High | Medium | Good |
| Snapshot | Manual | High | Manual | OK |
| Symlink | Live | High | N/A | Weak |
| Fetch Script | Strong | High | Manual | High |
| Package | SemVer | High | Via PR | High |

## Adding a New Prompt
See: `templates/prompt-template.md`, `templates/prompt-metadata.yaml`, `CONTRIBUTING.md`, `docs/writing-style.md`.

## Tooling

### Search and Discovery
- `tools/search.py`: Tag/keyword search over prompt metadata from markdown frontmatter
- `tools/index.json`: Auto-generated registry from markdown frontmatter (for tool discovery)

### Conversion and Build
- `tools/convert.sh`: Batch convert Markdown prompts to JSON/YAML objects
- `scripts/build_tools_index.py`: Regenerate tools/index.json from all markdown files
- `scripts/build_prompts_index.py`: Generate **prompts/index.json** from JSON prompt files
- `scripts/check_tools_index.sh`: Verify tools/index.json is up to date
- `scripts/check_prompt_index.sh`: Verify **prompts/index.json** is up to date

**Note**: `prompts/index.json` is the generated prompt registry (minified, read-only). `tools/index.json` catalogs markdown metadata for search functionality.

## Recommended Conventions
- Keep prompts atomic
- Use section headings
- Prefer explicit variables: `{{input_text}}`
- Tags concise & lowercase

## Note on Formats

**JSON files are optimized for LLMs and must remain minified:**
- All JSON prompt files (`prompts/**/*.json`) are intentionally minified for token efficiency and stable diffs
- Use the paired `.md` files for human-readable content and editing
- Generated files like `prompts/index.json` should never be manually edited

## Try It

Get started with a quick end-to-end example:

```bash
# List available test scripts
find prompts -name "test.sh" | head -3

# Try a prompt validation
bash prompts/engineering/code-review/test.sh

# Search for specific prompts
python tools/search.py --tags engineering

# View the generated index
head prompts/index.json | jq .
```

## Copilot & Coding Agent Usage

- Repository-specific Copilot guidance lives in `.github/copilot-instructions.md`.
- The meta prompt for applying Copilot best practices is at `prompts/meta/add-copilot-instructions.json` and `prompts/meta/add-copilot-instructions.md`.
- When requesting repo-wide improvements, ask the agent to produce: a repo snapshot, extracted best practices, a mapping table, prioritized changes, a tailored prompts library, a verification plan, and a PR plan.

## Roadmap Ideas
- Auto index regeneration pre-commit hook
- Multi-language prompt variants
- Embedding-based semantic search

## License
MIT — see `LICENSE`.

---
Happy prompting!