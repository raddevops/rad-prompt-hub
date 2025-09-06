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
│   └── writing/
├── templates/               # Authoring templates + metadata schema
├── docs/                    # Usage, style, best practices
├── tools/                   # Helper scripts (search, convert, index)
└── README.md
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

1. Browse `prompts/<category>/<prompt-name>/`.
2. Open the markdown file and copy:
   - Just the "Prompt" section (for quick use), or
   - Entire file (to preserve context + purpose).
3. Alternatively, use the JSON file for programmatic access.
4. Paste into your LLM tool and adapt variables if present (e.g. `{{code_snippet}}`, `{{goal}}`).
5. (Optional) Strip metadata if your interface doesn't need it.

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
- `tools/search.py`: Simple tag/keyword search over prompt metadata
- `tools/convert.sh`: Batch convert Markdown prompts to JSON/YAML objects
- `tools/index.json`: Auto-generated registry from markdown frontmatter
- `scripts/build_tools_index.py`: Regenerate tools/index.json from all markdown files
- `scripts/build_prompts_index.py`: Generate prompts/index.json from JSON prompt files
- `scripts/check_tools_index.sh`: Verify tools/index.json is up to date
- `scripts/check_prompt_index.sh`: Verify prompts/index.json is up to date

## Recommended Conventions
- Keep prompts atomic
- Use section headings
- Prefer explicit variables: `{{input_text}}`
- Tags concise & lowercase

Note on formats:
- JSON prompt files (`prompts/**/*.json`) are optimized for LLM execution and intentionally minified. Use the paired `.md` files for human-readable content and editing.

## Copilot & Coding Agent Usage

- Repository-specific Copilot guidance lives in `.github/copilot-instructions.md`.
- The meta prompt for applying Copilot best practices is at `prompts/meta/add-copilot-instructions.json` and `prompts/meta/add-copilot-instructions.md`.
- When requesting repo-wide improvements, ask the agent to produce: a repo snapshot, extracted best practices, a mapping table, prioritized changes, a tailored prompts library, a verification plan, and a PR plan.

## Roadmap Ideas
- Auto index regeneration pre-commit hook
- CI validation of metadata schema
- Multi-language prompt variants
- Embedding-based semantic search

## License
MIT — see `LICENSE`.

---
Happy prompting!