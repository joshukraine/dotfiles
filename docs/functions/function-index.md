# Function Index

Auto-generated comprehensive index of all documented functions in the dotfiles configuration.

*Last updated: Wed Jul 23 13:04:11 EEST 2025*

## Quick Reference

| Function | Brief Description | Shell | File Location |
|----------|-------------------|-------|---------------|
| `cat` | Enhanced cat command using bat for syntax highlighting and paging | Fish | `fish/.config/fish/functions/cat.fish` |
| `gcom` | Switch to the default Git branch (main or master) with optional pull | Fish | `fish/.config/fish/functions/gcom.fish` |
| `gpum` | Push current branch to origin with upstream tracking to the default branch | Fish | `fish/.config/fish/functions/gpum.fish` |
| `grbm` | Rebase current branch against the default branch (main or master) | Fish | `fish/.config/fish/functions/grbm.fish` |
| `haf` | You can also toggle hidden files from the Finder GUI with Cmd + Shift + . | Fish | `fish/.config/fish/functions/haf.fish` |
| `htop` | Interactive process viewer with elevated privileges | Fish | `fish/.config/fish/functions/htop.fish` |
| `mm` | Start Middleman development server | Fish | `fish/.config/fish/functions/mm.fish` |
| `pi` | Ping utility with sensible defaults and optional target override | Fish | `fish/.config/fish/functions/pi.fish` |
| `rlv` | List available Ruby versions using asdf with filtering | Fish | `fish/.config/fish/functions/rlv.fish` |
| `saf` | You can also toggle hidden files from the Finder GUI with Cmd + Shift + . | Fish | `fish/.config/fish/functions/saf.fish` |
| `src` | Reload Fish shell configuration and restart session | Fish | `fish/.config/fish/functions/src.fish` |
| `tsrc` | Source tmux configuration file to reload settings | Fish | `fish/.config/fish/functions/tsrc.fish` |
| `ct` | Returns: Creates ctags file including all Ruby files and bundled gem paths | Zsh | `zsh/.config/zsh/functions.zsh` |
| `copycwd` | Returns: Copies current directory path to clipboard with chosen format (~, $HOME, or full path) | Zsh | `zsh/.config/zsh/functions.zsh` |
| `dsx` | Returns: Deletes all .DS_Store files found, no output unless errors occur | Zsh | `zsh/.config/zsh/functions.zsh` |
| `fs` | Thank you, Mathias! https://raw.githubusercontent.com/mathiasbynens/dotfiles/master/.functions | Zsh | `zsh/.config/zsh/functions.zsh` |
| `path` | Returns: Numbered list of all directories in the PATH environment variable | Zsh | `zsh/.config/zsh/functions.zsh` |
| `src` | Returns: Sources .zshrc and reloads all configuration | Zsh | `zsh/.config/zsh/functions.zsh` |
| `pi` | Note: This Zsh version always pings 1.1.1.1 (unlike Fish version which accepts arguments) | Zsh | `zsh/.config/zsh/functions.zsh` |
| `rlv` | Returns: Filtered list of Ruby versions available for installation via asdf, excluding preview/rc versions | Zsh | `zsh/.config/zsh/functions.zsh` |
| `gpum` | Push current branch to origin with upstream tracking (smart default branch detection) | Zsh | `zsh/.config/zsh/functions.zsh` |
| `grbm` | Rebase current branch against default branch (smart branch detection) | Zsh | `zsh/.config/zsh/functions.zsh` |
| `reload-abbr` | Regenerate abbreviations for all shells from shared YAML source | Zsh | `zsh/.config/zsh/functions.zsh` |

## Function Categories

### Smart Git Functions

Functions that intelligently detect default branches and handle git workflows:

| `gcom` | Switch to the default Git branch (main or master) with optional pull | Fish | `fish/.config/fish/functions/gcom.fish` |
| `gpum` | Push current branch to origin with upstream tracking to the default branch | Fish | `fish/.config/fish/functions/gpum.fish` |
| `grbm` | Rebase current branch against the default branch (main or master) | Fish | `fish/.config/fish/functions/grbm.fish` |
| `gpum` | Push current branch to origin with upstream tracking (smart default branch detection) | Zsh | `zsh/.config/zsh/functions.zsh` |
| `grbm` | Rebase current branch against default branch (smart branch detection) | Zsh | `zsh/.config/zsh/functions.zsh` |

### Development Utilities

Tools for development workflow and navigation:

*No development utilities found with documentation*

### System Functions

System utilities and command wrappers:

*No system functions found with documentation*

### Tmux Functions

Session and window management:

*No tmux functions found with documentation*

## Usage

Most functions include help flags or usage information:

```bash
# Functions with help flags
gcom --help
gpum --help
reload-abbr --help

# Functions that show usage when called incorrectly
ta                  # Shows usage
tk                  # Shows usage
tn                  # Shows usage
```

## Related Documentation

- [Complete Function Documentation](README.md) - Detailed documentation for all functions
- [Abbreviations Reference](../abbreviations.md) - Shell abbreviation reference
- [Main README](../../README.md) - Repository overview and setup

---

*This index is automatically generated from inline function documentation.*
