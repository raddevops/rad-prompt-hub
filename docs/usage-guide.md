# Usage Guide

This guide explains how to integrate rad-prompt-hub prompts into tools, applications, and workflows. The repository is designed for **programmatic consumption** of JSON prompt specifications.

## Tool-First Design Philosophy

**JSON files** are the single source of truth for executable prompts. Tools and applications should consume these directly. **MD files** provide human context and integration guidance but never contain prompt content.

## Finding the Right Prompt

### By Category

Browse organized directories for JSON specifications:

```
prompts/
├── engineering/    # Code, architecture, dev workflows
│   ├── code-review/     # Each folder: .json (executable), .md (docs), test.sh
│   ├── git-workflow/
│   └── refactor-helper/
├── product/        # Requirements, planning, roadmaps  
├── writing/        # Content, documentation, communication
└── research/       # Analysis, synthesis, experimentation
```

**Integration Pattern**: Load the `.json` file directly into your application:
```python
import json
with open('prompts/engineering/code-review/code-review.json') as f:
    prompt_spec = json.load(f)
# prompt_spec now contains the complete LLM specification
```

### By Tags

Use the search tool for targeted discovery:

```bash
# Find all engineering prompts
python tools/search.py --tags engineering

# Find code review related prompts
python tools/search.py --tags code-review

# Multiple tag search (any match)
python tools/search.py --tags engineering quality

# Require all tags to match
python tools/search.py --tags engineering quality --all-tags

# Keyword search in titles
python tools/search.py --keyword "review"

# Get JSON output for programmatic use
python tools/search.py --tags engineering --json
```

### Using the Index

Browse `tools/index.json` for a complete registry:

```bash
cat tools/index.json | jq '.prompts[] | select(.category == "product")'
```

## Creating New Prompts (Developer Workflow)

Follow the **JSON-first creation process** to maintain DRY compliance:

### 1. Create JSON Specification (Source of Truth)
```bash
mkdir prompts/category/prompt-name/
# Create the executable JSON specification
cat > prompts/category/prompt-name/prompt-name.json << 'EOF'
{
  "target_model": "gpt-5-thinking",
  "parameters": {"reasoning_effort": "medium", "verbosity": "low"},
  "messages": [
    {"role": "system", "content": "Your system prompt here"},
    {"role": "user", "content": "User template with {{PLACEHOLDERS}}"}
  ],
  "assumptions": ["Any assumptions made"],
  "risks_or_notes": ["Important considerations"]
}
EOF
```

### 2. Document in MD (About the Prompt)
Create `prompt-name.md` with context and integration guidance (NOT prompt content):
```markdown
# Prompt Name

## Purpose
What this prompt accomplishes and when to use it.

## Integration Examples
How to consume the JSON in different tools/languages.

## Variables
Explanation of {{PLACEHOLDER}} values in the JSON.

## Notes
Additional guidance for effective use.
```

### 3. Add Validation Script
```bash
# Create test.sh to validate the prompt works
cat > prompts/category/prompt-name/test.sh << 'EOF'
#!/bin/bash
# Test script that validates JSON structure and functionality
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Add your validation logic here
EOF
chmod +x prompts/category/prompt-name/test.sh
```

### 4. Rebuild Index and Validate
```bash
python scripts/build_prompts_index.py
scripts/validate_prompts.sh
```

## Understanding Prompt Structure

Each prompt file follows a consistent format:

### Frontmatter (Metadata)
```yaml
---
title: "Descriptive Title"
tags: ["domain", "function", "style"]
author: "contributor-handle"  
last_updated: "2025-08-24"
---
```

### Content Sections

**Purpose**: When and why to use this prompt
**Prompt**: The LLM instruction text to copy
**Variables**: Explanation of `{{placeholder}}` values
**Example**: Input/output demonstration (optional)
**Notes**: Additional guidance or caveats

## Copy Strategies

### Quick Use (Just the Prompt)

1. Open the `.md` file
2. Copy only the "## Prompt" section content
3. Paste into your LLM interface
4. Replace any `{{variables}}` with actual values

### Full Context (Preserve Metadata)

1. Copy the entire file content
2. Paste into your tool/workflow
3. Strip frontmatter if your interface doesn't support it
4. Keep Purpose/Notes sections for reference

### Variable Substitution

Replace placeholder variables with your specific content:

```markdown
Original: "Analyze this {{code_snippet}} for security issues"
Replaced: "Analyze this Python function for security issues"
```

Common variable patterns:
- `{{input_text}}`: Your content to analyze
- `{{context}}`: Background information
- `{{goal}}`: Your specific objective
- `{{format}}`: Desired output structure

## Output Format Enforcement

Many prompts specify exact output formats. To get consistent results:

1. **Follow the template exactly**: Don't modify output format requests
2. **Use explicit constraints**: "Return only JSON", "Use Markdown headings"
3. **Provide examples**: Show the LLM what you want
4. **Add reminders**: "Remember to use the exact format specified"

## Integration Patterns

### CLI Tools

```bash
# Pipe prompt to LLM CLI
cat prompts/engineering/code-review.md | llm --system "$(head -n 20)"

# Use with OpenAI CLI
openai api chat_completions.create -m gpt-4 --messages '[{"role": "user", "content": "'$(cat prompt.md)'"}]'
```

### API Integration

```python
import requests

# Load prompt
with open('prompts/product/user-story/user-story.md') as f:
    prompt_content = f.read()

# Extract just the prompt section
prompt = extract_section(prompt_content, "## Prompt")

# Call LLM API
response = openai.ChatCompletion.create(
    model="gpt-4",
    messages=[{"role": "user", "content": prompt}]
)
```

### Workflow Integration

Create reusable prompt templates:

```bash
# Create project-specific prompt directory
mkdir my-project/prompts
cp rad-prompt-hub/prompts/engineering/code-review.md my-project/prompts/

# Customize for your stack
sed -i 's/{{code_snippet}}/{{python_code}}/' my-project/prompts/code-review.md
```

## Composition and Chaining

### Sequential Prompts

Chain related prompts for complex workflows:

1. Use `requirements-draft.md` to structure initial ideas
2. Feed output to `user-story/` prompts for breakdown
3. Use `acceptance-criteria.md` for detailed specifications

### Prompt Layering

Combine prompts for richer context:

```markdown
Base: "You are a senior software engineer"
+ Specific: "performing a security review"  
+ Context: "of a Python web application"
+ Constraints: "focusing on authentication and data validation"
```

## Version Management

### Tracking Changes

- Check `last_updated` field for recency
- Review git history for prompt evolution
- Test prompts with your specific use cases

### Backward Compatibility

- Keep old versions if prompts change significantly
- Document breaking changes in your integration
- Pin to specific commits for stability

## Tooling Hooks

### Pre-commit Validation

Validate prompts before committing:

```bash
# Check metadata completeness
python tools/search.py --all --json | jq '.[] | select(.title == null)'

# Validate format conversion
./tools/convert.sh json > /dev/null
```

### Automated Discovery

Generate prompt indexes for your projects:

```bash
# Export engineering prompts
python tools/search.py --tags engineering --json > eng-prompts.json

# Create category-specific indexes
for cat in engineering product writing research; do
    python tools/search.py --tags $cat --json > ${cat}-prompts.json
done
```

## Troubleshooting

### Inconsistent Results

- Check if variables are properly substituted
- Ensure output format constraints are clear
- Add more context or examples to the prompt
- Try different temperature settings

### Missing Context

- Include relevant background information
- Specify the domain/industry context
- Provide examples of desired output
- Add constraints about what NOT to include

### Format Issues

- Verify LLM interface supports Markdown
- Strip metadata if causing parsing errors
- Check for special characters that need escaping
- Ensure consistent line endings

## Security Considerations

- **Never include sensitive data** in prompts
- **Validate outputs** before using in production
- **Sanitize inputs** when automating prompt substitution
- **Review generated content** for accuracy and appropriateness

## Performance Tips

- **Keep prompts concise**: Under 500 words when possible
- **Use specific instructions**: Avoid ambiguous language
- **Provide clear constraints**: Reduce iteration cycles
- **Test with different models**: Some prompts work better with specific LLMs

## Strategy Selection

Choose integration approach based on your needs:

| Need | Strategy | Tools |
|------|----------|-------|
| Quick testing | Copy/paste | Browser, terminal |
| Development | Git submodule | Git, IDE |
| CI/CD | Artifact package | Build tools |
| Automation | API integration | Scripts, workflows |

---

Need help? Check our [troubleshooting guide](best-practices.md) or open an issue.