## Executive Summary Prompt (About)

Category: Writing  
JSON Spec: `writing/executive-summary/executive-summary.json`

### Purpose
Condenses source content into Objective, Key Findings, Decisions, Risks & Mitigations, Next Steps, Word Count (≤250 words default).

### Inputs
- `SOURCE_TEXT`

### Guardrails
- Flag absence of quantitative data
- No hidden chain-of-thought

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"SOURCE_TEXT": text})
```

### Extend
Add KPI delta table if metrics supplied.