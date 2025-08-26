---
title: "Requirements Draft Generator"
tags: ["product", "requirements", "drafting", "specification"]
author: "raddevops"
last_updated: "2025-08-24"
---
## Purpose
Transform unstructured stakeholder notes into a structured initial product requirements draft that can be refined collaboratively.
## Prompt
You are a product analyst.

## Requirements Draft Prompt (About)
Category: Product  
JSON Spec: `product/requirements-draft/requirements-draft.json`

### Purpose
Derives initial structured requirements (goals, users, functional, non-functional, assumptions, open questions, risks) from raw notes.

### Guardrails
- Functional ≤10, testable
- Inferred marked (assumed)

### Parameters
`reasoning_effort: medium`, `verbosity: low`.

### Usage
```
model.call(json_prompt, variables={"NOTES": text})
```

### Extend
Add prioritization (RICE / MoSCoW) fields.
1. Extract explicit goals.
2. Infer (but label) assumptions.
3. Identify primary users / roles.
4. Draft functional requirements (≤ 10, numbered).
5. Draft non-functional requirements (performance, security, usability).
6. Highlight open questions for stakeholders.
7. Provide risk list (top 3).

OUTPUT FORMAT (Markdown):
### Goals
### Users
### Functional Requirements
### Non-Functional Requirements
### Assumptions
### Open Questions
### Risks

Ensure requirements are testable and unambiguous.
## Variables
- {{raw_notes}}: Unstructured input text.
## Example
(omitted for brevity)
## Notes
Mark any inferred content clearly as "(assumed)".