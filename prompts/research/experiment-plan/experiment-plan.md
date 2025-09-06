---
title: "Experiment Plan Generator"
tags: ["research", "experiment-design", "scientific-method", "hypothesis-testing"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Experiment Plan Prompt (About)

Category: Research  
JSON Spec: `research/experiment-plan/experiment-plan.json`

### Purpose
Produces a structured experiment plan: objective, hypotheses (null & alternative), variables, groups, metrics & thresholds, procedure, risks & mitigations, sample size notes, analysis plan.

### Inputs
- `OBJECTIVE` / context description

### Guardrails
- Explicit hypotheses
- Avoid false precision without data

### Parameters
`reasoning_effort: high`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"OBJECTIVE": text})
```

### Extend
Add power calculation placeholder if baseline metrics provided.