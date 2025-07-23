# Customization Guide

This guide shows you how to personalize the dotfiles to match your preferences and workflow while maintaining the ability to receive updates from the main repository.

## 📋 Table of Contents

- [Local Configuration Pattern](#local-configuration-pattern)
- [Personal Information Setup](#personal-information-setup)
- [Shell Customization](#shell-customization)
- [Environment Variables](#environment-variables)
- [Selective Package Installation](#selective-package-installation)
- [Custom Scripts and Utilities](#custom-scripts-and-utilities)
- [Application-Specific Customization](#application-specific-customization)
- [Theme and Appearance](#theme-and-appearance)
- [Maintaining Your Customizations](#maintaining-your-customizations)

## 🎨 Local Configuration Pattern

The dotfiles use a `.local` suffix pattern for personal customizations. These files are:

- **Never committed** to the repository
- **Loaded automatically** by the main configuration files
- **Safe from updates** - won't be overwritten when you pull changes

### How It Works

Each main configuration file looks for a corresponding `.local` file:

```bash
# Example from .gitconfig
[include]
  path = ~/.gitconfig.local

# Example from .zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

This pattern ensures your personal settings persist through dotfiles updates.

## 👤 Personal Information Setup

### Git Configuration

Create `~/.gitconfig.local` for your personal git settings:

```bash
# Create the file
touch ~/.gitconfig.local

# Add your information
cat >> ~/.gitconfig.local << 'EOF'
[user]
  name = Your Full Name
  email = your.email@example.com
  signingkey = YOUR_GPG_KEY_ID  # Optional

[github]
  user = your-github-username

[credential]
  helper = osxkeychain

# Personal aliases that aren't in the main config
[alias]
  work = "!git config user.email 'work@company.com'"
  personal = "!git config user.email 'personal@example.com'"
EOF
```

### SSH Configuration

Create `~/.ssh/config.local` for personal SSH settings:

```bash
# Create the file
touch ~/.ssh/config.local

# Add your personal hosts
cat >> ~/.ssh/config.local << 'EOF'
Host personal-server
  HostName your-server.com
  User yourusername
  IdentityFile ~/.ssh/id_rsa_personal

Host work-*
  User work-username
  IdentityFile ~/.ssh/id_rsa_work
EOF
```

## 🐚 Shell Customization

### Fish Shell Customization

Create `~/dotfiles/local/config.fish.local` for Fish-specific settings:

```bash
# Create local config file
mkdir -p ~/dotfiles/local
touch ~/dotfiles/local/config.fish.local

# Add your customizations
cat >> ~/dotfiles/local/config.fish.local << 'EOF'
# Personal environment variables
set -gx EDITOR code  # Use VS Code instead of vim
set -gx BROWSER firefox

# Personal abbreviations (in addition to shared ones)
abbr -a myserver ssh personal-server
abbr -a backup rsync -av --progress

# Custom functions
function work_mode
    git config user.email "work@company.com"
    echo "Switched to work mode"
end

function personal_mode
    git config user.email "personal@example.com"
    echo "Switched to personal mode"
end
EOF
```

### Zsh Customization

Create `~/.zshrc.local` for Zsh-specific settings:

```bash
# Create local config file
touch ~/.zshrc.local

# Add your customizations
cat >> ~/.zshrc.local << 'EOF'
# Personal environment variables
export EDITOR="code"
export BROWSER="firefox"

# Personal aliases (in addition to abbreviations)
alias myserver="ssh personal-server"
alias backup="rsync -av --progress"

# Custom functions
work_mode() {
    git config user.email "work@company.com"
    echo "Switched to work mode"
}

personal_mode() {
    git config user.email "personal@example.com"
    echo "Switched to personal mode"
}

# Custom prompt additions (if using a different prompt)
# PROMPT_CUSTOM="(custom) "
EOF
```

## 🌍 Environment Variables

### Global Environment Customization

Create `~/.environment.local` for system-wide environment variables:

```bash
# Create the file
touch ~/.environment.local

# Add your variables
cat >> ~/.environment.local << 'EOF'
# Development paths
export DEV_HOME="$HOME/Development"
export PROJECTS_DIR="$HOME/Projects"

# API keys and tokens (use 1Password CLI or similar)
export GITHUB_TOKEN="$(op item get 'GitHub Token' --fields password 2>/dev/null)"

# Tool configurations
export HOMEBREW_NO_ANALYTICS=1
export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

# Custom PATH additions
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/scripts:$PATH"
EOF
```

### Application-Specific Environment

```bash
# Node.js configuration
cat >> ~/.environment.local << 'EOF'
export NPM_CONFIG_PREFIX="$HOME/.npm-global"
export PATH="$NPM_CONFIG_PREFIX/bin:$PATH"
EOF

# Python configuration
cat >> ~/.environment.local << 'EOF'
export PYTHON_PATH="$HOME/.local/lib/python3.11/site-packages:$PYTHON_PATH"
EOF

# Go configuration
cat >> ~/.environment.local << 'EOF'
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
EOF
```

## 📦 Selective Package Installation

### Installing Only Specific Components

Use environment variables to control which dotfiles packages are installed:

```bash
# Install only git, nvim, and tmux configurations
export STOW_PACKAGES="git,nvim,tmux"
./setup.sh --dry-run  # Preview
./setup.sh            # Install

# Or inline
STOW_PACKAGES="git,nvim,tmux" ./setup.sh
```

### Available Packages

List all available packages (directory names in dotfiles):

```bash
cd ~/dotfiles
ls -d */ | sed 's/\///' | sort
```

Common package combinations:

```bash
# Minimal setup
STOW_PACKAGES="git,bash,zsh"

# Development setup
STOW_PACKAGES="git,nvim,tmux,zsh,starship"

# Full terminal experience
STOW_PACKAGES="git,nvim,tmux,zsh,fish,starship,lazygit"
```

### Custom Brewfile

Create a personal `Brewfile.local` for additional packages:

```bash
# Create personal Brewfile
touch ~/Brewfile.local

# Add your packages
cat >> ~/Brewfile.local << 'EOF'
# Personal GUI applications
cask "discord"
cask "spotify"
cask "figma"

# Development tools
brew "postgresql"
brew "redis"

# Fonts
cask "font-operator-mono"
EOF

# Install personal packages
brew bundle install --file ~/Brewfile.local
```

## 🛠️ Custom Scripts and Utilities

### Personal Scripts Directory

Create `~/.local/bin/` for personal scripts (already in PATH):

```bash
# Create directory if it doesn't exist
mkdir -p ~/.local/bin

# Example: Personal deployment script
cat > ~/.local/bin/deploy-personal << 'EOF'
#!/usr/bin/env bash
# Personal deployment script

set -e

PROJECT_DIR="$HOME/Projects/my-site"
DEPLOY_HOST="personal-server"

echo "Deploying personal site..."
cd "$PROJECT_DIR"
npm run build
rsync -av --progress dist/ "$DEPLOY_HOST:/var/www/html/"
echo "Deploy complete!"
EOF

# Make it executable
chmod +x ~/.local/bin/deploy-personal
```

### Custom Fish Functions

Add personal functions to `~/dotfiles/local/config.fish.local`:

```fish
# Custom navigation function
function dev
    cd $DEV_HOME/$argv[1]
end

# Project management
function project
    set project_path "$PROJECTS_DIR/$argv[1]"
    if test -d $project_path
        cd $project_path
        code .  # Open in VS Code
    else
        echo "Project $argv[1] not found"
    end
end

# Quick commit function
function qc
    git add -A
    git commit -m "$argv"
end
```

## 🎯 Application-Specific Customization

### Neovim Customization

Create personal Neovim overrides in the LazyVim structure:

```bash
# Personal plugin additions
mkdir -p ~/.config/nvim/lua/plugins/personal

# Example: Add your favorite colorscheme
cat > ~/.config/nvim/lua/plugins/personal/colorscheme.lua << 'EOF'
return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night",
      transparent = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight-night",
    },
  },
}
EOF
```

### Tmux Customization

Create `~/.tmux.conf.local` for personal tmux settings:

```bash
# Create local tmux config
touch ~/.tmux.conf.local

cat >> ~/.tmux.conf.local << 'EOF'
# Personal key bindings
bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"

# Custom status bar
set -g status-right "#[fg=cyan]%A, %d %b %Y %I:%M %p"

# Personal color scheme
set -g status-bg colour235
set -g status-fg colour136
EOF
```

### Starship Customization

Create `~/.config/starship.local.toml` for prompt customization:

```bash
cat > ~/.config/starship.local.toml << 'EOF'
# Personal Starship configuration

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[git_branch]
symbol = " "

[nodejs]
symbol = " "

[python]
symbol = " "

[rust]
symbol = " "
EOF
```

## 🎨 Theme and Appearance

### Terminal Color Scheme

Customize colors in your terminal application:

1. **Ghostty**: Edit `~/.config/ghostty/config`
2. **Kitty**: Edit `~/.config/kitty/kitty.conf.local`
3. **iTerm2**: Import color schemes manually

### Font Customization

Install additional fonts and configure them:

```bash
# Install personal fonts via Homebrew
brew install --cask font-operator-mono
brew install --cask font-comic-code

# Update terminal font settings
# (varies by terminal application)
```

## 🔄 Maintaining Your Customizations

### Backup Your Local Configurations

Create a backup script for your customizations:

```bash
cat > ~/.local/bin/backup-local-configs << 'EOF'
#!/usr/bin/env bash
# Backup local configuration files

BACKUP_DIR="$HOME/dotfiles-local-backup-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# List of local config files to backup
LOCAL_FILES=(
    "$HOME/.gitconfig.local"
    "$HOME/.zshrc.local"
    "$HOME/.environment.local"
    "$HOME/Brewfile.local"
    "$HOME/dotfiles/local/config.fish.local"
    "$HOME/.tmux.conf.local"
)

for file in "${LOCAL_FILES[@]}"; do
    if [[ -f "$file" ]]; then
        cp "$file" "$BACKUP_DIR/"
        echo "Backed up: $file"
    fi
done

echo "Backup completed: $BACKUP_DIR"
EOF

chmod +x ~/.local/bin/backup-local-configs
```

### Version Control for Local Configs

Consider creating a private repository for your local configurations:

```bash
# Create a private repo for local configs
mkdir ~/.local-dotfiles
cd ~/.local-dotfiles
git init

# Add your local configs
cp ~/.gitconfig.local .
cp ~/.zshrc.local .
cp ~/dotfiles/local/config.fish.local .

# Create README documenting your customizations
cat > README.md << 'EOF'
# My Personal Dotfiles Customizations

This repository contains my personal local configuration files that complement the main dotfiles repository.

## Files
- `gitconfig.local` - Personal git configuration
- `zshrc.local` - Zsh customizations
- `config.fish.local` - Fish shell customizations

## Installation
Copy these files to their respective locations after setting up the main dotfiles.
EOF

git add .
git commit -m "Initial commit of local configurations"

# Push to a private GitHub repository
git remote add origin git@github.com:yourusername/local-dotfiles.git
git push -u origin master
```

### Updating Main Dotfiles While Preserving Customizations

Safe update workflow:

```bash
# 1. Backup your local configs
backup-local-configs

# 2. Update main dotfiles
cd ~/dotfiles
git pull origin master

# 3. Preview changes
./setup.sh --dry-run

# 4. Apply updates (your .local files are preserved)
./setup.sh

# 5. Update personal Homebrew packages
brew bundle install --file ~/Brewfile.local

# 6. Regenerate abbreviations if needed
reload-abbr
```

## 🚀 Advanced Customization

### Creating Your Own Stow Package

Add a custom configuration package to the dotfiles:

```bash
# Create a personal package directory
mkdir -p ~/dotfiles/personal/.local/bin

# Add your custom script
cat > ~/dotfiles/personal/.local/bin/my-tool << 'EOF'
#!/usr/bin/env bash
echo "My custom tool!"
EOF

chmod +x ~/dotfiles/personal/.local/bin/my-tool

# Include in installation
STOW_PACKAGES="git,nvim,tmux,personal" ./setup.sh
```

### Integration with External Tools

Connect your customizations with external services:

```bash
# Example: 1Password CLI integration
cat >> ~/.environment.local << 'EOF'
# Function to get secrets from 1Password
get_secret() {
    op item get "$1" --fields password 2>/dev/null
}

# Use in other configs
export GITHUB_TOKEN="$(get_secret 'GitHub Token')"
EOF
```

Remember: The goal is to customize your environment while maintaining the ability to receive updates from the main dotfiles repository. Always use the `.local` pattern to ensure your customizations persist!
