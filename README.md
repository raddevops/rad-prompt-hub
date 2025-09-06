# rad-prompt-hub

Production-ready LLM prompts designed for **tool consumption** with comprehensive JSON specifications that tools and applications can consume directly.

This hub prioritizes:
- **JSON-first design**: Executable prompts optimized for programmatic consumption
- **Tool integration**: Direct consumption by LLMs, APIs, and automation tools  
- **DRY compliance**: Single source of truth for prompt specifications
- **Human documentation**: Separate MD files for context and integration guidance
- **Comprehensive validation**: Automated testing and schema compliance

## Repository Layout

```
rad-prompt-hub/
├── prompts/                 # Organized by domain - JSON is source of truth
│   ├── engineering/
│   │   ├── code-review/     # Three-file structure per prompt
│   │   └── ...
│   ├── product/
│   ├── research/
│   ├── writing/
│   ├── meta/
│   ├── audit/
│   └── index.json           # Generated registry (tools consume this)
├── templates/               # Authoring templates + metadata schema
├── docs/                    # Usage, integration guides
├── tools/                   # Search, convert, validation utilities
└── README.md
```

## Prompt Folder Architecture

Each prompt follows a three-file structure with clear separation of concerns:

```
prompts/engineering/code-review/
├── code-review.json    # EXECUTABLE: LLM specification (tools consume this)
├── code-review.md      # DOCUMENTATION: Human context and usage guidance  
└── test.sh             # VALIDATION: Automated testing and examples
```

### File Purposes (DRY Principle)
- **`.json` file**: **Single source of truth** for executable prompt content
  - Optimized for tool/LLM consumption
  - Token-efficient, validated structure
  - Never duplicated elsewhere
- **`.md` file**: **Documentation about the prompt**
  - Purpose, integration examples, usage context
  - Human-readable guidance for developers
  - Does NOT contain prompt content (prevents duplication)
- **`test.sh`**: Validation script demonstrating integration patterns

## Tool Integration Examples

### Direct JSON Consumption
```python
# Python example
import json
import requests

with open('prompts/engineering/code-review/code-review.json') as f:
    prompt = json.load(f)
    
# Send to LLM API
response = requests.post('https://api.example.com/v1/chat', json=prompt)
```

### CLI Integration
```bash
# Direct consumption by LLM tools
llm-tool --prompt-file prompts/engineering/code-review/code-review.json --input "$(cat myfile.py)"
```

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