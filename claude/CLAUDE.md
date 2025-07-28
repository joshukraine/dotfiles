# Global CLAUDE.md

This file provides project-agnostic principles and standards for Claude Code (claude.ai/code) across all repositories.

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

- **Commits**: Follow [Conventional Commits](https://www.conventionalcommits.org/) format
  - Use the `/commit` command for guided commit workflow
- **Branches**: Use descriptive names (`feat/`, `fix/`, `docs/`, `chore/`)
- **Pull Requests**: Clear titles, reference issues, atomic changes
  - Use the `/create-pr` command for creating PRs
  - Use the `/review-pr` command for reviewing PRs

### Code Quality

- **Testing**: Write tests for new features and bug fixes
- **Error Handling**: Fail fast, provide context, use specific exceptions
- **Dependencies**: Pin versions, use lock files, document requirements
  - Use the `/update-deps` command for updates

## Available Commands

### Git & GitHub

- `/commit` - Create well-formatted commits
- `/fix-gh-issue` - Fix GitHub issues systematically
- `/review-pr` - Review pull requests thoroughly
- `/create-pr` - Create pull requests with smart titles

### Project Management

- `/setup-scratch` - Initialize temporary workspace
- `/new-project` - Comprehensive project setup (use after Claude Code's `/init`)
- `/update-deps` - Update dependencies safely

### Development Tools

- `/help` - Show available commands and usage
- `/debug-tests` - Debug failing tests (coming soon)

## Default Behaviors

- Use consistent formatting (leverage auto-formatters)
- Follow AAA pattern for tests: Arrange, Act, Assert
- Keep PRs focused and reviewable
- Maintain backward compatibility when possible

---

For detailed implementation guidance, use the appropriate slash command.
