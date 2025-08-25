## Provider Research Prompt (About)

Category: Research  
JSON Spec: `prompts_json/research/provider-research.json`

### Purpose
Evaluates local providers for a specified product/service; outputs shortlist, high-risk list, detailed profiles, methodology + dataset JSON for decision support.

### Key Scoring Elements
- RCAS (review composite) 0–100 (sentiment-weighted across sources)
- UER (underserved experience rate)
- Suitability weighted criteria (domain expertise, communication, longevity, price posture, etc.)

### Inputs
- `PRODUCT_OR_SERVICE`, `LOCATION`
- Optional radius & credential requirements

### Guardrails
- Every non-obvious claim cited (URL + retrieval date)
- Quotes ≤25 words
- High-Risk requires ≥2 independent signals

### Parameters
`reasoning_effort: high`, `verbosity: medium`.

### Usage
```
model.call(json_prompt, variables={"PRODUCT_OR_SERVICE": "...", "LOCATION": "..."})
```

### Extend
Adjust suitability weights or add compliance criterion (e.g., licensing) in system rules.
