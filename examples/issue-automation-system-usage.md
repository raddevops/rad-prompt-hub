# GitHub Issue Automation System Usage Examples

This document demonstrates how to use the newly created GitHub Issue Automation System to automate repetitive documentation validation and improvement workflows.

## System Overview

The system consists of four key prompts that work together:

1. **`github-issue-automation-system`** - Main orchestrator that analyzes issues and creates the entire system
2. **`documentation-validator`** - Validates JSON ↔ markdown consistency  
3. **`workflow-orchestrator`** - Coordinates multi-phase validation and improvement workflows
4. **`issue-workflow-system-builder`** - Analyzes patterns and builds automation systems

## Quick Start: Automating the Current Issues

### Step 1: Analyze Repository Issues

Use the main automation system to analyze the current 13 identical "Validate and Improve Documentation" issues:

```python
import json

# Gather the required inputs
repository_path = "/home/runner/work/rad-prompt-hub/rad-prompt-hub"
github_info = {
    "owner": "raddevops", 
    "repo": "rad-prompt-hub",
    "api_access": "full"
}
open_issues = [
    # All 13 issues from the GitHub API
    # Issues #33-45 with identical validation workflows
]
repository_standards = """
Repository follows 3-file structure (JSON + MD + test.sh)
Schema validation via scripts/schema_validate_prompts.py
DRY principles - no executable content duplication in markdown
PromptSmith available for meta-prompt engineering
"""
integration_requirements = """
CI/CD integration with GitHub Actions
Schema validation pipeline
Build script integration for prompt index
Automated workflow triggers
"""

# Execute the main automation system
result = model.call(
    "prompts/meta/github-issue-automation-system/github-issue-automation-system.json",
    variables={
        "REPOSITORY_PATH": repository_path,
        "GITHUB_ACCOUNT_INFO": json.dumps(github_info),
        "OPEN_ISSUES_JSON": json.dumps(open_issues),
        "REPOSITORY_STANDARDS": repository_standards,
        "INTEGRATION_REQUIREMENTS": integration_requirements,
        "IMPLEMENTATION_SCOPE": "full_automation_system"
    }
)
```

### Step 2: Execute Individual Workflow for Single Issue

For individual prompt validation and improvement:

```python
# Use workflow orchestrator for a specific prompt
result = model.call(
    "prompts/meta/workflow-orchestrator/workflow-orchestrator.json",
    variables={
        "TARGET_PROMPT_PATH": "prompts/writing/press-release/",
        "WORKFLOW_SCOPE": "full_validation_improvement",
        "QUALITY_STANDARDS": "enterprise_ready,comprehensive_documentation"
    }
)
```

### Step 3: Validate Documentation Consistency

For standalone validation analysis:

```python
# Read the files
with open("prompts/engineering/code-review/code-review.json") as f:
    json_content = f.read()
with open("prompts/engineering/code-review/code-review.md") as f:
    md_content = f.read()

# Execute validation
result = model.call(
    "prompts/meta/documentation-validator/documentation-validator.json",
    variables={
        "PROMPT_FOLDER_PATH": "prompts/engineering/code-review/",
        "JSON_CONTENT": json_content,
        "MARKDOWN_CONTENT": md_content,
        "QUALITY_STANDARDS": "production_deployment"
    }
)
```

## Integration with GitHub Actions

### Automated Issue Processing

Create `.github/workflows/issue-automation.yml`:

```yaml
name: Issue Automation Workflow

on:
  issues:
    types: [opened, labeled]

jobs:
  process-validation-issues:
    if: contains(github.event.issue.labels.*.name, 'documentation-validation')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Execute Validation Workflow
        run: |
          # Use workflow-orchestrator to process the issue
          python scripts/run_workflow_orchestrator.py \
            --issue-number ${{ github.event.issue.number }} \
            --workflow-scope "full_validation_improvement"
```

### Automated Documentation Validation

```yaml
name: Documentation Consistency Check

on:
  pull_request:
    paths:
      - 'prompts/**/*.json'
      - 'prompts/**/*.md'

jobs:
  validate-docs:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate Changed Prompts
        run: |
          # Use documentation-validator on changed files
          python scripts/validate_changed_prompts.py
```

## CLI Usage Examples

### Batch Processing Multiple Issues

```bash
# Process all documentation validation issues
python scripts/batch_issue_processor.py \
  --label "documentation-validation" \
  --workflow "full_validation_improvement" \
  --quality-standards "enterprise_ready"
```

### Single Prompt Validation

```bash
# Validate a specific prompt
python scripts/validate_prompt.py \
  --path prompts/research/literature-review/ \
  --quality-standards "comprehensive_documentation" \
  --generate-report
```

## Expected Outcomes

After implementing this system, the 13 identical issues will be transformed from manual workflows to automated processes:

**Before:**
- Manual execution of 4-phase validation process
- Repetitive documentation validator runs  
- Manual promptsmith improvements
- Manual markdown updates
- Manual final validation

**After:**
- Single command execution: `workflow-orchestrator`
- Automated validation reports with specific remediation steps
- Automated prompt improvements via PromptSmith integration
- Automated documentation updates maintaining DRY principles
- Automated final validation and quality scoring

## System Benefits

1. **Consistency**: Standardized validation and improvement process
2. **Efficiency**: Reduced manual work from 4-phase process to single execution
3. **Quality**: Systematic improvement using PromptSmith methodology
4. **Scalability**: Easy to apply to new prompts and similar workflows
5. **Integration**: Works with existing repository infrastructure and CI/CD

## Next Steps

1. Test the system with one of the existing issues (e.g., issue #45 - press-release)
2. Refine the automation based on results
3. Update all 13 issues to reference the new automated workflow
4. Create documentation for team adoption
5. Extend the system for other repetitive issue patterns in the repository