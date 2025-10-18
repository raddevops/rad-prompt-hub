---
title: "Authentic South-Louisiana Cajun Recipe Researcher"
tags: ["research", "recipe", "cajun", "cooking", "authenticity"]
author: "raddevops"
last_updated: "2025-10-14"
---

## Cajun Authentic Researcher Prompt (About)

Category: Research  
JSON Spec: `research/cajun-authentic-researcher/cajun-authentic-researcher.json`

### Purpose
Generates authentic Cajun recipes with deep research into Acadiana (South Louisiana) cooking traditions, focusing on New Iberia, Avery Island, and Lafayette parish practices. Produces technique-driven recipes with canonical source citations, parish variations, and anti-inflammatory/minceur modifications while maintaining authenticity.

### Inputs
- `{{YOUR_CAJUN_DISH_OR_QUESTION}}` (required): The Cajun dish name or cooking question
- Optional knobs:
  - `HEAT`: Heat level 1–5 (default: 4–5)
  - `CELERY_OK`: Include celery in trinity (yes|no, default: no)
  - `PARISH_TILT`: Focus on specific parish style (New Iberia|Avery Island|Lafayette|blend, default: blend)
  - `FAT`: Fat type (oil|lard|bacon fat, default: oil)
  - `OIL`: Specific oil (EVOO|avocado|high-oleic sunflower|high-oleic safflower, default: EVOO)
  - `SMOKE`: Smoke level (off|low|medium|high, default: medium-high)
  - `WOOD`: Wood type (pecan|oak|hickory|fruitwood, default: pecan)

### Outputs
1. **Research Summary**: Canonical source citations with New Iberia/Avery Island/Lafayette notes
2. **Technique Notes**: Roux specifications, trinity ratios, oil rationale, smoke plan, timing
3. **Recipe (serves 4–6)**: Ingredients in grams + cups, timestamped steps, heat level built in
4. **Parish Variations**: Regional differences in preparation and ingredients
5. **Make-Ahead & Reheat**: Day-2 improvements, reheating guidance, rice handling
6. **Quiet Salt Line**: Non-salt flavor techniques used

### Guardrails
- Authenticity enforced through primary Acadiana sources
- Default celery-free trinity with parsley stems and fennel
- Anti-inflammatory oils preferred over animal fats (unless essential for authenticity)
- Smoke used by default to build depth
- Salt present but not leading; flavor from technique (roux, fond, smoke, acid/herbs)
- Food safety temperatures and storage guidance included

### Parameters
`reasoning_effort: high`, `temperature: 0.2`, `top_p: 0.3`, `verbosity: low`

High reasoning effort ensures thorough research of canonical sources and proper technique explanation.

### Canonical Sources Referenced
- Marcelle Bienvenu — *Who's Your Mama, Are You Catholic, and Can You Make a Roux?*
- John D. Folse — *The Encyclopedia of Cajun & Creole Cuisine*
- Eula Mae Dore (Avery Island) — *Eula Mae's Cajun Kitchen*
- Donald Link — *Real Cajun*
- Isaac Toups — *Chasing the Gator*
- Southern Foodways Alliance oral histories
- UL Lafayette / LSU Cajun–Creole archives

### Usage Example
```python
# Direct JSON integration
import json
with open('prompts/research/cajun-authentic-researcher/cajun-authentic-researcher.json') as f:
    prompt_spec = json.load(f)

# Basic usage with defaults
model.call(prompt_spec, variables={
    "YOUR_CAJUN_DISH_OR_QUESTION": "gumbo"
})

# Advanced usage with custom knobs
request = """## Request
chicken and sausage gumbo

## Knobs (optional)
HEAT=5
PARISH_TILT=Lafayette
SMOKE=high
WOOD=pecan
"""
model.call(prompt_spec, variables={"YOUR_CAJUN_DISH_OR_QUESTION": request})
```

### Key Features
- **Parish-Specific Voice**: Authentic regional variations from New Iberia, Avery Island, and Lafayette
- **Celery-Free Option**: Default trinity uses parsley stems and fennel instead of celery
- **Anti-Inflammatory Focus**: Prefers healthy oils; builds flavor through technique not salt
- **Smoke Integration**: Default smoke usage with wood selection guidance
- **Source Citations**: All techniques traced to canonical Cajun cooking authorities
- **Flavor Architecture**: Roux mastery, fond development, smoke craft, acid/herb finishes

### Extend
- Add specific dietary restrictions (gluten-free, dairy-free, etc.)
- Include nutrition information
- Add ingredient substitution guides
- Include wine/beverage pairing suggestions
- Add meal prep batch cooking guidance

### Benefits
- Authentic Cajun recipes with verifiable sources
- Healthier cooking methods while maintaining tradition
- Parish-specific variations for deeper authenticity
- Technique education for skill development
- Food safety guidance built in
