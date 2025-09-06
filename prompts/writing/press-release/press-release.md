---
title: "Press Release Generator"
tags: ["writing", "pr", "press-release", "marketing", "communications"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Press Release Prompt (About)

Category: Writing  
JSON Spec: `writing/press-release/press-release.json`

### Purpose
Produces headline, subheadline, structured release body, quotes (with placeholders if none), boilerplate, media contact, optional CTA.

### Inputs
- `PRODUCT_DETAILS`, `COMPANY_NAME`, optional `CONTACT_INFO`, `RELEASE_DATE`

### Guardrails
- Headline ≤12 words
- Opening ≤80 words (5W coverage)
- Placeholder quotes clearly marked

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"PRODUCT_DETAILS": text})
```

### Extend
Add regulatory disclaimer or embargo note section.