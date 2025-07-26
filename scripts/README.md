# Configuration Validation Scripts

This directory contains the configuration validation framework for the dotfiles repository. The framework provides comprehensive validation of shell configurations, abbreviations, environment variables, dependencies, and markdown files.

## Overview

The validation framework ensures configuration integrity across both Fish and Zsh environments through:

- **Static analysis**: Syntax checking without execution
- **Consistency validation**: Cross-shell configuration synchronization
- **Dependency verification**: Required tool availability
- **Auto-fix capabilities**: Automatic correction of common issues
- **CI/CD integration**: Automated validation in GitHub Actions
- **Local development**: Pre-commit hooks for immediate feedback

## Quick Start

### Run All Validations

```bash
# Run complete validation suite
./scripts/validate-config.sh

# Run with auto-fix for repairable issues
./scripts/validate-config.sh --fix

# Run specific validator only
./scripts/validate-config.sh --validator markdown
```

### Shell Script Linting

For comprehensive shell script linting beyond the validation framework:

```bash
# Comprehensive shell script linting (all files)
lint-shell

# Focused on production code (skip tests)
lint-shell --exclude-tests

# Minimal output for CI/scripts
lint-shell --quiet
```

**Note**: The `lint-shell` utility provides more comprehensive shellcheck integration than the built-in shell-syntax validator, with additional features like smart file detection and detailed reporting.

### Setup Local Git Hooks

```bash
# Install pre-commit hooks for automatic validation
./scripts/setup-git-hooks.sh

# Check hook installation status
./scripts/setup-git-hooks.sh --check
```

## Architecture

### Main Runner (`validate-config.sh`)

The central validation orchestrator that:

- Manages validator execution order and priorities
- Provides unified CLI interface and options
- Handles error reporting and exit codes
- Supports CI-friendly output modes
- Measures performance and enforces time limits

**Key Features:**

- Modular validator architecture
- Performance target: <30 seconds total execution
- Fix mode for automatic issue resolution
- Machine-readable CI output
- Comprehensive error reporting

### Validators (`validators/`)

Individual validation modules for specific configuration types:

#### 1. Shell Syntax Validator (`shell-syntax.sh`)

- **Purpose**: Validates syntax of Fish, Zsh, and shell script files
- **Tools**: `fish -n`, `zsh -n`, `shellcheck`
- **Coverage**: ~50+ shell files across dotfiles
- **Features**:
  - Native shell syntax checking
  - Comprehensive shellcheck integration
  - Critical script validation (setup.sh, generators)
  - Auto-fix for executable permissions

#### 2. Abbreviations Validator (`abbreviations.sh`)

- **Purpose**: Ensures abbreviation consistency and generation accuracy
- **Tools**: `yq` for YAML parsing and validation
- **Coverage**: 200+ abbreviations from single source of truth
- **Features**:
  - YAML structure and syntax validation
  - Cross-shell generation verification
  - Duplicate abbreviation detection
  - System command conflict checking

#### 3. Environment Validator (`environment.sh`)

- **Purpose**: Validates environment variable synchronization
- **Tools**: `bash`, `fish` for variable extraction and comparison
- **Coverage**: Shared environment configuration files
- **Features**:
  - Variable consistency between bash/fish
  - Path configuration validation
  - Environment loading verification

#### 4. Dependencies Validator (`dependencies.sh`)

- **Purpose**: Verifies required tool availability and versions
- **Tools**: System commands and version checking
- **Coverage**: 20+ essential development tools
- **Features**:
  - Essential tool availability (git, nvim, tmux, etc.)
  - Homebrew package validation
  - System compatibility checks
  - Validator framework dependencies

#### 5. Markdown Validator (`markdown.sh`)

- **Purpose**: Validates markdown formatting and style consistency
- **Tools**: `markdownlint-cli2`
- **Coverage**: All .md files (excluding scratchpads)
- **Features**:
  - Comprehensive markdown linting
  - Auto-fix for formatting issues
  - Configuration via `.markdownlint.yaml`
  - Fast execution (~1.2 seconds)

## Usage Guide

### Command Line Interface

```bash
./scripts/validate-config.sh [OPTIONS]

OPTIONS:
    -h, --help           Show help message
    -f, --fix            Attempt to fix issues automatically
    -r, --report         Generate detailed validation report
    -v, --validator NAME Run specific validator only
    -q, --quiet          Suppress verbose output
    -c, --ci             CI mode (machine-readable output)

EXAMPLES:
    ./scripts/validate-config.sh                    # Run all validators
    ./scripts/validate-config.sh --fix              # Run with auto-fix
    ./scripts/validate-config.sh -v abbreviations   # Specific validator
    ./scripts/validate-config.sh --ci               # CI-friendly output
```

### Exit Codes

- **0**: All validations passed
- **1**: Validation failures found
- **2**: Script error or invalid usage

### Validator Execution Order

Validators run in priority order for optimal failure detection:

1. **shell-syntax**: Catches syntax errors that would prevent other validations
2. **abbreviations**: Validates core configuration consistency
3. **environment**: Ensures environment is properly configured
4. **dependencies**: Verifies all required tools are available
5. **markdown**: Validates documentation and formatting

## CI/CD Integration

### GitHub Actions Workflow

The validation framework integrates with GitHub Actions via `.github/workflows/validate.yml`:

**Features:**

- Runs on all pushes and pull requests
- Two-stage validation (config validation → dependency validation)
- Auto-fix attempts on failures
- Performance monitoring (45-second limit)
- Comprehensive reporting

**Relationship to Test Suite:**

- **Validation workflow**: Static analysis and configuration integrity
- **Test workflow**: Runtime behavior and functional testing
- **Execution order**: Validation runs first, tests run after validation passes

### Pre-commit Hooks

Local validation via `.pre-commit-config.yaml`:

**Hooks:**

- Shell syntax validation on shell file changes
- Abbreviation consistency on YAML/abbreviation file changes
- Environment validation on environment file changes
- Markdown linting with auto-fix on markdown changes

**Setup:**

```bash
# Install and configure pre-commit hooks
./scripts/setup-git-hooks.sh

# Manual pre-commit run
pre-commit run --all-files
```

## Performance

### Current Benchmarks

- **Total framework**: ~9 seconds (5 validators)
- **Shell syntax**: ~3 seconds (shellcheck integration)
- **Abbreviations**: ~2 seconds (YAML processing)
- **Environment**: ~1 second (variable comparison)
- **Dependencies**: ~2 seconds (tool checking)
- **Markdown**: ~1.2 seconds (linting)

### Performance Targets

- **Local development**: <30 seconds total
- **CI environment**: <45 seconds total
- **Individual validator**: <10 seconds
- **Parallel execution**: Where possible

## Configuration Files

### Validator Configuration

- **`.shellcheckrc`**: Shellcheck configuration and rule exclusions
- **`markdown/.markdownlint.yaml`**: Markdown linting rules
- **`shared/abbreviations.yaml`**: Single source of truth for abbreviations
- **`shared/environment.sh|fish`**: Shared environment variables

### Git Integration

- **`.pre-commit-config.yaml`**: Pre-commit hook configuration
- **`scripts/setup-git-hooks.sh`**: Git hooks installation script
- **`.github/workflows/validate.yml`**: CI validation workflow

## Development

### Adding New Validators

1. Create new validator script in `scripts/validators/`
2. Follow existing validator patterns and exit codes
3. Add validator to priority list in `get_validators()` function
4. Update documentation and help text
5. Add corresponding pre-commit hook if needed

### Validator Requirements

- **Exit codes**: 0=success, 1=validation failed, 2=error
- **Environment**: Support CI_MODE, FIX_MODE, VERBOSE variables
- **Output**: Use consistent logging functions
- **Performance**: Complete validation in <10 seconds
- **Documentation**: Include purpose and tool requirements

### Testing Validators

```bash
# Test individual validator
./scripts/validators/shell-syntax.sh

# Test with different modes
FIX_MODE=1 ./scripts/validators/markdown.sh
CI_MODE=1 VERBOSE=0 ./scripts/validators/abbreviations.sh

# Performance testing
time ./scripts/validate-config.sh --quiet
```

## Troubleshooting

### Common Issues

**Validation fails locally but passes in CI:**

- Check tool versions: `brew outdated`
- Regenerate configurations: `cd shared && ./generate-all-abbr.sh`
- Clear local state: `git clean -fd`

**Pre-commit hooks not working:**

- Verify installation: `./scripts/setup-git-hooks.sh --check`
- Update hooks: `./scripts/setup-git-hooks.sh --update`
- Manual test: `pre-commit run --all-files`

**Shellcheck warnings:**

- Check `.shellcheckrc` configuration
- Disable specific warnings with `# shellcheck disable=SCXXXX`
- Update shellcheck: `brew upgrade shellcheck`

**Markdown linting errors:**

- Review `.markdownlint.yaml` configuration
- Auto-fix: `./scripts/validate-config.sh --fix --validator markdown`
- Manual fix: `markdownlint-cli2 --fix *.md`

### Debug Mode

Enable debug output for troubleshooting:

```bash
# Verbose validation
./scripts/validate-config.sh --verbose

# Debug specific validator
VERBOSE=1 ./scripts/validators/shell-syntax.sh

# CI mode debugging
CI_MODE=1 ./scripts/validate-config.sh
```

## Integration with Existing Tools

### Relationship to Test Suite and Quality Tools

The validation framework complements the broader quality assurance ecosystem:

| Tool                            | Purpose                              | Speed | Scope               | When                     |
| ------------------------------- | ------------------------------------ | ----- | ------------------- | ------------------------ |
| **Validation Framework**        | Static analysis, config integrity    | ~9s   | Syntax, consistency | Pre-commit, every change |
| **Test Suite** (`run-tests`)    | Runtime behavior, functional testing | ~2min | Function behavior   | CI after validation      |
| **Shell Linter** (`lint-shell`) | Comprehensive shell script analysis  | ~30s  | All shell scripts   | Development, debugging   |

**Integration Workflow:**

```bash
# Local development quality check
./scripts/validate-config.sh --fix    # Fix configuration issues
lint-shell --exclude-tests            # Lint production shell scripts
run-tests --fast git                  # Quick functional test
git commit                           # Triggers pre-commit validation
```

### Integration Points

- **CI Pipeline**: Validation runs before tests
- **Local Development**: Pre-commit hooks catch issues early
- **Fix Mode**: Automatic correction reduces manual intervention
- **Reporting**: Both provide GitHub Actions summaries

## Development Tools Reference

### Quality Assurance Utilities

Beyond the validation framework, these tools provide comprehensive quality assurance:

- **`lint-shell`**: Comprehensive shell script linter using shellcheck
  - Location: `bin/.local/bin/lint-shell`
  - Usage: `lint-shell [--quiet] [--exclude-tests] [--help]`
  - Documentation: `docs/functions/development.md#testing-and-quality-assurance`

- **`run-tests`**: Test runner for bats-core testing framework
  - Location: `bin/.local/bin/run-tests`
  - Usage: `run-tests [category] [--verbose] [--perf] [--coverage]`
  - Documentation: `tests/README.md` and `docs/functions/development.md`

### Documentation Cross-References

- **Testing Framework**: `tests/README.md` - Functional testing with bats-core
- **Function Documentation**: `docs/functions/development.md` - Quality tools and workflows
- **CI/CD Workflows**: `.github/workflows/` - Automated quality gates

## Related Issues

- **Issue #72**: Original configuration validation implementation
- **Issue #74**: Function documentation (includes quality tools integration)
- **Issue #81**: Shellcheck integration (implemented in shell-syntax validator)
- **Issue #82**: Markdown linting integration (implemented in markdown validator)
- **PR #83**: Complete validation framework implementation

## Contributing

When contributing to the validation framework:

1. **Follow patterns**: Use existing validator structure and conventions
2. **Test thoroughly**: Validate both success and failure scenarios
3. **Document changes**: Update this README and inline documentation
4. **Performance**: Ensure validators complete quickly
5. **CI compatibility**: Test in both local and CI environments
