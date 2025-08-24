# Contributing to rad-prompt-hub

We welcome contributions to rad-prompt-hub! This guide outlines the process for adding new prompts, improving existing ones, and contributing to the project infrastructure.

## Quick Start

1. Fork the repository
2. Create a feature branch: `git checkout -b add-prompt-name`
3. Add your prompt using the template: `templates/prompt-template.md`
4. Follow our naming conventions and style guide
5. Test with our validation tools
6. Submit a pull request

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

1. Increment the `last_updated` date
2. Add changelog entry at bottom of file
3. Preserve backward compatibility when possible
4. If breaking changes needed, discuss in issue first

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