---
title: "Git Workflow Designer"
version: "1.0.1"
tags: ["engineering", "git", "workflow", "collaboration", "branching", "release-engineering"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Git Workflow Prompt (About)

**Category:** Engineering  
**JSON Spec:** `engineering/git-workflow/git-workflow.json`  
**Version:** 1.0.1  
**Target Model:** gpt-5-thinking  

### Purpose
A release engineering advisor optimizing Git collaboration models with evidence-based branching strategies and workflow recommendations. Produces comprehensive Git branching & collaboration models including branch roles, protections, commit/PR policy, automation, and risk assessment derived from team context analysis.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `TEAM_CONTEXT` | String | ✅ Yes | Team context including size, release cadence, CI/CD maturity, and collaboration pain points | `"5-person team, weekly releases, mature CI/CD, struggling with merge conflicts"` or `"20+ developers, monthly releases, basic CI, need better code review process"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"medium"` | Balanced analysis for Git workflow design, sufficient for evaluating team needs, release patterns, and collaboration trade-offs without over-analysis that could delay workflow adoption |
| `verbosity` | `"low"` | Concise, actionable guidance optimized for engineering lead consumption, avoiding verbose explanations that reduce practical adoption and decision-making efficiency |

### Output Structure

The prompt generates workflow recommendations in this exact 7-section format:

```markdown
## Context Summary
Team analysis and key factors influencing workflow choice

## Recommended Model  
Specific workflow model with justification (≤120 words)

## Branch Types
Branch categories, naming conventions, and purposes

## Commit Convention
Commit message standards and formatting requirements

## PR Policy
Pull request requirements, review standards, and approval processes

## Automation
CI/CD integration recommendations and automated workflow triggers

## Risks
Potential challenges and mitigation strategies for workflow adoption
```

### Key Guardrails & Rules
- **Evidence-Based**: Align workflow model to release cadence and team size
- **Pragmatic Focus**: Justify trade-offs without dogma, actionable guidance only
- **Concise Communication**: No chain-of-thought, direct engineering recommendations
- **Context-Driven**: Ask clarifying questions if team context missing (size, cadence, CI maturity)

### Assumptions & Limitations

The prompt operates under these key assumptions:
1. **Git Proficiency**: Team has basic Git proficiency and access to standard Git hosting platforms (GitHub, GitLab, Bitbucket)
2. **CI/CD Availability**: Pipeline capabilities are available for automation, though maturity levels may vary
3. **Predictable Releases**: Release cadence and deployment patterns follow schedules suitable for branching alignment
4. **Team Capacity**: Size and role distribution allow for recommended workflow complexity without overwhelming collaboration
5. **SDLC Standards**: Standard practices are in place for code review, testing, and deployment processes
6. **Change Readiness**: Team is open to workflow changes and has capacity for adoption/training of new patterns

### Risk Considerations

**Workflow Adoption Challenges:**
- **Feedback Cycles**: Recommendations based on provided context may require adjustment after real-world adoption
- **Change Management**: Success depends heavily on leadership support, training investment, and gradual transition strategies
- **Over-Generalization Risk**: Insufficient context may cause over-generalization of workflow recommendations without adequate consideration of team dynamics
- **Context Limitations**: Assessment without direct team observation may lead to complexity mismatches with actual capabilities
- **Infrastructure Dependencies**: Automation success depends on existing CI/CD maturity and technical expertise for configuration

### Usage Examples

#### Small Agile Team
```python
# 5-person team with frequent releases
result = model.call(json_prompt, variables={
    "TEAM_CONTEXT": "5-person startup team, daily deployments, mature CI/CD with automated testing, experiencing merge conflicts during feature development"
})
```

#### Large Enterprise Team
```python  
# Large team with structured releases
result = model.call(json_prompt, variables={
    "TEAM_CONTEXT": "25-developer enterprise team, monthly releases with quarterly major versions, basic CI setup, struggling with code review bottlenecks and release coordination"
})
```

#### Mid-Size Product Team
```python
# Growing team transitioning workflows
result = model.call(json_prompt, variables={
    "TEAM_CONTEXT": "12-person product team, bi-weekly sprints with weekly releases, intermediate CI/CD, need better feature branch management and hotfix processes"
})
```

### Workflow Model Specializations

**Team Size Considerations:**
- **Small Teams (2-6)**: Simplified branching, fast integration patterns
- **Medium Teams (7-15)**: Feature branching with review gates, automated testing
- **Large Teams (16+)**: Complex branching models, strict review processes, release trains

**Release Patterns:**
- **Continuous Deployment**: Trunk-based development, feature flags
- **Regular Releases**: Git Flow or GitHub Flow variations
- **Staged Releases**: Release branching with hotfix support

### Extensibility & Customization

**Workflow Variations:**
```json
// Add to system message for specific needs
"- Include semantic versioning strategy for library projects"
"- Add monorepo branching considerations for multi-service architectures"
"- Incorporate security review requirements for regulated industries"
```

**Team-Specific Adaptations:**
- **Remote Teams**: Enhanced PR documentation, async review processes  
- **Regulated Environments**: Compliance tracking, audit trail requirements
- **Open Source**: Community contribution workflows, maintainer guidelines

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ✅ Preserves existing functionality and output format  

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/engineering/git-workflow/git-workflow.json
```

Test with various team contexts to verify output structure and workflow appropriateness.

### Implementation Notes

- **Conversation Format**: Uses system/user message structure for optimal model interaction
- **Token Optimization**: JSON is minified for efficient LLM processing while maintaining comprehensive documentation
- **Context Sensitivity**: Designed to handle partial information and request clarification
- **Engineering Focus**: Optimized for technical leadership decision-making and team implementation

---

**Note:** This markdown provides comprehensive documentation and usage guidance. The executable prompt logic resides in `git-workflow.json`.