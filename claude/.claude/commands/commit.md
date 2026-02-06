# Commit Command

Create git commits with intelligent message generation and commit-splitting analysis.

## Command Options

- `--no-verify`: Skip running pre-commit checks

## Your task

1. **Check current status**: Run `git status` to see changed and staged files
2. **Review changes**: Run `git diff --cached` (staged) or `git diff` (unstaged) to understand modifications
3. **Analyze for commit splitting**: Review the diff to determine if changes should be split into multiple commits
4. **Stage and commit**: Help stage and commit changes, one logical group at a time if splitting
5. **Generate commit message**: Create a message following Conventional Commits format
6. **Execute commit**: Run `git commit` directly with the generated message
7. **Repeat if needed**: If splitting, return to step 4 for remaining changes
8. **Confirm completion**: Offer to help with next steps like pushing to remote

## Commit Standards

Follow Conventional Commits format:

- Use appropriate types (`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`)
- Keep subject line under 50 characters
- Use present tense, imperative mood
- **DO NOT** include issue closing references in commit messages (those belong in PR descriptions)

## Guidelines for Splitting Commits

Consider splitting when the diff contains:

1. **Different concerns**: Changes to unrelated parts of the codebase
2. **Different types**: Mixing features, fixes, refactoring, etc.
3. **File patterns**: Source code vs documentation vs configuration
4. **Large diffs**: Changes clearer if broken into logical pieces
