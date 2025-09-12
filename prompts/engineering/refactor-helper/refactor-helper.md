---
title: "Refactor Helper Assistant"
tags: ["engineering", "refactoring", "code-quality", "incremental-improvement"]
author: "raddevops"
version: "1.0.0"
last_updated: "2025-09-06"
---

## Refactor Helper Prompt (About)

**Category:** Engineering  
**JSON Spec:** `engineering/refactor-helper/refactor-helper.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Generates incremental refactor plans with pain points, strategy options (effort & risk), ordered steps, and acceptance criteria while preserving behavior. Designed for senior developers requiring surgical improvement guidance without large rewrites.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `CODE` | String | ✅ Yes | Code snippet, module, or function content to analyze for refactoring opportunities | Python function, JavaScript class, SQL query |
| `REFACTOR_GOAL` | String | Optional | Specific refactoring objective. Defaults to "general improvement" | `"improve performance"`, `"enhance readability"`, `"reduce complexity"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|-------|-----------|
| `reasoning_effort` | `"medium"` | Balances thoroughness with efficiency for typical refactoring analysis requiring code comprehension and strategic planning |
| `verbosity` | `"low"` | Provides concise, actionable output suitable for senior developers who prefer implementation-focused guidance |

### Output Structure
- **Pain Points**: Identified code quality issues and technical debt
- **Strategies**: Table format with effort tags (LOW/MED/HIGH) and risk assessment per strategy
- **Refactor Plan**: Ordered implementation steps with phase-based approach  
- **Acceptance Criteria**: Validation requirements to ensure behavior preservation

### Guardrails & Constraints
- Strategy descriptions limited to ≤40 words for conciseness
- No wholesale rewrites; focus on surgical improvements
- Behavior changes only permitted if explicit defects are identified
- Returns "Minimal refactor value." when no meaningful improvements possible

### Usage Examples

**Basic Refactoring:**
```python
# Call with code snippet
result = model.call(prompt, variables={
    "CODE": "def calc(x, y): return x + y if x > 0 else y"
})
```

**Targeted Refactoring:**
```python
# Call with specific goal
result = model.call(prompt, variables={
    "CODE": "complex_function_code_here",
    "REFACTOR_GOAL": "improve performance"
})
```

### Assumptions

1. **Code Validity**: Code provided is syntactically valid and represents complete, functional logic
2. **Behavior Preservation**: Refactoring must preserve externally observable behavior unless explicit defects are identified  
3. **Context Availability**: User has sufficient context of broader codebase architecture and constraints
4. **Static Analysis**: Static analysis is adequate without requiring runtime profiling or dynamic testing
5. **Audience Expertise**: Senior developer audience can implement suggested refactoring steps without detailed guidance

### Risk Considerations

- **Hidden Side-Effects**: May not be visible without runtime context or dynamic analysis
- **Limited Context**: Static analysis may miss broader architectural implications
- **Dependency Impact**: Changes may affect external code dependencies not visible in provided snippet

### Integration Examples

**CI/CD Pipeline Integration:**
```yaml
- name: Automated Refactor Analysis  
  run: |
    refactor_suggestions=$(call_prompt refactor-helper.json --code "$changed_files")
    echo "$refactor_suggestions" >> refactor_recommendations.md
```

**IDE Plugin Usage:**
```typescript
// VSCode extension integration
const suggestions = await promptAPI.call('refactor-helper', {
  CODE: selectedCode,
  REFACTOR_GOAL: userInput || 'general improvement'
});
```

### Extensibility

**Corporate Quality Gates:**
Add organization-specific thresholds to system rules:
- Code coverage percentage requirements
- Cyclomatic complexity limits  
- Security scanning integration
- Performance benchmark validation

**Custom Output Formats:**
Extend output contract for integration with:
- Issue tracking systems (Jira, GitHub Issues)
- Documentation generators
- Code review tools

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ✅ Maintains existing functionality  
**Test Coverage:** ✅ Full validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/engineering/refactor-helper/refactor-helper.json
```

Execute functionality tests:
```bash
cd prompts/engineering/refactor-helper && bash test.sh
```