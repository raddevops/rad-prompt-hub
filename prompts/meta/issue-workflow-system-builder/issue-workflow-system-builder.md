---
title: "Issue Workflow System Builder"
version: "1.0.0"
tags: ["meta", "automation", "workflow", "github-issues", "system-builder", "orchestration"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Issue Workflow System Builder Prompt (About)

**Category:** Meta  
**JSON Spec:** `meta/issue-workflow-system-builder/issue-workflow-system-builder.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Analyzes GitHub issues patterns to identify repetitive workflows, creates automated prompt-based systems to handle common task sequences, and updates issues to leverage the new automation infrastructure. Specializes in creating end-to-end workflow systems using PromptSmith and repository tooling.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `REPOSITORY_PATH` | String | ✅ Yes | Absolute path to repository root directory | `"/home/runner/work/rad-prompt-hub/rad-prompt-hub"` |
| `OPEN_ISSUES_DATA` | String | ✅ Yes | Complete GitHub issues data with patterns | JSON array of issues with titles, descriptions, labels |
| `EXISTING_COMPONENTS` | String | ✅ Yes | Current system infrastructure inventory | PromptSmith, validators, build scripts, CI/CD info |
| `REPOSITORY_STANDARDS` | String | ✅ Yes | Repository conventions and requirements | 3-file structure, schema validation, contribution guidelines |
| `INTEGRATION_REQUIREMENTS` | String | ✅ Yes | Specific integration and automation needs | CI/CD pipeline, GitHub Actions, tool compatibility |
| `SYSTEM_SCOPE` | String | Optional | Focus areas or constraints for system building | `"validation_workflows_only"`, `"prompt_improvement_automation"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"high"` | High reasoning effort essential for complex system architecture analysis, multi-phase workflow design, prompt orchestration planning, and thorough issue pattern recognition requiring deep structural reasoning |
| `verbosity` | `"low"` | Low verbosity ensures concise, actionable system implementation artifacts optimized for execution while maintaining technical precision without verbose explanations |

### Workflow Phases

**1. Issue Analysis**
- Parse and categorize recurring issue patterns
- Extract common workflows, phases, and deliverables
- Identify automation opportunities and missing components

**2. System Design**  
- Create a complete automation architecture
- Plan workflow orchestration and component integration
- Design system following repository patterns and standards

**3. Component Creation**
- Build missing prompts using PromptSmith methodology
- Create automation scripts following repository conventions
- Implement workflow orchestration tools

**4. Integration**
- Connect components into cohesive workflow system
- Ensure compatibility with existing CI/CD and validation infrastructure
- Test end-to-end system functionality

**5. Issue Updates**
- Update issue descriptions to reference new automation
- Replace manual workflow steps with automated instructions
- Preserve acceptance criteria while adding automation guidance

**6. Validation**
- Verify system meets repository standards and schema compliance
- Test automated workflows with sample issues
- Ensure backward compatibility and proper documentation

### System Architecture Approach

**Pattern Recognition:**
- Analyzes issue templates for recurring multi-phase workflows
- Identifies common tools, validation steps, and deliverable patterns
- Extracts automation opportunities across similar issue types

**Component Design:**
- Creates missing system components using established repository patterns
- Leverages PromptSmith for prompt engineering following meta-prompt methodology
- Ensures all new components follow 3-file structure (JSON + MD + test.sh)

**Workflow Orchestration:**
- Designs automation that integrates with existing repository infrastructure
- Creates scripts and workflows compatible with current CI/CD pipeline
- Implements systematic approach to issue workflow automation

### Usage Examples

#### Basic System Analysis
```python
result = model.call(system_builder_json, variables={
    "REPOSITORY_PATH": "/home/runner/work/rad-prompt-hub/rad-prompt-hub",
    "OPEN_ISSUES_DATA": json.dumps(github_issues),
    "EXISTING_COMPONENTS": "PromptSmith, schema validation, build scripts",
    "REPOSITORY_STANDARDS": "3-file structure, DRY principles, validation requirements",
    "INTEGRATION_REQUIREMENTS": "GitHub Actions, automated validation, CI/CD compatible"
})
```

#### Focused Validation Workflows
```python
result = model.call(system_builder_json, variables={
    "REPOSITORY_PATH": "/path/to/repo",
    "OPEN_ISSUES_DATA": validation_issues_json,
    "EXISTING_COMPONENTS": existing_infrastructure,
    "REPOSITORY_STANDARDS": standards_doc,
    "INTEGRATION_REQUIREMENTS": integration_needs,
    "SYSTEM_SCOPE": "validation_workflows_only"
})
```

#### Enterprise Integration
```python
result = model.call(system_builder_json, variables={
    "REPOSITORY_PATH": "/enterprise/repo/path",
    "OPEN_ISSUES_DATA": enterprise_issues,
    "EXISTING_COMPONENTS": "PromptSmith, validators, enterprise CI/CD",
    "REPOSITORY_STANDARDS": "Enterprise standards + repository conventions",
    "INTEGRATION_REQUIREMENTS": "Enterprise security, compliance automation",
    "SYSTEM_SCOPE": "full_workflow_automation"
})
```

### Key Capabilities

**Issue Pattern Analysis:**
- Identifies repetitive multi-phase workflows across issues
- Extracts common validation, improvement, and documentation patterns
- Recognizes automation opportunities in manual task sequences

**System Component Creation:**
- Uses PromptSmith to create missing workflow prompts
- Builds automation scripts following repository conventions
- Creates workflow orchestration tools and integration points

**Infrastructure Integration:**
- Leverages existing repository tooling (validation, build scripts)
- Integrates with CI/CD pipeline and GitHub Actions
- Maintains compatibility with established development workflows

**Issue Workflow Updates:**
- Updates issue descriptions to reference automated systems
- Replaces manual steps with automated workflow instructions
- Preserves acceptance criteria while adding automation guidance

### Assumptions & Limitations

**System Assumptions:**
1. **Repository Structure**: Follows established 3-file prompt structure with schema validation
2. **PromptSmith Availability**: Meta-prompt system exists for new prompt creation
3. **GitHub Integration**: Standard issue management with labels, projects, automation capabilities
4. **Repository Permissions**: User has appropriate access for file creation and issue updates
5. **Existing Infrastructure**: Validation tools and build scripts can be extended for new components
6. **Workflow Consistency**: Issues follow patterns suitable for systematic automation

**Implementation Limitations:**
- Bulk issue updates require coordination to avoid disrupting active work
- Complex systems may need phased delivery and integration planning
- Automated workflows should preserve human oversight and review processes
- System complexity requires careful scope management for maintainability

### Risk Considerations

**Implementation Risks:**
- **Workflow Disruption**: Bulk issue updates may interfere with active development workflows
- **System Complexity**: Large-scale automation may exceed maintenance capacity requiring careful scope management
- **Integration Challenges**: Multi-repository systems may require phased implementation and testing
- **API Limitations**: GitHub rate limits and permissions may constrain automation capabilities
- **Human Oversight**: Automation should enhance rather than replace critical decision points and review processes
- **Maintenance Burden**: System complexity requires clear documentation and sustainable maintenance approaches

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Backward Compatibility:** ✅ Preserves existing workflow patterns  
**Test Coverage:** ✅ Full validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/meta/issue-workflow-system-builder/issue-workflow-system-builder.json
```

Test with sample issue data to verify system analysis and component creation capabilities.

---

**Note:** This markdown documents usage. The executable prompt logic resides in `issue-workflow-system-builder.json`.