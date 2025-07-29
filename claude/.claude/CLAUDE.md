# Global CLAUDE.md

This file provides project-agnostic principles and standards for Claude Code
(claude.ai/code) across all repositories.

## Core Principles

### Security First

- Never commit secrets, API keys, or sensitive data
- Use environment variables or secure vaults for secrets
- Follow principle of least privilege
- Validate all inputs and sanitize outputs

### Clean Code

- Write self-documenting code with clear naming
- Follow established patterns in the codebase
- Prefer readability over cleverness
- Remove dead code and unused imports

### Documentation

- Update documentation when changing functionality
- Include examples for complex features
- Document breaking changes clearly

## Standards & Conventions

### Git Workflow

- **Commits**: Follow [Conventional Commits](https://www.conventionalcommits.org/)
  format
- **Branches**: Use descriptive names (`feat/`, `fix/`, `docs/`, `chore/`)
- **Pull Requests**: Clear titles, reference issues in PR description, atomic
  changes
- **Issue References**: Use "Closes #123" in PR descriptions only, never in
  individual commit messages

### Code Quality

- **Testing**: Write tests for new features and bug fixes
- **Error Handling**: Fail fast, provide context, use specific exceptions
- **Dependencies**: Pin versions, use lock files, document requirements

### Markdown

- **Code Fences**: Always label code blocks with language identifier to avoid linting errors
  - Use ` ```bash ` instead of ` ``` ` for shell commands
  - Use ` ```yaml `, ` ```json `, ` ```javascript `, etc. for respective languages
  - Use ` ```text ` or ` ```plaintext ` for generic content without syntax highlighting

## Default Behaviors

- Use consistent formatting (leverage auto-formatters)
- Follow AAA pattern for tests: Arrange, Act, Assert
- Keep PRs focused and reviewable
- Maintain backward compatibility when possible

---

For detailed implementation guidance, use slash commands (run `/help` for
available commands).
