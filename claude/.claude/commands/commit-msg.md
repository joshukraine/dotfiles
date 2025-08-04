# Auto Commit Message Generator

Generate conventional commit messages from staged files and copy to clipboard.

## Your task

1. **Check staged files**: Run `git status --porcelain` to see what files are staged for commit
2. **Handle empty staging area**:
   - If no files are staged, inform the user and provide helpful git commands to stage files
   - Exit early and ask them to stage files first
3. **Analyze staged changes**: Run `git diff --cached` to understand the modifications
4. **Generate commit message**:
   - Follow Conventional Commits format from global CLAUDE.md
   - Use appropriate commit type (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`)
   - Keep subject line under 50 characters
   - Use present tense, imperative mood
   - **DO NOT** include issue closing references like "Closes #123"
   - Add body with more details if the changes are complex
5. **Copy to clipboard**: Use `pbcopy` to copy the commit message to the clipboard
6. **Display confirmation**: Show the user what was copied and confirm it's ready to paste

## Commit Message Format

```text
<type>[optional scope]: <description>

[optional body]
```

## Example Output

```text
📋 Commit message copied to clipboard:

feat: add user authentication middleware

Implement JWT-based authentication with session management
and password hashing using bcrypt

✅ Ready to paste into your git client!
```

## Common Commands for Staging

If no files are staged, suggest these commands:

```bash
git add .                    # Stage all changes
git add -A                   # Stage all changes including deletions
git add <file>               # Stage specific file
git add -p                   # Interactive staging (patch mode)
```

## Notes

- This command focuses only on message generation and clipboard copying
- User maintains control over the actual commit execution
- Works with any git client (command line, Lazygit, GUI tools)
- Prevents automatic Claude Code attribution in commits
