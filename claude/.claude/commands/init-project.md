# Initialize Project Command

Set up new projects with consistent standards and tooling.

## Command Options

- `--type <type>`: Project type (node, python, ruby, go, rust)
- `--no-git`: Skip git initialization
- `--no-scratchpads`: Skip scratchpad setup
- `--minimal`: Minimal setup without linting/formatting tools

## Your task

1. **Detect or ask for project type**:
   - Check for existing indicators (package.json, Gemfile, etc.)
   - If new project, ask for type or use `--type` flag
   - Default to generic setup if type unclear

2. **Initialize git repository** (unless `--no-git`):
   - Run `git init` if not already initialized
   - Create appropriate `.gitignore` for project type
   - Make initial commit: "chore: initialize project"

3. **Set up scratchpads** (unless `--no-scratchpads`):
   - Use `/setup-scratch` command
   - Ensure scratchpads/ added to .gitignore

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

# Scratchpads
scratchpads/
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
Project initialized successfully!

Created files:
- README.md
- .gitignore
- .editorconfig
- [project-specific files]

Next steps:
1. Update README.md with project details
2. Configure your development environment
3. Run initial tests: <test command>
4. Set up CI/CD if using GitHub

Use '/setup-scratch' if you need temporary workspace.
Use '/commit' to make your first meaningful commit.
```
