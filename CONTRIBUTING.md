# Contributing to rad-prompt-hub

We welcome contributions to rad-prompt-hub! This guide outlines the process for adding new prompts, improving existing ones, and contributing to the project infrastructure.

## Quick Start

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/your-feature-slug-YYYYMMDD`
3. **Set up pre-commit hooks** (recommended): `./tools/setup-pre-commit.sh`
4. Follow our naming conventions and style guide
5. Run validation locally (e.g., `scripts/validate_prompts.sh`)
6. Commit and push your branch
7. Open a pull request

## Branch naming convention

We use structured, date-stamped branch names. Pattern:

`<type>/<slug>-YYYYMMDD`

- type: one of `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `perf`, `ci`
- slug: short, kebab-case summary (starts with a letter, a–z, 0–9 and '-')
- date: UTC date in `YYYYMMDD`

Examples:
- `feat/new-search-api-20250906`
- `fix/guardrail-npe-20250906`
- `chore/gitignore-hardening-20250906` (this repo’s first well-named branch)

Exceptions allowed: `main`, `release/x.y.z`

CI enforces this on pull requests.

## Pre-commit Hooks Setup

We use pre-commit hooks to ensure prompt quality and consistency. **Setting up these hooks is strongly recommended** for all contributors.

### Automatic Setup

Run the setup script to install and configure everything:

```bash
./tools/setup-pre-commit.sh
```

### Manual Setup

If you prefer to set up manually:

```bash
# Install pre-commit (if not already installed)
pip install pre-commit

# Install the hooks
pre-commit install

# Test the setup
pre-commit run --all-files
```

### What the Hooks Check

- **last_updated enforcement**: When you modify prompt body content, the `last_updated` field must be set to today's date
- **Metadata validation**: Ensures all required frontmatter fields are present

### Working with the Hooks

The hooks run automatically before each commit. If they fail:

1. Fix the issues reported (usually updating `last_updated` field)
2. Re-stage your files: `git add <file>`
3. Commit again

To run hooks manually:
```bash
# Run on staged files
pre-commit run

# Run on all files
pre-commit run --all-files

# Run specific hook
pre-commit run check-last-updated
```

### Bypassing Hooks (Not Recommended)

If you need to bypass hooks in exceptional circumstances:
```bash
git commit --no-verify
```

**Note**: Pull requests will still be validated by CI, so issues must be fixed before merging.

## Adding a New Prompt

### 1. Author the Markdown (Docs)

Create a new `.md` file and include the required frontmatter and sections below:

- **Title**: Clear, specific description (≤ 8 words)
- **Tags**: 2-5 lowercase tags (include domain + function)
- **Author**: Your GitHub handle or identifier
- **Purpose**: 2-5 sentences explaining when to use this prompt
- **Prompt**: The actual LLM instruction text
- **Variables**: Document any `{{placeholder}}` variables
- **Example**: Show input/output structure if helpful

### 2. Create the Prompt Folder

Create a new folder structure for your prompt:

- Create folder: `prompts/<category>/<prompt-name>/`
- Place your prompt files in this folder:
  - `<prompt-name>.md`: Human-readable documentation
  - `<prompt-name>.json`: Executable JSON specification  
  - `test.sh`: Test script to validate functionality

**JSON Format Requirements**: The JSON file must conform to [`scripts/prompt.schema.json`](scripts/prompt.schema.json). Required fields are `target_model`, `parameters` (containing `reasoning_effort` and `verbosity`), and `messages` array. See [README.md](README.md#json-schema) for full schema details.

Categories:
- `prompts/engineering/`: Code review, refactoring, architecture, testing
- `prompts/product/`: Requirements, user stories, roadmaps, metrics
- `prompts/writing/`: Documentation, communication, content creation
- `prompts/research/`: Analysis, synthesis, experimentation, evaluation

### 3. Follow Naming Conventions

- Folder name: `kebab-case-descriptive-name`
- Filenames match folder name: `prompt-name.md`, `prompt-name.json`
- Max 50 characters for folder/file names
- Avoid abbreviations
- Examples: `code-review/`, `user-story-generator/`, `blog-outline/`

### 4. Metadata Requirements

All prompts must include complete YAML frontmatter:

```yaml
---
title: "Descriptive Title"
tags: ["domain", "function", "optional-third"]
author: "your-github-handle"
last_updated: "YYYY-MM-DD"
---
```

Required fields:
- `title`: Human-readable name
- `tags`: Array of 2-5 lowercase strings
- `author`: Attribution identifier
- `last_updated`: ISO date format

### 5. Style Guidelines

- Write in second person ("You are...")
- Use active voice
- Include explicit constraints and output format
- Prefer numbered lists for multi-step instructions
- Keep prompts under 500 words
- Use `{{variable_name}}` for placeholders

### 6. Quality Checklist

Before submitting, verify:

- [ ] Follows template structure exactly
- [ ] All metadata fields completed
- [ ] Title is specific and actionable
- [ ] Tags accurately reflect content
- [ ] Purpose section explains when to use
- [ ] Prompt text is clear and unambiguous
- [ ] Variables are documented
- [ ] No typos or grammatical errors
- [ ] Example provided if prompt is complex

## Validation and Testing


### Index Regeneration

After adding or modifying markdown files, regenerate the metadata index:

```bash
# Regenerate tools/index.json from markdown frontmatter
python scripts/build_tools_index.py

# Verify the index is current
bash scripts/check_tools_index.sh
```


### JSON Schema Validation


All JSON prompt files are validated against our **canonical schema** at [`scripts/prompt.schema.json`](scripts/prompt.schema.json). This schema is the **source of truth** for prompt structure and is automatically enforced in CI.

Run local schema validation:
```bash
python scripts/schema_validate_prompts.py
```

This validates:
- **Required fields**: `target_model`, `parameters` (with `reasoning_effort`), `messages`
- **Message structure**: Proper `role` and `content` fields  
- **Version format**: Semantic versioning if `version` field is present
- **File pairing**: Every `.json` must have a corresponding `.md` file

### Prompt Linting & Schema Enforcement

We provide an opinionated lint script that layers **custom repository rules** on top of the canonical schema. Run it before every commit touching prompts:

```bash
bash scripts/lint_prompts.sh
```

What it does (in order):
1. Discovers all prompt JSON specs under `prompts/**/<name>/<name>.json`
2. Runs full schema validation (`scripts/schema_validate_prompts.py`)
3. Applies custom lint rules:
   - Minification: JSON prompt files should be ≤ 2 lines (token efficiency)
   - Required keys present: `target_model`, `parameters.reasoning_effort`, `parameters.verbosity`, `messages`
   - Allowed message roles: `system`, `user` only (no `assistant` authoring leakage)
   - Semantic version regex (if `version` present)
   - No trailing spaces (single‑line files)
4. Produces a consolidated pass/fail report

Sample successful output:
```
🔍 Collecting prompt JSON files...
✅ Found 23 prompt files
🔍 Running schema validation (python)...
✅ Schema validation passed
🔍 Applying custom lint rules...
✅ All 23 prompt files passed custom lint rules
```

Failure example (truncated):
```
... version not valid semver -> 1.0
... missing parameters.reasoning_effort
❌ Lint failed (2 issues across 1 files)
```

Install prerequisites (if missing):
```bash
brew install jq            # macOS
python3 --version          # Ensure Python 3 available
```

Add an optional git alias for convenience:
```bash
git config alias.lint-prompts '!bash scripts/lint_prompts.sh'
```

#### (Optional) Local Pre-commit Hook Integration

We intentionally keep the lint script out of the default `.pre-commit-config.yaml` to preserve fast commits for docs‑only edits. If you want stricter local enforcement, append this to `.pre-commit-config.yaml` under `repos: - repo: local`:

```yaml
  - id: prompt-lint
    name: Prompt JSON lint (schema + custom rules)
    entry: bash scripts/lint_prompts.sh
    language: system
    pass_filenames: false
    always_run: false
    files: ^prompts/.*\.json$
```

Then reinstall hooks:
```bash
pre-commit install
```

#### When to Run
- Before opening a PR that changes any prompt JSON
- After rebasing if you pulled in upstream prompt changes
- In CI (future enhancement) — today CI already runs schema & index checks; we may extend it to call `lint_prompts.sh` for unified reporting.

#### Rationale
Consistent minified JSON + enforced structural contract reduces diff noise, improves cache efficiency, and prevents subtle drift (e.g., accidental role additions or missing reasoning parameters) before prompts reach production workflows.

### Full Validation Suite

Run all validation checks (same as CI):
```bash
bash scripts/validate_prompts.sh        # Structural validation
bash scripts/check_prompt_index.sh      # Index consistency  
python scripts/detect_stray_prompts.py  # Detect orphaned files
python scripts/schema_validate_prompts.py # Schema validation
```

### Metadata Validation

Test prompt discoverability:
```bash
python tools/search.py --all --json | jq '.[] | select(.title == null)'
```
Should return empty results.

### Search Testing

Test discoverability:

```bash
# Test tag search
python tools/search.py --tags engineering

# Test keyword search  
python tools/search.py --keyword "code review"
```

### Format Testing

Verify conversion works:

```bash
./tools/convert.sh json | jq '.[0]'

```

## Generated files policy

- All JSON prompt files (`prompts/**/*.json`, including `prompts/index.json`) are optimized for LLM use and must remain minified/compact. These files are generated for token efficiency and small diffs—do not hand-edit or pretty-print them. Use the paired Markdown (`.md`) for human readability, and always use the provided scripts to rebuild JSON files when needed.
- `tools/index.json` is automatically generated from markdown frontmatter. Run `python scripts/build_tools_index.py` to regenerate it after adding/modifying markdown files.
- The CI workflow automatically checks that both index files are up to date and will fail if manual regeneration is needed.

## Anti-Patterns to Avoid

❌ **Overly Generic Prompts**
- "Help me with my code" → Too vague
- ✅ "Review Python function for security vulnerabilities"

❌ **Missing Context**
- "Analyze this" → No role or constraints
- ✅ "You are a data analyst. Analyze the CSV data..."

❌ **Unclear Output Format**
- "Give me feedback" → Ambiguous structure
- ✅ "Return JSON with fields: summary, issues, recommendations"

❌ **Too Many Responsibilities**
- Single prompt doing code review + documentation + testing
- ✅ Separate atomic prompts for each function

❌ **Inconsistent Variable Format**
- Using `[input]`, `<text>`, `{variable}` inconsistently
- ✅ Always use `{{variable_name}}`

## Updating Existing Prompts

When modifying existing prompts, follow these requirements:

1. **Update the `last_updated` field** to today's date (YYYY-MM-DD) when changing prompt body content
2. **Add a changelog entry** at the bottom of the file describing your changes
3. **Preserve backward compatibility** when possible
4. **If breaking changes are needed**, discuss in an issue first

### Pre-commit Hook Enforcement

Our pre-commit hooks automatically check that:
- If you modify prompt body content (anything after the frontmatter), the `last_updated` field must be set to today's date
- The hook will fail your commit if this requirement is not met
- This ensures all changes are properly tracked and dated

### Example Update Process

```bash
# 1. Make your changes to the prompt content
vim prompts/engineering/code-review.md

# 2. Update the last_updated field to today's date
# last_updated: "2025-08-24"

# 3. Add changelog entry
## Changelog
- 2025-08-24: Added example for security review criteria

# 4. Stage and commit (pre-commit hook will validate)
git add prompts/engineering/code-review.md
git commit -m "Improve code review security criteria"
```

## Versioning and Changelog Management

For prompts requiring stable behavior for external integrations, follow our semantic versioning conventions.

### When to Add Versions

**Add semantic versioning when:**
- External APIs or automated systems depend on your prompt
- Breaking changes would impact downstream consumers  
- Deterministic behavior is required across deployments
- Formal release process is needed

**Use `last_updated` field only when:**
- Prompt is used manually/informally
- Changes are non-breaking improvements
- Quick iteration is preferred

### Semantic Versioning Process

Follow [Semantic Versioning 2.0.0](https://semver.org/): `MAJOR.MINOR.PATCH`

#### Version Bump Rules

- **MAJOR** (breaking changes): Output format changes, removed parameters, behavioral changes
- **MINOR** (new features): New optional parameters, enhanced capabilities
- **PATCH** (bug fixes): Typos, clarifications, documentation updates

#### Example Workflow

```bash
# 1. Update JSON file with version
vim prompts/engineering/code-review/code-review.json
# Add: "version": "1.3.0"

# 2. Update markdown frontmatter  
vim prompts/engineering/code-review/code-review.md
# Update: last_updated: "2025-09-06"
# Optionally: version: "1.3.0"

# 3. Add changelog entry
## Changelog

### [1.3.0] - 2025-09-06
#### Added
- Enhanced error handling for edge cases
- Optional security focus parameter

#### Changed
- Improved recommendation prioritization  

#### Fixed
- Typo in system prompt

# 4. Commit with semantic message
git add prompts/engineering/code-review/
git commit -m "feat(code-review): enhance error handling (v1.3.0)"

# 5. Optional: Tag release
git tag v1.3.0-code-review
```

### Breaking Changes

For **major version bumps** with breaking changes:

1. **Document impact**: Clearly explain what breaks
2. **Provide migration path**: Show how to update usage
3. **Use clear prefix**: Mark with **BREAKING** in changelog
4. **Consider deprecation**: Give users time to migrate

Example:
```markdown
### [2.0.0] - 2025-09-06
#### Breaking Changes
- **BREAKING**: Output format changed from text to JSON schema
  - Migration: Update your parsing logic to handle JSON structure
  - See [Schema Documentation](schema.md) for new format
- **BREAKING**: Removed deprecated `{{style}}` parameter
  - Migration: Use `{{format}}` parameter instead
```

### Documentation

For detailed versioning guidelines, see [docs/VERSIONING_CHANGELOG.md](docs/VERSIONING_CHANGELOG.md).

## Release & Tagging (Repository)

Use this process for repository releases that cover docs/CI/policies and broad prompt-pack updates.

- Tag format: `vMAJOR.MINOR.PATCH` (example: `v0.1.0`)
- Release branch (preferred): `release/x.y.z` (example: `release/0.1.0`)
  - The branch should include:
    - README badges/notes (if needed)
    - An entry in `docs/VERSIONING_CHANGELOG.md` under “Release History”
    - No pretty-printing of generated JSON; keep JSON artifacts minified
- Required check: `validate` must pass on the PR

Standard flow:
1) Create the release branch and open a PR to `main`
2) Ensure CI passes and resolve any review comments
3) Merge the PR
4) Tag the merge commit as `vX.Y.Z` and push the tag
5) (Optional) Create a GitHub Release from the tag using the changelog entry

Notes:
- Branch protections require the `validate` check to pass before merge
- Conversation resolution may be enforced; resolve any open PR threads
- After a public flip, badges and links should render without auth

## Prompt-specific Tags (Optional)

Only use prompt-scoped tags when a prompt is versioned independently for external consumers.

- Tag format: `vX.Y.Z-<prompt-folder>` (example: `v1.3.0-code-review`)
- Follow the semantic versioning rules in this guide
- Ensure the Markdown frontmatter optionally reflects `version` and `last_updated`

## Documentation Contributions

Help improve our guides:

- `docs/usage-guide.md`: How to use prompts effectively
- `docs/best-practices.md`: Prompt engineering best practices

## Governance and Merge Policy

This repository uses CODEOWNERS for required reviews. See `CODEOWNERS` at the repo root and `docs/GOVERNANCE.md` for roles and SLAs.

## Automation

New issues and pull requests are automatically added to the OSS Readiness project for tracking. See `.github/workflows/project-auto-add.yml`.

## Schema Extensions

To propose new metadata fields:

1. Open an issue describing the use case
2. Show examples of how it would be used
3. Ensure backward compatibility
4. Update documentation to describe the new field (e.g., in docs/ or README)

## Infrastructure Contributions

We welcome improvements to:

- Search functionality (`tools/search.py`)
- Conversion utilities (`tools/convert.sh`)
- Index generation (`tools/index.json`)
- CI/CD workflows
- Validation scripts

## Code of Conduct

- Be respectful and constructive
- Focus on prompt quality and reusability
- Provide clear, actionable feedback
- Help newcomers learn our conventions

## Questions?

- Open an issue for clarification
- Tag maintainers for urgent items
- Check existing issues for similar questions

---

Thank you for contributing to rad-prompt-hub!