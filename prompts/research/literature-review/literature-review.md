---
title: "Literature Review Synthesizer"
tags: ["research", "literature-review", "academic", "synthesis"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Literature Review Prompt (About)

Category: Research  
JSON Spec: `research/literature-review/literature-review.json`

### Purpose
Synthesizes sources into themes, summaries, source table (method, findings, limitations), methodological critique, gaps, and suggested research questions.

### Inputs
- `SOURCES`: excerpts / structured list

### Guardrails
- No fabricated statistics
- Theme summaries ≤120 words

### Parameters
`reasoning_effort: high`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"SOURCES": text_or_list})
```

### Extend
Add citation formatting (APA/MLA) requirement in system rules.