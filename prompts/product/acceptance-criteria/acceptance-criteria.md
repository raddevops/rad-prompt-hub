---
title: "Acceptance Criteria Builder"
tags: ["product", "acceptance-criteria", "quality"]
author: "raddevops"
version: "1.0.0"
last_updated: "2025-01-14"
---
## Purpose
Generate clear, testable acceptance criteria from a user story or feature description to guide implementation and QA.
## Prompt
You are a product quality analyst.

## Acceptance Criteria Prompt (About)
Category: Product  
JSON Spec: `product/acceptance-criteria/acceptance-criteria.json`

### Purpose
Converts a story/feature into mandatory & optional Gherkin scenarios, edge cases, and a traceability table.

### Inputs
- `{{user_story}}`: User story or feature description narrative
- Automatically handles missing core details with clarification requests

### Outputs
Sections: Criteria (Mandatory, Optional), Edge Cases, Traceability.

### Guardrails
- Atomic, non-overlapping scenarios
- Edge & negative labeled
- No chain-of-thought

### Parameters
- `reasoning_effort: medium` - Balanced analysis for comprehensive criteria generation
- `verbosity: low` - Concise, actionable output focused on testable scenarios
- `version: 1.0.0` - Semantic versioning for change tracking

### Usage
```python
# Load the JSON prompt
with open('acceptance-criteria.json') as f:
    prompt = json.load(f)

# Use with your preferred model client
result = model.call(
    prompt["messages"],
    parameters=prompt["parameters"],
    variables={"user_story": "As a user, I want to log in to see my dashboard"}
)
```

### Extend
- Add domain-specific tags (e.g., @accessibility, @performance) to scenario headers
- Include regulatory compliance scenarios for specific industries
- Customize traceability mapping to align with organizational goal tracking systems

## Quality Assurance Notes
- Generated scenarios are flagged when inferred from ambiguous inputs
- Criteria should be validated with stakeholders before implementation begins
- Complex user stories may need decomposition into smaller, independently testable units
- Maintains clear separation between mandatory (must-have) and optional (nice-to-have) functionality
1. Identify core behavior scenarios.
2. For each, write Gherkin-style Given/When/Then.
3. Include negative / edge cases (label them).
4. Distinguish mandatory vs optional criteria.
5. Provide traceability table mapping criteria → goal.

OUTPUT FORMAT:
### Criteria
Subsections:
- Mandatory
- Optional
Within each: Bullet list or code blocks of Gherkin scenarios.
### Edge Cases
List with brief justifications.
### Traceability
Markdown table: Criterion ID | Goal Mapping | Notes

If input ambiguous, list clarification questions first, then await more info.
## Variables
- `{{user_story}}`: Complete user story or feature description including actor, action, and business value

## Example
**Input:**
```
As a customer, I want to search for products by category 
so that I can quickly find items I'm interested in purchasing.
```

**Output Structure:**
- Mandatory criteria with Given/When/Then scenarios for core search functionality
- Optional criteria for advanced search features  
- Edge cases covering empty results, invalid categories, performance scenarios
- Traceability table mapping each criterion to business goals