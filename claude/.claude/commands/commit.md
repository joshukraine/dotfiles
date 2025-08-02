# Collaborative Commit Command

Create git commits with intelligent message generation - Claude Code handles analysis and staging, you execute the commits for clean attribution.

## Command Options

- `--no-verify`: Skip running the pre-commit checks (lint, build, generate:docs)

## Your task

1. **Check current status**: Run `git status` to see what files have been changed and what's already staged
2. **Determine staging approach**:
   - If specific files are already staged, proceed with only those files
   - If no files are staged, review all modified and new files for staging
3. **Review changes**: Run `git diff --cached` (for staged files) or `git diff` (if nothing staged) to understand modifications
4. **Pre-commit verification**: Unless `--no-verify` is specified, remind me to ensure:
   - Code is linted and formatted
   - Code builds correctly
   - Tests are passing
   - Documentation is updated if needed
5. **Analyze for commit splitting**: Before proceeding, review the diff to determine if changes should be split into multiple commits based on the splitting guidelines below
6. **Handle staging and commits**:
   - If multiple commits are recommended: Help stage and commit changes separately, one logical group at a time
   - If single commit is appropriate: Stage remaining files (if none were already staged) and proceed
7. **Generate commit message**: Create a commit message following the Conventional Commits format from global CLAUDE.md
8. **Prepare commit**: Generate the commit message and copy just the message content to clipboard using pbcopy
9. **Display for review**: Show the message was copied and display it for confirmation
10. **User executes**: User pastes (Cmd+V) the message into their git tool (Lazygit, command line, etc.)
11. **Repeat if needed**: If this was part of a multi-commit process, return to step 5 for remaining changes
12. **Confirm completion**: After user executes commit(s), offer to help with next steps like pushing to remote

## Commit Standards

Follow the Conventional Commits format and best practices defined in the global CLAUDE.md:

- Use appropriate commit types (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`)
- Keep subject line under 50 characters
- Use present tense, imperative mood
- **DO NOT** include issue closing references like "Closes #123" in commit messages
- Issue references belong in PR descriptions, not individual commits

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down

## Example output format

**Important**: Output each status line separately with a blank line between for proper CLI display:

```text
✅ Staged 3 files

📝 Commit message: "feat: add user authentication system"

📋 Message copied to clipboard! Just paste into your git tool:
feat: add user authentication system

Add JWT-based authentication with secure session management...

🎯 Ready to paste into Lazygit or git command line
```

When displaying the summary, ensure each line is output independently with proper spacing to prevent concatenation in the terminal.

**Note**: The collaborative approach (user executes via their preferred git tool) prevents Claude Code attribution from being automatically added to commits. Works seamlessly with Lazygit, command line, or any git interface.
