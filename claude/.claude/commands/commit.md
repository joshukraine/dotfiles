# Simple Commit Command

Create a git commit with a meaningful message based on the current changes.

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
7. **Generate commit message**: Based on the specific changes being committed, create a clear, concise commit message following the best practices below
8. **Create commit**: Execute the git commit with the generated message (including `--no-verify` flag if specified)
9. **Repeat if needed**: If this was part of a multi-commit process, return to step 5 for remaining changes
10. **Confirm**: Show the commit hash and ask if I want to push to remote (only after all commits are complete)

## Best Practices for Commits

- **Verify before committing**: Ensure code is linted, builds correctly, and documentation is updated
- **Atomic commits**: Each commit should contain related changes that serve a single purpose
- **Split large changes**: If changes touch multiple concerns, split them into separate commits
- **Conventional commit format**: Use the format `<type>: <description>` where type is one of:
  - `feat`: A new feature
  - `fix`: A bug fix
  - `docs`: Documentation changes
  - `style`: Code style changes (formatting, etc)
  - `refactor`: Code changes that neither fix bugs nor add features
  - `perf`: Performance improvements
  - `test`: Adding or fixing tests
  - `chore`: Changes to the build process, tools, etc.
- **Subject line formatting**:
  - Keep under 50 characters
  - Use present tense, imperative mood (e.g., "add feature" not "added feature" or "fixes bug")
  - Capitalize first letter of description
  - No period at end of subject line
- **Message structure**:
  - Include body when change needs explanation
  - Reference issues/PRs in footer when applicable (e.g., "Fixes #123", "Closes #456")

## Guidelines for Splitting Commits

When analyzing the diff, consider splitting commits based on these criteria:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types of changes**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Changes to different types of files (e.g., source code vs documentation)
4. **Logical grouping**: Changes that would be easier to understand or review separately
5. **Size**: Very large changes that would be clearer if broken down

## Example output format

```text
✅ Staged 3 files
📝 Commit message: "feat: add user authentication system"
🎯 Commit created: abc1234
❓ Push to remote? (y/n)
```
