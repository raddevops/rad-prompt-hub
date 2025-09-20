---
title: Architectural Katas in the Age of AI
category: software-architecture
tags: [software-architecture, katas, ai, governance]
author: raddevops
last_updated: 2025-09-19
---

Architectural Katas in the Age of AI: Why They Matter and How to Embed Them in Your Toolkit

Executive Summary
- Architectural katas are structured, time-boxed design exercises that sharpen decision-making under realistic constraints while producing tangible, reviewable artifacts. They originated as a practice to cultivate architectural thinking, collaboration, and trade-off literacy.
- With AI-assisted engineering, katas provide an essential governance and learning scaffold: they force measurable quality goals (QAS), expose trade-offs early (ATAM), and capture decisions (ADRs) that can be executed and validated via fitness functions. This is how teams evolve architecture safely, not by accident.
- We propose integrating katas directly into the AI development workflow through a deterministic prompt pair: Briefsmith (brief creation) and Kata Runner (design, trade-offs, and repo artifacts). This couples exploration with accountability.

Origins and Evolution
- Practice Roots: Architectural katas popularized by the software architecture community as collaborative exercises to simulate real-world design constraints, align on quality attributes, and practice trade-off reasoning.
- Documentation Traditions: ADRs (Michael Nygard) and MADR formalize concise decision capture. C4 Model (Simon Brown) improves communication with context/container views. SEI’s ATAM/QAS frames quality drivers for measurable, scenario-based evaluation.
- Evolutionary Architecture: Fitness functions (Ford, Parsons, Kua) introduced executable architectural constraints to continuously validate NFRs as systems evolve.

Why Katas Belong in AI Development
- Evidence Over Intuition: LLMs accelerate ideation, but katas provide the structure to ground outputs in measurable QAS and explicit trade-offs.
- Multiple Options Before Decision: Encourages exploration (2–3 candidates) and prevents premature convergence. ATAM-lite scoring makes rationale explicit.
- Determinism and Traceability: A stable output contract (files + dossier) enables CI checks, audits, and continuous learning.
- Team Cognition and Safety: Fitness functions preserve intent; ADRs and risks logs keep decisions explainable as the system and team evolve.

Core Components to Include
- Briefsmith: Facilitated interviews or silent parsing to produce a tight brief (≤3 must-have capabilities, primary user, constraints), plus seed QAS.
- Kata Runner: Transforms the brief into designs, trade-offs, recommendation, and artifacts: C4, ADRs, QAS, risks, backlog, fitness functions, and a dossier JSON.
- Quality Gates: Hard preconditions ensure measurability and completeness (e.g., cost guardrail, walking skeleton, ADR-0001 alignment).

Operating the Kata Loop
- Timebox: 1–2 days of design with explicit defaults marked “assumed.”
- Outputs to Repo: Write artifacts to `docs/architecture/*` and wire fitness functions to CI.
- Review & Learn: Use the dossier to run reviews/retrospectives; refine fitness thresholds as telemetry matures.

Adoption Guidance
- Start Small: Run katas for significant changes or new product slices; socialize ADRs in PRs.
- Make It Executable: Wire fitness functions to your observability stack and CI so drift breaks the build early.
- Evolve Deliberately: Supersede ADRs as facts change; adjust QAS/thresholds with product input.

References (Representative)
- ADRs (Nygard); MADR template; C4 Model (Brown); SEI ATAM and QAS; Building Evolutionary Architectures (Ford, Parsons, Kua); Thoughtworks guidance on evolutionary architecture.

Appendix: Minimal Kata Artifact Set
- Brief (goal, primary user, ≤3 capabilities, constraints)
- QAS (5–8 scenarios with response measures, including cost guardrail)
- Candidates (2–3) with QAS mapping and sensitivity points
- ATAM-lite trade-offs and recommendation with caveats
- ADRs (3–5, Nygard), C4 Context/Container
- Fitness functions (4–6) with gates and ownership
- Thin-slice backlog with a walking skeleton, plus risks/assumptions
- Dossier JSON capturing everything for CI and governance
