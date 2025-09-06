# Repository instructions for GitHub Copilot

This repository intentionally keeps certain JSON artifacts minified and machine-generated. Please follow these guidelines during reviews:

- Do not suggest pretty-printing or reformatting `prompts/index.json`. It is minified by design for token efficiency and diff stability. Changes to this file should only come from our generator.
- Treat `prompts/index.json` as generated output. Focus on whether it was rebuilt (hashes/paths updated) rather than human readability.
- Prefer suggestions that improve guardrails, validation, or safety over stylistic changes that increase noise.
- Respect our branch naming convention: `<type>/<slug>-YYYYMMDD` with allowed types `feat|fix|chore|docs|refactor|test|perf|ci`.

Thank you.
