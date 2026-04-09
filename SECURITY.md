# Security Policy

## Supported Versions

| Version | Supported |
| :--- | :--- |
| 1.0.x | Yes |

## Reporting a Vulnerability

If you discover a security vulnerability in Claude Conductor, please report it responsibly.

**Do not open a public GitHub issue for security vulnerabilities.**

Instead, please send an email to the maintainer or use [GitHub's private vulnerability reporting](https://github.com/mofy-scpo/claude-conductor/security/advisories/new).

### What to Include

- Description of the vulnerability
- Steps to reproduce
- Potential impact
- Suggested fix (if any)

### Response Timeline

- **Acknowledgment**: within 48 hours
- **Assessment**: within 1 week
- **Fix**: as soon as possible, depending on severity

## Scope

Claude Conductor is a set of Markdown prompt files that instruct Claude Code. It does not execute arbitrary code itself. However, the generated workflows may instruct Claude Code to run commands, so prompt injection or unexpected command execution are relevant concerns.
