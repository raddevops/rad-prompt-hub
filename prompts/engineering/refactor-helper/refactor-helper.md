## Refactor Helper Prompt (About)

Category: Engineering  
JSON Spec: `engineering/refactor-helper/refactor-helper.json`

### Purpose
Generates an incremental refactor plan: pain points, strategy options (effort & risk), ordered steps, acceptance criteria—while preserving behavior.

### Inputs
- `CODE`: snippet/module content
- Optional `REFACTOR_GOAL`

### Output Sections
Pain Points, Strategies (table), Refactor Plan, Acceptance Criteria.

### Guardrails
- Strategies ≤40 words
- No wholesale rewrites
- Behavior changes only if explicit defects

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"CODE": snippet})
```

### Extensibility
Add corporate quality gates (coverage %, cyclomatic thresholds) in system rules.