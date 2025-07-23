# Usage Examples

This guide provides practical command examples and scenarios for using the setup script in different situations. Whether you're doing a first-time installation, updating existing configurations, or recovering from issues, you'll find the right commands here.

## 📋 Table of Contents

- [Basic Usage](#basic-usage)
- [Installation Scenarios](#installation-scenarios)
- [Update and Maintenance](#update-and-maintenance)
- [Advanced Configuration](#advanced-configuration)
- [Recovery and Troubleshooting](#recovery-and-troubleshooting)
- [Environment Variables](#environment-variables)
- [Verification Commands](#verification-commands)

## 🚀 Basic Usage

### Standard Installation

The most common use case - full installation with default settings:

```bash
# Navigate to dotfiles directory
cd ~/dotfiles

# Run the setup script
./setup.sh
```

### Preview Before Installing (Recommended)

Always preview what the script will do before running it:

```bash
# Dry-run mode - shows what would happen without making changes
./setup.sh --dry-run
```

Example dry-run output:

```text
[DRY RUN MODE - No changes will be made]

[DOTFILES] Initializing dotfiles setup...
[INFO] Prerequisites check passed
[DRY RUN] Would set HostName to: MacBook-Pro
[DRY RUN] Would create directory: /Users/username/.config
[DRY RUN] Would stow package: asdf
[DRY RUN] Would stow package: bash
[INFO] Processed 20 stow packages
```

### Get Help

```bash
# Show available options
./setup.sh --help
```

## 🏠 Installation Scenarios

### Fresh macOS Installation

Complete setup on a brand new Mac:

```bash
# 1. Clone the repository
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. Preview the installation
./setup.sh --dry-run

# 3. Run the full setup
./setup.sh

# 4. Install Homebrew packages
brew bundle install
```

### Updating Existing Configuration

Safe way to update your dotfiles on an existing system:

```bash
# Navigate to dotfiles
cd ~/dotfiles

# Pull latest changes
git pull origin master

# Preview what would change
./setup.sh --dry-run

# Apply updates (script is idempotent)
./setup.sh
```

### Partial Installation

Installing only specific components (advanced users):

```bash
# Set environment variable to specify packages
export STOW_PACKAGES="git,nvim,tmux"
./setup.sh --dry-run

# Install only specified packages
export STOW_PACKAGES="git,nvim,tmux"
./setup.sh
```

> **Note**: Package names correspond to directory names in the dotfiles repository.

## 🔄 Update and Maintenance

### Regular Maintenance

Recommended commands for keeping your setup current:

```bash
# Check for conflicts without applying changes
./setup.sh --dry-run

# Update configurations (safe to run multiple times)
./setup.sh

# Update Homebrew packages
brew bundle install
brew bundle cleanup  # Remove packages not in Brewfile
```

### After Pulling New Changes

When the dotfiles repository has been updated:

```bash
cd ~/dotfiles
git pull origin master

# Check what the new changes would do
./setup.sh --dry-run

# Apply the updates
./setup.sh

# Regenerate abbreviations if shared config changed
reload-abbr  # or manually: cd shared && ./generate-all-abbr.sh
```

### Checking Configuration Status

```bash
# Verify symlinks are correct
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim
# Should show arrows pointing to ~/dotfiles/...

# Check for broken symlinks
find ~ -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null

# Verify git configuration
git config --list | head -10
```

## ⚙️ Advanced Configuration

### Custom Backup Directory

Specify where conflicting files should be backed up:

```bash
# Custom backup location
BACKUP_DIR="/tmp/dotfiles-backup" ./setup.sh --dry-run
BACKUP_DIR="/tmp/dotfiles-backup" ./setup.sh
```

### Development/Testing Setup

For contributing to the dotfiles repository:

```bash
# Clone your fork
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles-dev
cd ~/dotfiles-dev

# Test your changes safely
./setup.sh --dry-run

# Apply changes to test branch
git checkout -b test-feature
./setup.sh
```

### Force Overwrite Conflicts

⚠️ **Use with caution** - this will overwrite existing files:

```bash
# Preview what would be overwritten
./setup.sh --dry-run

# Force overwrite (backup files are still created)
FORCE_OVERWRITE=true ./setup.sh
```

## 🩹 Recovery and Troubleshooting

### Recovering from Failed Installation

If the setup script fails partway through:

```bash
# Check what was installed
ls -la ~ | grep " -> "  # Show existing symlinks

# Run dry-run to see remaining tasks
./setup.sh --dry-run

# Continue installation (script handles partial state)
./setup.sh
```

### Restoring Backup Files

If you need to restore original files:

```bash
# List backup files (with timestamps)
ls -la ~/*_20*

# Restore a specific file
mv ~/.zshrc_2025-01-23_1642534789 ~/.zshrc

# Remove dotfiles symlink first if needed
rm ~/.zshrc  # (if it's a symlink)
mv ~/.zshrc_2025-01-23_1642534789 ~/.zshrc
```

### Fixing Broken Symlinks

Remove broken symlinks and re-run setup:

```bash
# Find and remove broken symlinks
find ~ -maxdepth 2 -type l ! -exec test -e {} \; -delete 2>/dev/null

# Re-run setup to recreate proper links
./setup.sh
```

### Complete Reset

Start over completely (nuclear option):

```bash
# 1. Remove all dotfiles symlinks
cd ~/dotfiles
stow -D */  # Unstow all packages

# 2. Restore backups if desired
# mv ~/.zshrc_backup ~/.zshrc
# (repeat for other backed up files)

# 3. Fresh installation
./setup.sh --dry-run
./setup.sh
```

## 🌍 Environment Variables

### Available Variables

Control setup script behavior with environment variables:

```bash
# Specify dotfiles location (default: ~/dotfiles)
DOTFILES="/custom/path/to/dotfiles" ./setup.sh

# Custom XDG config directory (default: ~/.config)
XDG_CONFIG_HOME="/custom/config" ./setup.sh

# Specify which packages to install
STOW_PACKAGES="git,tmux,nvim" ./setup.sh

# Custom backup directory for conflicts
BACKUP_DIR="/tmp/my-backups" ./setup.sh

# Skip hostname setup (advanced)
SKIP_HOSTNAME=true ./setup.sh

# Enable debug output
DEBUG=true ./setup.sh --dry-run
```

### Combining Variables

```bash
# Example: Install only git and nvim configs to custom location
DOTFILES="/path/to/my/dotfiles" \
STOW_PACKAGES="git,nvim" \
BACKUP_DIR="/tmp/backup" \
./setup.sh --dry-run
```

## ✅ Verification Commands

### Post-Installation Checks

Verify your installation was successful:

```bash
# Check key symlinks exist
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim ~/.config/tmux

# Test shell configuration loads
zsh -c 'echo $PATH | tr ":" "\n" | head -5'
fish -c 'echo $PATH'

# Verify git configuration
git config user.name
git config user.email

# Test Neovim
nvim --version
nvim -c ':checkhealth' -c ':quit'

# Check Homebrew integration
brew --version
which brew

# Verify Tmux
tmux -V
ls ~/.config/tmux/plugins/
```

### Abbreviation and Function Tests

```bash
# Test abbreviations work (should show expansions)
# In Fish:
abbr | head -10

# In Zsh:
abbr list | head -10

# Test custom functions
which g    # Should show git function
which cdot # Should show dotfiles navigation function
which tat  # Should show tmux function
```

### System Integration Tests

```bash
# Test Starship prompt
starship --version
echo $STARSHIP_CONFIG

# Test asdf version manager
asdf --version
asdf current

# Test custom scripts
ls ~/.local/bin/
which git-cm  # Custom git commit script
```

## 🔧 Common Command Patterns

### Daily Workflow

```bash
# Morning routine - update everything
cd ~/dotfiles
git pull origin master
./setup.sh --dry-run  # Check for changes
./setup.sh            # Apply updates
brew bundle install   # Update packages
```

### Testing Changes

```bash
# Before making changes
./setup.sh --dry-run > /tmp/before.txt

# After making changes
./setup.sh --dry-run > /tmp/after.txt
diff /tmp/before.txt /tmp/after.txt  # See differences
```

### Backup Strategy

```bash
# Create full backup before major changes
cp -r ~/.config ~/.config.backup.$(date +%Y%m%d)
./setup.sh --dry-run  # Preview changes
./setup.sh            # Apply changes
```

## 🆘 Getting Help

If these examples don't cover your use case:

1. **Check the logs**: Look for error messages in terminal output
2. **Use dry-run**: Always preview with `--dry-run` first
3. **Read the script**: `less ~/dotfiles/setup.sh` to understand behavior
4. **Review other guides**: See [troubleshooting.md](troubleshooting.md) for specific issues
5. **File an issue**: Report problems on [GitHub](https://github.com/joshukraine/dotfiles/issues)

Remember: The setup script is designed to be idempotent - safe to run multiple times!
