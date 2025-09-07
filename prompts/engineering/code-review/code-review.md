---
title: "Senior Software Engineer - Code Reviewer"
version: "1.0.1"
tags: ["engineering", "code-review", "peer-review", "quality-assurance", "structured-analysis"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Code Review Prompt (About)

**Category:** Engineering  
**JSON Spec:** `engineering/code-review/code-review.json`  
**Version:** 1.0.1  
**Target Model:** gpt-5-thinking  

### Purpose
A senior software engineer performing structured, comprehensive code reviews with systematic analysis methodology. Generates structured peer code reviews with six standardized sections: Summary, Strengths, Issues, Recommendations, Risk Assessment, and Suggested Tests.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `DIFF` | String | ✅ Yes | The code diff, code snippet, or pull request changes to be reviewed. Should include sufficient context lines for meaningful analysis. | `git diff HEAD~1`, code blocks, formatted change descriptions, PR diffs with context |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"medium"` | Balanced analysis for typical code changes, sufficient for assessing correctness, clarity, and maintainability without over-analysis that could delay review cycles |
| `verbosity` | `"low"` | Concise, actionable feedback optimized for peer review consumption, focusing on essential insights without verbose explanations that reduce review efficiency |

### Key Guardrails & Rules
- **Scope Limitation**: Only analyze provided diff/code - no assumptions about unseen context
- **No Speculation**: Avoid speculative architecture changes beyond visible code
- **Actionable Focus**: Be specific and concise; avoid redundancy and fluff
- **Structured Output**: Always provide all six required sections
- **Professional Tone**: Senior engineering peer level - concise, neutral, improvement-focused

### Assumptions & Limitations

The prompt operates under these key assumptions:
1. **Limited Scope**: Analysis is restricted to provided diff without broader system context or architecture
2. **Pattern-Based Assessment**: Risk evaluation based on visible code patterns, may miss system-level issues
3. **Standard Practices**: Assumes familiarity with standard software engineering practices for target language
4. **Complete Diffs**: Review effectiveness depends on completeness and clarity of provided changes
5. **Implementation Capability**: Developer can implement suggestions without additional guidance
6. **Context Dependency**: Testing recommendations require additional context for comprehensive coverage

### Output Structure

The prompt generates reviews in this exact format:

```markdown
## Summary
Brief overview of the changes reviewed

## Strengths
What the code does well

## Issues Found
Clear list of problems, categorized by severity (LOW/MODERATE/HIGH)

## Recommendations
Specific suggestions for improvement

## Risk Assessment
Potential risks or concerns with severity rating

## Suggested Tests
Recommendations for additional testing
```

### Usage Examples

#### Basic Usage
```python
# Simple diff review
result = model.call(json_prompt, variables={
    "DIFF": """
@@ -15,7 +15,12 @@
 def calculate_total(items):
-    return sum(item.price for item in items)
+    total = 0
+    for item in items:
+        if item.price > 0:
+            total += item.price
+    return total
"""
})
```

#### Pull Request Review
```python
# PR changes review
result = model.call(json_prompt, variables={
    "DIFF": pr_diff_content  # Full PR diff with file context
})
```

### Risk Considerations

**Analysis Constraints:**
- **Scope**: Limited to provided diff, lacks full system context for architectural assessment
- **Performance**: Cannot assess system-wide performance implications beyond visible patterns
- **Security**: Restricted to observable vulnerabilities without comprehensive threat modeling
- **Dependencies**: Review quality depends on diff completeness - may miss integration issues
- **Validation**: Recommendations may require additional validation against broader system requirements

### Extensibility & Customization

**Language-Specific Conventions:**
```json
// Add to system message for organizational standards
"- Follow [ORG] naming conventions for variables and functions"
"- Ensure all database queries use parameterized statements"
"- Include logging for all external API calls"
```

**Severity Customization:**
Adjust reasoning_effort to `"high"` for:
- Security-critical code reviews
- Performance-sensitive algorithms  
- Complex concurrency patterns
- Mission-critical system components

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ✅ Preserves existing functionality and output format  

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/engineering/code-review/code-review.json
```

Test with sample diffs to verify output structure and quality.

### Implementation Notes

- **Conversation Format**: Uses system/user message structure for optimal model interaction
- **Token Optimization**: JSON is minified for efficient LLM processing
- **Context Preservation**: Maintains adequate context lines in diff analysis
- **Error Handling**: Includes eagerness controls for missing diff scenarios

---

**Note:** This markdown provides comprehensive documentation. The executable prompt logic resides in `code-review.json`.