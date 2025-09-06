# Documentation Validator

A comprehensive prompt for validating consistency between JSON prompt files and their accompanying markdown documentation.

## Purpose

This prompt acts as a Technical Documentation Auditor that ensures prompt engineering documentation is accurate, consistent, and complete. It validates that JSON implementations match their markdown documentation across all critical dimensions.

## Key Features

- **Consistency Validation**: Compares JSON prompt content with markdown documentation
- **Parameter Verification**: Validates all parameters are documented correctly
- **Schema Compliance**: Checks JSON structure and required fields
- **Role Alignment**: Ensures system messages match documented purposes
- **Placeholder Documentation**: Verifies all {{PLACEHOLDERS}} are explained
- **Quality Assessment**: Evaluates documentation clarity and completeness
- **Actionable Feedback**: Provides prioritized improvement recommendations

## Parameters

- **target_model**: `gpt-5-thinking` - Uses reasoning capabilities for thorough analysis
- **reasoning_effort**: `high` - Comprehensive validation requires deep analysis
- **verbosity**: `medium` - Detailed reports without overwhelming output

## Required Inputs

- `{{PROMPT_DIRECTORY}}`: Path to the prompt directory being validated
- `{{JSON_CONTENT}}`: Contents of the .json prompt file
- `{{MD_CONTENT}}`: Contents of the .md documentation file

## Optional Inputs

- `{{TEST_CONTENT}}`: Contents of the test.sh file for additional validation
- `{{VALIDATION_FOCUS}}`: Focus area (all|consistency|parameters|completeness|examples)
- `{{IMPROVEMENT_PRIORITY}}`: Priority level for recommendations (high|medium|low)

## Output Format

Structured markdown report with:

1. **Executive Summary** - Overall consistency score and key findings
2. **Consistency Analysis** - JSON vs markdown alignment details
3. **Parameter Validation** - Tabular comparison of all parameters
4. **Documentation Quality Assessment** - Clarity, accuracy, completeness evaluation
5. **Schema & Structure Validation** - Compliance with prompt standards
6. **Improvement Recommendations** - Prioritized action items (P0/P1/P2)
7. **Action Items** - Specific, measurable tasks with checkboxes
8. **Validation Summary** - Analysis scope and next steps

## Use Cases

- **Pre-release Quality Assurance**: Validate documentation before publishing
- **Batch Documentation Audit**: Review multiple prompts for consistency
- **Maintenance Reviews**: Ensure documentation stays current with JSON changes
- **Standards Compliance**: Verify adherence to prompt documentation standards
- **Onboarding Validation**: Ensure new prompts meet documentation quality bar

## Example Usage

```bash
# Validate a single prompt's documentation
./documentation-validator.json \\
  --prompt-directory "prompts/research/literature-review" \\
  --json-content "$(cat prompts/research/literature-review/literature-review.json)" \\
  --md-content "$(cat prompts/research/literature-review/literature-review.md)"
```

## Quality Assurance

- **Read-only Operations**: No destructive changes to existing files
- **Evidence-based Analysis**: Only reports on actual file contents
- **Measurable Feedback**: Quantified gaps and specific improvement areas
- **Structured Output**: Consistent reporting format for all validations

## Assumptions

- Prompts follow 3-file structure (.md, .json, test.sh)
- JSON files should be schema-compliant
- Documentation should be self-contained and user-ready
- Parameters should include types, defaults, and clear descriptions

## Limitations

- Analysis quality depends on provided file contents
- Complex domain-specific prompts may need expert review
- Template variations may require manual validation
- Some documentation approaches may have legitimate variations
