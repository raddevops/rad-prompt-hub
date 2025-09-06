---
title: "Blog Outline Generator"
tags: ["writing", "blog", "content-strategy", "seo", "outline"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Blog Outline Prompt (About)

Category: Writing  
JSON Spec: `writing/blog-outline/blog-outline.json`

### Purpose
Generates title options, audience & angle clarification, hierarchical outline with section intent, CTA ideas, SEO keyword sets (primary vs long-tail).

### Inputs
- `TOPIC` (required)
- Optional `AUDIENCE`

### Outputs
Title Options, Audience & Angle, Outline (Markdown), CTA Ideas, SEO Keywords.

### Guardrails
- Assumptions labeled
- No filler

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"TOPIC": text})
```

### Extend
Add competitor differentiation bullets or funnel stage mapping.