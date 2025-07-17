# Global CLAUDE.md

This file provides project-agnostic guidance to Claude Code (claude.ai/code) across all repositories.

## Git Commit Guidelines

### Conventional Commits
Always use [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, no logic changes)
- `refactor` - Code refactoring (no feature changes or bug fixes)
- `test` - Adding or updating tests
- `chore` - Maintenance tasks, dependency updates
- `perf` - Performance improvements
- `ci` - CI/CD configuration changes
- `build` - Build system or external dependencies changes
- `revert` - Reverting previous commits

**Examples:**
```
feat(auth): add OAuth login support
fix: resolve memory leak in user service
docs: update API documentation
chore: update dependencies to latest versions
```

### Commit Best Practices
- Keep subject line under 50 characters
- Use present tense: "add feature" not "added feature"
- Use imperative mood: "fix bug" not "fixes bug"
- Capitalize first letter of description
- No period at end of subject line
- Include body when change needs explanation
- Reference issues/PRs in footer when applicable
- Never include Claude Code generation snippets (e.g., "🤖 Generated with [Claude Code]") in commit messages

## Code Quality Standards

### Security
- Never commit secrets, API keys, or sensitive data
- Use environment variables or secure vaults for secrets
- Follow principle of least privilege
- Validate all inputs and sanitize outputs
- Keep dependencies updated and scan for vulnerabilities

### Documentation
- Write clear, concise comments for complex logic
- Update README files when adding features
- Document API changes and breaking changes
- Include examples in documentation

### Testing
- Write tests for new features and bug fixes
- Maintain good test coverage
- Use descriptive test names that explain the behavior
- Follow AAA pattern: Arrange, Act, Assert

## Development Workflow

### Branch Naming
Use descriptive branch names:
- `feat/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-readme` - Documentation updates
- `chore/dependency-update` - Maintenance tasks

### Pull Requests
- Write clear PR titles using Conventional Commits format
- Include description of changes and why they're needed
- Reference related issues
- Ensure CI passes before requesting review
- Keep PRs focused and atomic when possible

## Code Style

### General Principles
- Write self-documenting code with clear variable and function names
- Follow established patterns and conventions in the codebase
- Prefer readability over cleverness
- Remove dead code and unused imports
- Use consistent formatting (leverage auto-formatters when available)

### Error Handling
- Handle errors gracefully with appropriate error messages
- Use specific exception types rather than generic ones
- Log errors with sufficient context for debugging
- Fail fast when encountering unrecoverable errors

## Project Setup

### Dependencies
- Pin dependency versions in production
- Regularly update dependencies and test for breaking changes
- Use lock files to ensure consistent environments
- Document system requirements and installation steps

### Configuration
- Use configuration files for environment-specific settings
- Provide sensible defaults
- Document all configuration options
- Separate configuration from code