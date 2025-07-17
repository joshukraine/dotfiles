# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is a personal dotfiles repository for macOS using GNU Stow for symlink management. It provides a comprehensive development environment configuration including shell setups (Zsh/Fish), terminal configurations (ghostty/kitty), and Neovim with LazyVim distribution.

## Repository Structure

The repository is organized with each top-level directory representing a tool or application configuration:

- `fish/` - Fish shell configuration with abbreviations and functions
- `zsh/` - Zsh configuration with zsh-abbr for abbreviations
- `nvim/` - Neovim configuration using LazyVim distribution
- `ghostty/` - Ghostty terminal emulator configuration
- `kitty/` - Kitty terminal emulator configuration
- `git/` - Git configuration and global gitignore
- `brew/` - Homebrew Brewfile for package management
- `starship/` - Starship prompt configuration
- `tmux/` - Tmux configuration (optional, not installed by default)
- `bin/` - Custom shell scripts and utilities
- `spell/` - Custom spell dictionaries for multiple languages

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

### Development Workflow

```bash
# Navigate to dotfiles
cdot

# Navigate to config directories
cdxc    # ~/.config
cdnv    # ~/.config/nvim
cdfi    # ~/.config/fish

# Git operations (using custom abbreviations)
ga      # git add
gaa     # git add --all
gcm     # git cm (custom commit script)
gst     # git status
```

### Shell Management

Both Fish and Zsh configurations provide 90% functional parity with the same abbreviations and functions.

**Zsh-specific:**

```bash
src     # source ~/.zshrc
```

**Fish-specific:**

```bash
fish_config  # Open Fish configuration UI
```

## Architecture Notes

### Dual Shell Support

The repository maintains parallel configurations for both Zsh and Fish shells:

- Shared abbreviations defined in both `fish/.config/fish/abbreviations.fish` and `zsh/.config/zsh-abbr/abbreviations.zsh`
- Both use Starship for consistent prompting
- Fish uses native abbreviations, Zsh uses zsh-abbr plugin for Fish-like behavior

### Stow-based Symlink Management

- GNU Stow creates symlinks from dotfiles directory to `$HOME`
- `setup.sh` script handles conflict detection and backup
- Each subdirectory represents a "package" that can be stowed independently
- Script is idempotent and can be run multiple times safely

### Neovim Configuration

- Uses LazyVim distribution as base configuration
- Custom plugins and overrides in `nvim/.config/nvim/lua/plugins/`
- Configuration follows LazyVim conventions and structure

### Terminal Environment

- Primary terminal: ghostty (GPU-accelerated, modern terminal)
- Alternative: kitty (also GPU-accelerated with native split support)
- Font setup includes Nerd Font symbols for icons without patched fonts
- Tmux configuration available but not installed by default

### Package Management

- Homebrew via `brew/Brewfile` for system packages and applications
- asdf for runtime version management (Node.js, Ruby, etc.)
- Fonts installed via Homebrew Cask Fonts

## Important Files

- `setup.sh` - Main installation script
- `brew/Brewfile` - Homebrew package definitions
- `fish/.config/fish/abbreviations.fish` - Fish shell abbreviations
- `zsh/.config/zsh-abbr/abbreviations.zsh` - Zsh abbreviations
- `nvim/.config/nvim/lua/config/lazy.lua` - LazyVim configuration entry point
- `local/` - Contains example local configuration files for customization

## Customization

Local customizations should be placed in `*.local` files:

- `~/.gitconfig.local` - Personal git configuration
- `~/.laptop.local` - Additional laptop setup customizations
- `~/dotfiles/local/config.fish.local` - Fish-specific local configuration

## Platform Support

- **macOS only** - setup script checks for Darwin and exits on other platforms
- **Apple Silicon and Intel** - automatically detects architecture and sets HOMEBREW_PREFIX accordingly
- **XDG Base Directory** support with automatic directory creation

