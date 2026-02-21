# Workflow Guide

A project-agnostic guide covering GitHub Projects setup, Claude Code permission presets, Git worktrees, and sprint workflows. Apply these patterns to any project that uses the label taxonomy and Conventional Commits.

---

## Part 1: GitHub Projects Setup

### Step 1: Create the Project

1. Go to **github.com** → your profile or organization → **Projects** tab → **New project**.
2. Select **Board** layout.
3. Name it to match the repository (e.g., "My Project Board").
4. Link the repository under **Settings → Manage access → Link a repository**.

### Step 2: Configure Columns

Create 5 status columns in this order:

| Column | Purpose |
| -------- | --------- |
| **Backlog** | Triaged issues not yet scheduled |
| **Up Next** | Committed to for the current or next sprint |
| **In Progress** | Actively being worked on |
| **In Review** | PR open, awaiting review |
| **Done** | Merged and closed |

Delete any default columns that don't match (e.g., "Todo", "In progress", "Done" may need renaming).

### Step 3: Add Existing Issues

1. Click **+ Add item** at the bottom of any column.
2. Search for and add open issues from the linked repository.
3. Drag each issue to the appropriate column.

### Step 4: Enable Auto-Workflows

Under **Workflows** (in the project's `...` menu):

- **Item closed** → move to **Done**
- **Pull request merged** → move to **Done**
- **Item reopened** → move to **Backlog**

### Step 5: Add the Priority Field

1. Click **+** next to the field headers → **New field**.
2. Name: `Priority`, Type: **Single select**.
3. Add three options:
   - :rotating_light: Critical
   - Normal (no emoji)
   - :ice_cube: Low

### Using the Board Day-to-Day

- **Starting work:** Move the issue from **Up Next** to **In Progress**. Create the branch.
- **Opening a PR:** Move to **In Review**. Link the PR to the issue.
- **PR merged:** Auto-workflow moves it to **Done**.
- **Blocked:** Add the `blocked` label. Leave in current column but note the blocker in a comment.

---

## Part 2: Claude Code Permission Presets

### Where Permissions Live

Claude Code reads permissions from three files, in order of precedence:

| File | Scope | Managed By |
| ------ | ------- | ------------ |
| `~/.claude/settings.json` | All projects (user-level) | You |
| `.claude/settings.json` | This project (repo-level, committed) | Team |
| `.claude/settings.local.json` | This project (local, gitignored) | You |

Later files override earlier ones. Project-level settings override user-level settings.

### The Preset System

Presets use a **base + overlay** architecture:

| Layer | Purpose | Example |
| ------- | --------- | --------- |
| **Base** | Permissions safe for all projects | Read files, run linters, run tests |
| **Sprint overlay** | Additional permissions for active development | Git operations, database commands, dev server |
| **Project overlay** | Project-specific tools and commands | Framework CLI, deployment scripts |

The base layer is always active. Overlays are applied on top when needed.

### Applying Presets

Use shell functions to switch between permission sets:

```bash
# In your shell profile (~/.zshrc or ~/.bashrc)

# Apply sprint permissions for active development
claude-sprint() {
  cp ~/.claude/presets/sprint.json .claude/settings.local.json
  echo "Sprint permissions applied."
}

# Reset to base permissions
claude-base() {
  rm -f .claude/settings.local.json
  echo "Reset to base permissions."
}
```

### What the Presets Cover

**Base permissions** (always active):

- File reading and searching
- Running linters and formatters
- Running tests
- Git status and log (read-only git)

**Sprint overlay** (active during development):

- Git add, commit, branch, checkout, merge
- Database migration and seed commands
- Dev server start/stop
- Package install commands

**Deny rules** (never permitted, regardless of overlay):

- `git push --force` to main/master
- Production database commands
- Credential or secret file access
- Package publishing

### Combining with Auto-Accept Mode

When using `claude --dangerously-skip-permissions`, the preset system is bypassed entirely. Use this only for trusted, well-understood operations in isolated environments (e.g., a worktree you plan to discard).

---

## Part 3: Git Worktrees for Parallel Development

### Concept

Git worktrees let you work on multiple branches simultaneously without stashing or switching. Each worktree is a separate directory with its own working tree, sharing the same Git history.

```text
my-project/                  # Main worktree (main branch)
my-project-worktrees/
  feat-gh-42-auth/           # Worktree for feature work
  fix-gh-87-pagination/      # Worktree for bug fix
```

### Setup

```bash
# Create a worktree for a new feature branch
git worktree add ../my-project-worktrees/feat-gh-42-auth -b feat/gh-42-auth

# Create a worktree from an existing branch
git worktree add ../my-project-worktrees/fix-gh-87-pagination fix/gh-87-pagination

# List all worktrees
git worktree list
```

### Working in Worktrees

Each worktree is a full working directory. Run commands normally:

```bash
cd ../my-project-worktrees/feat-gh-42-auth
bin/dev          # Start the dev server
bin/rails test   # Run tests
```

Dependencies may need to be installed separately in each worktree if the project uses local node_modules or similar.

### Sprint Permissions in Worktrees

Apply the sprint overlay in each worktree independently:

```bash
cd ../my-project-worktrees/feat-gh-42-auth
claude-sprint    # Apply sprint permissions to this worktree
```

The `.claude/settings.local.json` file is per-worktree, so permissions in one worktree don't affect another.

### Merging and Cleanup

```bash
# From the main worktree, merge the feature branch
git merge feat/gh-42-auth

# Remove the worktree
git worktree remove ../my-project-worktrees/feat-gh-42-auth

# Prune stale worktree references
git worktree prune
```

### Practical Tips

- **Name worktrees after branches** to keep the mapping obvious.
- **Don't nest worktrees** inside the main repo directory — put them in a sibling directory.
- **Run `git worktree list`** periodically to clean up forgotten worktrees.
- **Each worktree has its own index** — changes in one worktree don't appear as unstaged in another.
- **Shared objects** — all worktrees share the same `.git/objects`, so disk usage is minimal.

---

## Part 4: Slash Command Updates

### Existing Commands

Custom slash commands live in `~/.claude/commands/` and `.claude/commands/` within each project. These commands integrate with the label taxonomy and workflow patterns.

### /sprint-issue

Creates a single GitHub issue with:

- A type label (`feat`, `fix`, `chore`, `docs`, `test`)
- Priority assignment
- Board column placement (Up Next)
- Branch name suggestion following the naming convention

### /setup-sprint

Bulk-creates issues for a sprint:

- Accepts a list of tasks with types and priorities
- Creates all issues with appropriate labels
- Adds all issues to the project board in the Up Next column
- Outputs a summary of created issues

### Worktree Awareness

Slash commands detect whether they are running in a worktree and adjust behavior:

- Branch creation commands skip creating a new branch if the worktree already has a feature branch checked out.
- Status commands show the worktree path for context.

---

## Putting It All Together: The Sprint

### Before the Sprint

1. **Identify work items** from the backlog or new requirements.
2. **Create issues** using `/sprint-issue` or `/setup-sprint`. Each issue gets a type label and priority.
3. **Order the board** — drag issues in **Up Next** into the planned sequence.
4. **Review PRD sections** relevant to the sprint's work.

### During the Sprint

1. **Pick an issue** from the top of **Up Next**.
2. **Move it to In Progress** on the board.
3. **Create a branch** following the naming convention: `<type>/gh-<#>-<description>`.
4. **Apply sprint permissions** if not already active.
5. **Implement** — reference the PRD, follow conventions, write tests.
6. **Open a PR** — move the issue to **In Review**. Reference the issue with `Closes #<number>` in the PR description.
7. **Merge** — the auto-workflow moves the issue to **Done**.
8. **Log any PRD deviations** in `docs/prd/CHANGELOG.md`.

### After the Sprint

1. **Review the board** — all sprint items should be in **Done** or explained.
2. **Sync the PRD** — if CHANGELOG entries have accumulated, fold changes back into the PRD files.
3. **Clean up worktrees** if any were created for the sprint.
4. **Reset permissions** back to base if sprint overlay was applied.
5. **Retrospective** — note what worked and what to adjust for the next sprint.

---

## Quick Reference

| Task | Command / Action |
| ------ | ----------------- |
| Create a sprint issue | `/sprint-issue` |
| Bulk-create sprint issues | `/setup-sprint` |
| Apply sprint permissions | `claude-sprint` |
| Reset to base permissions | `claude-base` |
| Create a worktree | `git worktree add ../worktrees/<name> -b <branch>` |
| List worktrees | `git worktree list` |
| Remove a worktree | `git worktree remove ../worktrees/<name>` |
| Move issue to In Progress | Drag on project board |
| Log a PRD deviation | Add entry to `docs/prd/CHANGELOG.md` |
| Sync PRD after sprint | Review CHANGELOG, update PRD files, clear entries |
