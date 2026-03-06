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

- Squash merge: `gh pr merge --squash --delete-branch`

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
- Remote branch: deleted
- Local branch: deleted (or kept — reason)
- Local main: up to date
```

## Important

- **Always squash merge.** This keeps main history clean with one commit per PR.
- **Do not force-delete local branches.** If `git branch -d` fails, report it and let the user decide.
- **Do not merge if CI has not passed.** This is the one hard gate.
- **Do not amend or rewrite commits** as part of the merge process.
