# Sprint Issue Command

Quickly resolve a small, well-scoped GitHub issue with a streamlined workflow. Use `/resolve-issue` for larger or more complex work that needs full checkpoints.

## Your task

### Step 1: Get issue details and prepare

- Run `gh issue view $ARGUMENTS` to get issue details.
- Briefly assess scope and identify files that need changes.
- **If already on a feature branch** (e.g., from `/setup-sprint` worktrees): confirm the branch name matches the issue and proceed to Step 2.
- **If on main/master**: create a feature branch using the issue's type label to determine the prefix (e.g., `chore/gh-$ARGUMENTS-short-description`, `fix/gh-$ARGUMENTS-short-description`, `feat/gh-$ARGUMENTS-short-description`). If no type label is present, infer from context (default to `chore/`).

### Step 2: Implement and verify

- Implement the fix with frequent commits following Conventional Commits.
- Run the project's linter (if configured) and fix any issues before proceeding. To find the right command, check the project's README, CI workflow files, or look for config files like `.rubocop.yml`, `.standardrb.yml`, `.eslintrc.*`, or `package.json`.
- Run the project's test suite (if one exists) and ensure all tests pass. Check for `Rakefile`, `package.json`, `pytest.ini`, or CI config to discover the test command.
- **Do NOT proceed if linting or tests fail.** If the project has no linter or test suite, skip the corresponding check and move on.

### Step 3: Create PR and report

- Push the branch and create a PR using `gh pr create`.
- PR description must include "Closes #$ARGUMENTS".
- Report: files changed, commits made, test/lint status.

## Important

- This command is for small, well-scoped issues.
- Skip the implementation plan checkpoint — move directly to implementation.
- Still verify tests and linting before creating the PR.
- **Commit messages**: Describe what the commit does, NO issue references.
- **PR description**: Contains "Closes #$ARGUMENTS" to link the PR to the issue.
