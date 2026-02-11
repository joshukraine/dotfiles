# Setup Sprint Command

Prepare parallel Git worktrees for a batch of issues filtered by label.
This command sets up the workspace but does not start Claude Code instances
or begin implementation.

## Your task

### Step 1: Verify starting point

- Confirm the current branch is `main` (or the repository's default branch).
  If not, ask the user before proceeding.
- Run `git pull` to ensure `main` is up to date. Worktrees branch from the
  current HEAD, so starting from stale history creates merge headaches later.

### Step 2: Find issues

- Determine the project name from the current directory basename (e.g., if
  working in `/home/user/projects/comix-distro`, the project name is
  `comix-distro`).
- Run `gh issue list --label $ARGUMENTS --state open --json number,title`
  to find all open issues with the specified label.
- Present the list to the user.

**CHECKPOINT**: Confirm which issues to include and in what order. The user
may exclude issues (e.g., if two touch the same files and should be done
sequentially) or adjust the batch.

### Step 3: Create worktrees

For each confirmed issue:

- Determine the branch prefix from the issue title or label:
  - `chore/` for housekeeping, cleanup, or refactoring
  - `fix/` for bug fixes
  - `feat/` for enhancements or new features
  - `docs/` for documentation-only changes
- Generate a short kebab-case description from the issue title (3-5 words max).
- Create the worktree:

```bash
git worktree add ../<project-name>-issue-<number> -b <prefix>/gh-<number>-<short-description>
```

### Step 4: Apply sprint permissions

- Check if `~/.claude/presets/sprint-permissions.json` exists.
- If it exists, copy it into each worktree's `.claude/settings.local.json`.
- If it does not exist, skip this step and note that sprint permissions were
  not applied.

### Step 5: Report

Present a summary with copy-ready commands:

```text
Project: <project-name>
Worktrees created:
  ../<project-name>-issue-51  →  chore/gh-51-fix-linting-errors
  ../<project-name>-issue-52  →  fix/gh-52-update-readme-links

Sprint permissions: applied (or: not found — skipped)

To start working, open a separate terminal for each worktree:
  cd ../<project-name>-issue-51 && claude
  cd ../<project-name>-issue-52 && claude

Then in each Claude Code session:
  /sprint-issue <number>
```

## Important

- This command creates worktrees and copies permission files only. It does
  not start Claude Code instances, write application code, or begin
  implementation.
- The checkpoint in Step 2 is a hard stop. Do not create worktrees without
  user confirmation.
- If `bundle install` or similar dependency setup is needed in each worktree,
  mention it in the report but do not run it.
