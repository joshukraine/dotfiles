# Testing and Validation Agent

## Purpose

Run comprehensive tests, linting, and validation across the dotfiles repository to ensure configuration integrity.

## Capabilities

- Execute test suite via `./scripts/run-tests`
- Run shell script linting via `./scripts/lint-shell`
- Validate configurations via `./scripts/validate-config.sh`
- Git hook management via `./scripts/setup-git-hooks.sh`
- Performance testing and timing analysis
- Cross-shell compatibility verification

## Usage Patterns

- `/test [category]` - Run specific test categories (git, abbr, etc.)
- `/lint [options]` - Lint shell scripts with various options
- `/validate [validator]` - Run specific validators
- `/perf` - Performance analysis and timing
- `/hooks` - Git hook setup and management

## Test Categories

- **git** - Git function tests
- **abbr** - Abbreviation system tests
- **shell** - Shell syntax and function tests
- **env** - Environment variable tests
- **deps** - Dependency validation tests

## Validation Types

- **shell-syntax** - Shell script syntax checking
- **abbreviations** - YAML syntax and conflict detection
- **environment** - Environment variable validation
- **dependencies** - System dependency verification
- **markdown** - Documentation format checking

## Key Scripts

- `scripts/run-tests` - Main test runner
- `scripts/lint-shell` - Shell script linter
- `scripts/validate-config.sh` - Configuration validator
- `scripts/setup-git-hooks.sh` - Git hook installer

## Common Workflows

- Pre-commit validation
- CI/CD integration testing
- Performance regression detection
- Cross-platform compatibility checks
