# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## About This Repository

This is a personal dotfiles repository for macOS using GNU Stow for symlink management. It provides a comprehensive development environment configuration including shell setups (Zsh/Fish), terminal configurations (ghostty/kitty), and Neovim with LazyVim distribution.

## Repository Structure

The repository is organized with each top-level directory representing a tool or application configuration:

- `asdf/` - asdf version manager configuration
- `bash/` - Bash shell configuration
- `bin/` - Custom shell scripts and utilities
- `brew/` - Homebrew Brewfile for package management
- `claude/` - Claude AI assistant configuration
- `fish/` - Fish shell configuration with abbreviations and functions
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

### Dual Shell Support

The repository maintains parallel configurations for both Zsh and Fish shells:

- **Shared configuration framework** eliminates duplication:
  - `shared/environment.sh` and `shared/environment.fish` - Common environment variables
  - `shared/abbreviations.yaml` - Single source for all abbreviations
  - Shell-specific files generated via `shared/generate-*-abbr.sh` scripts
- Both use Starship for consistent prompting
- Fish uses native abbreviations, Zsh uses zsh-abbr plugin for Fish-like behavior
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
- `shared/abbreviations.yaml` - **Single source of truth for all abbreviations**
- `shared/environment.sh` and `shared/environment.fish` - Shared environment variables
- `shared/generate-*-abbr.sh` - Scripts to generate shell-specific abbreviations
- `fish/.config/fish/abbreviations.fish` - **Generated** Fish shell abbreviations
- `zsh/.config/zsh-abbr/abbreviations.zsh` - **Generated** Zsh abbreviations
- `nvim/.config/nvim/lua/config/lazy.lua` - LazyVim configuration entry point
- `local/` - Contains example local configuration files for customization

## Shared Configuration System

### Adding/Modifying Abbreviations

1. Edit `shared/abbreviations.yaml` (single source of truth)
2. Regenerate shell-specific files:

   ```bash
   cd ~/dotfiles/shared
   ./generate-fish-abbr.sh    # Updates fish/.config/fish/abbreviations.fish
   ./generate-zsh-abbr.sh     # Updates zsh/.config/zsh-abbr/abbreviations.zsh
   ```

### Environment Variables

- **Shared**: Edit `shared/environment.sh` and `shared/environment.fish`
- **Shell-specific**: Edit in respective shell configs (`fish/config.fish` or `zsh/.zshrc`)

**Important**: Never edit generated abbreviation files directly — changes will be overwritten!

## Customization

Local customizations should be placed in `*.local` files:

- `~/.gitconfig.local` - Personal git configuration
- `~/.laptop.local` - Additional laptop setup customizations
- `~/dotfiles/local/config.fish.local` - Fish-specific local configuration

## Platform Support

- **macOS only** - setup script checks for Darwin and exits on other platforms
- **Apple Silicon and Intel** - automatically detects architecture and sets HOMEBREW_PREFIX accordingly
- **XDG Base Directory** support with automatic directory creation
