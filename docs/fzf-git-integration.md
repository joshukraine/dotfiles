# FZF Git Integration

This document describes the integration of [fzf-git.sh](https://github.com/junegunn/fzf-git.sh) into the dotfiles configuration.

## Overview

fzf-git.sh provides enhanced git operations with fuzzy finding capabilities through interactive key bindings and command-line utilities.

## Features

The integration provides the following capabilities:

### Key Bindings

- **Ctrl-G Ctrl-F** - Fuzzy find git files
- **Ctrl-G Ctrl-B** - Fuzzy find git branches  
- **Ctrl-G Ctrl-T** - Fuzzy find git tags
- **Ctrl-G Ctrl-R** - Fuzzy find git remotes
- **Ctrl-G Ctrl-H** - Fuzzy find git commit hashes
- **Ctrl-G Ctrl-S** - Fuzzy find git stashes
- **Ctrl-G Ctrl-L** - Fuzzy find git reflogs
- **Ctrl-G Ctrl-E** - Fuzzy find git refs (for-each-ref)
- **Ctrl-G Ctrl-W** - Fuzzy find git worktrees
- **Ctrl-G ?** - Show help with all available bindings

### Command Line Abbreviations

The following abbreviations are available for direct command-line usage:

- `gfzf` - Load fzf-git.sh key bindings
- `gfzff` - Fuzzy find git files
- `gfzfb` - Fuzzy find git branches
- `gfzft` - Fuzzy find git tags
- `gfzfr` - Fuzzy find git remotes
- `gfzfh` - Fuzzy find git commit hashes
- `gfzfs` - Fuzzy find git stashes
- `gfzfl` - Fuzzy find git reflogs
- `gfzfe` - Fuzzy find git refs
- `gfzfw` - Fuzzy find git worktrees

## Installation

The fzf-git.sh script is automatically loaded when you start an interactive shell session. The script is located at `bin/fzf-git.sh` and is sourced by both Fish and Zsh configurations.

## Dependencies

- **fzf** - Already installed via Homebrew in the Brewfile
- **bat** - Used for syntax highlighting in previews (already installed)
- **git** - Core git functionality

## Usage Examples

### Using Key Bindings

1. Press `Ctrl-G` followed by `Ctrl-F` to fuzzy find git files
2. Press `Ctrl-G` followed by `Ctrl-B` to fuzzy find branches
3. Press `Ctrl-G` followed by `?` to see all available bindings

### Using Command Line

```bash
# Fuzzy find files
gfzff

# Fuzzy find branches
gfzfb

# Fuzzy find commit hashes
gfzfh
```

### Direct Script Usage

```bash
# Run specific fzf-git functions directly
fzf-git.sh --run files
fzf-git.sh --run branches
fzf-git.sh --run tags
```

## Configuration

The script respects the following environment variables:

- `FZF_GIT_COLOR` - Color mode for git output (default: "always")
- `FZF_GIT_PREVIEW_COLOR` - Color mode for previews
- `FZF_GIT_CAT` - Custom cat command for previews
- `NO_COLOR` - Disable colors when set

## Integration Details

### Fish Shell

The script is loaded in `fish/.config/fish/config.fish` during interactive sessions:

```fish
# https://github.com/junegunn/fzf-git.sh
# Load fzf-git.sh for enhanced git operations with fuzzy finding
if test -f $DOTFILES/bin/fzf-git.sh
    source $DOTFILES/bin/fzf-git.sh
end
```

### Zsh Shell

The script is loaded in `zsh/.zshrc`:

```bash
# https://github.com/junegunn/fzf-git.sh
# Load fzf-git.sh for enhanced git operations with fuzzy finding
if [[ -f "$DOTFILES/bin/fzf-git.sh" ]]; then
  source "$DOTFILES/bin/fzf-git.sh"
fi
```

### Abbreviations

All fzf-git abbreviations are defined in `shared/abbreviations.yaml` and automatically generated for both shells.

## Troubleshooting

### Key Bindings Not Working

1. Ensure you're in an interactive shell session
2. Check that the script is loaded: `echo $DOTFILES/bin/fzf-git.sh`
3. Verify fzf is installed: `command -v fzf`

### Script Not Found

1. Ensure the script exists: `ls -la $DOTFILES/bin/fzf-git.sh`
2. Check file permissions: `chmod +x $DOTFILES/bin/fzf-git.sh`
3. Verify DOTFILES environment variable is set

### Preview Issues

1. Ensure bat is installed: `command -v bat`
2. Check git color configuration: `git config --get color.ui`

## References

- [fzf-git.sh GitHub Repository](https://github.com/junegunn/fzf-git.sh)
- [fzf Documentation](https://github.com/junegunn/fzf)
- [Git Documentation](https://git-scm.com/doc)
