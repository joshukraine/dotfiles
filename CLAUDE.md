# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is a personal dotfiles repository for macOS using GNU Stow for symlink management. It provides a comprehensive development environment configuration including Zsh shell setup, terminal configurations (ghostty/kitty), and Neovim with LazyVim distribution.

## Repository Structure

The repository is organized with each top-level directory representing a tool or application configuration:

- `asdf/` - asdf version manager configuration
- `bash/` - Bash shell configuration
- `bin/` - Custom shell scripts and utilities
- `brew/` - Homebrew Brewfile for package management
- `claude/` - Claude AI assistant configuration
- `ghostty/` - Ghostty terminal emulator configuration
- `git/` - Git configuration and global gitignore
- `kitty/` - Kitty terminal emulator configuration
- `laptop/` - Laptop setup scripts and configuration
- `lazygit/` - Lazygit terminal UI configuration
- `markdown/` - Markdown-related configuration
- `node/` - Node.js configuration
- `nvim/` - Neovim configuration using LazyVim distribution
- `rc/` - Various RC files (.inputrc, .curlrc, etc.)
- `ruby/` - Ruby configuration (.gemrc, .irbrc)
- `spell/` - Custom spell dictionaries for multiple languages
- `starship/` - Starship prompt configuration
- `terminfo/` - Custom terminal information files
- `tmux/` - Tmux terminal multiplexer configuration
- `yamllint/` - YAML linter configuration
- `zsh/` - Zsh configuration with zsh-abbr for abbreviations

## Common Commands

### Setup and Installation

```bash
# Initial setup (idempotent)
bash ~/dotfiles/setup.sh

# Install Homebrew packages
brew bundle install

# Install Zap (Zsh plugin manager)
# Follow instructions at https://www.zapzsh.com with --keep flag
```

### Testing and Linting

```bash
# Lint shell scripts (must be run from dotfiles root)
./scripts/lint-shell

# Run test suite (must be run from dotfiles root)
./scripts/run-tests

# Run specific test categories
./scripts/run-tests git         # Git function tests
./scripts/run-tests abbr        # Abbreviation tests
```

## Architecture Notes

### Shell Configuration

- Zsh is the primary shell, using zsh-abbr plugin for abbreviations
- `shared/environment.sh` provides common environment variables
- `zsh/.config/zsh-abbr/abbreviations.zsh` contains all abbreviations, managed directly by zsh-abbr
- Starship prompt for consistent, informative shell prompting
- Smart git functions with automatic branch detection (gpum, grbm, gcom, gbrm)

### Stow-based Symlink Management

- GNU Stow creates symlinks from dotfiles directory to `$HOME`
- `setup.sh` script handles conflict detection and backup
- Each subdirectory represents a "package" that can be stowed independently
- Script is idempotent and can be run multiple times safely

#### Ignoring Directories from Stow

Some directories contain repository infrastructure and should not be symlinked to `$HOME`. The `setup.sh` script loops through all directories and runs `stow package/` on each one individually.

**To ignore a directory from stow operations:**

1. Create a `.stow-local-ignore` file in the root of the directory
2. Add the pattern `.+ # Ignore everything` to ignore all contents

**Important:** Do not add directory names to the root `.stow-local-ignore` file — this has no effect since stow runs on individual packages, not the entire repository.

### Neovim Configuration

- Uses LazyVim distribution as base configuration
- Custom plugins and overrides in `nvim/.config/nvim/lua/plugins/`
- Configuration follows LazyVim conventions and structure

### Terminal Environment

- Primary terminal: ghostty (GPU-accelerated, modern terminal)
- Alternative: kitty (also GPU-accelerated with native split support)
- Font setup includes Nerd Font symbols for icons without patched fonts
- Tmux installed and configured by default for terminal multiplexing

## Important Files

- `setup.sh` - Main installation script
- `brew/Brewfile` - Homebrew package definitions
- `shared/environment.sh` - Shared environment variables
- `zsh/.config/zsh-abbr/abbreviations.zsh` - Zsh abbreviations
- `nvim/.config/nvim/lua/config/lazy.lua` - LazyVim configuration entry point
- `local/` - Contains example local configuration files for customization

## Abbreviations

Abbreviations are managed by the [zsh-abbr](https://zsh-abbr.olets.dev) plugin. Edit `zsh/.config/zsh-abbr/abbreviations.zsh` directly, or use `abbr add`/`abbr remove` commands in your shell.

## Environment Variables

- **Shared**: Edit `shared/environment.sh`
- **Shell-specific**: Edit in `zsh/.zshrc` or files in `zsh/.config/zsh/`

## Customization

Local customizations should be placed in `*.local` files:

- `~/.gitconfig.local` - Personal git configuration
- `~/.laptop.local` - Additional laptop setup customizations

## Platform Support

- **macOS only** - setup script checks for Darwin and exits on other platforms
- **Apple Silicon and Intel** - `.zshrc` uses `brew shellenv` for architecture-appropriate Homebrew setup
- **XDG Base Directory** support with automatic directory creation
