---
title: "Kata Briefsmith - Architectural Kata Brief Generator"
version: "1.0.0"
tags: ["software-architecture", "kata", "briefing", "interview", "requirements"]
author: "raddevops"
last_updated: "2025-09-19"
---

## Kata Briefsmith Prompt (About)

**Category:** Software Architecture  
**JSON Spec:** `software-architecture/kata-briefsmith/kata-briefsmith.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Interactive interview system for creating structured Architectural Kata briefs. Normalizes messy inputs or conducts user interviews to produce concise kata briefs with companion artifacts including quality attribute scenarios, open questions, and quality reports.

For background on architectural katas methodology, see [docs/architectural-katas-ai-guide.md](../../../docs/architectural-katas-ai-guide.md).

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `MODE` | String | ❓ Optional | Execution mode for brief creation | `"interview"` (default), `"silent"` |
| `RAW_INPUT` | String | ❓ Optional | Unstructured notes or requirements to normalize | Paste notes, requirements, or leave blank for interview mode |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | "medium" | Medium reasoning effort appropriate for requirements gathering and brief creation, balancing thorough analysis with efficient processing |
| `verbosity` | "low" | Low verbosity ensures concise, actionable brief outputs optimized for kata execution without verbose explanations |

### Operation Modes

#### Interview Mode (Default)
- **Activation**: Set `MODE=interview` or leave blank
- **Process**: Conducts structured interview with ≤8 focused questions
- **Use Case**: When starting from scratch or with minimal requirements
- **Output**: Complete brief based on user responses

#### Silent Mode  
- **Activation**: Set `MODE=silent`
- **Process**: Normalizes provided `RAW_INPUT` without questions
- **Use Case**: When you have existing notes or requirements to structure
- **Output**: Structured brief derived from input text

### Output Structure

**Single JSON Object** containing:
- `kata_brief.json`: Minified brief ready for kata-runner consumption
- `kata_brief.md`: Human-readable brief documentation  
- `open_questions.md`: Unresolved questions requiring clarification
- `seed_qas.json`: Initial quality attribute scenarios
- `quality_report`: Validation status and brief completeness assessment

### Usage Examples

#### Interactive Briefing Session
```python
result = model.call(kata_briefsmith_json, variables={
    "MODE": "interview",
    "RAW_INPUT": ""  # Optional: paste any existing notes
})
```

#### Silent Normalization
```python
result = model.call(kata_briefsmith_json, variables={
    "MODE": "silent", 
    "RAW_INPUT": "Build a payment system that handles 1000 TPS..."
})
```

#### Hybrid Approach
```python
result = model.call(kata_briefsmith_json, variables={
    "MODE": "interview",
    "RAW_INPUT": "Some initial requirements or context..."
})
```

### Key Features
- **Structured Output**: Generates kata brief JSON matching runner schema
- **Quality Gating**: Built-in validation and completeness reporting
- **Flexible Input**: Handles both interactive and batch processing
- **Companion Artifacts**: Creates supporting documentation and QAS seeds

### Assumptions & Limitations

**Assumptions:**
1. **Time Constraints**: Interview sessions are bounded to essential questions only
2. **Domain Knowledge**: User can provide business context and constraints when prompted
3. **Standard Patterns**: Assumes typical enterprise/web application patterns unless specified
4. **Brief Scope**: Focuses on architectural decisions rather than detailed implementation

**Limitations:**
- **Interview Depth**: Limited to ≤8 questions to maintain focus and efficiency
- **Context Dependency**: Quality of output depends on clarity and completeness of input
- **Domain Specificity**: May require domain expertise for specialized system types
- **Iteration Required**: Complex systems may need multiple brief refinement cycles

### Integration with Kata Runner

The output `kata_brief.json` is designed for direct consumption by kata-runner:

```python
# Generate brief
brief_result = model.call(kata_briefsmith_json, variables={...})
brief_json = brief_result["kata_brief.json"]

# Use brief in kata runner
kata_result = model.call(kata_runner_json, variables={
    "KATA_BRIEF_JSON": brief_json,
    "MODE": "silent"
})
```

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid format for LLM optimization  
**Interview Design:** ✅ Bounded question sets for efficient briefing  
**Test Coverage:** ✅ Full validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/software-architecture/kata-briefsmith/kata-briefsmith.json
```

Test with sample requirements to verify brief generation quality and completeness.

---

**Note:** This markdown provides documentation and usage guidance. The executable prompt logic resides in `kata-briefsmith.json`.roduction-ready prompt pack you can drop into any GPT-5 Thinking chat/app. It will interview the user (or ingest messy text) and emit a usable Architectural Kata brief plus companion artifacts.


How to use

For an interactive intake: set MODE=interview, leave RAW_INPUT blank or paste any scraps you have.

For one-shot normalization: set MODE=silent and paste unformatted notes into RAW_INPUT.

The model will return a single JSON bundle containing kata_brief.json, kata_brief.md, open_questions.md, and seed_qas.json, plus a gate quality_report.