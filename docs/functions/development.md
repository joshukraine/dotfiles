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
