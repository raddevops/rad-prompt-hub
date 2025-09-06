## Code Review Prompt (About)

Category: Engineering  
JSON Spec: `engineering/code-review/code-review.json`

### Purpose
Generates a structured peer code review (Summary, Strengths, Issues, Recommendations, Risk Assessment, Suggested Tests) from a provided diff or code snippet.

### Inputs
- `DIFF` or code excerpt (required)
- Optional context: architectural notes, risk focus

### Key Guardrails (from JSON)
- Only analyze visible code
- No speculative architecture rewrites
- Actionable, concise findings
- No chain-of-thought output

### Parameters
`reasoning_effort: medium`, `verbosity: low` (raise effort for complex concurrency / security reviews).

### Usage
```
model.call(json_prompt, variables={"DIFF": diff_text})
```

### Extensibility
Add organization-specific conventions (naming, logging) by appending bullets in the JSON system message.

### Notes
This markdown is descriptive only; executable logic lives in the JSON prompt.