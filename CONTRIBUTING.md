# Contributing to rad-prompt-hub

We welcome contributions to rad-prompt-hub! This guide outlines the process for adding new prompts, improving existing ones, and contributing to the project infrastructure.

## Quick Start

1. Fork the repository
2. Create a feature branch: `git checkout -b add-prompt-name`
3. **Set up pre-commit hooks** (recommended): `./tools/setup-pre-commit.sh`
4. Add your prompt using the template: `templates/prompt-template.md`
5. Follow our naming conventions and style guide
6. Test with our validation tools
7. Submit a pull request

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

### 1. Use the Template

Start with `templates/prompt-template.md` and fill in all sections:

- **Title**: Clear, specific description (≤ 8 words)
- **Tags**: 2-5 lowercase tags (include domain + function)
- **Author**: Your GitHub handle or identifier
- **Purpose**: 2-5 sentences explaining when to use this prompt
- **Prompt**: The actual LLM instruction text
- **Variables**: Document any `{{placeholder}}` variables
- **Example**: Show input/output structure if helpful

### 2. Choose the Right Category

Place your prompt in the appropriate domain directory:

- `prompts/engineering/`: Code review, refactoring, architecture, testing
- `prompts/product/`: Requirements, user stories, roadmaps, metrics
- `prompts/writing/`: Documentation, communication, content creation
- `prompts/research/`: Analysis, synthesis, experimentation, evaluation

### 3. Follow Naming Conventions

- Filename: `kebab-case-descriptive-name.md`
- Max 50 characters
- Avoid abbreviations
- Examples: `code-review.md`, `user-story-generator.md`, `blog-outline.md`

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

### Metadata Validation

Run our validation script:

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

## Documentation Contributions

Help improve our guides:

- `docs/usage-guide.md`: How to use prompts effectively
- `docs/writing-style.md`: Style and tone guidelines
- `docs/best-practices.md`: Prompt engineering best practices
- `README.md`: Main project documentation

## Schema Extensions

To propose new metadata fields:

1. Open an issue describing the use case
2. Show examples of how it would be used
3. Ensure backward compatibility
4. Update `templates/prompt-metadata.yaml` documentation

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