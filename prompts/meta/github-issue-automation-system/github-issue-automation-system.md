---
title: "GitHub Issue Automation System"
version: "1.0.0"
tags: ["meta", "automation", "github-issues", "workflow", "system-orchestration", "pattern-analysis"]
author: "raddevops"
last_updated: "2025-09-06"
---

## GitHub Issue Automation System Prompt (About)

**Category:** Meta  
**JSON Spec:** `meta/github-issue-automation-system/github-issue-automation-system.json`  
**Version:** 1.0.0  
**Target Model:** gpt-5-thinking  

### Purpose
Advanced meta-prompt that analyzes GitHub repository issues to identify repetitive workflow patterns, creates comprehensive prompt-based automation systems using repository infrastructure, and updates issues to leverage new workflow automation. Orchestrates end-to-end automation system creation and deployment.

### Input Variables

| Variable | Type | Required | Description | Examples |
|----------|------|----------|-------------|----------|
| `REPOSITORY_PATH` | String | ✅ Yes | Absolute path to repository root with write permissions | `"/home/runner/work/rad-prompt-hub/rad-prompt-hub"` |
| `GITHUB_ACCOUNT_INFO` | String | ✅ Yes | GitHub account and repository details with API access | Account owner, repo name, API tokens, permissions |
| `OPEN_ISSUES_JSON` | String | ✅ Yes | Complete JSON data of open GitHub issues | Issues with titles, descriptions, labels, patterns |
| `REPOSITORY_STANDARDS` | String | ✅ Yes | Repository conventions and requirements | 3-file structure, schema validation, guidelines |
| `INTEGRATION_REQUIREMENTS` | String | ✅ Yes | Technical integration and automation needs | CI/CD pipeline, GitHub Actions, tool compatibility |
| `IMPLEMENTATION_SCOPE` | String | Optional | Scope definition for system implementation | `"validation_workflows_only"`, `"full_automation_system"` |
| `CUSTOM_CONSTRAINTS` | String | Optional | Specific constraints or organizational requirements | Policies, limitations, timeline, preservation needs |

### Parameters Configuration

| Parameter | Value | Reasoning |
|-----------|--------|-----------|
| `reasoning_effort` | `"high"` | High reasoning effort essential for comprehensive issue pattern analysis, multi-component system architecture design, workflow orchestration planning, and systematic issue automation requiring deep structural reasoning and planning |
| `verbosity` | `"low"` | Low verbosity ensures concise, actionable implementation artifacts optimized for execution and deployment while maintaining technical precision without verbose explanations that reduce clarity |

### Implementation Strategy

**Phase 1: Repository & Issue Analysis**
- Clone and analyze repository structure, existing tooling, and standards
- Parse open GitHub issues to identify common workflow patterns
- Catalog existing system components and determine missing components
- Assess integration requirements and infrastructure compatibility

**Phase 2: System Architecture Design**
- Design automation system leveraging existing repository infrastructure
- Plan workflow orchestration connecting validation, improvement, and documentation
- Ensure CI/CD pipeline and GitHub Actions compatibility
- Create comprehensive system documentation and usage guidelines

**Phase 3: Component Implementation**  
- Create missing prompts using PromptSmith methodology
- Implement workflow orchestration tools and automation scripts
- Build integration points with existing validation infrastructure
- Ensure all components follow 3-file structure (JSON + MD + test.sh)

**Phase 4: System Integration & Testing**
- Connect all system components into cohesive workflow automation
- Test end-to-end functionality with sample issue workflows
- Validate schema compliance and repository standards adherence
- Create comprehensive system documentation and user guides

**Phase 5: Issue Workflow Updates**
- Update GitHub issue templates to reference new automation system
- Replace manual workflow steps with automated process instructions
- Preserve acceptance criteria while adding automation guidance
- Include usage examples and integration documentation

**Phase 6: Deployment & Validation**
- Deploy system components following repository contribution guidelines
- Run comprehensive validation ensuring quality standards
- Create deployment documentation and maintenance guidelines
- Provide training materials and adoption guidance

### System Architecture Components

**Core Automation Elements:**
- **documentation-validator**: JSON ↔ markdown consistency validation
- **promptsmith**: Meta-prompt engineering for quality improvements  
- **workflow-orchestrator**: Multi-phase workflow coordination
- **issue-workflow-system-builder**: Pattern analysis and system creation
- **github-issue-automation-system**: End-to-end automation orchestration

**Integration Infrastructure:**
- Schema validation integration for quality assurance
- Build script integration for index management  
- CI/CD pipeline compatibility for automated workflows
- GitHub Actions integration for issue workflow automation

### Usage Examples

#### Full System Implementation
```python
result = model.call(automation_system_json, variables={
    "REPOSITORY_PATH": "/home/runner/work/rad-prompt-hub/rad-prompt-hub",
    "GITHUB_ACCOUNT_INFO": {"owner": "raddevops", "repo": "rad-prompt-hub", "api_access": "full"},
    "OPEN_ISSUES_JSON": json.dumps(github_issues_data),
    "REPOSITORY_STANDARDS": repository_conventions,
    "INTEGRATION_REQUIREMENTS": "CI/CD pipeline, GitHub Actions, automated validation"
})
```

#### Validation-Focused Implementation
```python
result = model.call(automation_system_json, variables={
    "REPOSITORY_PATH": "/path/to/repo",
    "GITHUB_ACCOUNT_INFO": github_account_details,
    "OPEN_ISSUES_JSON": validation_issues_json,
    "REPOSITORY_STANDARDS": standards_documentation,
    "INTEGRATION_REQUIREMENTS": integration_specs,
    "IMPLEMENTATION_SCOPE": "validation_workflows_only"
})
```

#### Constrained Enterprise Implementation
```python
result = model.call(automation_system_json, variables={
    "REPOSITORY_PATH": "/enterprise/repo/path",
    "GITHUB_ACCOUNT_INFO": enterprise_github_details,
    "OPEN_ISSUES_JSON": enterprise_issues,
    "REPOSITORY_STANDARDS": "Enterprise + repository standards",
    "INTEGRATION_REQUIREMENTS": "Enterprise security, compliance automation",
    "CUSTOM_CONSTRAINTS": "Regulatory compliance, security policies, phased rollout"
})
```

### Key Capabilities

**Issue Pattern Analysis:**
- Identifies repetitive multi-phase workflows across GitHub issues
- Extracts common validation, improvement, and documentation patterns
- Recognizes automation opportunities in manual task sequences
- Categorizes issues by workflow complexity and automation potential

**System Architecture Design:**
- Creates comprehensive automation systems using existing infrastructure
- Designs workflow orchestration connecting multiple prompt components
- Ensures seamless integration with CI/CD and validation systems
- Plans scalable architecture for long-term maintenance and extension

**Component Implementation:**
- Uses PromptSmith methodology for creating new automation prompts
- Follows repository's 3-file structure and validation requirements
- Builds integration scripts and workflow orchestration tools
- Creates comprehensive testing and validation frameworks

**Issue Workflow Integration:**
- Updates GitHub issues to reference automated workflow systems
- Replaces manual steps with automated process instructions
- Preserves acceptance criteria while adding automation guidance
- Provides clear usage examples and adoption documentation

### Repository Integration Rules

**Standards Compliance:**
- Follow repository's established 3-file structure (JSON + MD + test.sh)
- Use existing tools: PromptSmith, schema validation, build scripts
- Maintain DRY principles and comprehensive documentation standards
- Ensure schema compliance and quality assurance throughout

**Infrastructure Integration:**
- Leverage existing CI/CD pipeline and validation infrastructure
- Integrate with GitHub Actions and automation workflows
- Preserve backward compatibility with existing development processes
- Make minimal surgical changes following repository patterns

**Quality Assurance:**
- All new components must pass comprehensive validation testing
- Maintain documentation completeness and accuracy standards
- Ensure system reliability and maintainability for long-term use
- Preserve human oversight while improving workflow efficiency

### Assumptions & Limitations

**System Assumptions:**
1. **Repository Structure**: Follows established 3-file prompt structure with schema validation
2. **GitHub Integration**: Standard issue management with API access and automation permissions
3. **Infrastructure**: PromptSmith and validation systems available for extension
4. **Permissions**: Appropriate repository access for file creation and issue management
5. **Issue Patterns**: Open issues contain consistent patterns suitable for automation
6. **Implementation Environment**: Supports multi-file operations and GitHub API integration

**Implementation Limitations:**
- Large automation systems may require phased delivery and testing
- Bulk issue updates may disrupt active development requiring coordination
- Complex systems may exceed single implementation scope needing iteration
- GitHub API constraints may limit automation capabilities requiring graceful handling

### Risk Considerations

**System Implementation Risks:**
- **Complexity Management**: Large automation systems require careful maintenance and documentation
- **Change Coordination**: Bulk workflow changes may disrupt development requiring managed rollout
- **Scope Management**: Complex systems may need phased delivery with stakeholder coordination
- **API Limitations**: GitHub rate limits may affect automation requiring error handling
- **Human Oversight**: Automation should enhance rather than replace critical decision processes
- **Maintenance Burden**: System interdependencies require comprehensive documentation and knowledge transfer

### Quality Assurance

**Schema Validation:** ✅ Passes `scripts/schema_validate_prompts.py`  
**JSON Structure:** ✅ Valid minified format for LLM optimization  
**System Integration:** ✅ Compatible with existing repository infrastructure  
**Test Coverage:** ✅ Comprehensive validation via `test.sh`

### Testing & Validation

Run the validation script to ensure prompt integrity:
```bash
python scripts/schema_validate_prompts.py --target prompts/meta/github-issue-automation-system/github-issue-automation-system.json
```

Test with sample GitHub issue data to verify pattern analysis and system creation capabilities.

---

**Note:** This markdown provides comprehensive documentation. The executable prompt logic resides in `github-issue-automation-system.json`.