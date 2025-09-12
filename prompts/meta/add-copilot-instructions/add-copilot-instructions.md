---
title: "Add Copilot Instructions"
tags: ["meta", "copilot", "best-practices", "repository-improvement", "automation"]
author: "raddevops"
last_updated: "2025-01-09"
---

# Add Copilot Instructions Prompt (About)

Slug: add-copilot-instructions  
Category: meta  
Version: 2.0.1  
Model: gpt-5-thinking

## Purpose
Analyze a repository and the Copilot Coding Agent best-practices page, then produce tailored implementation artifacts: improved guardrail docs, prompt snippets, and a PR execution plan.

## Parameters
- **Target Model**: gpt-5-thinking  
- **Reasoning Effort**: high (essential for comprehensive codebase analysis, best-practices synthesis, and cross-repository pattern recognition)
- **Verbosity**: low (ensures concise, actionable JSON output optimized for direct consumption)

## Input Variables
### Required
- **REPO_LOCATION**: Absolute or relative path to repository being analyzed, or GitHub URL
- **PROJECT_SUMMARY**: One-paragraph description of project's purpose, goals, and context
- **LANGS_AND_FRAMEWORKS**: Array of primary technologies and platforms (e.g., ['TypeScript', 'React', 'AWS'])
- **CONSTRAINTS**: Array of technical/organizational limitations (e.g., ['no internet access', 'enterprise compliance'])
- **PRIORITY_AREAS**: Array of focus areas for best-practices application (e.g., ['agent prompts', 'testing'])
- **COPILOT_BEST_PRACTICES_URL**: URL to GitHub Copilot Coding Agent best-practices documentation

### Optional
- **SAMPLING_HINT**: Guidance for large repository analysis (e.g., 'focus on /src/api first')
- **TOOLS**: Array of available analysis tools (e.g., ['fs_reader', 'ripgrep', 'linter'])
- **MAX_SCAN_DEPTH**: Integer limiting filesystem traversal depth
- **GLOBS**: Array of file patterns for focused analysis (e.g., ['**/*.md', '**/*.py'])
- **NETWORK_ACCESS_BOOL**: Boolean indicating if agent can fetch external URLs

## Output Contract (JSON)
Return a single minified JSON object with keys:
- **repo_snapshot** (object): Repository structure and context analysis
- **best_practices** (array): Extracted concrete practices from documentation
- **mapping** (array): Objects with practice, where, evidence, gap_risk, recommendation
- **prioritized_changes** (object): Arrays P0, P1, P2 for immediate/short/long-term improvements
- **prompts_library** (array): Objects with name, snippet, placeholders, constraints, success_criteria
- **verification_plan** (object): Testing and validation steps
- **pr_plan** (object): Implementation strategy with minimal, effective changes
- **open_questions** (array): Unresolved considerations requiring clarification

## Guardrails
- **Output Format**: JSON-only response; no prose/markdown/code fences; single-line minified output
- **Security**: Never invent secrets/keys; don't suggest disabling security controls; flag unsafe patterns
- **Methodology**: Evidence-based; explicit file paths; deterministic tables & checklists
- **Scope Management**: Sample large repositories with clear criteria; mark inferred generalizations

## Assumptions
- Model has read-only access to repository file tree or pasted structure
- Best-practices URL remains accessible (fallback: user can paste relevant sections)
- User wants minimally invasive, high-leverage improvements first (quick wins)

## Risks & Considerations
- Network/repo access limitations may require assumption-based outputs and follow-up passes
- Best-practices documentation may change; periodic re-sync recommended
- Large monorepos require sampling; scope and generalizations must be clearly marked

## Example Invocation
```json
{
  "REPO_LOCATION": "/path/to/my-project",
  "PROJECT_SUMMARY": "React-based dashboard application with Python API backend",
  "LANGS_AND_FRAMEWORKS": ["TypeScript", "React", "Python", "FastAPI", "PostgreSQL"],
  "CONSTRAINTS": ["enterprise compliance required", "CI/CD integration needed"],
  "PRIORITY_AREAS": ["agent prompts", "testing automation", "documentation"],
  "COPILOT_BEST_PRACTICES_URL": "https://docs.github.com/en/enterprise-cloud@latest/copilot/tutorials/coding-agent/get-the-best-results",
  "NETWORK_ACCESS_BOOL": true
}
```

## Change Log
- 2.0.1: Added comprehensive input variable documentation, parameter reasoning, and usage examples; improved documentation consistency
- 2.0.0 (BREAKING): Switched output from Markdown to minified JSON-only contract; tightened guardrails; lowered verbosity
- 1.0.0: Initial migration into structured meta category
