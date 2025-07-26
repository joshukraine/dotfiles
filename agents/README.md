# Dotfiles Agents

Specialized AI agents for managing different aspects of this dotfiles repository.

## Available Agents

### 🔧 [Config Manager](config-manager.md)

Manages dotfiles structure, Stow packages, and system configuration.

- **Use for**: Package management, symlink issues, environment setup
- **Commands**: `/config`, `/stow`, `/env`, `/nvim`, `/brew`

### ⚡ [Abbreviation Manager](abbreviation-manager.md)

Handles the shared YAML-based abbreviation system across Fish and Zsh.

- **Use for**: Adding/modifying shell abbreviations, maintaining sync
- **Commands**: `/abbr add`, `/abbr remove`, `/abbr sync`, `/abbr validate`

### ✅ [Test Validator](test-validator.md)

Runs tests, linting, and validation across the repository.

- **Use for**: Pre-commit checks, CI/CD, performance analysis
- **Commands**: `/test`, `/lint`, `/validate`, `/perf`, `/hooks`

### 📚 [Documentation Helper](docs-helper.md)

Maintains documentation accuracy and consistency.

- **Use for**: Updating docs, syncing examples, troubleshooting guides
- **Commands**: `/docs update`, `/docs abbr`, `/docs setup`

## Usage

Reference specific agents when you need focused expertise:

```bash
# Example: Need to add a new git abbreviation
# Use: Abbreviation Manager agent

# Example: Troubleshooting Stow symlink conflicts
# Use: Config Manager agent

# Example: Setting up pre-commit validation
# Use: Test Validator agent
```

Each agent has deep knowledge of their domain and can provide targeted assistance.
