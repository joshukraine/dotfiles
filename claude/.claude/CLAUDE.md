# Global CLAUDE.md

This file provides project-agnostic principles and standards for Claude Code
(claude.ai/code) across all repositories.

## Scratchpad Management

For every project, use standardized scratchpad organization for temporary files,
notes, and debugging:

### Setup (run on project initialization)

```bash
mkdir -p scratchpads/{pr-reviews,planning,debugging,notes}
echo "# Scratchpads for temporary files, notes, and debugging" >> .gitignore
echo "scratchpads/" >> .gitignore
```

### Directory Structure

```text
scratchpads/
├── pr-reviews/     # Pull request reviews and analysis
├── planning/       # Project planning and roadmaps
├── debugging/      # Debug sessions and troubleshooting
└── notes/         # General development notes and research
```

### Naming Convention

- Include timestamps: `pr-review-123-20250721-211241.md`
- Use descriptive names: `phase-3-planning-20250721.md`
- Keep organized by date and purpose

### Benefits

- **Safe**: Never accidentally committed (ignored by git)
- **Organized**: Consistent structure across all projects
- **Discoverable**: Easy to find previous work and context
- **Collaborative**: Clear convention when working with others

### Integration with /init

When initializing new projects:

1. **Always offer to set up scratchpads** after basic project initialization
2. **Run the setup script**: `bash ~/.claude/setup-scratchpads.sh`
3. **Verify structure created** and .gitignore updated properly
4. **Reference in project docs** if project has its own CLAUDE.md

This ensures consistent scratchpad management across all projects from day one.

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
  - Use the `/commit` command for guided commit workflow
  - Do NOT include issue closing references in individual commit messages
- **Branches**: Use descriptive names (`feat/`, `fix/`, `docs/`, `chore/`)
- **Pull Requests**: Clear titles, reference issues in PR description, atomic changes
  - Use the `/create-pr` command for creating PRs
  - Issue references like "Closes #123" belong in PR descriptions only
  - Use the `/review-pr` command for reviewing PRs

### Code Quality

- **Testing**: Write tests for new features and bug fixes
- **Error Handling**: Fail fast, provide context, use specific exceptions
- **Dependencies**: Pin versions, use lock files, document requirements
  - Use the `/update-deps` command for updates

## Available Commands

### Git & GitHub

- `/commit` - Create well-formatted commits
- `/resolve-issue` - Resolve GitHub issues systematically
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
