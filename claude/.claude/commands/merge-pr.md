# Merge Pull Request Command

Merge a pull request with consistent practices: verify checks, squash merge, clean up the branch, and pull latest main.

## Command Options

- `$ARGUMENTS`: PR number (optional — defaults to the PR for the current branch)
- `--rebase`: Use rebase merge instead of squash merge
- `--no-delete`: Keep the remote branch after merging

## Your task

### Step 1: Identify the PR

- If a PR number was provided, use it
- Otherwise, detect from the current branch: `gh pr view --json number,title,state,headRefName,baseRefName`
- Confirm the PR exists and is open
- Display the PR title and number for confirmation

### Step 2: Verify merge readiness

Check each of the following and report status:

- **CI status**: Run `gh pr checks` to verify all required checks have passed
- **Review status**: Run `gh pr view --json reviewDecision` to check review state
- **Merge conflicts**: Run `gh pr view --json mergeable` to verify no conflicts

If CI has not passed, **stop and report**. Do not proceed with the merge.

If reviews are pending or changes requested, **warn** but allow the user to decide whether to proceed (some repos don't require formal reviews).

### Step 3: Merge the PR

- **Default: squash merge** — `gh pr merge --squash`
- If `--rebase` flag is provided, use `gh pr merge --rebase` instead
- The `--delete-branch` flag is included by default to remove the remote branch after merge. Skip if `--no-delete` is provided.

### Step 4: Update local state

- Switch to main: `git switch main`
- Pull latest: `git pull`
- Delete the local feature branch: `git branch -d <branch-name>`

If the local branch delete fails (e.g., unmerged changes warning), report this but do not force-delete. The user may have local work they want to preserve.

### Step 5: Confirm completion

Report:

```text
## Merge Complete

- PR: #N — [title]
- Merge method: squash (or rebase)
- Remote branch: deleted (or kept)
- Local branch: deleted (or kept — reason)
- Local main: up to date
```

## Important

- **Squash merge is the default.** This keeps main history clean with one commit per PR. Only use rebase when explicitly requested.
- **Do not force-delete local branches.** If `git branch -d` fails, report it and let the user decide.
- **Do not merge if CI has not passed.** This is the one hard gate.
- **Do not amend or rewrite commits** as part of the merge process.
