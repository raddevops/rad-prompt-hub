# Contributing

- All changes via Pull Requests from forks. No direct pushes to {{DEFAULT_BRANCH}}.
- Only CODEOWNERS can merge. Require ≥1 approval and CODEOWNERS review; conversations resolved.
- Write small, focused PRs with passing checks.

## Workflow
1. Fork and create a feature branch: type/slug-YYYYMMDD
2. Follow commit conventions: scope + short imperative
3. Include tests/validation; keep prompt JSON minified
4. Open PR with description, acceptance criteria, and linked issues
5. Address review; CODEOWNERS approval required

## Prompt Packages
- Three files: docs.md, minified .json spec, test.sh
- Include metadata per schema in docs/prompt-metadata.schema.json
- Version prompts semantically (major for breaking output contracts)

## Code of Conduct
See CODE_OF_CONDUCT.md.

## Security
Report privately per SECURITY.md; do not open public issues for vulnerabilities.
