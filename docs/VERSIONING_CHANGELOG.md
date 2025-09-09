# Prompt Versioning and Changelog Conventions

This document establishes comprehensive guidelines for versioning stable prompts and maintaining changelogs in rad-prompt-hub.

## When to Use Versioning

### Use Semantic Versioning When:
- **External integrations** depend on your prompt (APIs, automated systems, CI/CD pipelines)
- **Breaking changes** would impact downstream consumers
- **Deterministic behavior** is required across deployments
- **Formal release process** is needed for the prompt

### Use `last_updated` Field Only When:
- Prompt is used informally or manually
- Changes are non-breaking improvements
- No external systems depend on stable behavior
- Quick iteration and updates are preferred

## Semantic Versioning Format

Follow [Semantic Versioning 2.0.0](https://semver.org/) specification:

```
MAJOR.MINOR.PATCH[-prerelease][+build]
```

### Version Bumping Rules

#### MAJOR Version (X.y.z)
Increment when making **incompatible changes** that break existing usage:

- **Output format changes**: Different JSON schema, removed fields, changed field types
- **Input parameter changes**: Removed required parameters, changed parameter semantics  
- **Behavioral changes**: Different core logic, altered prompt reasoning approach
- **Breaking constraint changes**: New restrictions that invalidate existing inputs

**Examples:**
- `1.5.0 → 2.0.0`: Removed required `{{context}}` parameter
- `3.1.2 → 4.0.0`: Changed from code review to security audit focus

#### MINOR Version (x.Y.z)
Increment when adding **backward-compatible functionality**:

**Examples:**
- `1.2.1 → 1.3.0`: Added optional `{{language}}` parameter
- `2.0.0 → 2.1.0`: Added risk assessment section to output

#### PATCH Version (x.y.Z)
Increment for **backward-compatible bug fixes and documentation corrections**:

Examples:
- `1.2.1 → 1.2.2`: Fixed typos in system prompt
- `2.3.4 → 2.3.5`: Corrected parameter description in documentation

#### Pre-release Versions
```
1.3.0-beta.2     # Feature complete, testing
1.3.0-rc.1       # Release candidate
```

#### Build Metadata
Use for tracking build information (ignored in version precedence):

```
1.2.1+20231205       # Build date
1.2.1+commit.abc123  # Git commit
```

## Implementation Guidelines

### JSON Files
Add version field to prompt JSON when needed:

```json
{
  "target_model": "gpt-4",
  "version": "1.2.0",
  "parameters": {
    "reasoning_effort": "medium",
    "verbosity": "low"
  },
  "messages": [...]
}
```

### Markdown Files
Include version in frontmatter and document in About section:

```markdown
---
title: "Code Review Assistant"
tags: ["engineering", "code-review", "quality"]
author: "raddevops"
last_updated: "2025-09-06"
version: "1.2.0"
---

## Version History
See [Changelog](#changelog) section below.

### Changelog Format

```
#### Added
- Optional `{{security_focus}}` parameter for targeted security reviews
```
---

## Release History

### [v0.1.0] - 2025-09-09
#### Added
- README: Repository protections section and usage of `tools/enable-security.sh`
- Badges: CI validate status, license, version

#### Changed
- Protections: Require `validate` status check on `main`; conversation resolution enabled; admins enforced; solo-maintainer friendly (no required approvals)

#### Security
- Dependabot: Actions + pip updates enabled
- CodeQL: Analysis workflow on push to `main`

#### Changed
- Enhanced error handling for malformed code inputs
- Improved clarity of recommendation prioritization

#### Fixed
- Typo in variable placeholder documentation

### [2.0.0] - 2025-08-24
#### Breaking Changes
- **BREAKING**: Output format changed from plain text to structured JSON
- **BREAKING**: Removed deprecated `{{style}}` parameter

#### Added
- Structured JSON output with summary, strengths, issues, recommendations
- Support for multiple programming languages

### [1.5.2] - 2025-08-15
#### Fixed  
- Corrected example usage in documentation
- Fixed inconsistent placeholder naming
```

### Changelog Sections

Use these standard sections:

#### Added
- New features
- New parameters or capabilities
- New output fields or formats

#### Changed
- Updates to existing functionality (non-breaking)
- Improved behavior or performance
- Enhanced documentation

#### Deprecated  
- Soon-to-be removed features
- Include timeline and migration path

#### Removed
- Previously deprecated features
- Deleted parameters or capabilities  

#### Fixed
- Bug fixes
- Typo corrections
- Documentation fixes

#### Security
- Vulnerability fixes
- Security-related improvements

#### Breaking Changes
- Use for major version bumps
- Clearly mark with **BREAKING** prefix
- Explain migration path

### Entry Guidelines

#### Be Specific and Actionable
```markdown
# Good
- Added optional `{{language}}` parameter with auto-detection fallback
- Fixed typo in system prompt: "anaylze" → "analyze"  
- **BREAKING**: Output format changed from plain text to JSON schema

# Bad  
- Improvements
- Bug fixes
- Updates
```

#### Include Context When Helpful
```markdown  
- Enhanced error handling for malformed inputs (addresses issue #42)
- Improved recommendation prioritization based on user feedback
- Added security focus parameter (requested by enterprise users)
```

#### Link to Breaking Changes
```markdown
- **BREAKING**: Removed `{{style}}` parameter - use `{{format}}` instead
- **BREAKING**: Changed output schema - see [Migration Guide](migration.md)
```

## Migration and Backward Compatibility

### Deprecation Process

1. **Announce**: Add deprecation notice to changelog and documentation
2. **Timeline**: Provide at least 30 days notice for widely-used prompts  
3. **Migration**: Document replacement or upgrade path
4. **Support**: Continue supporting deprecated features during transition
5. **Remove**: Delete in next major version

### Example Deprecation Notice

```markdown
#### Deprecated
- `{{style}}` parameter deprecated in favor of `{{format}}` (will be removed in v3.0.0)
  - Migration: Replace `{{style}}` with `{{format}}` in your prompts
  - Timeline: Removal planned for 2025-10-01
```

### Backward Compatibility Guidelines

- **Maintain input compatibility**: Don't remove required parameters in minor versions
- **Extend output format**: Add new fields, don't change existing ones
- **Preserve behavior**: Core prompt logic should remain consistent
- **Document changes**: All modifications must be documented in changelog

## Best Practices

### Version Management
- **Start with 1.0.0** for first stable release
- **Use 0.x.y** for initial development and experimentation
- **Tag git commits** with version releases
- **Update both JSON and markdown** files consistently

### Documentation
- **Update changelog** with every version bump
- **Include migration notes** for breaking changes  
- **Provide examples** of new features or changed behavior
- **Link to related issues** or pull requests when relevant

### Testing and Validation
- **Test with actual data** before releasing new versions
- **Validate schema changes** don't break existing integrations
- **Check dependent prompts** that might be affected
- **Run full validation suite** before tagging releases

### Communication
- **Announce major changes** in repository discussions
- **Tag breaking changes clearly** in commit messages and PR descriptions
- **Provide migration assistance** for complex breaking changes
- **Consider user impact** when planning version increments

## Examples

### Versioned Prompt Structure

```
prompts/engineering/advanced-code-review/
├── advanced-code-review.json          # version: "2.1.0"
├── advanced-code-review.md            # Documents v2.1.0 features
├── CHANGELOG.md                       # Optional dedicated changelog
└── test.sh                           # Tests for current version
```

### Version Upgrade Workflow

```bash
# 1. Make changes to prompt
vim prompts/engineering/code-review/code-review.json
vim prompts/engineering/code-review/code-review.md

# 2. Update version in JSON file
# "version": "1.2.1" → "1.3.0"

# 3. Update last_updated in markdown frontmatter
# last_updated: "2025-09-06"

# 4. Add changelog entry
# ### [1.3.0] - 2025-09-06
# #### Added
# - Enhanced error handling for edge cases

# 5. Commit with semantic message
git add prompts/engineering/code-review/
git commit -m "feat(code-review): enhance error handling (v1.3.0)"

# 6. Tag the release
git tag v1.3.0-code-review
git push origin v1.3.0-code-review
```

## Tools and Automation

### Validation
- Schema validation ensures version format compliance
- Pre-commit hooks check for updated `last_updated` field
- CI/CD validates version consistency between JSON and markdown

### Future Enhancements
- Automated version bumping based on conventional commits
- Changelog generation from commit messages
- Version compatibility checking for dependent prompts
- Integration with package managers for prompt distribution

---

For questions about versioning strategy or specific version bump decisions, open an issue with the `versioning` label.