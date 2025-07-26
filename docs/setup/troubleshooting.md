# Troubleshooting Guide

This guide covers common issues you might encounter when setting up or maintaining the dotfiles, along with their solutions. Use this as a reference when things don't go as expected.

## 📋 Table of Contents

- [Permission and Access Issues](#-permission-and-access-issues)
- [Stow and Symlink Problems](#-stow-and-symlink-problems)
- [Homebrew Issues](#-homebrew-issues)
- [Shell Configuration Problems](#-shell-configuration-problems)
- [Platform and Architecture Issues](#%EF%B8%8F-platform-and-architecture-issues)
- [Git Configuration Problems](#-git-configuration-problems)
- [Application-Specific Issues](#-application-specific-issues)
- [Performance and Startup Issues](#-performance-and-startup-issues)

## 🔐 Permission and Access Issues

### Setup Script Fails with Permission Denied

**Problem**: Script fails with "Permission denied" errors

```text
[ERROR] Failed to execute: sudo scutil --set HostName
Permission denied
```

**Solutions**:

1. **Ensure you have sudo access**:

   ```bash
   sudo -v  # Test sudo access
   ```

2. **Don't run the script as root**:

   ```bash
   # ❌ Wrong - don't do this
   sudo ./setup.sh

   # ✅ Correct - run as your user
   ./setup.sh
   ```

3. **Check your user account type**:

   ```bash
   # Verify you're in the admin group
   groups $USER | grep -q admin && echo "Admin user" || echo "Standard user"
   ```

### Files Cannot Be Created in Home Directory

**Problem**: Script fails to create directories or files in `$HOME`

```text
mkdir: /Users/username/.config: Permission denied
```

**Solutions**:

1. **Fix home directory permissions**:

   ```bash
   # Check permissions
   ls -ld $HOME

   # Fix if needed (replace 'username' with your username)
   sudo chown -R username:staff $HOME
   chmod 755 $HOME
   ```

2. **Check disk space**:

   ```bash
   df -h $HOME
   ```

3. **Verify the path is correct**:

   ```bash
   echo $HOME
   pwd
   ```

## 🔗 Stow and Symlink Problems

> 💡 **Agent Assistance**: For complex Stow and symlink issues, consider using the **[Config Manager Agent](../../agents/config-manager.md)** for specialized help with dotfiles structure and Stow package management.

### Stow Command Not Found

**Problem**: `stow: command not found`

**Solutions**:

1. **Install GNU Stow via Homebrew**:

   ```bash
   brew install stow
   ```

2. **Verify installation**:

   ```bash
   which stow
   stow --version
   ```

3. **Check PATH includes Homebrew**:

   ```bash
   echo $PATH | grep -E "(opt/homebrew|usr/local)"
   ```

### Stow Conflicts Not Automatically Resolved

**Problem**: Stow reports conflicts that the script didn't handle

```text
WARNING! stowing git would cause conflicts:
  * existing target is neither a link nor a directory: .gitconfig
```

**Solutions**:

1. **Manual backup and retry**:

   ```bash
   # Backup the conflicting file
   mv ~/.gitconfig ~/.gitconfig.backup.$(date +%Y%m%d)

   # Re-run setup
   ./setup.sh
   ```

2. **Force adoption of existing files**:

   ```bash
   cd ~/dotfiles
   stow --adopt git/  # Adopts existing .gitconfig into dotfiles
   git checkout .     # Reset adopted files to dotfiles version
   ```

3. **Check for hidden conflicts**:

   ```bash
   # Look for files that might conflict
   ls -la ~ | grep -E "\.(zshrc|bashrc|gitconfig|tmux\.conf)"
   ls -la ~/.config/
   ls -la ~/.local/bin/
   ```

### Broken Symlinks After Setup

**Problem**: Symlinks point to non-existent files

```bash
ls -la ~/.zshrc
# Shows: .zshrc -> /path/to/missing/file
```

**Solutions**:

1. **Find and remove broken symlinks**:

   ```bash
   # Find broken symlinks in home directory
   find ~ -maxdepth 2 -type l ! -exec test -e {} \; -print 2>/dev/null

   # Remove them
   find ~ -maxdepth 2 -type l ! -exec test -e {} \; -delete 2>/dev/null
   ```

2. **Re-run setup to recreate links**:

   ```bash
   ./setup.sh
   ```

3. **Verify dotfiles repository is complete**:

   ```bash
   cd ~/dotfiles
   git status  # Check for missing files
   git pull origin master  # Update to latest
   ```

## 🍺 Homebrew Issues

### Homebrew Not Found in PATH

**Problem**: `brew: command not found` after installation

**Solutions**:

1. **Add Homebrew to PATH manually**:

   ```bash
   # For Apple Silicon Macs
   echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
   source ~/.zprofile

   # For Intel Macs
   echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
   source ~/.zprofile
   ```

2. **Check Homebrew installation**:

   ```bash
   # Apple Silicon
   ls -la /opt/homebrew/bin/brew

   # Intel
   ls -la /usr/local/bin/brew
   ```

3. **Reinstall Homebrew if needed**:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

### Homebrew Packages Fail to Install

**Problem**: `brew bundle install` fails with various errors

**Solutions**:

1. **Update Homebrew first**:

   ```bash
   brew update
   brew upgrade
   brew doctor  # Check for issues
   ```

2. **Check for architecture conflicts**:

   ```bash
   # Check what architecture Homebrew is using
   brew config | grep "CPU\|Architecture"

   # For Apple Silicon with Rosetta issues
   arch -arm64 brew install <package>
   ```

3. **Clear Homebrew cache**:

   ```bash
   brew cleanup -s  # Clean up cached downloads
   ```

4. **Install packages individually**:

   ```bash
   # Skip problematic packages temporarily
   brew bundle install --no-lock
   ```

## 🐚 Shell Configuration Problems

> 💡 **Agent Assistance**: For abbreviation and shell configuration issues, the **[Abbreviation Manager Agent](../../agents/abbreviation-manager.md)** can help with YAML-based abbreviation system troubleshooting.

### New Terminal Doesn't Load Dotfiles Configuration

**Problem**: New terminal sessions use default configurations instead of dotfiles

**Solutions**:

1. **Verify symlinks exist**:

   ```bash
   ls -la ~/.zshrc ~/.config/fish/config.fish
   # Should show arrows pointing to dotfiles
   ```

2. **Check shell is correctly set**:

   ```bash
   echo $SHELL
   # Should show /opt/homebrew/bin/zsh or similar

   # Change shell if needed
   chsh -s $(which zsh)  # or $(which fish)
   ```

3. **Restart terminal completely**:
   - Close all terminal windows/tabs
   - Quit terminal application
   - Reopen terminal

4. **Source configuration manually**:

   ```bash
   # For Zsh
   source ~/.zshrc

   # For Fish
   exec fish
   ```

### Abbreviations Not Working

**Problem**: Shell abbreviations don't expand

**Solutions**:

1. **Regenerate abbreviations**:

   ```bash
   # Use the convenience function
   reload-abbr

   # Or manually
   cd ~/dotfiles/shared
   ./generate-all-abbr.sh
   ```

2. **Check abbreviation files exist**:

   ```bash
   ls -la ~/.config/fish/abbreviations.fish
   ls -la ~/.config/zsh-abbr/abbreviations.zsh
   ```

3. **For Zsh, ensure zsh-abbr is installed**:

   ```bash
   # Install Zap plugin manager first
   # Then restart terminal
   ```

4. **Test abbreviation system**:

   ```bash
   # In Fish
   abbr | head -5

   # In Zsh
   abbr list | head -5
   ```

### Starship Prompt Not Loading

**Problem**: Terminal shows default prompt instead of Starship

**Solutions**:

1. **Install Starship**:

   ```bash
   brew install starship
   ```

2. **Check configuration file**:

   ```bash
   ls -la ~/.config/starship.toml
   echo $STARSHIP_CONFIG
   ```

3. **Verify shell initialization**:

   ```bash
   # Check these lines exist in shell config
   grep -n "starship" ~/.zshrc ~/.config/fish/config.fish
   ```

4. **Test Starship directly**:

   ```bash
   starship --version
   starship config  # Should show current config
   ```

## 🖥️ Platform and Architecture Issues

### Script Fails on Non-macOS Systems

**Problem**: Setup script exits with "This script only supports macOS"

**Solutions**:

1. **For Linux/WSL users**:

   ```bash
   # The dotfiles are macOS-specific, but you can:
   # 1. Fork the repository
   # 2. Modify the OS check in setup.sh
   # 3. Adapt Homebrew commands to your package manager
   # 4. Remove macOS-specific components
   ```

2. **For virtualized macOS**:

   ```bash
   # Ensure the VM reports correct OS
   uname -s  # Should return "Darwin"
   ```

### Architecture Detection Issues

**Problem**: Wrong Homebrew path detected (Intel vs Apple Silicon)

**Solutions**:

1. **Check current architecture**:

   ```bash
   uname -m  # Should show "arm64" or "x86_64"
   arch      # Should show "arm64" or "i386"
   ```

2. **Manually set HOMEBREW_PREFIX**:

   ```bash
   # For Apple Silicon
   export HOMEBREW_PREFIX="/opt/homebrew"

   # For Intel
   export HOMEBREW_PREFIX="/usr/local"

   # Then run setup
   ./setup.sh
   ```

3. **Fix mixed architecture installations**:

   ```bash
   # If you have both Intel and ARM Homebrew installed
   # Remove one and reinstall
   ```

## 📝 Git Configuration Problems

### Git Doesn't Recognize User Identity

**Problem**: Git commits fail with "Please tell me who you are"

**Solutions**:

1. **Create local git configuration**:

   ```bash
   touch ~/.gitconfig.local
   # Add your information:
   cat >> ~/.gitconfig.local << EOF
   [user]
     name = Your Full Name
     email = your.email@example.com
   EOF
   ```

2. **Verify configuration is loaded**:

   ```bash
   git config --list | grep user
   git config user.name
   git config user.email
   ```

3. **Check global gitconfig symlink**:

   ```bash
   ls -la ~/.gitconfig
   # Should point to ~/dotfiles/git/.gitconfig
   ```

### Git Functions Not Working

**Problem**: Custom git functions like `gpum`, `gcom` don't work

**Solutions**:

1. **Check function files are loaded**:

   ```bash
   which gpum
   type gpum
   ```

2. **Verify function definitions**:

   ```bash
   # In Fish
   functions gpum

   # In Zsh
   whence -f gpum
   ```

3. **Reload shell configuration**:

   ```bash
   source ~/.zshrc  # Zsh
   exec fish        # Fish
   ```

## 🎯 Application-Specific Issues

### Neovim Configuration Problems

**Problem**: Neovim doesn't load LazyVim configuration

**Solutions**:

1. **Check Neovim configuration symlink**:

   ```bash
   ls -la ~/.config/nvim
   # Should point to ~/dotfiles/nvim/.config/nvim
   ```

2. **Verify Neovim version**:

   ```bash
   nvim --version
   # Should be >= 0.8.0 for LazyVim
   ```

3. **Run health check**:

   ```bash
   nvim -c ':checkhealth' -c ':quit'
   ```

4. **Reset Neovim configuration**:

   ```bash
   # Backup and clear existing config/data
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup

   # Re-run setup
   ./setup.sh
   ```

### Tmux Plugin Issues

**Problem**: Tmux plugins not installing or working

**Solutions**:

1. **Check Tmux Plugin Manager**:

   ```bash
   ls -la ~/.config/tmux/plugins/tpm
   ```

2. **Install TPM if missing**:

   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```

3. **Install plugins manually**:

   ```bash
   # In tmux session, press: prefix + I (capital i)
   # Default prefix is Ctrl-b
   ```

4. **Check tmux configuration**:

   ```bash
   tmux show-options -g | grep plugins
   ```

## ⚡ Performance and Startup Issues

### Slow Shell Startup

**Problem**: New terminal sessions take a long time to open

**Solutions**:

1. **Enable Zsh profiling**:

   ```bash
   touch ~/.zshrc.profiler
   # Open new terminal, then check results
   zshrc_profiler_view
   ```

2. **Check for slow components**:

   ```bash
   # Time individual components
   time starship init zsh
   time asdf reshim
   ```

3. **Disable problematic plugins temporarily**:

   ```bash
   # Comment out slow initializations in shell config
   # Re-enable one by one to identify culprit
   ```

### High Resource Usage

**Problem**: Shell or terminal uses excessive CPU/memory

**Solutions**:

1. **Check running processes**:

   ```bash
   ps aux | grep -E "(zsh|fish|starship)" | head -10
   ```

2. **Monitor resource usage**:

   ```bash
   top -o cpu | grep -E "(zsh|fish)"
   ```

3. **Identify problematic functions**:

   ```bash
   # Check for infinite loops in shell functions
   # Review custom aliases and abbreviations
   ```

## 🆘 Getting Additional Help

### Specialized Agent Assistance

For targeted help with specific aspects of the dotfiles, use the appropriate specialized agent:

| Issue Type                                 | Recommended Agent                                                   | What They Help With                                          |
| ------------------------------------------ | ------------------------------------------------------------------- | ------------------------------------------------------------ |
| **Stow conflicts, package management**     | **[🔧 Config Manager](../../agents/config-manager.md)**             | Dotfiles structure, Stow operations, symlink troubleshooting |
| **Abbreviations not working, shell setup** | **[⚡ Abbreviation Manager](../../agents/abbreviation-manager.md)** | YAML abbreviation system, Fish/Zsh sync issues               |
| **Test failures, validation errors**       | **[✅ Test Validator](../../agents/test-validator.md)**             | Running tests, linting, pre-commit hook setup                |
| **Documentation outdated or unclear**      | **[📚 Documentation Helper](../../agents/docs-helper.md)**          | Updating guides, fixing examples, troubleshooting docs       |

### General Troubleshooting Steps

If your issue isn't covered here:

1. **Check the setup script output carefully** - error messages often point to the exact problem
2. **Use dry-run mode** to understand what the script is trying to do: `./setup.sh --dry-run`
3. **Search existing issues** on the [GitHub repository](https://github.com/joshukraine/dotfiles/issues)
4. **Enable debug mode** for more verbose output: `DEBUG=true ./setup.sh --dry-run`
5. **File a new issue** with:
   - Your operating system and version
   - Complete error messages
   - Steps to reproduce the problem
   - Output from `./setup.sh --dry-run`

## 🔧 Emergency Recovery

If everything is broken and you need to start over:

```bash
# 1. Remove all dotfiles symlinks
cd ~/dotfiles
stow -D */

# 2. Restore any backup files you want to keep
ls -la ~/*_20*  # List backup files
# mv ~/.zshrc_backup ~/.zshrc  # etc.

# 3. Start fresh
git pull origin master
./setup.sh --dry-run
./setup.sh
```

Remember: The setup script creates timestamped backups of any files it would overwrite, so your original configurations are preserved!
