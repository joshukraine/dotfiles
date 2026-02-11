# Sprint Issue Command

Quickly resolve a housekeeping or non-critical GitHub issue with a streamlined
workflow. Use `/resolve-issue` for critical work that needs full checkpoints.

## Your task

### Step 1: Get issue details and prepare

- Run `gh issue view $ARGUMENTS` to get issue details.
- Briefly assess scope and identify files that need changes.
- **If already on a feature branch** (e.g., from `/setup-sprint`): confirm the
  branch name matches the issue and proceed to Step 2.
- **If on main/master**: create a feature branch using the project's branch
  naming conventions (typically `chore/gh-$ARGUMENTS-short-description` or
  `fix/gh-$ARGUMENTS-short-description`).

### Step 2: Implement and verify

- Implement the fix with frequent commits following Conventional Commits.
- Run the project's linter (if configured) and fix any issues before
  proceeding.
- Run the project's test suite (if one exists) and ensure all tests pass.
- **Do NOT proceed if linting or tests fail.** If the project has no linter
  or test suite, skip the corresponding check and move on.

### Step 3: Create PR and report

- Push the branch and create a PR using `gh pr create`.
- PR description must include "Closes #$ARGUMENTS".
- Report: files changed, commits made, test/lint status.

## Important

- This command is for small, well-scoped housekeeping issues.
- Skip the implementation plan checkpoint — move directly to implementation.
- Still verify tests and linting before creating the PR.
- **Commit messages**: Describe what the commit does, NO issue references.
- **PR description**: Contains "Closes #$ARGUMENTS" to link the PR to the
  issue.
