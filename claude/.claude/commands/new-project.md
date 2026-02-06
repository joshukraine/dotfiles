# New Project Command

Set up new projects with comprehensive tooling and standards.

## Prerequisites

This command is designed to work **in conjunction** with Claude Code's native `/init` command:

1. **First**: Run Claude Code's `/init` to create CLAUDE.md with project context
2. **Then**: Run `/new-project` for comprehensive project setup

> **Note**: While not strictly required, having a CLAUDE.md file helps this command provide better project-specific setup.

## Command Options

- `--type <type>`: Project type (node, python, ruby, go, rust)
- `--skip-git`: Skip git initialization
- `--minimal`: Minimal setup without linting/formatting tools

## Your task

1. **Check prerequisites**:
   - Look for existing CLAUDE.md file
   - If missing, suggest running Claude Code's `/init` first (but continue anyway)
   - Inform user about the complementary workflow

2. **Detect or ask for project type**:
   - Check for existing indicators (package.json, Gemfile, etc.)
   - If new project, ask for type or use `--type` flag
   - Default to generic setup if type unclear

3. **Initialize git repository**:
   - Run `git init` if not already initialized
   - Create appropriate `.gitignore` for project type
   - Make initial commit: "chore: initialize project"
   - **If `--skip-git` provided**: Skip git initialization

4. **Create README.md**:
   - Project name as title
   - Description placeholder
   - Installation section
   - Usage section
   - Contributing section
   - License section

5. **Set up project-specific files**:

   **Node.js projects**:
   - Initialize package.json: `npm init -y`
   - Set up common scripts (test, lint, build)
   - Add .nvmrc with current Node version
   - Create basic folder structure (src/, tests/)

   **Python projects**:
   - Create `requirements.txt` or `pyproject.toml`
   - Set up virtual environment instructions
   - Add `__init__.py` files
   - Create basic structure (src/, tests/)

   **Ruby projects**:
   - Create Gemfile with ruby version
   - Add .ruby-version file
   - Basic folder structure (lib/, spec/)

   **Go projects**:
   - Initialize go.mod: `go mod init`
   - Create cmd/ and pkg/ directories
   - Add Makefile with common targets

   **Rust projects**:
   - Run `cargo init` if Cargo not detected
   - Set up workspace if needed

6. **Configure development tools** (unless `--minimal`):
   - Add appropriate linter config (.eslintrc, .rubocop.yml, etc.)
   - Set up formatter config (.prettierrc, .rustfmt.toml, etc.)
   - Add editor config (.editorconfig)
   - Configure pre-commit hooks if requested

7. **Create GitHub Actions workflow** (if .git exists):
   - Basic CI workflow for the project type
   - Test runner configuration
   - Linting checks

8. **Final steps**:
   - Display summary of created files
   - Suggest next steps based on project type
   - Remind about updating README.md

## Template Files

### Generic .gitignore

```gitignore
# Dependencies
node_modules/
vendor/
*.pyc
__pycache__/

# Build outputs
dist/
build/
*.egg-info/

# Environment
.env
.env.local
*.log

# IDE
.vscode/
.idea/
*.swp
*.swo

# OS
.DS_Store
Thumbs.db
```

### Basic README.md

````markdown
# Project Name

Brief description of what this project does.

## Installation

```bash
# Installation commands here
```

## Usage

```bash
# Usage examples here
```

## Development

```bash
# Development setup commands
```

## Contributing

Please read CONTRIBUTING.md for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
````

### EditorConfig

```ini
# .editorconfig
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 2

[*.{py,go}]
indent_size = 4

[Makefile]
indent_style = tab
```

## Project Type Detection

Check for these files to auto-detect project type:

- `package.json` → Node.js
- `Gemfile` or `*.gemspec` → Ruby
- `requirements.txt` or `pyproject.toml` → Python
- `go.mod` → Go
- `Cargo.toml` → Rust

## Error Handling

- **No CLAUDE.md found**: "No CLAUDE.md found. Consider running Claude Code's `/init` command first for better project context. Continue anyway? (y/n)"
- **Directory not empty**: "Directory contains files. Continue anyway? (y/n)"
- **Git already initialized**: "Git repository already exists, skipping init"
- **Unknown project type**: "Unknown project type. Using generic setup."
- **Command not found**: "Required command not found: commandname"

## Integration with Global Standards

- Follow directory structure conventions from global CLAUDE.md
- Apply security principles (no secrets in commits)
- Set up testing infrastructure by default
- Use consistent formatting standards

## Next Steps Message

After initialization, display:

```text
Project setup completed successfully!

Created files:
- README.md
- .gitignore
- .editorconfig
- [project-specific files]

Recommended workflow:
1. Run `/init` (a built-in command of Claude Code) first (if not already done) for project context
2. Update README.md with project details
3. Configure your development environment
4. Run initial tests: <test command>
5. Set up CI/CD if using GitHub

Use '/commit' to make your first meaningful commit.
```
