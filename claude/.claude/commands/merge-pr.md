# Merge Pull Request Command

Merge a pull request with consistent practices: verify checks, squash merge, clean up the branch, and pull latest main.

## Command Options

- `$ARGUMENTS`: PR number (optional — defaults to the PR for the current branch)

## Your task

### Step 1: Identify the PR

- If a PR number was provided, use it
- Otherwise, detect from the current branch: `gh pr view --json number,title,state,headRefName,baseRefName`
- Confirm the PR exists and is open
- Display the PR title and number before proceeding

### Step 2: Verify merge readiness

Check each of the following and report status:

- **CI status**: Run `gh pr checks` to verify all required checks have passed
- **Merge conflicts**: Run `gh pr view --json mergeable` to verify no conflicts

If CI has not passed, **stop and report**. Do not proceed with the merge.

### Step 3: Merge the PR

- Squash merge: `gh pr merge --squash`
- Do **not** pass `--delete-branch` — GitHub is configured to auto-delete remote branches on merge. Local branch cleanup is handled in Step 4.

### Step 4: Update local state

After `gh pr merge` completes:

- Switch to the base branch (e.g., `main`, `master`, or whatever `baseRefName` was detected in Step 1) and pull: `git switch <base-branch> && git pull`
- Delete the local feature branch with `git branch -D <branch-name>` (force-delete is required because squash merges produce a different SHA, so `-d` cannot detect the branch as merged)

### Step 5: Confirm completion

Report:

```text
## Merge Complete

- PR: #N — [title]
- Remote branch: deleted
- Local branch: deleted (or kept — reason)
- Local main: up to date
```

## Important

- **Always squash merge.** This keeps main history clean with one commit per PR.
- **Do not merge if CI has not passed.** This is the one hard gate.
- **Do not amend or rewrite commits** as part of the merge process.
- **Squash merges require force-delete.** `git branch -d` cannot detect squash-merged branches, so `-D` is the correct flag for cleanup after a confirmed merge.
