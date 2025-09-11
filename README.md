# rad-prompt-hub

![CI](https://img.shields.io/github/actions/workflow/status/raddevops/rad-prompt-hub/validate-prompts.yml?branch=main&label=validate)
![License](https://img.shields.io/github/license/raddevops/rad-prompt-hub)
![Version](https://img.shields.io/badge/version-v0.1.0-blue)


Sample LLM prompts designed for **tool consumption** with JSON specifications that tools and applications can consume directly.

  

## What's the Problem?

  

I'm getting good results from using meta-prompting to create reusable prompts for various tasks, but I find myself doing a good bit of manual copy/paste work across different tools and interfaces.

  

Gathering all my 'golden' prompts, and a few draft ones, into one place lets me standardize more easily, keep up with versions, and reference across different code projects.

  

In case this is helpful to anyone to see what's working for me right now, or to collaborate on improving the catalog, this is posted so more people than myself can see and experiment with it.

  

This hub prioritizes:

- **JSON-first design**: Executable prompts optimized for programmatic consumption

- **Tool integration**: Direct consumption by LLMs, APIs, and automation tools

- **DRY compliance**: Single source of truth for prompt specifications

- **Human-usable documentation**: Separate MD files for context and integration guidance

- **Validation**: Automated testing and schema compliance

  

## Repository Layout

  

```

rad-prompt-hub/

├── prompts/ # Organized by domain - JSON is source of truth

│ ├── engineering/

│ │ ├── code-review/ # Three-file structure per prompt

│ │ └── ...

│ ├── product/

│ ├── research/

│ ├── writing/

│ ├── meta/

│ ├── audit/

│ └── index.json # Generated registry (tools consume this)

├── docs/ # Usage, integration guides

├── tools/ # Search, convert, validation utilities

└── README.md

```

  

## Prompt Folder Architecture

  

Each prompt follows a three-file structure with clear separation of concerns:

  

```

prompts/engineering/code-review/

├── code-review.json # EXECUTABLE: LLM specification (tools consume this)

├── code-review.md # DOCUMENTATION: Human context and usage guidance

└── test.sh # VALIDATION: Automated testing and examples

```

  

### File Purposes 

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

  

## Quick Example (Prompt Files)

  

This repo separates executable prompt specs (.json) from human docs (.md).

  

1) Executable spec (.json) — single source of truth (minified):

  

```json

{"target_model":"gpt-4","parameters":{"reasoning_effort":"standard","verbosity":"concise"},"messages":[{"role":"system","content":"You are a senior engineer. Review the code diff and return a clear, actionable report."},{"role":"user","content":"{DIFF}"}]}

```

  

2) Documentation (.md) — human-readable context only (no prompt content):

  

```markdown
## Usage & Integration (De‑duplicated)

To keep this README lean, detailed usage, integration patterns, variable substitution, validation workflow, reuse strategies, and version management now live in:

- `docs/usage-guide.md` (primary end‑to‑end guide: discovery, integration, creation, chaining, troubleshooting, security, performance)
- `docs/PROMPTS_OVERVIEW.md` (three‑file architecture + DRY enforcement + remediation checklist)
- `docs/writing-style.md` (style & tone for human-facing docs)
- `CONTRIBUTING.md` (contribution flow & validation requirements)

Quick start recap:
1. Locate a prompt JSON under `prompts/<category>/<name>/<name>.json`.
2. Load the JSON directly into your LLM/tool – it is the canonical spec.
3. Consult the sibling `.md` for human context (never copy content back into JSON).
4. Run `bash prompts/<category>/<name>/test.sh` for local validation.
5. When adding a new prompt: JSON → MD → test.sh → `python scripts/build_prompts_index.py`.

Need examples for: bulk search, submodule reuse, or CI integration? See `docs/usage-guide.md` sections: “Finding the Right Prompt”, “Cross-Project Reuse Workflows”, and “Integration Patterns”.

Schema reference & required fields: see `scripts/prompt.schema.json` plus validation notes in `docs/PROMPTS_OVERVIEW.md`.

# Copy a minimal test from a similar prompt and adapt it

chmod +x prompts/<category>/<prompt-name>/test.sh

```

  

### 4. Validate and Build

```bash

# Validate prompt structure

./scripts/validate_prompts.sh

  

# Rebuild the index

python3 scripts/build_prompts_index.py

  

# Test the prompt

bash prompts/<category>/<prompt-name>/test.sh

```

  

See: `CONTRIBUTING.md`, `docs/writing-style.md` for detailed guidance.

  

## Tooling

  

### Search and Discovery

- `tools/search.py`: Tag/keyword search over prompt metadata from Markdown front matter

- `tools/index.json`: Auto-generated registry from Markdown front matter (for tool discovery)

  

### Conversion and Build

- `tools/convert.sh`: Stream‑convert every prompt markdown: emits JSON (frontmatter → naive key/value + raw body) or raw frontmatter YAML to stdout. Does not modify files; parser is intentionally minimal.

- `scripts/build_tools_index.py`: Rebuilds `tools/index.json` (markdown prompt metadata registry) by scanning all `prompts/**/*.md`, extracting frontmatter (or inferring title/category), and writing a minified index (not a list of executable tools).

- `scripts/build_prompts_index.py`: Generates `prompts/index.json` from all prompt JSON specs (hashes content, captures slug, category, model + reasoning/verbosity parameters). Skips `prompts/index.json` itself.

- `scripts/check_tools_index.sh`: Rebuilds then compares `tools/index.json` ignoring the `generated_at` field; reports drift and restores the original file if mismatch so your working tree stays clean.

- `scripts/check_prompt_index.sh`: Ensures every `prompts/**/*.json` (excluding the index itself) is listed in `prompts/index.json` (path set parity). It does not re-hash or validate internal metadata consistency.

  

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

- The meta prompt for applying Copilot best practices is at `prompts/meta/add-copilot-instructions`

- When requesting repo-wide improvements, ask the agent to produce: a repo snapshot, extracted best practices, a mapping table, prioritized changes, a tailored prompts library, a verification plan, and a PR plan.

  

## Roadmap Ideas

- Auto index regeneration pre-commit hook

- Embedding-based semantic search

  

## License

MIT — see `LICENSE`.

  

## AI-generated content notice

  

Portions of this repository were created or assisted by AI systems. Review outputs critically and validate for accuracy, safety, licensing, and fitness for your use case before relying on them. See `docs/AI_CONTENT_NOTICE.md`.



---

Happy prompting!