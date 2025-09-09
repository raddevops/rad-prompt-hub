---
title: "Workflow Orchestrator"
version: "1.0.0"
tags: ["meta", "orchestration", "workflow", "validation", "automation"]
author: "raddevops"
last_updated: "2025-09-06"
---

## Workflow Orchestrator Prompt (About)

**Category:** Meta  
**JSON Spec:** `meta/workflow-orchestrator/workflow-orchestrator.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Orchestrates multi-phase documentation validation and improvement workflows by coordinating documentation-validator and promptsmith prompts for systematic prompt quality enhancement. Manages the complete 4-phase workflow process for consistent, high-quality prompt documentation.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `TARGET_PROMPT_PATH` | String | ✅ Yes | Absolute path to prompt folder for validation and improvement | `"prompts/engineering/code-review/"` |
| `WORKFLOW_SCOPE` | String | ✅ Yes | Scope of workflow execution and analysis depth | `"full_validation_improvement"`, `"validation_only"` |
| `QUALITY_STANDARDS` | String | ✅ Yes | Quality requirements and assessment criteria | `"enterprise_ready"`, `"production_deployment"` |
| `PHASE_CONTROL` | String | Optional | Phase execution control for workflow customization | `"skip_phase_1"`, `"improvement_only"` |
| `CUSTOM_REQUIREMENTS` | String | Optional | Specific requirements or constraints | `"minimal_changes_only"`, `"focus_on_examples"` |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"high"` | High reasoning effort required for complex workflow coordination, multi-prompt orchestration, phase management, and comprehensive quality assurance requiring sophisticated planning and execution oversight |
| `verbosity` | `"medium"` | Medium verbosity needed for clear workflow progress reporting, phase completion status, and actionable next steps while maintaining operational clarity for users |

### Workflow Phases

**Phase 1: Documentation Validation**
- Execute documentation-validator prompt with target prompt folder
- Analyze JSON ↔ markdown consistency findings
- Generate detailed validation report with gaps and issues
- Determine improvement priorities and scope

**Phase 2: Prompt Enhancement**
- Use validation findings to create promptsmith improvement requests  
- Execute promptsmith to generate enhanced JSON specifications
- Address identified documentation gaps and quality issues
- Validate improvements maintain compatibility and functionality

**Phase 3: Documentation Update**
- Generate markdown documentation updates reflecting JSON improvements
- Ensure parameter, placeholder, and capability documentation accuracy
- Update version numbers and changelog entries appropriately
- Verify DRY principles compliance and completeness

**Phase 4: Final Validation & Quality Assurance**
- Re-execute documentation-validator on improved components
- Verify 100% consistency between JSON and updated markdown
- Confirm all validation issues resolved and quality standards met
- Generate implementation recommendations and testing guidance

### Usage Examples

#### Full Validation and Improvement
```python
result = model.call(orchestrator_json, variables={
    "TARGET_PROMPT_PATH": "prompts/engineering/code-review/",
    "WORKFLOW_SCOPE": "full_validation_improvement",
    "QUALITY_STANDARDS": "enterprise_ready,comprehensive_documentation"
})
```

#### Validation Only Workflow
```python
result = model.call(orchestrator_json, variables={
    "TARGET_PROMPT_PATH": "prompts/writing/blog-outline/",
    "WORKFLOW_SCOPE": "validation_only",
    "QUALITY_STANDARDS": "production_deployment",
    "PHASE_CONTROL": "validation_then_stop"
})
```

#### Targeted Improvement Focus
```python
result = model.call(orchestrator_json, variables={
    "TARGET_PROMPT_PATH": "prompts/research/literature-review/",
    "WORKFLOW_SCOPE": "improvement_focused",
    "QUALITY_STANDARDS": "comprehensive_documentation",
    "CUSTOM_REQUIREMENTS": "focus_on_examples,preserve_existing_parameters"
})
```

### Orchestration Capabilities

**Multi-Prompt Coordination:**
- Seamlessly coordinates documentation-validator and promptsmith prompts
- Manages data flow between validation and improvement phases  
- Ensures consistent quality standards across workflow phases

**Progress Tracking:**
- Provides clear status reporting at each workflow phase
- Includes validation scores and metrics for improvement tracking
- Generates comprehensive summary reports for implementation planning

**Quality Assurance:**
- Maintains repository standards and schema compliance throughout
- Verifies backward compatibility while implementing improvements
- Includes testing verification steps for all workflow phases

### Assumptions & Limitations

**Workflow Assumptions:**
1. **3-File Structure**: Target prompts follow repository's JSON + MD + test.sh structure
2. **Prompt Ecosystem**: Documentation-validator and promptsmith prompts are available and functional
3. **Permissions**: User has appropriate access for reading files and implementing changes
4. **Environment**: Supports multi-prompt orchestration and result processing
5. **Standards**: Quality standards are well-defined and measurable for consistent assessment
6. **Implementation**: Human review follows workflow recommendations with testing and validation

**Orchestration Limitations:**
- Complex prompts may require multiple iterations for full quality standards
- Depends on stable prompt ecosystem components for reliable execution
- Large improvements may introduce breaking changes requiring version management
- Extensive output may need efficient parsing and prioritization for implementation

### Risk Considerations

**Workflow Risks:**
- **Iteration Requirements**: Complex prompts may need multiple validation cycles to achieve consistency
- **Dependency Management**: Orchestration relies on stable ecosystem components and may fail if dependencies unavailable
- **Breaking Changes**: Large-scale improvements may require careful version and compatibility management  
- **Output Management**: Multi-phase workflows generate extensive results requiring efficient processing and prioritization
- **Subjective Assessment**: Quality evaluation includes subjective elements requiring human judgment and context
- **Performance Variability**: Execution time varies with prompt complexity requiring appropriate timeout and progress management

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**Workflow Integration:** ✅ Compatible with existing prompt ecosystem  
**Test Coverage:** ✅ Comprehensive validation via `test.sh`

---

**Note:** This markdown provides comprehensive documentation. The executable prompt logic resides in `workflow-orchestrator.json`.