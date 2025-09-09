---
title: "PromptSmith Meta Generator"
version: "3.0.0"
tags: ["meta", "prompt-engineering", "ai", "automation", "production"]
author: "raddevops"
last_updated: "2025-09-09"
---

## PromptSmith Meta Prompt (About)

**Category:** Meta  
**JSON Spec:** `meta/promptsmith/promptsmith.json`  
**Version:** 3.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Advanced meta-prompt engineering system for creating production-grade GPT-5 prompt packages with end-to-end validation, self-improvement capabilities, and enterprise deployment readiness. Emits either a gating QUESTIONS JSON (minified) when critical info is missing, or a final prompt JSON (system + user messages, parameters, assumptions, risks) — always minified and JSON-only.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `REQUEST` | String | ✅ Yes | Core prompt requirement specification including domain, functionality, and desired capabilities | "Create a code review prompt for Python" or "Need a research synthesis prompt for academic papers" |
| `CONSTRAINTS` | String | ❓ Optional | Technical limitations, format requirements, length restrictions, compliance needs, or workflow integration requirements | "Must integrate with CI/CD pipeline" or "Maximum 500 tokens, enterprise compliance required" |
| `AUDIENCE_TONE` | String | ❓ Optional | Target user profile and communication style preferences | "Technical leads, concise and actionable" or "Researchers, analytical" |
| `ENVIRONMENT` | String | ❓ Optional | Deployment context, tool integrations, infrastructure considerations, or platform-specific requirements | Context-specific deployment information |
| `EXAMPLES` | String | ❓ Optional | Reference implementations, similar prompts, or desired output samples to guide prompt generation | Concrete illustrations for requirement clarity |
| `OUTPUT_CONTRACT` | String | ❓ Optional | Specific deliverable format, structure requirements, validation criteria, or success metrics | Format specifications ensuring downstream compatibility |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | "high" | High reasoning effort is essential for meta-prompt generation requiring deep analysis of requirements, contradiction detection, workflow optimization, and broad prompt engineering domain knowledge synthesis |
| `verbosity` | "low" | Low verbosity ensures concise, actionable prompt artifacts optimized for production deployment while maintaining technical accuracy without verbose explanations that reduce clarity |

### Workflow Summary
**5-Step Process:** Triage → Focused Questions → Design → Parameter Recommendation → Self-Check & Emit

1. **Restate & Triage**: Analyze and categorize incoming prompt requirements
2. **Ask Focused Questions**: Generate QUESTIONS JSON (minified) if critical information missing
3. **Design Prompt**: Create system + user message structure with appropriate placeholders
4. **Recommend Parameters**: Configure reasoning_effort and verbosity for optimal performance
5. **Self-Check & Emit**: Validate for contradictions and vagueness before final JSON output

### Key Guardrails & Rules
- **No Chain-of-Thought**: Internal reasoning process not revealed in output
- **Placeholder Format**: Use `{{LIKE_THIS}}` convention with optional defaults via `:=`
- **Contradiction Prevention**: Full audit before emission to ensure logical consistency
- **Vagueness Elimination**: Specific, actionable directives only
- **Gating Mechanism**: QUESTIONS JSON output when insufficient information provided

### Assumptions & Limitations

The PromptSmith operates under these key assumptions:
1. **Context Sufficiency**: Users provide sufficient context in REQUEST field to enable prompt generation without extensive back-and-forth clarification cycles
2. **Environment Compatibility**: Target deployment environment supports GPT-5-thinking model capabilities and parameter configuration for optimal prompt engineering results
3. **Human Review Process**: Generated prompts will undergo human review and iteration before production deployment, allowing for real-world refinement and optimization
4. **User Knowledge Baseline**: Users have basic prompt engineering knowledge to interpret and customize generated artifacts for their specific domain and use case requirements
5. **System Compatibility**: Prompt consumption systems can handle JSON format with standard fields (messages, parameters, assumptions, risks) following established schema conventions
6. **Ethical Guidelines**: Meta-prompt generation operates within ethical AI guidelines and organizational policies for responsible prompt engineering and deployment practices

### Risk Considerations

**Production Deployment Risks:**
- **Domain Specificity**: Generated prompts may require domain-specific refinement beyond automated meta-generation capabilities, particularly for specialized technical or regulated industry applications
- **Workflow Complexity**: Complex multi-step workflows or extensive tool integrations may exceed single-prompt generation scope, requiring prompt architecture and orchestration considerations
- **Requirement Ambiguity**: Ambiguous or contradictory requirements in REQUEST field may lead to sub-optimal prompt generation requiring clarification cycles or assumption-based gap filling
- **Testing Requirements**: Production deployment without adequate testing and validation may result in prompt performance issues in real-world scenarios with diverse input variations and edge cases
- **Version Management**: Meta-prompt updates and improvements may introduce breaking changes to generated prompt structure, requiring version management and backward compatibility considerations
- **Performance Trade-offs**: High reasoning effort configuration may increase generation latency for time-sensitive prompt development workflows requiring optimization for speed versus thoroughness trade-offs

### Usage Examples

#### Basic Prompt Generation
```python
result = model.call(promptsmith_json, variables={
    "REQUEST": "Create a code review prompt for TypeScript applications",
    "CONSTRAINTS": "Must integrate with GitHub Actions, maximum 1000 tokens",
    "AUDIENCE_TONE": "Senior developers, concise and actionable feedback"
})
```

#### Research Domain Application
```python
result = model.call(promptsmith_json, variables={
    "REQUEST": "Need a literature synthesis prompt for academic papers",
    "AUDIENCE_TONE": "Researchers, analytical",
    "OUTPUT_CONTRACT": "Structured summary with methodology, findings, and gaps"
})
```

#### Enterprise Integration
```python
result = model.call(promptsmith_json, variables={
    "REQUEST": "Product requirements documentation prompt",
    "CONSTRAINTS": "Enterprise compliance required, standardized format",
    "ENVIRONMENT": "Jira integration, automated workflow triggers",
    "EXAMPLES": "Similar to existing PRD templates in system"
})
```

### Output Structure

The PromptSmith generates JSON artifacts with this structure:
```json
{
  "name": "Generated Prompt Name",
  "version": "1.0.0",
  "description": "Prompt purpose and capabilities",
  "target_model": "gpt-5-thinking",
  "parameters": {"reasoning_effort": "medium", "verbosity": "low"},
  "messages": [{"role": "system", "content": "..."}, {"role": "user", "content": "..."}],
  "assumptions": ["Assumption 1", "Assumption 2"],
  "risks_or_notes": ["Risk 1", "Risk 2"]
}
```

### Agent Controls Framework

Optional advanced configurations:
- **Tool Preambles**: Rephrase goal, step plan, progress updates with tools, deviation summaries
- **Eagerness Control**: Balance between asking clarifying questions vs. proceeding with assumptions

### Extensibility & Customization

**Enhancement Options:**
- **Organizational Safety**: Add company-specific safety and compliance policies
- **Tool Integration**: Configure for specific deployment tools and platforms
- **Domain Specialization**: Customize for industry-specific prompt engineering requirements
- **Quality Standards**: Integrate automated validation and testing frameworks

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ❗ Breaking change in 3.0.0 (JSON-only output; QUESTIONS in JSON)  
**Test Coverage:** ✅ Full validation via `test.sh`

### Version History

**v3.0.0 (Current)** - Enforce JSON-only/minified output, QUESTIONS in JSON, behavior is breaking  
**v2.0.0** - Major enhancement with expanded metadata, input variables documentation, expanded assumptions and risks, parameter reasoning, and production-grade enterprise readiness

### Implementation Notes

- **Self-Improvement Capability**: PromptSmith can enhance itself through meta-generation processes
- **Production Optimization**: JSON minified for efficient LLM processing while maintaining clear documentation
- **Enterprise Ready**: Designed for production deployment with extensive risk assessment and quality controls
- **Repository Compliance**: Follows rad-prompt-hub standards for prompt engineering excellence

---

**Note:** This markdown provides documentation and usage guidance. The executable prompt logic resides in `promptsmith.json`.
