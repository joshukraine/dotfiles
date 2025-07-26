# Setup Script Documentation

Welcome to the comprehensive setup script documentation for the dotfiles repository. This collection of guides will help you successfully install, configure, and maintain your development environment using our automated setup script.

## 📋 Quick Reference

| Scenario                | Guide                                       | Description                                      |
| ----------------------- | ------------------------------------------- | ------------------------------------------------ |
| **New Installation**    | [Installation Guide](installation-guide.md) | Complete walkthrough for fresh macOS setup       |
| **Command Examples**    | [Usage Examples](usage-examples.md)         | All setup script options with practical examples |
| **Issues & Fixes**      | [Troubleshooting](troubleshooting.md)       | Common problems and their solutions              |
| **Personal Setup**      | [Customization](customization.md)           | Local configuration and personal overrides       |
| **From Other Dotfiles** | [Migration Guide](migration.md)             | Moving from other dotfiles repositories          |

## 🚀 Quick Start

For first-time users who want to get started immediately:

1. **Prerequisites**: Ensure you have macOS with [Homebrew](https://brew.sh) and [GNU Stow](https://www.gnu.org/software/stow/) installed
2. **Clone**: `git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles`
3. **Preview**: `~/dotfiles/setup.sh --dry-run` (see what will happen)
4. **Install**: `~/dotfiles/setup.sh` (run the actual setup)

For detailed instructions, see the [Installation Guide](installation-guide.md).

## 🛠️ Setup Script Features

Our `setup.sh` script provides a robust, idempotent installation experience:

- **Safe to run multiple times** - Script detects existing configurations
- **Dry-run capability** - Preview changes before applying them
- **Automatic conflict resolution** - Backs up existing files with timestamps
- **Comprehensive error handling** - Clear error messages and recovery guidance
- **Platform detection** - Automatic Apple Silicon vs Intel Mac configuration
- **Prerequisite checking** - Validates required tools before proceeding

## 📖 Documentation Structure

### Core Guides

- **[Installation Guide](installation-guide.md)** - Complete step-by-step installation walkthrough
  - Fresh macOS setup procedures
  - Pre-installation checklist
  - Post-installation verification
  - Common first-time user scenarios

- **[Usage Examples](usage-examples.md)** - Practical command examples and scenarios
  - Basic installation examples
  - Advanced configuration options
  - Update and maintenance procedures
  - Recovery from failed installations

### Specialized Guides

- **[Troubleshooting](troubleshooting.md)** - Solutions for common issues
  - Permission and sudo problems
  - Stow conflicts and symlink issues
  - Homebrew installation problems
  - Shell configuration conflicts

- **[Customization](customization.md)** - Personalizing your setup
  - Local configuration patterns
  - Environment variable overrides
  - Selective package installation
  - Personal data integration

- **[Migration Guide](migration.md)** - Moving from other dotfiles
  - Backup strategies for existing configurations
  - Conflict resolution approaches
  - Safe testing and rollback procedures
  - Integration with existing tools

## 🎯 Choose Your Path

### I'm new to dotfiles

→ Start with the [Installation Guide](installation-guide.md) for a complete walkthrough

### I want to see examples first

→ Check out [Usage Examples](usage-examples.md) to understand the setup script options

### I'm having problems

→ Go to [Troubleshooting](troubleshooting.md) for solutions to common issues

### I have existing dotfiles

→ See the [Migration Guide](migration.md) for safe transition strategies

### I want to customize everything

→ Read the [Customization Guide](customization.md) for personalization options

## 🔗 Related Documentation

- **[Main README](../../README.md)** - Repository overview and highlights
- **[Function Documentation](../functions/README.md)** - Shell function reference
- **[Abbreviations Reference](../abbreviations.md)** - Complete command shortcuts guide
- **[CLAUDE.md](../../CLAUDE.md)** - AI assistant guidance for development

## 💡 Getting Help

If you encounter issues not covered in these guides:

1. **Check existing documentation** - Search through all setup guides
2. **Review the script** - Read `setup.sh` directly for implementation details
3. **Test with dry-run** - Use `--dry-run` to understand what will happen
4. **File an issue** - Report problems on the [GitHub repository](https://github.com/joshukraine/dotfiles/issues)

## ⚡ TL;DR Commands

```bash
# Quick installation for experienced users
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
~/dotfiles/setup.sh --dry-run  # Preview first!
~/dotfiles/setup.sh            # Install

# Common maintenance commands
~/dotfiles/setup.sh --dry-run  # Check what would change
~/dotfiles/setup.sh            # Update configuration (idempotent)
```

Happy coding! 🚀
