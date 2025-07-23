# Development Utilities Documentation

Development-focused functions for navigation, clipboard operations, package management, and workflow optimization.

## Overview

Development utilities streamline common development tasks including:

- **Navigation**: Quick directory shortcuts
- **Clipboard Operations**: Path and text copying
- **Package Management**: Homebrew operations and abbreviation management
- **Path Utilities**: PATH manipulation and display

## Navigation Functions

### Directory Shortcuts (Abbreviations)

These abbreviations provide instant navigation to frequently used directories:

#### `cdot` - Navigate to Dotfiles

```bash
# Navigate to dotfiles directory
cdot
# Expands to: cd $DOTFILES
```

**Description**: Quick access to the dotfiles repository for configuration changes.

#### `cdxc` - Navigate to XDG Config

```bash
# Navigate to XDG config directory
cdxc
# Expands to: cd $XDG_CONFIG_HOME
```

**Description**: Access the main configuration directory (`~/.config` by default).

#### `cdnv` - Navigate to Neovim Config

```bash
# Navigate to Neovim configuration
cdnv
# Expands to: cd $XDG_CONFIG_HOME/nvim
```

**Description**: Quick access to Neovim configuration for customization.

#### `cdfi` - Navigate to Fish Config

```bash
# Navigate to Fish shell configuration
cdfi
# Expands to: cd $XDG_CONFIG_HOME/fish
```

**Description**: Access Fish shell configuration directory.

### Usage Examples

```bash
# Quick config editing workflow
cdnv                    # Go to Neovim config
nvim lua/config/lazy.lua    # Edit configuration
cdot                    # Return to dotfiles
git add nvim/           # Stage changes
```

## Clipboard Operations

### `copy` - Copy to Clipboard

Simple utility to copy text to the system clipboard.

```bash
# Copy text to clipboard
copy "Hello, World!"

# Copy command output to clipboard
echo "some text" | copy

# Copy file contents to clipboard
cat file.txt | copy
```

**Implementation:**

- Uses `pbcopy` on macOS
- Joins all arguments with spaces
- No trailing newline added

### `copycwd` - Copy Current Directory

Interactive utility to copy the current working directory path with formatting options.

```bash
# Copy current directory (interactive prompt for format)
copycwd

# Available formats:
# 1. Home directory format: ~/dotfiles
# 2. Environment variable format: $HOME/dotfiles
# 3. Full path format: /Users/username/dotfiles
```

**Features:**

- Interactive format selection
- Automatic clipboard copying
- Visual confirmation of copied path
- Handles paths containing spaces

**Usage Examples:**

```bash
# In ~/dotfiles directory
copycwd
# Prompts:
# 1. ~/dotfiles
# 2. $HOME/dotfiles
# 3. /Users/username/dotfiles
# Select format: 1
# Copied: ~/dotfiles
```

## Package Management

### `bubo` - Homebrew Update and Outdated

Convenience function for Homebrew maintenance.

```bash
# Update Homebrew and show outdated packages
bubo

# Equivalent to:
# brew update && brew outdated
```

**Description**:

- Updates Homebrew package database
- Lists all outdated packages
- Useful for maintenance workflows

**Typical Workflow:**

```bash
bubo                    # Check for updates
brew upgrade package    # Upgrade specific packages
brew upgrade           # Upgrade all packages
```

### `reload-abbr` - Regenerate Abbreviations

Regenerates shell abbreviations from the shared YAML source.

```bash
# Regenerate abbreviations for current shell
reload-abbr

# Get help
reload-abbr --help

# Run from any directory (automatically finds dotfiles)
cd /some/other/directory
reload-abbr            # Still works
```

**Features:**

- Works from any directory
- Automatically detects current shell (Fish/Zsh)
- Regenerates abbreviations from `shared/abbreviations.yaml`
- Provides feedback on completion
- Maintains abbreviation state between shell sessions

**Use Cases:**

- After modifying `shared/abbreviations.yaml`
- When abbreviations aren't working properly
- Initial setup of abbreviations
- Testing abbreviation changes

## Path Utilities

### `path` - Display PATH Entries

Displays PATH environment variable entries in a readable format.

```bash
# Display all PATH entries with line numbers
path

# Example output:
# 1  /opt/homebrew/bin
# 2  /opt/homebrew/sbin
# 3  /usr/local/bin
# 4  /usr/bin
# 5  /bin
# 6  /usr/sbin
# 7  /sbin
```

**Features:**

- Splits PATH by colons
- Numbers each entry for easy reference
- Helps debug PATH issues
- Useful for PATH manipulation scripts

**Common Use Cases:**

```bash
# Check if a directory is in PATH
path | grep "/usr/local/bin"

# Count PATH entries
path | wc -l

# Find duplicate entries
path | sort | uniq -d
```

## Cross-Shell Compatibility

### Implementation Details

| Function | Fish | Zsh | Implementation |
|----------|------|-----|----------------|
| Navigation Shortcuts | ✅ | ✅ | `shared/abbreviations.yaml` |
| `copy` | ✅ | ✅ | `bin/.local/bin/copy` |
| `copycwd` | ✅ | ✅ | Functions in both shells |
| `bubo` | ✅ | ✅ | `bin/.local/bin/bubo` |
| `reload-abbr` | ✅ | ✅ | Functions in both shells |
| `path` | ✅ | ✅ | Functions in both shells |
| `run-tests` | ✅ | ✅ | `bin/.local/bin/run-tests` |
| `lint-shell` | ✅ | ✅ | `bin/.local/bin/lint-shell` |

### Shared Configuration

Navigation shortcuts are defined in `shared/abbreviations.yaml`:

```yaml
# Navigation shortcuts
cdot: "cd $DOTFILES"
cdxc: "cd $XDG_CONFIG_HOME"
cdnv: "cd $XDG_CONFIG_HOME/nvim"
cdfi: "cd $XDG_CONFIG_HOME/fish"
```

Generated abbreviation files:

- **Fish**: `fish/.config/fish/abbreviations.fish` (generated)
- **Zsh**: `zsh/.config/zsh-abbr/abbreviations.zsh` (generated)

## Integration Examples

### Development Workflow

```bash
# Navigate to project
cdot
cd some-project/

# Copy project path for sharing
copycwd                 # Select format and copy

# Check project dependencies
bubo                    # Update Homebrew, check outdated

# Edit configuration
cdnv                    # Go to Neovim config
nvim .                  # Edit configuration

# Return and commit changes
cdot                    # Back to dotfiles
git add .
git commit -m "Update nvim config"
```

### Configuration Management

```bash
# Update abbreviations
cdot                    # Navigate to dotfiles
nvim shared/abbreviations.yaml  # Edit abbreviations
reload-abbr             # Regenerate abbreviations
# Test new abbreviations immediately
```

### PATH Debugging

```bash
# Check current PATH
path

# Identify issues
which command           # Find command location
path | grep "/problematic/path"  # Check for problematic entries

# After PATH modification
path                    # Verify changes
```

## Environment Variables

These functions rely on the following environment variables:

| Variable | Description | Default |
|----------|-------------|---------|
| `$DOTFILES` | Path to dotfiles directory | `~/dotfiles` |
| `$XDG_CONFIG_HOME` | XDG config directory | `~/.config` |
| `$HOME` | User home directory | System default |
| `$PATH` | System PATH variable | System configured |

Set in `shared/environment.sh` and `shared/environment.fish`.

## Testing and Quality Assurance

### `run-tests` - Test Runner

Comprehensive test runner for the dotfiles testing framework using bats-core.

```bash
# Run all tests
run-tests

# Run specific test categories
run-tests git               # Git function tests only
run-tests abbr              # Abbreviation tests only
run-tests utils             # Utility tests only
run-tests env               # Environment tests only

# Advanced options
run-tests --verbose         # Enable verbose output
run-tests --fast            # Skip setup, run tests immediately
run-tests --perf            # Show performance timing
run-tests --coverage        # Show coverage analysis

# Setup and installation
run-tests --install         # Install bats-core and dependencies
run-tests --setup           # Setup test environment only
```

**Features:**

- **Test Categories**: Supports running specific test suites (git, abbr, utils, env)
- **Performance Monitoring**: Tracks execution time and warns if tests exceed 2-minute target
- **Coverage Analysis**: Shows function counts vs test coverage
- **Dependency Management**: Can install required testing tools (bats-core, fish, zsh)
- **Environment Setup**: Automatically prepares test environment (permissions, abbreviations)

**Usage Examples:**

```bash
# First-time setup
run-tests --install         # Install dependencies
run-tests --setup           # Setup environment

# Development workflow
run-tests --fast git        # Quick git function tests
run-tests --verbose --perf  # Full tests with timing

# CI-like testing
run-tests                   # Complete test suite
```

**Output Example:**

```text
🔍 Running git function tests...
✅ test_gcom.bats: 8 tests passed
✅ test_gpum.bats: 6 tests passed
✅ test_grbm.bats: 7 tests passed
✅ test_gbrm.bats: 4 tests passed

Performance Results:
  Total execution time: 45s
  ✅ Tests completed within 2-minute target
```

### `lint-shell` - Shell Script Linter

Comprehensive shell script linter using shellcheck with project-specific configurations.

```bash
# Lint all shell scripts
lint-shell

# Advanced options
lint-shell --fix            # Apply automatic fixes (planned feature)
lint-shell --quiet          # Suppress informational output
lint-shell --exclude-tests  # Skip test files (*.bats)

# Help
lint-shell --help
```

**Features:**

- **Comprehensive Coverage**: Finds all shell scripts (*.sh, *.bash, *.bats, executables in bin/)
- **Shell Type Detection**: Automatically detects bash vs sh from shebangs
- **Smart Filtering**: Skips non-shell files (Ruby, Python, etc.)
- **Project Aware**: Configures shellcheck for project-specific patterns
- **Performance**: Uses timeouts to prevent hanging on problematic files

**File Detection Logic:**

```bash
# Files that are linted:
*.sh files              # Shell scripts
*.bash files            # Bash scripts
*.bats files            # Test files (unless --exclude-tests)
bin/.local/bin/*        # Executable scripts (filtered by shebang)

# Files that are skipped:
*.ruby, *.python files  # Non-shell interpreters
.git/ directory         # Version control files
```

**Usage Examples:**

```bash
# Check all scripts before commit
lint-shell

# Focus on non-test code
lint-shell --exclude-tests

# Quiet mode for CI
lint-shell --quiet

# Get help
lint-shell --help
```

**Output Example:**

```text
🔍 Linting shell scripts in /Users/name/dotfiles

Found 23 shell script(s) to lint:
[1/23] Checking bin/.local/bin/git-cm
[2/23] Checking bin/.local/bin/tat
[3/23] Checking setup.sh

✅ All shell scripts passed linting!
```

**Integration with Development Workflow:**

```bash
# Pre-commit workflow
lint-shell              # Check for issues
run-tests --fast git    # Quick test relevant functions
git add .               # Stage changes
git commit              # Commit (triggers pre-commit hooks)

# Full quality check
lint-shell              # Lint all scripts
run-tests --perf        # Run all tests with timing
run-tests --coverage    # Check test coverage
```

## Related Abbreviations

Development utilities work with these abbreviations:

| Abbreviation | Expansion | Category |
|--------------|-----------|----------|
| `reload` | `reload-abbr` | Package Management |
| `path` | `path` | System Utilities |
| `copy` | `copy` | Clipboard |

See [abbreviations reference](../abbreviations.md) for complete list.

## Troubleshooting

### Common Issues

1. **Navigation shortcuts not working**

   ```bash
   # Regenerate abbreviations
   reload-abbr
   # Restart shell
   src
   ```

2. **copycwd format selection issues**

   ```bash
   # Ensure interactive terminal
   # Function requires user input
   ```

3. **bubo command not found**

   ```bash
   # Ensure Homebrew is installed
   which brew
   # Check PATH includes Homebrew
   path | grep brew
   ```

4. **Environment variables not set**

   ```bash
   # Check variables
   echo $DOTFILES
   echo $XDG_CONFIG_HOME
   # Source environment files
   source ~/.config/fish/config.fish  # Fish
   source ~/.zshrc                     # Zsh
   ```

---

*Development utilities are designed to streamline common development workflows. For issues or feature requests, see the main repository.*
