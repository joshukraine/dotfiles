# Migration Guide

This guide helps you safely migrate from other dotfiles repositories or manual configurations to this dotfiles setup while preserving your existing customizations and settings.

## 📋 Table of Contents

- [Pre-Migration Preparation](#%EF%B8%8F-pre-migration-preparation)
- [From Manual Configurations](#-from-manual-configurations)
- [From Other Dotfiles Repositories](#-from-other-dotfiles-repositories)
- [Common Migration Scenarios](#-common-migration-scenarios)
- [Preserving Your Customizations](#-preserving-your-customizations)
- [Testing Your Migration](#-testing-your-migration)
- [Rollback Procedures](#%EF%B8%8F-rollback-procedures)
- [Post-Migration Cleanup](#-post-migration-cleanup)

## 🛡️ Pre-Migration Preparation

### Complete Backup Strategy

Before making any changes, create comprehensive backups:

```bash
# 1. Create backup directory with timestamp
BACKUP_DIR="$HOME/dotfiles-migration-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"

# 2. Backup entire home directory configuration
rsync -av --progress \
  --exclude='.git' \
  --exclude='Library' \
  --exclude='Applications' \
  --exclude='Downloads' \
  --exclude='Desktop' \
  --exclude='Documents' \
  --exclude='Movies' \
  --exclude='Music' \
  --exclude='Pictures' \
  ~/.* "$BACKUP_DIR/"

echo "Backup created at: $BACKUP_DIR"
```

### Document Your Current Setup

Create an inventory of your current configuration:

```bash
# Create migration notes file
cat > "$BACKUP_DIR/migration-notes.md" << 'EOF'
# Migration Notes

## Current Shell Configuration
- Shell: $(echo $SHELL)
- Terminal: $(echo $TERM_PROGRAM)

## Key Configuration Files
EOF

# Document key config files
ls -la ~/.{bashrc,zshrc,vimrc,gitconfig,tmux.conf} 2>/dev/null >> "$BACKUP_DIR/migration-notes.md"

# Document current PATH
echo "## Current PATH" >> "$BACKUP_DIR/migration-notes.md"
echo $PATH | tr ':' '\n' >> "$BACKUP_DIR/migration-notes.md"

# Document installed packages (if using Homebrew)
if command -v brew &> /dev/null; then
    echo "## Homebrew Packages" >> "$BACKUP_DIR/migration-notes.md"
    brew list >> "$BACKUP_DIR/migration-notes.md"
fi
```

### Environment Snapshot

Capture your current environment for comparison:

```bash
# Save current environment variables
env | sort > "$BACKUP_DIR/current-env.txt"

# Save current aliases and functions
alias > "$BACKUP_DIR/current-aliases.txt"

# Save current git configuration
git config --list > "$BACKUP_DIR/current-git-config.txt" 2>/dev/null
```

## 🔧 From Manual Configurations

### Migrating Shell Configuration

If you have manually configured shell files:

```bash
# 1. Extract your custom configurations
mkdir -p "$BACKUP_DIR/custom-configs"

# Extract custom aliases from .bashrc/.zshrc
grep -E "^alias|^function|^export" ~/.bashrc ~/.zshrc 2>/dev/null > "$BACKUP_DIR/custom-configs/my-shell-customizations.sh"

# Extract custom git settings
cp ~/.gitconfig "$BACKUP_DIR/custom-configs/gitconfig.backup" 2>/dev/null
```

### Migrating Vim/Neovim Configuration

From vim to Neovim with LazyVim:

```bash
# 1. Backup existing vim configurations
cp -r ~/.vim "$BACKUP_DIR/vim-backup" 2>/dev/null
cp ~/.vimrc "$BACKUP_DIR/vimrc.backup" 2>/dev/null
cp -r ~/.config/nvim "$BACKUP_DIR/nvim-backup" 2>/dev/null

# 2. Extract your personal vim settings
grep -E "^set|^let|^map|^nmap" ~/.vimrc 2>/dev/null > "$BACKUP_DIR/custom-configs/vim-settings.vim"
```

### Converting Personal Settings

Transform your settings to the new format:

```bash
# 1. Create your local configuration files
touch ~/.gitconfig.local

# 2. Extract and convert git settings
if [[ -f "$BACKUP_DIR/custom-configs/gitconfig.backup" ]]; then
    # Copy user information
    git config --file="$BACKUP_DIR/custom-configs/gitconfig.backup" --list | \
    grep -E "^user\." > ~/.gitconfig.local
fi

# 3. Convert shell customizations
if [[ -f "$BACKUP_DIR/custom-configs/my-shell-customizations.sh" ]]; then
    echo "# Migrated customizations" > ~/.zshrc.local
    cat "$BACKUP_DIR/custom-configs/my-shell-customizations.sh" >> ~/.zshrc.local
fi
```

## 📦 From Other Dotfiles Repositories

### From Oh My Zsh

Migrating from Oh My Zsh setup:

```bash
# 1. Document Oh My Zsh configuration
echo "# Oh My Zsh Configuration" > "$BACKUP_DIR/oh-my-zsh-config.md"
echo "ZSH_THEME: $(grep ZSH_THEME ~/.zshrc)" >> "$BACKUP_DIR/oh-my-zsh-config.md"
echo "Plugins: $(grep "plugins=" ~/.zshrc)" >> "$BACKUP_DIR/oh-my-zsh-config.md"

# 2. Extract custom functions and aliases
grep -A 999 "# User configuration" ~/.zshrc > "$BACKUP_DIR/custom-configs/oh-my-zsh-custom.zsh"

# 3. Note custom themes or plugins
ls ~/.oh-my-zsh/custom/ > "$BACKUP_DIR/oh-my-zsh-customizations.txt" 2>/dev/null

# 4. After migration, add equivalent functionality to ~/.zshrc.local
# (Many Oh My Zsh features are replaced by Starship prompt and zsh-abbr)
```

### From Prezto

```bash
# 1. Backup Prezto configuration
cp ~/.zpreztorc "$BACKUP_DIR/zpreztorc.backup" 2>/dev/null

# 2. Document enabled modules
grep -E "^zstyle.*modules" ~/.zpreztorc > "$BACKUP_DIR/prezto-modules.txt" 2>/dev/null

# 3. Extract theme preferences
grep -E "theme" ~/.zpreztorc > "$BACKUP_DIR/prezto-theme.txt" 2>/dev/null
```

### From Thoughtbot Dotfiles

```bash
# 1. Backup thoughtbot configurations
cp -r ~/.dotfiles "$BACKUP_DIR/thoughtbot-dotfiles" 2>/dev/null

# 2. Extract local customizations
cp ~/.vimrc.local "$BACKUP_DIR/custom-configs/" 2>/dev/null
cp ~/.tmux.conf.local "$BACKUP_DIR/custom-configs/" 2>/dev/null
cp ~/.gitconfig.local "$BACKUP_DIR/custom-configs/" 2>/dev/null
```

### From Mathias Bynens' Dotfiles

```bash
# 1. Backup .macos settings file
cp ~/.macos "$BACKUP_DIR/macos-settings.backup" 2>/dev/null

# 2. Extract custom functions
grep -E "^function" ~/.functions > "$BACKUP_DIR/custom-configs/mathias-functions.sh" 2>/dev/null

# 3. Document aliases
cp ~/.aliases "$BACKUP_DIR/custom-configs/mathias-aliases.backup" 2>/dev/null
```

## 🎯 Common Migration Scenarios

### Scenario 1: From Bare Shell to Full Setup

1. **Current state**: Basic shell with few customizations
2. **Goal**: Full development environment

```bash
# Safe migration steps
cd ~/dotfiles
./setup.sh --dry-run  # Preview all changes
./setup.sh             # Apply changes
brew bundle install   # Install development tools
```

### Scenario 2: From Vim to Neovim + LazyVim

1. **Current state**: Heavy vim customization
2. **Goal**: Modern Neovim with LazyVim

```bash
# 1. Migration-safe approach
mv ~/.config/nvim ~/.config/nvim.backup 2>/dev/null

# 2. Install new dotfiles
./setup.sh

# 3. Gradually migrate vim settings to LazyVim format
# Create ~/.config/nvim/lua/config/local.lua for personal settings
```

### Scenario 3: Corporate to Personal Environment

1. **Current state**: Corporate-managed dotfiles
2. **Goal**: Personal development setup

```bash
# 1. Check corporate policies first!
# 2. Create separate user account if needed
# 3. Clone personal dotfiles to separate location
git clone https://github.com/joshukraine/dotfiles.git ~/personal-dotfiles

# 4. Install to isolated environment
DOTFILES="$HOME/personal-dotfiles" ./setup.sh
```

## 🔄 Preserving Your Customizations

### Identify What to Preserve

Before migration, categorize your existing settings:

```bash
# Create categorized backup
mkdir -p "$BACKUP_DIR/preserve"/{essential,nice-to-have,obsolete}

# Essential: Critical for your workflow
# Nice-to-have: Convenient but not critical
# Obsolete: Can be replaced by new dotfiles features
```

### Mapping Old Settings to New Structure

| Old Configuration | New Location | Notes |
|------------------|--------------|-------|
| `~/.bashrc` aliases | `~/.zshrc.local` | Convert to zsh format |
| `~/.vimrc` | `~/.config/nvim/lua/config/local.lua` | Convert to LazyVim |
| `~/.gitconfig` user info | `~/.gitconfig.local` | Keep user identity |
| Custom functions | `~/dotfiles/local/config.fish.local` | Choose shell |
| Environment variables | `~/.environment.local` | Global variables |

### Gradual Migration Strategy

Don't migrate everything at once:

```bash
# Week 1: Core shell and git
STOW_PACKAGES="git,zsh" ./setup.sh

# Week 2: Add editor
STOW_PACKAGES="git,zsh,nvim" ./setup.sh

# Week 3: Add multiplexer
STOW_PACKAGES="git,zsh,nvim,tmux" ./setup.sh

# Week 4: Full setup
./setup.sh
```

## 🧪 Testing Your Migration

### Create Test Environment

Test the migration without affecting your current setup:

```bash
# 1. Create test user account (macOS)
sudo dscl . -create /Users/testuser
sudo dscl . -create /Users/testuser UserShell /bin/zsh

# 2. Or use Docker for isolated testing
docker run -it --rm ubuntu:latest bash
# (adapt for your testing needs)
```

### Validation Checklist

After migration, verify everything works:

```bash
# Shell functionality
echo "Testing shell..." && zsh -c 'echo "Zsh works"'

# Git configuration
git config --list | grep user

# Editor functionality
nvim --version && echo "Neovim OK"

# Custom functions
which g && echo "Git function works"

# Abbreviations
abbr | head -3 && echo "Abbreviations OK"

# Package manager
brew --version && echo "Homebrew OK"
```

### Performance Testing

Compare startup times:

```bash
# Test shell startup time
time zsh -i -c exit

# Test editor startup
time nvim --startuptime /tmp/nvim-startup.log +qa
```

## ↩️ Rollback Procedures

### Emergency Rollback

If something goes wrong during migration:

```bash
# 1. Remove dotfiles symlinks
cd ~/dotfiles
stow -D */

# 2. Restore original configurations
cp "$BACKUP_DIR"/.zshrc ~/.zshrc 2>/dev/null
cp "$BACKUP_DIR"/.gitconfig ~/.gitconfig 2>/dev/null
cp "$BACKUP_DIR"/.vimrc ~/.vimrc 2>/dev/null
# (restore other key files)

# 3. Restart shell
exec zsh
```

### Selective Rollback

Roll back specific components:

```bash
# Roll back only nvim configuration
stow -D nvim/
cp -r "$BACKUP_DIR/nvim-backup" ~/.config/nvim

# Roll back only shell configuration
stow -D zsh/
cp "$BACKUP_DIR/.zshrc" ~/.zshrc
```

### Partial Rollback with Merge

Keep some changes while reverting others:

```bash
# 1. Create hybrid configuration
cp "$BACKUP_DIR/.zshrc" ~/.zshrc.original

# 2. Merge with new configuration
# (manually combine files or use tools like vimdiff)

# 3. Create custom local configuration
cat > ~/.zshrc.local << 'EOF'
# Merged customizations from original config
source ~/.zshrc.original
EOF
```

## 🧹 Post-Migration Cleanup

### Remove Old Configurations

After successful migration and testing:

```bash
# Remove obsolete configuration files
rm -rf ~/.oh-my-zsh 2>/dev/null
rm ~/.preztorc 2>/dev/null
rm ~/.bash_profile 2>/dev/null  # If migrated to zsh

# Clean up old symlinks
find ~ -maxdepth 2 -type l ! -exec test -e {} \; -delete 2>/dev/null
```

### Clean Up Package Managers

```bash
# Remove packages that are no longer needed
brew bundle cleanup

# Update package lists
brew update && brew upgrade
```

### Archive Migration Backup

```bash
# Compress backup for long-term storage
tar -czf "$HOME/dotfiles-migration-backup-$(date +%Y%m%d).tar.gz" -C "$HOME" "dotfiles-migration-backup-*"

# Store in safe location (cloud storage, external drive, etc.)
```

## 📝 Migration Checklist

### Pre-Migration

- [ ] Full backup created
- [ ] Current configuration documented
- [ ] Migration strategy planned
- [ ] Test environment prepared

### During Migration

- [ ] Dotfiles repository cloned
- [ ] Setup script reviewed
- [ ] Dry-run executed successfully
- [ ] Migration executed step by step
- [ ] Custom configurations preserved

### Post-Migration

- [ ] All functionality tested
- [ ] Performance verified
- [ ] Custom settings migrated
- [ ] Old configurations cleaned up
- [ ] Backup archived

### Validation

- [ ] Shell starts without errors
- [ ] Git configuration works
- [ ] Editor functions properly
- [ ] Custom functions/aliases work
- [ ] Development tools accessible

## 🆘 Migration Support

If you encounter issues during migration:

1. **Don't panic** - your backup contains everything
2. **Use rollback procedures** to restore working state
3. **Check troubleshooting guide** for common issues
4. **Test changes incrementally** rather than all at once
5. **Ask for help** on the [GitHub repository](https://github.com/joshukraine/dotfiles/issues)

Remember: Migration is a process, not a one-time event. Take your time and test thoroughly at each step!
