<!-- Modified by mofy-scpo (2026) — Adapted from Gemini Conductor for Claude Code CLI -->
<!-- Original: https://github.com/gemini-cli-extensions/conductor -->
<!-- Licensed under Apache License 2.0 -->

# Agent Skills Catalog

This catalog defines the curriculum of skills available to the Conductor framework. Skills are detected based on project dependencies and keywords, and can be installed to provide specialized guidance during implementation.

## How Skills Work

1. **Detection**: Conductor scans your project's dependencies and keywords to identify relevant skills
2. **Installation**: Skills can be installed globally or per-project
3. **Activation**: During implementation, relevant skills are loaded to provide domain-specific guidance

## Adding Custom Skills

To add a custom skill, create a directory with:
- `SKILL.md` - The skill definition and guidelines
- Any reference files needed

### Installation Paths
- **Global skills**: `~/.claude/conductor-skills/<skill-name>/`
- **Project skills**: `.conductor/skills/<skill-name>/`

## Example Skill Entry

```markdown
### my-custom-skill
- **Description**: What this skill does and when to use it
- **URL**: https://github.com/org/repo/tree/main/skills/my-skill/
- **Party**: 1p (first-party) or 3p (third-party)
- **Detection Signals**:
    - **Dependencies**: `package-name`, `another-package`
    - **Keywords**: `relevant keyword`, `another keyword`
```

## Built-in Skills

Skills can be contributed by the community. Check the repository for available skill packages.
