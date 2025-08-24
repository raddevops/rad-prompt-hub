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
├── prompts/                 # Organized prompts by domain
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

1. Browse `prompts/<category>/`.
2. Open a file and copy:
   - Just the "Prompt" section (for quick use), or
   - Entire file (to preserve context + purpose).
3. Paste into your LLM tool and adapt variables if present (e.g. `{{code_snippet}}`, `{{goal}}`).
4. (Optional) Strip metadata if your interface doesn’t need it.

## Adding a New Prompt

See:
- `templates/prompt-template.md` for the canonical layout
- `templates/prompt-metadata.yaml` for schema guidance
- `CONTRIBUTING.md` for the full workflow
- `docs/writing-style.md` for tone and formatting rules

## Tooling

- `tools/search.py`: Simple tag/keyword search over prompt metadata
- `tools/convert.sh`: Batch convert Markdown prompts to JSON/YAML objects
- `tools/index.json`: Auto-generated registry of prompts (can be regenerated via future tooling)

## Recommended Conventions

- Keep prompts atomic (one core function)
- Use section headings for clarity
- Prefer explicit variables: `{{input_text}}` over generic pronouns
- Keep metadata tags concise and lowercase

## Roadmap Ideas

- Auto index regeneration pre-commit hook
- CI validation of metadata schema
- Multi-language prompt variants
- Embedding-based semantic search

## License

MIT — see `LICENSE`.

---
Happy prompting!
