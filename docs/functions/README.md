# Shell Functions Documentation

Comprehensive documentation for all custom shell functions available in this dotfiles configuration.

## Overview

This dotfiles configuration provides **37 custom functions** across Fish and Zsh shells, organized into the following categories:

- **[Git Functions](#git-functions)**: Smart Git operations with branch detection
- **[Development Utilities](#development-utilities)**: Navigation, clipboard, and package management
- **[Tmux Functions](#tmux-functions)**: Session management and configuration
- **[System Functions](#system-functions)**: File system, command wrappers, and utilities

## Quick Reference

### Most Frequently Used Functions

| Function | Description | Category |
|----------|-------------|----------|
| `cdot` | Navigate to dotfiles directory | Navigation |
| `cdxc` | Navigate to XDG config directory | Navigation |
| `gcom` | Switch to default Git branch | Git |
| `gpum` | Push current branch with upstream | Git |
| `tat` | Attach/create tmux session for current dir | Tmux |
| `src` | Reload shell configuration | System |

### Function Categories

#### Git Functions

- **Smart Git Operations**: `gcom`, `gpum`, `grbm`, `gbrm`
- **Git Utilities**: `g`, `gl`, `glg`, `git-cm`, `git-check-uncommitted`

#### Development Utilities

- **Navigation**: `cdot`, `cdxc`, `cdnv`, `cdfi`
- **Clipboard**: `copy`, `copycwd`
- **Package Management**: `bubo`, `reload-abbr`
- **Path Utilities**: `path`
- **Testing & QA**: `run-tests`, `lint-shell`

#### Tmux Functions

- **Session Management**: `tat`, `tna`, `ta`, `tk`, `tka`, `tn`
- **Configuration**: `tsrc`

#### System Functions

- **File System**: `fs`, `dsx`, `sha256`
- **Command Wrappers**: `cat`, `htop`, `l`, `ll`, `la`
- **Development Tools**: `pi`, `rlv`, `saf`, `haf`

## Documentation Format

All functions follow a standardized documentation format:

```bash
# Brief description of what the function does
#
# Usage: function_name [args...]
# Arguments:
#   $1 - Description of first argument
#   $2 - Description of second argument (optional)
#
# Examples:
#   function_name arg1        # Description of example
#   function_name arg1 arg2   # Another example
#
# Returns: Description of return value/behavior
```

## Cross-Shell Compatibility

| Function Type | Fish Support | Zsh Support | Implementation |
|---------------|--------------|-------------|----------------|
| Git Functions | ✅ | ✅ | Shared logic in both shells |
| Tmux Functions | ✅ | ✅ | Shared scripts in `bin/` |
| Navigation | ✅ | ✅ | Abbreviations in shared YAML |
| Command Wrappers | ✅ | ⚠️ | Primary implementation in Fish |
| System Utilities | ✅ | ✅ | Functions in both shells |

## Detailed Documentation

- **[Git Functions](git-functions.md)**: Smart Git operations and utilities
- **[Development Utilities](development.md)**: Navigation, clipboard, and development tools
- **[Tmux Functions](tmux.md)**: Complete tmux session management guide
- **[System Functions](system.md)**: File system operations and command wrappers

## Related Documentation

- **[Abbreviations Reference](../abbreviations.md)**: Complete list of shell abbreviations
- **[Setup Guide](../../README.md#setup)**: Installation and configuration instructions
- **[Contributing](../../CONTRIBUTING.md)**: Guidelines for adding new functions

## Getting Help

Most complex functions include built-in help. Try:

```bash
# Functions with help flags
gcom --help
gpum --help
grbm --help
reload-abbr --help

# Functions with usage checks
ta                  # Shows usage when called without arguments
tk                  # Shows usage when called without arguments
tn                  # Shows usage when called without arguments
sha256              # Shows usage when called without arguments
```

## Function Index

### A-C

- `cat` - bat wrapper for syntax highlighting
- `copy` - Copy text to clipboard
- `copycwd` - Copy current working directory to clipboard

### D-F

- `dsx` - Remove .DS_Store files recursively
- `fs` - Get file or directory size

### G

- `g` - Smart git wrapper (shows status or runs git command)
- `gbrm` - Remove branches merged into default branch
- `gcom` - Switch to default Git branch with optional pull
- `git-check-uncommitted` - Check for uncommitted changes
- `git-cm` - Git commit wrapper
- `gl` - Pretty git log
- `glg` - Pretty git log with graph and stats
- `gpum` - Push current branch to origin with upstream tracking
- `grbm` - Rebase current branch against default branch

### H-L

- `haf` - Hide all files in Finder
- `htop` - sudo htop wrapper
- `l`, `ll`, `la` - Enhanced ls with exa/eza
- `lint-shell` - Comprehensive shell script linter

### P

- `path` - Display PATH entries with line numbers
- `pi` - Ping utility with default target

### R

- `reload-abbr` - Regenerate abbreviations from shared YAML source
- `rlv` - List Ruby versions
- `run-tests` - Test runner for dotfiles testing framework

### S

- `saf` - Show all files in Finder
- `sha256` - Verify SHA256 checksum
- `src` - Reload shell configuration

### T

- `ta` - Attach to existing tmux session by name
- `tat` - Attach or create tmux session named after current directory
- `tk` - Kill tmux session by name
- `tka` - Kill all tmux sessions
- `tn` - Create new tmux session with specific name
- `tna` - Create/attach tmux session named after current directory
- `tsrc` - Source tmux configuration file

### Navigation Shortcuts (Abbreviations)

- `cdot` - Navigate to dotfiles directory (`cd $DOTFILES`)
- `cdxc` - Navigate to XDG config directory (`cd $XDG_CONFIG_HOME`)
- `cdnv` - Navigate to Neovim config (`cd $XDG_CONFIG_HOME/nvim`)
- `cdfi` - Navigate to Fish config (`cd $XDG_CONFIG_HOME/fish`)

---

*This documentation is part of the comprehensive dotfiles improvement plan. For issues or contributions, see the main repository.*
