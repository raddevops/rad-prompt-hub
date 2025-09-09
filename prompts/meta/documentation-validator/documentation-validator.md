---
title: "Documentation Validator"
version: "1.0.0"
tags: ["meta", "validation", "documentation", "quality-assurance", "consistency"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Documentation Validator Prompt (About)

**Category:** Meta  
**JSON Spec:** `meta/documentation-validator/documentation-validator.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Validates consistency between JSON prompt specifications and their corresponding markdown documentation in the repository's 3-file structure. Generates detailed validation reports with specific remediation steps to ensure production-ready documentation quality and JSON ↔ markdown alignment.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `PROMPT_FOLDER_PATH` | String | ✅ Yes | Absolute path to prompt folder being validated | `"prompts/engineering/code-review/"` |
| `JSON_CONTENT` | String | ✅ Yes | Complete JSON prompt specification content | Raw JSON with all required fields |
| `MARKDOWN_CONTENT` | String | ✅ Yes | Complete markdown documentation content | Full markdown with frontmatter and sections |
| `VALIDATION_FOCUS` | String | Optional | Specific validation areas to emphasize | `"parameter_documentation"`, `"placeholder_accuracy"` |
| `QUALITY_STANDARDS` | String | Optional | Organizational quality requirements | `"enterprise_ready"`, `"beginner_friendly"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"high"` | High reasoning effort required for JSON vs markdown consistency analysis, placeholder validation, parameter alignment, and capability verification requiring deep structural analysis |
| `verbosity` | `"medium"` | Medium verbosity needed for detailed validation reports with specific findings, gaps, and actionable remediation guidance while maintaining report clarity and usability |

### Key Validation Areas

**JSON Analysis:**
- Parameter extraction and validation
- Placeholder identification and usage patterns  
- Message structure and content analysis
- Assumptions and risk assessment completeness
- Schema compliance verification

**Markdown Analysis:**
- Documentation completeness assessment
- DRY principles adherence (no executable duplication)
- Parameter and placeholder explanation quality
- Usage examples accuracy and clarity
- Extensibility and customization guidance

**Consistency Verification:**
- Parameter values match documentation
- All placeholders properly documented
- Capability claims alignment
- Version consistency and changelog presence
- Example accuracy and practical applicability

### Output Structure

The validator generates structured reports in this format:

```markdown
## Executive Summary
Overall consistency rating and critical findings

## JSON Analysis  
Structure validation and capability extraction

## Markdown Analysis
Documentation completeness assessment

## Consistency Matrix
Detailed alignment verification table

## Gap Analysis
Missing or misaligned elements with severity

## Remediation Plan
Specific actionable improvements with priorities

## Quality Score
Quantitative assessment (0-100) with breakdown
```

### Usage Examples

#### Basic Validation
```python
result = model.call(validator_json, variables={
    "PROMPT_FOLDER_PATH": "prompts/engineering/code-review/",
    "JSON_CONTENT": json_file_content,
    "MARKDOWN_CONTENT": markdown_file_content
})
```

#### Focused Analysis
```python  
result = model.call(validator_json, variables={
    "PROMPT_FOLDER_PATH": "prompts/writing/blog-outline/",
    "JSON_CONTENT": json_content,
    "MARKDOWN_CONTENT": md_content,
    "VALIDATION_FOCUS": "parameter_documentation,placeholder_accuracy"
})
```

#### Enterprise Standards
```python
result = model.call(validator_json, variables={
    "PROMPT_FOLDER_PATH": "prompts/research/literature-review/",
    "JSON_CONTENT": json_content,
    "MARKDOWN_CONTENT": md_content,
    "QUALITY_STANDARDS": "enterprise_ready,comprehensive_examples"
})
```

### Assumptions & Limitations

**Validation Scope:**
1. **3-File Structure**: Prompts follow repository's JSON + MD + test.sh pattern
2. **Schema Compliance**: JSON adheres to established prompt schema specification
3. **DRY Principles**: Markdown follows documentation-only approach without executable duplication
4. **Production Focus**: Analysis targets enterprise deployment readiness
5. **Structural Analysis**: Focuses on consistency rather than functional prompt testing
6. **Quality Standards**: Applies repository-established documentation patterns

**Limitations:**
- Subjective quality assessments may vary by audience and use case
- Functional prompt effectiveness requires separate testing beyond validation
- Large complex prompts may need focused validation sessions for manageable analysis
- Automated validation complements but doesn't replace human review for nuanced quality

### Risk Considerations

**Validation Process Risks:**
- **Scope Management**: Complex prompts may overwhelm single validation session requiring iterative analysis
- **Subjective Assessment**: Documentation clarity ratings depend on intended audience context and expertise levels
- **Incomplete Input**: Missing or partial files result in limited validation requiring additional analysis cycles
- **Context Dependency**: Version validation requires organizational versioning practices and historical context understanding
- **Quality Variance**: Automated assessments should supplement human review for complete quality assurance

### Integration Examples

**CI/CD Validation:**
```bash
# Automated documentation consistency checking
python tools/validate_docs.py --folder prompts/engineering/code-review/
```

**Batch Validation:**
```bash
# Validate all prompts in category
for folder in prompts/writing/*/; do
    echo "Validating $folder"
    # Run validation logic
done
```

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ✅ Preserves existing validation patterns  
**Test Coverage:** ✅ Full validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/meta/documentation-validator/documentation-validator.json
```

Test with sample prompt folders to verify validation accuracy and report quality.

---

**Note:** This markdown documents usage. The executable prompt logic resides in `documentation-validator.json`.