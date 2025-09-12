---
title: "Multi-Prompt Workflow Example"
purpose: "Demonstrate orchestration of multiple meta prompts into an automated issue/documentation improvement system"
last_updated: "2025-09-11"
status: "example"
---

# Multi-Prompt Workflow Example (Issue Automation System)

This example shows how four meta/orchestration prompts can be combined to replace a repetitive, manual multi‑phase documentation validation & improvement process.

Prompts involved:
1. `github-issue-automation-system` – Orchestrator that analyzes issues & proposes an automation system
2. `documentation-validator` – Ensures JSON ↔ Markdown consistency
3. `workflow-orchestrator` – Runs multi-phase validation & improvement sequences
4. `issue-workflow-system-builder` – Derives reusable automation workflows from issue patterns

## 1. Quick Repository Issue Analysis
```python
import json

repository_path = "/home/runner/work/rad-prompt-hub/rad-prompt-hub"
github_info = {"owner": "raddevops", "repo": "rad-prompt-hub", "api_access": "full"}
open_issues = []  # Populate with issues #33–#45 JSON payloads
repository_standards = """
3-file structure (JSON + MD + test.sh)
Schema validation via scripts/schema_validate_prompts.py
DRY: no executable duplication in MD
PromptSmith available for meta engineering
"""
integration_requirements = """
GitHub Actions integration
Schema validation pipeline
Prompt index build
Automated workflow triggers
"""

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

## 2. Single Prompt Deep Validation
```python
result = model.call(
    "prompts/meta/workflow-orchestrator/workflow-orchestrator.json",
    variables={
        "TARGET_PROMPT_PATH": "prompts/writing/press-release/",
        "WORKFLOW_SCOPE": "full_validation_improvement",
        "QUALITY_STANDARDS": "enterprise_ready,comprehensive_documentation"
    }
)
```

## 3. Documentation Consistency Check (Standalone)
```python
with open("prompts/engineering/code-review/code-review.json") as f: json_content = f.read()
with open("prompts/engineering/code-review/code-review.md") as f: md_content = f.read()

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

## 4. GitHub Actions Integration Snippets
### Issue Event Automation
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
          python scripts/run_workflow_orchestrator.py \
            --issue-number ${{ github.event.issue.number }} \
            --workflow-scope "full_validation_improvement"
```

### PR Documentation Consistency
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
        run: python scripts/validate_changed_prompts.py
```

## 5. CLI Batch Examples
```bash
# Process all documentation validation issues
python scripts/batch_issue_processor.py \
  --label "documentation-validation" \
  --workflow "full_validation_improvement" \
  --quality-standards "enterprise_ready"

# Validate a specific prompt
python scripts/validate_prompt.py \
  --path prompts/research/literature-review/ \
  --quality-standards "comprehensive_documentation" \
  --generate-report
```

## 6. Before → After Impact
| Phase | Manual (Before) | Automated (After) |
|-------|-----------------|-------------------|
| Validation execution | 4 separate runs | Single orchestrated run |
| Doc consistency | Manual validator reruns | Automated workflow step |
| Prompt refinement | Manual PromptSmith use | Embedded improvement phase |
| Markdown updates | Manual edits | Auto-updated with DRY enforcement |
| Final QA | Manual checklist | Automated final validation |

## 7. Benefits
1. Consistency across all prompt remediation workflows
2. Reduced manual effort & cognitive load
3. Higher quality via systematic multi-phase improvement
4. Scales to new prompt categories with minimal config
5. Integrates cleanly with existing CI / repo standards

## 8. Next Steps
1. Pilot on a single prompt folder (e.g., `writing/press-release`)
2. Roll out to remaining similar issues
3. Add success metrics (time saved, defect reduction)
4. Generalize orchestrator for other repetitive issue archetypes

---
_This example replaces the former `examples/issue-automation-system-usage.md` file. The `examples/` directory was removed to avoid single-file drift._