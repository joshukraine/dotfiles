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

### Step 4: Detect worktree context

Before updating local state, determine whether you are inside a git worktree:

```bash
git rev-parse --git-dir
git rev-parse --git-common-dir
```

- If these values are **identical**, you are in a normal repo — proceed with Step 5a.
- If they **differ**, you are in a worktree — proceed with Step 5b.

### Step 5a: Update local state (normal repo)

After `gh pr merge` completes:

- Switch to the base branch (e.g., `main`, `master`, or whatever `baseRefName` was detected in Step 1) and pull: `git switch <base-branch> && git pull`
- Delete the local feature branch with `git branch -D <branch-name>` (force-delete is required because squash merges produce a different SHA, so `-d` cannot detect the branch as merged)

Then skip to Step 6.

### Step 5b: Update local state (worktree)

When inside a worktree, `git switch` to the base branch will fail because it is checked out in another worktree. Handle this differently:

1. **Find the primary worktree** on the base branch:

   ```bash
   git worktree list --porcelain
   ```

   Parse the output to find the worktree entry whose `branch` matches `refs/heads/<base-branch>`. Extract its path.

2. **Pull the base branch** from the primary worktree:

   ```bash
   git -C <primary-worktree-path> pull
   ```

3. **Do not delete the branch or remove the worktree automatically.** The branch cannot be deleted while it is checked out in a worktree, and removing the worktree would destroy the user's current working directory. Instead, provide the cleanup commands in the completion report.

### Step 6: Confirm completion

**Normal repo** — report:

```text
## Merge Complete

- PR: #N — [title]
- Remote branch: deleted
- Local branch: deleted (or kept — reason)
- Local main: up to date
```

**Worktree** — report:

```text
## Merge Complete

- PR: #N — [title]
- Remote branch: deleted
- Local main: up to date (pulled in primary worktree)

## Worktree cleanup (run from outside this directory)

    git worktree remove <this-worktree-path>
    git branch -D <branch-name>
```

## Important

- **Always squash merge.** This keeps main history clean with one commit per PR.
- **Do not merge if CI has not passed.** This is the one hard gate.
- **Do not amend or rewrite commits** as part of the merge process.
- **Squash merges require force-delete.** `git branch -d` cannot detect squash-merged branches, so `-D` is the correct flag for cleanup after a confirmed merge.
