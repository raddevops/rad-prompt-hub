# Repository Audit Prompt (About)

Slug: repository-audit  
Category: engineering  
Model: gpt-5-thinking  
Version: 1.0.0

## Purpose
Provide an evidence-based snapshot of a codebase's current maturity and produce a prioritized improvement roadmap (no speculative redesign).

## When To Use
- New ownership / due diligence.
- Planning a modernization or reliability push.
- Establishing baseline before large initiative.

## Required Inputs
Supply as many of these as possible (otherwise sections will show "Insufficient evidence"):
- Dependency manifest(s) (e.g., requirements.txt, package.json, pom.xml)
- Representative module/file samples
- Test summary (counts, pass rate)
- CI / build config (e.g., GitHub Actions YAML)
- README / architecture notes
- Deployment / infra manifests (Dockerfile, Terraform, Helm, etc.)

## Output Sections
1. Summary  
2. Architecture & Modularity  
3. Code Quality  
4. Testing  
5. Security & Dependencies  
6. Operational Readiness  
7. Documentation & Onboarding  
8. Risk & Priority Matrix (table)  
9. 30/60/90 Plan  
10. Quick Wins  
11. Assumptions & Gaps

Sections with inadequate data are replaced by `Insufficient evidence`.

## Key Guardrails
- Evidence-only; no invention of metrics.
- Each bullet ≤25 words.
- Measurable phrasing where possible.
- Chain-of-thought suppressed.

## Placeholders
- `{{REPO_SUMMARY}}` – Short summary (default stub)
- `{{OBJECTIVES}}` – Assessment objectives
- `{{FOCUS_AREAS}}` – all | quality | architecture | testing | security | ops | docs

## Risks / Notes
- Security depth unknown without scans.
- Test effectiveness uncertain without coverage & flake data.
- Operational maturity hard to gauge absent runbooks & SLOs.

## Example Invocation
Provide: repo summary, file tree excerpt, key manifests, test stats. Ask: "Audit focus on reliability & dependency risk; produce 30/60/90 plan."

## Change Log
- 1.0.0: Initial addition next to JSON spec.
