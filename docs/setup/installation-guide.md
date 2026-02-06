# Installation Guide

This guide provides a complete, step-by-step walkthrough for installing the dotfiles on a fresh macOS system. Follow these instructions for a smooth setup experience.

## 📋 Table of Contents

- [Pre-Installation Checklist](#%EF%B8%8F-pre-installation-checklist)
- [System Requirements](#%EF%B8%8F-system-requirements)
- [Step-by-Step Installation](#-step-by-step-installation)
- [Post-Installation Verification](#-post-installation-verification)
- [Next Steps](#-next-steps)
- [Common First-Time Issues](#%EF%B8%8F-common-first-time-issues)

## 🛡️ Pre-Installation Checklist

Before running the bootstrap script, complete these essential steps:

### ✅ 1. System Preparation

- [ ] **Update macOS** - Ensure you're running the latest version
- [ ] **Complete initial macOS setup** (Apple ID, user account, etc.)
- [ ] **Log in to iCloud**

### 🚀 2. Run the Bootstrap Script

The bootstrap script handles everything automatically — Xcode CLI tools,
Homebrew, dotfiles, language runtimes, and shell setup:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/pyeh/dotfiles/master/scripts/bootstrap.sh)
```

Preview what the script will do first:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/pyeh/dotfiles/master/scripts/bootstrap.sh) --dry-run
```

The bootstrap script is idempotent and can be run multiple times safely. See the
[README](../../README.md#-new-mac-bootstrap) for the full list of phases and options.

### Alternative: Manual Setup

If you prefer manual control, you can install prerequisites individually:

#### Install Xcode Command Line Tools

```bash
xcode-select --install
```

#### Install Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-installation instructions to add Homebrew to your PATH.

#### Install GNU Stow

```bash
brew install stow
```

## 🖥️ System Requirements

- **Operating System**: macOS (Darwin) - Intel or Apple Silicon
- **Required Tools**:
  - Git (usually included with Xcode Command Line Tools)
  - GNU Stow (for symlink management)
  - Homebrew (package manager)
- **Permissions**: sudo access (required for hostname setup)
- **Disk Space**: ~500MB for dotfiles and basic tools

## 🚀 Step-by-Step Installation

### Step 1: Clone the Repository

```bash
# Clone to the standard location
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles

# Navigate to the dotfiles directory
cd ~/dotfiles
```

### Step 2: Review the Setup Script

Always review automation scripts before running them:

```bash
# Read the setup script
less setup.sh

# Check available options
./setup.sh --help
```

You should see output like:

```text
Usage: ./setup.sh [OPTIONS]

This script sets up dotfiles using GNU Stow for symlink management.
It can be run safely multiple times on the same machine.

Options:
  --dry-run    Show what would be done without making any changes
  --help       Show this help message
```

### Step 3: Preview Changes (Recommended)

Run a dry-run to see exactly what the script will do:

```bash
./setup.sh --dry-run
```

This will show you:

- What directories will be created
- Which files might be backed up due to conflicts
- What symlinks will be created
- Any potential issues before they occur

### Step 4: Check for Conflicts

The script will automatically detect conflicts, but you can manually check:

```bash
# Check your home directory for existing dotfiles
ls -la ~ | grep -E "\.(zshrc|gitconfig|tmux\.conf)"

# Check XDG config directory
ls -la ~/.config 2>/dev/null

# Check local bin directory
ls -la ~/.local/bin 2>/dev/null
```

If you see files that match what the dotfiles will install, the setup script will automatically back them up with timestamps.

### Step 5: Run the Installation

When you're ready, run the full installation:

```bash
./setup.sh
```

The script will:

1. **Check prerequisites** - Verify macOS, Stow, and sudo access
2. **Set hostname** - Configure system hostname settings
3. **Create directories** - Set up `~/.config` and `~/.local/bin`
4. **Handle conflicts** - Back up existing files with timestamps
5. **Create symlinks** - Use Stow to link all configuration files
6. **Configure shells** - Set up Fish user paths if Fish is installed
7. **Install Tmux components** - Set up terminal info and plugin manager

### Step 6: Handle Any Conflicts

If the script encounters conflicts, you'll see messages like:

```text
[WARN] Conflict detected: /Users/username/.zshrc
[INFO] Backing up /Users/username/.zshrc to /Users/username/.zshrc_2025-01-23_1642534789
```

This is normal and safe - your original files are preserved with timestamps.

## ✅ Post-Installation Verification

After installation completes, verify everything worked correctly:

### Check Symlinks

```bash
# Verify key symlinks were created
ls -la ~/.zshrc ~/.gitconfig ~/.config/nvim

# Should show arrows pointing to ~/dotfiles/... locations
```

### Test Shell Configuration

```bash
# Test Zsh configuration (if using Zsh)
zsh -c 'echo "Zsh config loaded successfully"'

# Test Fish configuration (if using Fish)
fish -c 'echo "Fish config loaded successfully"'
```

### Verify Git Configuration

```bash
# Check git configuration
git config --list | head -10

# Should show configurations from dotfiles
```

### Test Neovim

```bash
# Launch Neovim and check health
nvim -c ':checkhealth' -c ':quit'
```

### Check Homebrew Integration

```bash
# Verify Homebrew is in PATH
which brew

# Should show /opt/homebrew/bin/brew (Apple Silicon) or /usr/local/bin/brew (Intel)
```

## 🔄 Next Steps

After successful installation, consider these additional setup tasks:

### 1. Install Homebrew Packages

```bash
# Review the Brewfile
less ~/Brewfile

# Install all packages (this may take a while)
brew bundle install
```

### 2. Set Up Shell (Choose One)

**For Zsh users:**

```bash
# Install Zap plugin manager (follow instructions at zapzsh.com with --keep flag)
# Then restart your terminal or run:
exec zsh
```

**For Fish users:**

```bash
# Fish should work immediately, but you can customize:
fish_config

# Or simply restart your terminal
```

### 3. Configure Personal Information

Create local configuration files for personal data:

```bash
# Git personal configuration
touch ~/.gitconfig.local
# Add your name and email:
# [user]
#   name = Your Name
#   email = your.email@example.com

# Laptop local configuration (if you ran the laptop script)
touch ~/.laptop.local

# Fish local configuration (if using Fish)
touch ~/dotfiles/local/config.fish.local
```

### 4. Set Up Tmux Plugins

If you use Tmux:

```bash
# Launch Tmux
tmux

# Install plugins with prefix + I (default prefix is Ctrl-b)
# Press: Ctrl-b, then Shift-i
```

### 5. Configure Neovim

```bash
# Launch Neovim - plugins should install automatically
nvim

# Run health check to resolve any issues
:checkhealth
```

## ⚠️ Common First-Time Issues

### Permission Errors

**Problem**: Script fails with permission errors
**Solution**: Ensure you have sudo access and run the script from your user account, not as root

### Homebrew Path Issues

**Problem**: Command not found errors for brew, git, etc.
**Solution**:

```bash
# Add Homebrew to PATH manually, then restart terminal
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile  # Apple Silicon
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile     # Intel Mac
```

### Stow Conflicts

**Problem**: Stow reports conflicts that weren't automatically resolved
**Solution**:

```bash
# Remove or backup the conflicting files manually
mv ~/.conflicting-file ~/.conflicting-file.backup

# Re-run the setup script
./setup.sh
```

### Shell Doesn't Load Configuration

**Problem**: New terminal sessions don't load the dotfiles configuration
**Solution**:

```bash
# Verify symlinks exist
ls -la ~/.zshrc ~/.config/fish/config.fish

# Restart terminal completely (not just new tab)
# Or source manually:
source ~/.zshrc  # for Zsh
exec fish        # for Fish
```

### Git Configuration Missing

**Problem**: Git doesn't recognize your identity
**Solution**: Create `~/.gitconfig.local` with your personal information:

```bash
[user]
  name = Your Full Name
  email = your.email@example.com
```

## 🆘 Getting Additional Help

If you encounter issues not covered here:

1. **Re-run with dry-run**: `./setup.sh --dry-run` to diagnose
2. **Check the logs**: Look for error messages in the terminal output
3. **Review troubleshooting guide**: See [troubleshooting.md](troubleshooting.md)
4. **File an issue**: Report problems on [GitHub](https://github.com/joshukraine/dotfiles/issues)

## 🎉 Success

If you've completed all steps successfully, you now have a fully configured development environment! Your terminal should show the Starship prompt, and you'll have access to all the shell functions and abbreviations.

Welcome to your new development setup! 🚀
