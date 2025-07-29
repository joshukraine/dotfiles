# Help Command

Display available Claude Code commands and their usage.

## Command Options

- `--all`: Show all commands with detailed descriptions
- `--category <name>`: Show commands for specific category (git, project, dev)
- `<command>`: Show detailed help for a specific command

## Your task

1. **Default behavior** (no arguments):
   Display a concise list of all available commands grouped by category.

2. **Specific command help** (`/help commit`):
   Show detailed information about the specified command including options and examples.

3. **Category view** (`/help --category git`):
   Show all commands in the specified category with descriptions.

4. **Comprehensive view** (`/help --all`):
   Display all commands with full descriptions and usage notes.

## Command Categories

### Git & GitHub Workflows

- `/commit` - Create well-formatted commits with guided workflow
- `/create-pr` - Create pull requests with smart titles and issue linking
- `/fix-gh-issue` - Fix GitHub issues systematically
- `/review-pr` - Review pull requests with configurable depth

### Project Management

- `/setup-scratch` - Initialize temporary workspace for notes and debugging
- `/new-project` - Comprehensive project setup (use after Claude Code's `/init`)
- `/update-deps` - Update dependencies safely across package managers

### Development Tools

- `/debug-tests` - Debug failing tests systematically (coming soon)
- `/help` - Display this help information

## Output Format

### Default view

```text
Claude Code Commands

Git & GitHub:
  /commit              - Create well-formatted commits
  /create-pr           - Create pull requests with smart titles
  /fix-gh-issue        - Fix GitHub issues systematically
  /review-pr           - Review pull requests thoroughly

Project Management:
  /setup-scratch       - Initialize temporary workspace
  /new-project         - Comprehensive project setup (use after /init)
  /update-deps         - Update dependencies safely

Use '/help <command>' for detailed information about a specific command.
```

### Specific command view

```text
/commit - Create well-formatted commits

Options:
  --no-verify    Skip pre-commit checks

Description:
  Guides you through creating atomic commits with proper formatting
  following Conventional Commits standards. Analyzes staged changes
  and suggests appropriate commit messages.

Examples:
  /commit                 - Standard commit workflow
  /commit --no-verify     - Skip pre-commit hooks


See global CLAUDE.md for commit standards and best practices.
```

### Category view

```text
Git & GitHub Commands

/commit
  Create well-formatted commits with guided workflow
  Options: --no-verify

/create-pr
  Create pull requests with smart titles and issue linking
  Options: --draft, --no-issue-link

/fix-gh-issue
  Fix GitHub issues systematically with optional complexity modes
  Options: --quick, --no-scratchpad, --draft-pr

/review-pr
  Review pull requests with configurable depth and focus
  Options: --quick, --thorough, --security, --auto-detect
```

## Command Details Reference

When showing specific command help, read the command's markdown file and extract:

- Brief description (first paragraph)
- Command options section
- Key workflow steps (summarized)
- Usage examples if available
- Integration notes with other commands

## Error Handling

- **Unknown command**: "Command '/commandname' not found. Use '/help' to see available commands."
- **Unknown category**: "Category 'categoryname' not found. Available: git, project, dev"
- **Command file not found**: "Help unavailable for '/commandname' - command file missing"

## Integration Notes

- Reference global CLAUDE.md for overarching principles
- Note command aliases where available
- Indicate which commands are coming soon
- Link related commands (e.g., fix-gh-issue uses create-pr)

## Future Enhancement

When new commands are added:

1. They automatically appear in the help system
2. Add appropriate category classification
3. Include any new aliases
4. Update related command references
