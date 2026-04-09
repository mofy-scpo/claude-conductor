# Contributing to Claude Conductor

Thank you for your interest in contributing! This guide will help you get started.

## How to Contribute

### Reporting Issues

- Use [GitHub Issues](https://github.com/mofy-scpo/claude-conductor/issues) to report bugs or suggest features
- Check existing issues before creating a new one
- Include steps to reproduce for bug reports
- Specify your OS, Claude Code version, and any relevant configuration

### Submitting Changes

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/my-improvement`)
3. Make your changes
4. Test your changes by installing the plugin locally:
   ```bash
   claude --plugin-dir ./
   ```
5. Commit with a clear message following [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: add new style guide for Rust
   fix: correct path resolution in setup command
   docs: improve installation instructions
   ```
6. Push to your fork and open a Pull Request

### What Can You Contribute?

- **New code style guides** in `templates/code_styleguides/`
- **Bug fixes** in the command files (`commands/`)
- **Documentation improvements** in `README.md` or command descriptions
- **New skills** in `skills/`
- **Translations** of command prompts

### Style Guidelines

- Keep command files (.md) focused and well-structured
- Follow the existing patterns in the codebase
- Test changes with both Greenfield and Brownfield project scenarios

## Development Setup

```bash
git clone https://github.com/mofy-scpo/claude-conductor.git
cd claude-conductor

# Test locally as a plugin
claude --plugin-dir ./
```

## License

By contributing, you agree that your contributions will be licensed under the [Apache License 2.0](LICENSE).
