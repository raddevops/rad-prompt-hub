# Issues 33-45 Update Implementation Guide

## Overview
This document contains the updated content for GitHub issues 33-45, replacing outdated manual workflow plans with references to the established automation framework.

## Problem Summary
- **Original Issues**: Contained detailed 4-phase manual workflows that are now outdated
- **Old Tool References**: Issues referenced `tmp/documentation-validator.json` and other incorrect locations
- **Manual Process**: Issues described repetitive manual processes that can now be automated
- **Outdated Methodology**: Issues didn't leverage the new PromptSmith methodology and automation framework

## Solution Summary
- **Framework Reference**: Updated issues now reference the established automation framework in `examples/issue-automation-system-usage.md`
- **Correct Tool Locations**: Issues now point to proper tool locations in `prompts/meta/`
- **Automated Workflows**: Issues now emphasize automated execution via workflow-orchestrator
- **Current Methodology**: Issues now reference current best practices and documentation

## Key Changes Made

### 1. Updated Tool References
- **Old**: `tmp/documentation-validator.json`
- **New**: `prompts/meta/documentation-validator/documentation-validator.json`

- **Old**: `prompts/writing/promptsmith/promptsmith.json`
- **New**: `prompts/meta/promptsmith/promptsmith.json`

### 2. Added Framework Documentation Links
- Main Framework: `examples/issue-automation-system-usage.md`
- Workflow Orchestrator: `prompts/meta/workflow-orchestrator/`
- Documentation Validator: `prompts/meta/documentation-validator/`
- PromptSmith: `prompts/meta/promptsmith/`

### 3. Streamlined Workflow
- **Old**: 4-phase manual process with detailed step-by-step instructions
- **New**: Reference to established framework with Option 1 (automated) and Option 2 (manual)

### 4. Added Quick Start Examples
- Python code examples for automated execution
- References to detailed documentation for manual execution
- Proper variable usage for each specific prompt

## Files Generated
The following files contain the updated content for each issue:

```
/tmp/updated_issues/
├── issue_33_updated.md  # refactor-helper (prompts/engineering/refactor-helper)
├── issue_34_updated.md  # repository-audit (prompts/engineering/repository-audit)
├── issue_35_updated.md  # add-copilot-instructions (prompts/meta/add-copilot-instructions)
├── issue_36_updated.md  # acceptance-criteria (prompts/product/acceptance-criteria)
├── issue_37_updated.md  # requirements-draft (prompts/product/requirements-draft)
├── issue_38_updated.md  # user-story (prompts/product/user-story)
├── issue_39_updated.md  # experiment-plan (prompts/research/experiment-plan)
├── issue_40_updated.md  # literature-review (prompts/research/literature-review)
├── issue_41_updated.md  # provider-research (prompts/research/provider-research)
├── issue_42_updated.md  # source-digest (prompts/research/source-digest)
├── issue_43_updated.md  # blog-outline (prompts/writing/blog-outline)
├── issue_44_updated.md  # executive-summary (prompts/writing/executive-summary)
└── issue_45_updated.md  # press-release (prompts/writing/press-release)
```

## Implementation Steps

### Manual Update Process
Since GitHub MCP functions are read-only, the issues need to be updated manually:

1. **For each issue (33-45)**:
   - Open the issue in GitHub
   - Copy the content from the corresponding `/tmp/updated_issues/issue_XX_updated.md` file
   - Replace the entire issue body with the new content
   - Save the issue

### Batch Update Script (Optional)
For automated updating using GitHub CLI or API:

```bash
# Using GitHub CLI (if available)
for i in {33..45}; do
  gh issue edit $i --body-file /tmp/updated_issues/issue_${i}_updated.md
done
```

## Validation

### Verify Referenced Files Exist
All referenced files have been verified to exist:
- ✅ `examples/issue-automation-system-usage.md`
- ✅ `prompts/meta/workflow-orchestrator/workflow-orchestrator.json`
- ✅ `prompts/meta/documentation-validator/documentation-validator.json`
- ✅ `prompts/meta/promptsmith/promptsmith.json`
- ✅ `docs/PROMPTS_OVERVIEW.md`
- ✅ `docs/usage-guide.md`

### Content Verification
Each updated issue contains:
- ✅ Proper prompt name and path for each issue
- ✅ References to established framework documentation
- ✅ Correct tool locations in `prompts/meta/`
- ✅ Python code examples with proper variable substitution
- ✅ Links to relevant documentation
- ✅ Preserved acceptance criteria and success metrics

## Benefits of Updated Issues

1. **Consistency**: All issues now reference the same established framework
2. **Accuracy**: Tool references point to correct current locations
3. **Efficiency**: Issues emphasize automation over manual processes
4. **Maintainability**: Single source of truth for methodology in framework documentation
5. **Current**: Issues reflect the current state of the repository's automation capabilities

## Next Steps

1. Apply the updated content to issues 33-45 using the generated files
2. Verify that updated issues display correctly in GitHub
3. Test the referenced automation framework with one of the issues
4. Close this implementation task

## Quality Assurance

- **No Repository Changes**: This update only affects issue descriptions, not repository files
- **Minimal Changes**: Only the workflow sections were replaced; acceptance criteria and file lists were preserved
- **Accurate References**: All links point to existing files and documentation
- **Framework Compliant**: Updated content follows the established repository patterns