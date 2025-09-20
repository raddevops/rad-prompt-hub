---
title: "Kata Runner - Architectural Design Orchestrator"
version: "1.0.0"
tags: ["software-architecture", "kata", "design", "orchestration", "ATAM"]
author: "raddevops"
last_updated: "2025-09-19"
---

## Kata Runner Prompt (About)

**Category:** Software Architecture  
**JSON Spec:** `software-architecture/kata-runner/kata-runner.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Architectural-kata orchestrator that accepts a kata brief (JSON), performs clarification loops if needed, derives quality-attribute scenarios, generates 2–3 candidate designs, runs an ATAM-lite trade-off analysis, and emits complete repository-ready artifacts including C4 diagrams, ADRs, risks, backlog, and fitness functions.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `KATA_BRIEF_JSON` | String | ✅ Yes | JSON matching the Briefsmith schema containing kata requirements | Complete JSON brief from kata-briefsmith |
| `REPO_ROOT` | String | ❓ Optional | Base path for emitted files | `"./"` (default), `"./project/"` |
| `MODE` | String | ❓ Optional | Execution mode for user interaction | `"silent"` (default), `"interview"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | "high" | High reasoning effort essential for architectural design requiring deep analysis of quality attributes, trade-off evaluation, ATAM methodology application, and comprehensive design artifact generation |
| `verbosity` | "low" | Low verbosity ensures concise, actionable design artifacts optimized for repository consumption while maintaining technical accuracy without verbose explanations |
| `temperature` | 0.2 | Low temperature for consistent, deterministic architectural outputs |
| `top_p` | 0.9 | Balanced nucleus sampling for design creativity within constraints |

### Workflow Summary
**9-Phase Process:** Validate → QAS Builder → Candidate Generator → Trade-off Analyst → Decision & ADRs → C4 Communicator → Fitness Functions → Backlog & Risks → Dossier

1. **Validate Brief**: Check completeness and apply defaults for missing parameters
2. **QAS Builder**: Derive 5–8 ATAM-style quality attribute scenarios with measurable targets
3. **Candidate Generator**: Create 2–3 architectural candidates (e.g., modular monolith, service-oriented, event-driven)
4. **Trade-off Analyst**: Run ATAM-lite scoring against multiple quality attributes with sensitivity analysis
5. **Decision & ADRs**: Recommend architecture with rationale and emit 3–5 ADRs using Nygard template
6. **C4 Communicator**: Generate Context + Container diagrams in text-first, diagram-friendly Markdown
7. **Fitness Functions**: Create 4–6 executable checks with metrics, thresholds, and ownership
8. **Backlog & Risks**: Generate thin-slice backlog and comprehensive risks/assumptions log
9. **Dossier**: Persist complete JSON record for downstream tooling and auditing

### Key Operating Principles
- **Evidence over Style**: Design choices must trace to QAS and constraints
- **Multiple Options**: Always produce ≥2 credible candidates before recommending one
- **Measurables First**: No structural commitment until QAS with targets exist
- **Deterministic Outputs**: Same inputs → same file set and naming
- **Implementation Agnostic**: Plain language, no vendor bias

### Output Structure
**Single JSON Object** containing:
- `quality_report`: Validation status, issues, and notes
- `files[]`: Complete repository-ready artifacts (13 files total)

**Generated Files:**
- Architecture documentation (index, C4 context/container, trade-offs)
- Quality scenarios and fitness functions
- ADRs (Architecture Decision Records)
- Risk assessment and development backlog
- Complete design dossier for auditing

### Quality Gates
**Hard Requirements (fail if unmet):**
- ≥5 QAS with measurable targets and ≥1 cost guardrail
- ≥2 candidates with explicit QAS mapping
- ADR-0001 present and consistent with recommendation
- Backlog contains a walking skeleton
- No more than 3 must-have capabilities

### Usage Examples

#### Basic Kata Execution
```python
result = model.call(kata_runner_json, variables={
    "KATA_BRIEF_JSON": briefsmith_output,
    "REPO_ROOT": "./",
    "MODE": "silent"
})
```

#### Interactive Mode
```python  
result = model.call(kata_runner_json, variables={
    "KATA_BRIEF_JSON": partial_brief,
    "MODE": "interview"
})
```

#### Custom Repository Structure
```python
result = model.call(kata_runner_json, variables={
    "KATA_BRIEF_JSON": brief_json,
    "REPO_ROOT": "./services/payment-system/",
    "MODE": "silent"
})
```

### Assumptions & Limitations

**Default Assumptions Applied:**
1. **Timebox**: design_days=2, delivery_horizon_weeks=4
2. **Team**: team_size=4–6, budget_tshirt=M
3. **Performance**: p99 ≤ 300ms, availability ≥ 99.9% monthly, MTTR ≤ 30m, RPO ≤ 5m
4. **Security**: TLS in transit, PII encrypted at rest, audit log ≥ 90d

**Limitations:**
- Requires well-formed Briefsmith JSON input for optimal results
- ATAM-lite scoring provides guidance but requires domain expertise validation
- Generated fitness functions need integration with organizational observability stack
- ADRs capture point-in-time decisions requiring ongoing maintenance

### Risk Considerations

**Architectural Design Risks:**
- **Scope Complexity**: Large enterprise systems may require multiple kata iterations
- **Context Dependency**: Generated designs assume standard web-scale patterns
- **Implementation Gap**: Abstract designs require detailed technical specification
- **Organizational Fit**: Solutions must align with team capabilities and infrastructure
- **Evolution Planning**: Fitness functions require ongoing threshold adjustment

### Integration Examples

**CI/CD Pipeline Integration:**
```bash
# Run architectural validation
python scripts/validate_architecture.py --kata-output ./docs/architecture/
```

**Development Workflow:**
```bash
# Generate architecture from brief
python tools/run_kata.py --brief ./requirements/kata-brief.json
```

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid format for LLM optimization  
**ATAM Compliance:** ✅ Follows Software Engineering Institute methodology  
**Test Coverage:** ✅ Full validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/software-architecture/kata-runner/kata-runner.json
```

Test with sample kata briefs to verify architecture generation quality and completeness.

---

**Note:** This markdown provides documentation and usage guidance. The executable prompt logic resides in `kata-runner.json`.
