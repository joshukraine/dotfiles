# Git Functions Documentation

Comprehensive guide to smart Git operations and utilities in this dotfiles configuration.

## Overview

The Git functions provide intelligent branch detection, automated workflows, and
enhanced Git commands that simplify common development tasks. All functions
support both `main` and `master` as default branches.

## Smart Git Functions

### Core Smart Functions (With Help Flags)

#### `gcom` - Switch to Default Branch

Intelligently switches to the repository's default branch (`main` or `master`)
with optional pull.

```bash
# Switch to default branch
gcom

# Switch to default branch and pull latest changes
gcom --pull

# Get help
gcom --help
```

**Features:**

- Automatically detects `main` or `master` as default branch
- Handles uncommitted changes gracefully
- Optional pull from origin
- Safe error handling with informative messages

#### `gpum` - Push with Upstream Tracking

Pushes the current branch to origin and sets up upstream tracking.

```bash
# Push current branch and set upstream
gpum

# Get help
gpum --help
```

**Features:**

- Automatically sets upstream tracking for new branches
- Works with any branch name
- Provides clear feedback on push status

#### `grbm` - Rebase Against Default Branch

Rebases the current branch against the default branch with latest changes.

```bash
# Rebase current branch against default
grbm

# Get help
grbm --help
```

**Features:**

- Fetches latest changes before rebasing
- Detects default branch automatically
- Checks for uncommitted changes
- Handles rebase conflicts gracefully

#### `gbrm` - Remove Merged Branches

Removes local branches that have been merged into the default branch.

```bash
# Remove all merged branches (interactive)
gbrm

# Force remove without confirmation
gbrm --force

# Get help
gbrm --help
```

**Features:**

- Interactive confirmation by default
- Protects current branch and default branch
- Only removes branches merged into default
- Shows count of removed branches

## Git Utilities

### `g` - Smart Git Wrapper

Wrapper that shows git status when called without arguments, otherwise runs git commands.

```bash
# Show git status
g

# Run any git command
g log --oneline
g commit -m "message"
g push origin main
```

**Usage Pattern:**

- No arguments → `git status`
- With arguments → `git [arguments]`

### `gl` - Pretty Git Log

Enhanced git log with formatting and date information.

```bash
# Show formatted git log
gl

# Show last 10 commits
gl -10

# Show commits since date
gl --since="2 weeks ago"
```

**Output Format:**

- Commit hash (short)
- Commit date
- Author name
- Commit message

### `glg` - Git Log with Graph

Enhanced git log with graph visualization and file statistics.

```bash
# Show git log with graph
glg

# Show last 5 commits with graph
glg -5
```

**Features:**

- Visual branch graph
- File change statistics
- Color-coded output
- Commit relationships

### `gll` - Detailed Graph Git Log

Comprehensive git log with detailed graph formatting, color highlighting, and rich commit information.

```bash
# Show detailed formatted git log
gll

# Show last 10 commits with detailed formatting
gll -10

# Show commits since a specific date
gll --since="1 week ago"

# Show commits by specific author
gll --author="John Doe"

# Get help
gll --help
```

**Features:**

- Detailed graph visualization with branch structure
- Color-coded commit hashes (bold blue)
- Relative dates in parentheses (bold green)
- Author names with em dash separator (bold white)
- Branch decorations in yellow
- Abbreviated commit hashes for cleaner display
- Support for all standard git log options
- Built-in help documentation

**Output Format:**

```text
* a1b2c3d - (2 hours ago) Add new feature — John Doe (HEAD -> feature/branch)
* e4f5g6h - (1 day ago) Fix bug in user authentication — Jane Smith
* i7j8k9l - (3 days ago) Update documentation — Bob Johnson (origin/main, main)
```

**Use Cases:**

- Detailed commit history review
- Branch relationship analysis
- Code review preparation
- Release planning and commit tracking

### `git-cm` - Commit Wrapper

Intelligent commit wrapper that handles messages and editor scenarios.

```bash
# Commit with message
git-cm "Add new feature"

# Open editor for commit message
git-cm

# Commit with multi-line message
git-cm "Feature: Add user auth

- Add login/logout functionality
- Add session management
- Add password validation"
```

**Behavior:**

- With arguments → Commits with provided message
- Without arguments → Opens default editor
- Preserves git commit options

### `git-check-uncommitted` - Uncommitted Changes Check

Utility to check for uncommitted changes with optional user prompt.

```bash
# Check for uncommitted changes (exit code only)
git-check-uncommitted

# Check with user prompt for confirmation
git-check-uncommitted --prompt

# Use in scripts
if git-check-uncommitted; then
  echo "Repository is clean"
else
  echo "Uncommitted changes detected"
fi
```

**Exit Codes:**

- `0` - No uncommitted changes
- `1` - Uncommitted changes detected
- `2` - Error (not a git repository)

**With `--prompt` flag:**

- Prompts user to continue if uncommitted changes found
- Returns appropriate exit code based on user choice

### `git-brst` - Branch Status Overview

Display ahead/behind status for all branches compared to origin/master.

```bash
# Show all branches with their status
git-brst
```

**Output Example:**

```text
dns_check (ahead 1) | (behind 112) origin/master
feature-branch (ahead 3) | (behind 0) origin/master
master (ahead 0) | (behind 0) origin/master
```

**Use Cases:**

- Review branch status before rebasing
- Identify stale branches
- Check deployment readiness

### `git-publish` - Push Branch to Origin

Push current branch to origin and set up tracking relationship.

```bash
# Push current branch to origin
git-publish
```

**Features:**

- Creates upstream tracking branch
- Uses same name as local branch
- Refuses to publish master branch for safety
- Ruby implementation for cross-platform compatibility

### `git-uncommit` - Undo Last Commit

Undo the last commit while preserving changes in the working directory.

```bash
# Undo last commit, keep changes unstaged
git-uncommit
```

**Safety Features:**

- Only works with clean working directory
- Shows branch name and previous commit SHA
- Aborts if uncommitted changes exist
- Leaves changes unstaged for review

**Example Output:**

```text
Branch feature-xyz was abc123def
```

## Integration Examples

### Typical Workflow

```bash
# Start feature development
git checkout -b feature/new-feature

# Make changes and commit
git add .
git-cm "Implement new feature"

# Push branch with upstream tracking
gpum

# Rebase against latest default branch
grbm

# Switch back to default branch
gcom --pull

# Clean up merged branches
gbrm
```

### Script Integration

```bash
#!/bin/bash
# deployment-check.sh

# Ensure we're on default branch
gcom || { echo "Failed to switch to default branch"; exit 1; }

# Check for uncommitted changes
git-check-uncommitted --prompt || { echo "Deployment cancelled"; exit 1; }

# Fetch latest and rebase
grbm || { echo "Rebase failed"; exit 1; }

echo "Ready for deployment"
```

## Cross-Shell Implementation

### Function Availability

| Function | Fish | Zsh | Implementation Location |
|----------|------|-----|------------------------|
| `gcom` | ✅ | ✅ | `fish/functions/gcom.fish`, `zsh/functions.zsh` |
| `gpum` | ✅ | ✅ | `fish/functions/gpum.fish`, `zsh/functions.zsh` |
| `grbm` | ✅ | ✅ | `fish/functions/grbm.fish`, `zsh/functions.zsh` |
| `gbrm` | ✅ | ✅ | `bin/.local/bin/gbrm` (shared script) |
| `g` | ✅ | ✅ | `bin/.local/bin/g` (shared script) |
| `gl` | ✅ | ✅ | `bin/.local/bin/gl` (shared script) |
| `glg` | ✅ | ✅ | `bin/.local/bin/glg` (shared script) |
| `gll` | ✅ | ✅ | `fish/functions/gll.fish`, `zsh/functions.zsh` |
| `git-cm` | ✅ | ✅ | `bin/.local/bin/git-cm` (shared script) |
| `git-check-uncommitted` | ✅ | ✅ | `bin/.local/bin/git-check-uncommitted` (shared script) |
| `git-brst` | ✅ | ✅ | `bin/.local/bin/git-brst` (shared script) |
| `git-publish` | ✅ | ✅ | `bin/.local/bin/git-publish` (shared script) |
| `git-uncommit` | ✅ | ✅ | `bin/.local/bin/git-uncommit` (shared script) |

### Shared Logic

The smart git functions (`gcom`, `gpum`, `grbm`) share identical logic between
Fish and Zsh implementations:

1. **Default Branch Detection**: Both shells use the same branch detection algorithm
2. **Error Handling**: Consistent error messages and exit codes
3. **Help System**: Both support `--help` flag with identical output
4. **Safety Checks**: Same validation for uncommitted changes and repository status

## Error Handling

### Common Error Scenarios

1. **Not a Git Repository**

   ```bash
   $ gcom
   Error: Not a git repository
   ```

2. **Uncommitted Changes**

   ```bash
   $ gcom
   Error: You have uncommitted changes. Please commit or stash them first.
   ```

3. **No Default Branch Found**

   ```bash
   $ gcom
   Error: Could not determine default branch (no main or master found)
   ```

4. **Network Issues**

   ```bash
   $ gcom --pull
   Error: Failed to pull from origin
   ```

### Recovery Strategies

- **Uncommitted Changes**: Use `git stash` or commit changes first
- **Network Issues**: Check connectivity and repository access
- **Detached HEAD**: Switch to a named branch first
- **Merge Conflicts**: Resolve conflicts before continuing with operations

## Testing

All git functions include comprehensive test coverage in `tests/git_functions/`:

- `test_gcom.bats` - Tests for gcom function
- `test_gpum.bats` - Tests for gpum function
- `test_grbm.bats` - Tests for grbm function
- `test_gbrm.bats` - Tests for gbrm function

Run tests with:

```bash
# Run all git function tests
bats tests/git_functions/

# Run specific function tests
bats tests/git_functions/test_gcom.bats
```

## Related Abbreviations

The following abbreviations complement the git functions:

| Abbreviation | Expansion | Description |
|--------------|-----------|-------------|
| `ga` | `git add` | Stage files |
| `gaa` | `git add --all` | Stage all files |
| `gcm` | `git-cm` | Commit with message |
| `gst` | `git status` | Repository status |
| `gp` | `git push` | Push changes |
| `gpl` | `git pull` | Pull changes |
| `gpub` | `git publish` | Push branch to origin |

See [abbreviations reference](../abbreviations.md) for complete list.

---

*For issues or contributions related to git functions, see the main repository issues.*
