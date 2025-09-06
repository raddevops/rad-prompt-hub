---
title: "PromptSmith Meta Generator"
tags: ["writing", "meta", "prompt-engineering", "ai", "automation"]
author: "raddevops"
last_updated: "2025-09-06"
---

## PromptSmith Meta Prompt (About)

Category: Meta  
JSON Spec: `writing/promptsmith/promptsmith.json`

### Purpose
Creates production-grade prompt artifacts. Either emits gating QUESTIONS YAML (when critical info missing) or final prompt JSON (system + user messages, parameters, assumptions, risks).

### Workflow Summary
Triage → Focused Questions → Design → Parameter Recommendation → Self-Check & Emit.

### Key Guardrails
- No chain-of-thought revealed
- Placeholders `{{LIKE_THIS}}` (defaults via `:=`)
- Contradiction & vagueness audit before emit

### Parameters
`reasoning_effort: high`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"REQUEST": "Need a prompt for ..."})
```

### Extend
Add org safety, compliance, or tool invocation policies within system rules.