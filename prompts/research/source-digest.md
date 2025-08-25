## Source Digest Prompt (About)

Category: Research  
JSON Spec: `prompts_json/research/source-digest.json`

### Purpose
Extracts structured claims & evidence from a source set, then synthesizes convergence, conflicts, gaps, and next research steps.

### Inputs
- `SOURCE_LIST`: list or delimited text

### Output Sections
Sources (table), Convergence, Conflicts, Gaps, Next Research Steps.

### Guardrails
- Confidence LOW/MED/HIGH with justification
- No fabricated evidence
- Unclear sources labeled explicitly

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"SOURCE_LIST": sources})
```

### Extend
Add evidence robustness weights or citation formatting rules.