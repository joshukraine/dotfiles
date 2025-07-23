# Shell Abbreviations Reference

This document provides a comprehensive reference for all shell abbreviations available in both Fish and Zsh shells. Abbreviations are automatically generated from the single source of truth: `shared/abbreviations.yaml`.

## Overview

- **Total abbreviations**: 289 (288 in Fish, 289 in Zsh)
- **Source file**: `shared/abbreviations.yaml`
- **Generated files**:
  - Fish: `fish/.config/fish/abbreviations.fish`
  - Zsh: `zsh/.config/zsh-abbr/abbreviations.zsh`

## Usage

Abbreviations expand automatically when you press space or enter. For example:

- Type `gst` + space → expands to `git status`
- Type `ll` + space → expands to `eza -la`

## Managing Abbreviations

### Regeneration

To update abbreviations after modifying `shared/abbreviations.yaml`:

```bash
# Regenerate all abbreviation files
~/dotfiles/shared/generate-all-abbr.sh

# Or use the function (available in both shells)
reload-abbr
```

### Shell Differences

- **Fish**: Uses native abbreviations (`abbr` command)
- **Zsh**: Uses `zsh-abbr` plugin to provide Fish-like behavior
- Most abbreviations work identically in both shells
- Some shell-specific abbreviations exist (e.g., `src` for Zsh only)

## Abbreviation Categories

### UNIX Commands

Basic system utilities with enhanced options:

| Abbr | Command | Description |
|------|---------|-------------|
| `c` | `clear` | Clear terminal screen |
| `cv` | `command -v` | Check if command exists |
| `df` | `df -h` | Show disk usage in human-readable format |
| `du` | `du -h` | Show directory usage in human-readable format |
| `dud` | `du -d 1 -h` | Show directory usage one level deep |
| `duf` | `du -sh *` | Show usage of all items in current directory |
| `mkdir` | `mkdir -pv` | Create directories with parents and verbose output |
| `mv` | `mv -iv` | Move files with interactive and verbose options |

### System Tools

System information and management:

| Abbr | Command | Description |
|------|---------|-------------|
| `fast` | `fastfetch` | Display system information with ASCII art |

### Claude Code

AI assistant shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `cl` | `claude` | Launch Claude Code |
| `clsp` | `claude --dangerously-skip-permissions` | Skip permission checks |
| `clh` | `claude --help` | Show help |
| `clv` | `claude --version` | Show version |
| `clr` | `claude --resume` | Resume previous session |
| `clc` | `claude --continue` | Continue current session |
| `clp` | `claude --print` | Print mode |
| `clcp` | `claude --continue --print` | Continue in print mode |
| `clup` | `claude update` | Update Claude Code |
| `clmcp` | `claude mcp` | MCP commands |

### Homebrew Package Management

Homebrew shortcuts with common options:

| Abbr | Command | Description |
|------|---------|-------------|
| `brc` | `brew cleanup` | Clean up old versions |
| `brb` | `brew bundle` | Bundle operations |
| `brd` | `brew doctor` | Check system for problems |
| `brg` | `brew upgrade` | Upgrade all packages |
| `bri` | `brew info` | Show package information |
| `brl` | `brew list -1` | List installed packages (one per line) |
| `brlf` | `brew list \| fzf` | Fuzzy search installed packages |
| `bro` | `brew outdated` | Show outdated packages |
| `brs` | `brew search` | Search for packages |
| `bru` | `brew update` | Update Homebrew |
| `bs0` | `brew services stop` | Stop services |
| `bs1` | `brew services start` | Start services |

### Navigation & Configuration

Quick access to common directories:

| Abbr | Command | Description |
|------|---------|-------------|
| `cdot` | `cd ~/dotfiles` | Navigate to dotfiles directory |
| `cdxc` | `cd ~/.config` | Navigate to XDG config directory |
| `cdnv` | `cd ~/.config/nvim` | Navigate to Neovim configuration |
| `cdfi` | `cd ~/.config/fish` | Navigate to Fish configuration |

### Tree Commands

Enhanced directory listing with `eza`:

| Abbr | Command | Description |
|------|---------|-------------|
| `l` | `eza` | List files |
| `la` | `eza -la` | List all files with details |
| `ll` | `eza -la` | List all files with details (alias) |
| `lt` | `eza --tree` | Tree view |
| `ltd` | `eza --tree --level=2` | Tree view (2 levels) |
| `ltdd` | `eza --tree --level=3` | Tree view (3 levels) |

### Development Tools

Programming and development utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `server` | `python3 -m http.server` | Start HTTP server |
| `aua` | `./node_modules/.bin/\*` | Execute local npm binary |
| `bubo` | `brew update && brew outdated` | Update and show outdated packages |
| `copy` | `pbcopy` | Copy to clipboard |

### Git Commands

Comprehensive git workflow shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `g` | `git` | Git command |
| `ga` | `git add` | Add files |
| `gaa` | `git add --all` | Add all files |
| `gb` | `git branch` | List branches |
| `gba` | `git branch -a` | List all branches |
| `gc` | `git commit -v` | Commit with verbose output |
| `gca` | `git commit -v -a` | Commit all changes |
| `gcam` | `git commit -a -m` | Commit all with message |
| `gcb` | `git checkout -b` | Create and checkout branch |
| `gcm` | `git cm` | Custom commit command |
| `gco` | `git checkout` | Checkout branch |
| `gd` | `git diff` | Show differences |
| `gdc` | `git diff --cached` | Show staged differences |
| `gl` | `git pull` | Pull changes |
| `glg` | `git log --stat` | Log with statistics |
| `gp` | `git push` | Push changes |
| `grb` | `git rebase` | Rebase |
| `grbi` | `git rebase -i` | Interactive rebase |
| `gst` | `git status` | Show status |
| `gsta` | `git stash push` | Stash changes |
| `gstp` | `git stash pop` | Pop stash |

### Docker

Container management shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `dps` | `docker ps` | List running containers |
| `dpsa` | `docker ps -a` | List all containers |
| `di` | `docker images` | List images |
| `drm` | `docker rm` | Remove container |
| `drmi` | `docker rmi` | Remove image |

### Rails Development

Ruby on Rails shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `rc` | `bin/rails console` | Rails console |
| `rcs` | `bin/rails console --sandbox` | Rails console (sandbox) |
| `rdb` | `bin/rails dbconsole` | Database console |
| `rg` | `bin/rails generate` | Rails generator |
| `rgm` | `bin/rails generate migration` | Generate migration |
| `rs` | `bin/rails server` | Rails server |
| `rt` | `bin/rails test` | Run tests |

### Tmux Session Management

Terminal multiplexer shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `tl` | `tmux ls` | List sessions |
| `tlw` | `tmux list-windows` | List windows |
| `tks` | `tmux kill-session -t` | Kill session |
| `tkw` | `tmux kill-window -t` | Kill window |

### Node.js & NPM

JavaScript development tools:

| Abbr | Command | Description |
|------|---------|-------------|
| `ni` | `npm install` | Install packages |
| `nid` | `npm install --save-dev` | Install dev dependencies |
| `nig` | `npm install --global` | Install globally |
| `nr` | `npm run` | Run npm script |
| `nrb` | `npm run build` | Run build script |
| `nrd` | `npm run dev` | Run dev script |
| `nrs` | `npm run start` | Run start script |
| `nrt` | `npm run test` | Run test script |

## Cross-Shell Compatibility

### Fish-Only Features

- Native abbreviation expansion
- Better completion integration

### Zsh-Only Features

- `src` abbreviation for reloading configuration
- Integration with Oh My Zsh plugins

### Shared Features

- All abbreviations work identically
- Same expansion behavior
- Consistent command structure

## Customization

### Adding New Abbreviations

1. Edit `shared/abbreviations.yaml`
2. Add to appropriate category
3. Run `reload-abbr` to regenerate files
4. Reload your shell configuration

### Example Addition

```yaml
# In shared/abbreviations.yaml
git:
  gnew: "git checkout -b"  # New branch shortcut
```

### Category Guidelines

- **unix**: Basic UNIX commands and utilities
- **git**: Git version control operations
- **dev_tools**: Development and programming tools
- **navigation**: Directory and file navigation
- **system**: System administration and information

## Related Documentation

- [Function Documentation](functions/README.md) - Shell function reference
- [Git Functions](functions/git-functions.md) - Smart git operations
- [Development Tools](functions/development.md) - Development utilities
- [Tmux Functions](functions/tmux.md) - Terminal multiplexer management

---

*This file is automatically generated from `shared/abbreviations.yaml`. Do not edit directly.*
