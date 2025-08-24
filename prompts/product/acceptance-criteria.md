---
title: "Acceptance Criteria Builder"
tags: ["product", "acceptance-criteria", "quality"]
author: "raddevops"
last_updated: "2025-08-24"
---
## Purpose
Generate clear, testable acceptance criteria from a user story or feature description to guide implementation and QA.
## Prompt
You are a product quality analyst.

TASK:
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
- {{user_story}}: Canonical user story text OR feature description.
## Notes
Scenarios should avoid overlapping triggers; each should test a single path.