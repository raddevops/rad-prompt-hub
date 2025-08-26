## Git Workflow Prompt (About)

Category: Engineering  
JSON Spec: `engineering/git-workflow/git-workflow.json`

### Purpose
Produces an evidence-based Git branching & collaboration model (branch roles, protections, commit/PR policy, automation, risks) derived from team context.

### Inputs
- `TEAM_CONTEXT`: team size, release cadence, CI maturity, pain points

### Output Sections
Context Summary, Recommended Model (≤120 words), Branch Types, Commit Convention, PR Policy, Automation, Risks.

### Guardrails
- Justify trade-offs without dogma
- Concise actionable guidance
- No chain-of-thought

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"TEAM_CONTEXT": text})
```

### Extensibility
Add semantic versioning or monorepo strategy notes by editing system message.