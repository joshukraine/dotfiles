# Dotfiles Testing Framework

This directory contains automated tests for shell functions, abbreviations, and configurations using the [bats-core](https://github.com/bats-core/bats-core) testing framework.

## Overview

The testing framework ensures reliability and cross-shell compatibility for:

- **200+ abbreviations** from `shared/abbreviations.yaml`
- **Smart git functions** (gpum, grbm, gcom, gbrm)
- **Development utilities** (cdot, cdxc, cdnv, etc.)
- **tmux session management** functions
- **Environment variable loading** mechanisms
- **Cross-shell compatibility** (Fish vs Zsh)

## Directory Structure

```
tests/
├── README.md                 # This documentation
├── helpers/                  # Shared test utilities
│   ├── common.bash          # Common assertion and utility functions
│   ├── git_helpers.bash     # Git repository mocking and setup
│   └── shell_helpers.bash   # Shell environment and function loading
├── fixtures/                # Test data and mock repositories
│   └── mock_repos/         # Temporary git repositories for testing
├── git_functions/          # Tests for smart git functions
│   └── test_gpum.bats      # Tests for gpum function
├── abbreviations/          # Tests for shell abbreviations
│   └── test_core_abbr.bats # Core abbreviation expansion tests
├── utilities/              # Tests for development utility functions
└── environment/            # Tests for environment loading
```

## Prerequisites

### Install bats-core

The testing framework is automatically installed via Homebrew:

```bash
brew bundle install  # Installs bats-core from Brewfile
```

Or install manually:

```bash
brew install bats-core
```

### Required shells

Tests run against both Fish and Zsh:

```bash
brew install fish zsh
```

## Running Tests

### Run all tests

```bash
# From dotfiles root directory
bats tests/ --recursive
```

### Run specific test categories

```bash
# Git functions only
bats tests/git_functions/

# Abbreviations only  
bats tests/abbreviations/

# Utilities only
bats tests/utilities/
```

### Run individual test files

```bash
# Test specific function
bats tests/git_functions/test_gpum.bats

# Test core abbreviations
bats tests/abbreviations/test_core_abbr.bats
```

### Verbose output

```bash
# Show detailed output for debugging
bats tests/ --recursive --verbose-run
```

## Writing Tests

### Test File Structure

Test files use the `.bats` extension and follow this structure:

```bash
#!/usr/bin/env bats

# Load helper functions
load '../helpers/common.bash'
load '../helpers/git_helpers.bash'
load '../helpers/shell_helpers.bash'

setup() {
  # Setup before each test
  save_original_path
  setup_dotfiles_path
}

teardown() {
  # Cleanup after each test
  teardown_test_git_repo
  restore_path
}

@test "descriptive test name" {
  # Test implementation
  run some_command
  [ "$status" -eq 0 ]
  assert_contains "$output" "expected text"
}
```

### Available Helpers

#### Common Helpers (`common.bash`)

- `assert_equals expected actual [message]`
- `assert_contains haystack needle [message]`
- `assert_file_exists file [message]`
- `assert_command_succeeds command [message]`
- `assert_command_fails command [message]`
- `require_command cmd` - Skip test if command missing
- `mock_command cmd output [exit_code]` - Create command mocks

#### Git Helpers (`git_helpers.bash`)

- `setup_main_repo` - Create repo with main as default branch
- `setup_master_repo` - Create repo with master as default branch
- `setup_no_remote_repo` - Create repo without origin remote
- `create_feature_branch [name]` - Create and switch to feature branch
- `create_uncommitted_changes` - Add staged but uncommitted changes
- `create_unstaged_changes` - Add unstaged changes
- `teardown_test_git_repo` - Clean up temporary repositories

#### Shell Helpers (`shell_helpers.bash`)

- `run_fish_function function_name [args...]` - Execute Fish function
- `run_zsh_function function_name [args...]` - Execute Zsh function  
- `test_abbreviation abbr expected [shell_type]` - Test abbreviation expansion
- `load_environment` - Source shared environment variables
- `setup_dotfiles_path` - Add bin directory to PATH

### Testing Best Practices

1. **Isolation**: Each test should be independent and not rely on other tests
2. **Cleanup**: Always clean up temporary files and repositories in `teardown()`
3. **Descriptive names**: Use clear, descriptive test names that explain the behavior
4. **Edge cases**: Test both success and failure scenarios
5. **Performance**: Keep tests fast - aim for under 2 minutes total execution time

### Testing Git Functions

When testing git functions, use the provided git helpers:

```bash
@test "gpum works with main branch repository" {
  setup_main_repo
  create_feature_branch "test-feature"
  
  run run_fish_function gpum
  [ "$status" -eq 0 ]
  assert_contains "$output" "Successfully pushed"
}
```

### Testing Abbreviations

Test abbreviations for both Fish and Zsh compatibility:

```bash
@test "git add abbreviation works in both shells" {
  test_abbreviation "ga" "git add" "both"
}

@test "shell-specific abbreviation works correctly" {
  test_abbreviation "src" "source $HOME/.zshrc" "zsh"
}
```

## CI/CD Integration

Tests run automatically in GitHub Actions on:

- Push to `master`/`main` branches
- Pull requests to `master`/`main` branches

The workflow:
1. Tests both Fish and Zsh environments
2. Runs tests in parallel for performance
3. Enforces 2-minute execution time limit
4. Provides coverage analysis
5. Generates test reports

## Performance Targets

- **Full test suite**: Under 2 minutes execution time
- **Individual test**: Under 10 seconds
- **Parallel execution**: Tests run concurrently where possible

## Coverage Goals

The framework aims to test:

- ✅ **Core git functions**: gpum, grbm, gcom, gbrm
- ✅ **Key abbreviations**: 20+ most critical abbreviations  
- ⏳ **Development utilities**: Directory navigation functions
- ⏳ **Environment loading**: Variable and path setup
- ⏳ **tmux functions**: Session management utilities

## Troubleshooting

### Tests failing locally

1. Ensure bats-core is installed: `brew install bats-core`
2. Check that Fish and Zsh are available: `which fish zsh`
3. Verify dotfiles structure: `ls -la shared/abbreviations.yaml`
4. Run with verbose output: `bats tests/ --verbose-run`

### Mock git repositories not working

The git helpers create temporary repositories in `/tmp`. If tests fail:

1. Check disk space: `df -h /tmp`
2. Verify git is configured: `git config --global user.name`
3. Check permissions: `ls -la /tmp`

### Abbreviation tests failing

Abbreviation tests depend on generated files:

1. Regenerate abbreviations: `cd shared && ./generate-all-abbr.sh`
2. Check YAML syntax: `python3 -c "import yaml; yaml.safe_load(open('shared/abbreviations.yaml'))"`
3. Verify generated files exist: `ls -la fish/.config/fish/abbreviations.fish`

## Contributing

When adding new functions or abbreviations:

1. **Add tests first** - Follow TDD approach
2. **Test both shells** - Ensure Fish/Zsh compatibility  
3. **Include edge cases** - Test error conditions
4. **Update documentation** - Add examples to this README
5. **Check performance** - Ensure tests complete quickly

### Adding New Test Categories

Create new test categories by:

1. Adding directory under `tests/`
2. Creating `.bats` files with appropriate helpers
3. Updating CI workflow if needed
4. Documenting in this README

## Related Issues

- [Issue #71](https://github.com/joshukraine/dotfiles/issues/71) - Original testing framework request
- Phase 3 of dotfiles improvement plan - Long-term automation goals