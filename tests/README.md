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

```text
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

### Using the Test Runner (Recommended)

The `run-tests` utility provides a convenient wrapper around bats with additional features:

```bash
# Run all tests with full setup
run-tests

# Run specific test categories
run-tests git               # Git function tests only
run-tests abbr              # Abbreviation tests only
run-tests utils             # Utility tests only
run-tests env               # Environment tests only

# Advanced options
run-tests --verbose         # Enable verbose output
run-tests --fast            # Skip setup, run tests immediately
run-tests --perf            # Show performance timing
run-tests --coverage        # Show coverage analysis

# Setup and installation
run-tests --install         # Install bats-core and dependencies
run-tests --setup           # Setup test environment only
```

**Benefits of using `run-tests`:**

- Automatic environment setup (permissions, abbreviations)
- Performance monitoring with 2-minute target enforcement
- Coverage analysis showing function vs test counts
- Dependency management (installs bats-core, fish, zsh)
- Test categorization with meaningful names

### Direct bats Commands

You can also run bats directly for more control:

```bash
# Run all tests
bats tests/ --recursive

# Run specific test categories
bats tests/git_functions/      # Git functions only
bats tests/abbreviations/      # Abbreviations only
bats tests/utilities/          # Utilities only

# Run individual test files
bats tests/git_functions/test_gpum.bats      # Just gpum tests
bats tests/git_functions/test_grbm.bats     # Just grbm tests
bats tests/git_functions/test_gcom.bats     # Just gcom tests

# Verbose output
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

- ✅ **Smart git functions**: gpum (comprehensive), grbm, gcom, gbrm (basic)
- ✅ **Key abbreviations**: 20+ most critical abbreviations
- ✅ **Development utilities**: git-cm, git-check-uncommitted, tat (tmux session manager)
- ✅ **Environment loading**: Variable and path setup
- ✅ **Bin script utilities**: Key scripts in bin/.local/bin directory

### Current Test Coverage (101 tests)

**Abbreviations (11 tests)**

- Cross-shell compatibility validation (Fish + Zsh)
- Core abbreviation categories (unix, git, homebrew, claude, tmux, system)
- File structure and generation validation

**Git Functions (78 tests)**

- **gpum**: 12 comprehensive tests (help, error cases, branch detection, push scenarios)
- **grbm**: 20 tests (help, git validation, branch detection, rebase scenarios)
- **gcom**: 22 tests (help, checkout with/without pull, branch detection)
- **gbrm**: 12 tests (branch removal, default branch detection, edge cases)
- **git-check-uncommitted**: 17 tests (status detection, prompt handling, edge cases)

**Utility Scripts (12 tests)**

- **git-cm**: 9 tests (commit wrapper functionality, argument handling)
- **tat**: 9 tests (tmux session creation, directory name handling)

## Test Cleanup

### Automatic cleanup

The test suite automatically cleans up resources created during testing:

- **Tmux sessions**: Test-related sessions are tracked and removed after each test
- **Temporary files**: Git repositories and temp directories are cleaned up
- **Test state**: Each test runs in isolation with proper setup/teardown

### Manual cleanup

If tests are interrupted or cleanup fails, run the cleanup script:

```bash
# Clean up any remaining test resources
./tests/cleanup.bash
```

This will remove:

- All tmux sessions matching test patterns (`tmp-*`, `test-*`, `custom-session`, etc.)
- Old temporary files in `/tmp`

### Tmux session management

**Mock tmux commands during testing:**
The test suite uses tmux command mocking to prevent terminal hijacking. When `tat` or other tmux utilities are tested, they use mock commands that simulate tmux operations without actually creating or attaching to sessions.

**Session cleanup:**
Test sessions are automatically tracked and cleaned up, but you can also manually remove them:

```bash
# List all current tmux sessions
tmux list-sessions

# Kill specific test sessions
tmux kill-session -t "session-name"

# Kill all test-related sessions
tmux list-sessions | grep -E "(tmp-|test-|custom)" | cut -d: -f1 | xargs -I {} tmux kill-session -t {}
```

## Troubleshooting

### Tests failing locally

1. Ensure bats-core is installed: `brew install bats-core`
2. Check that Fish and Zsh are available: `which fish zsh`
3. Verify dotfiles structure: `ls -la shared/abbreviations.yaml`
4. Run with verbose output: `bats tests/ --verbose-run`
5. Clean up test resources: `./tests/cleanup.bash`

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

## Development Quality Tools

### Shell Script Linting

The `lint-shell` utility complements the testing framework by providing static analysis:

```bash
# Lint all shell scripts
lint-shell

# Advanced options
lint-shell --quiet            # Minimal output
lint-shell --exclude-tests    # Skip test files (*.bats)
lint-shell --help            # Show usage information
```

**Integration with Testing Workflow:**

```bash
# Pre-commit quality check
lint-shell              # Check for shell script issues
run-tests --fast git    # Quick test relevant functions
git add .               # Stage changes
git commit              # Commit (triggers pre-commit hooks)

# Full quality assurance
lint-shell              # Lint all scripts
run-tests --perf        # Run all tests with timing
run-tests --coverage    # Check test coverage
```

**Relationship to Validation Framework:**

| Tool | Purpose | Speed | Scope |
|------|---------|-------|-------|
| `lint-shell` | Shell script linting with shellcheck | ~30s | All shell scripts |
| `run-tests` | Functional behavior testing | ~2min | Function behavior |
| `scripts/validate-config.sh` | Configuration integrity | ~9s | Static analysis |

### Documentation

- **Testing**: This README and `docs/functions/development.md`
- **Validation**: `scripts/README.md` and individual validator docs
- **Functions**: `docs/functions/` directory with comprehensive guides

## Related Issues

- [Issue #71](https://github.com/joshukraine/dotfiles/issues/71) - Original testing framework request
- [Issue #74](https://github.com/joshukraine/dotfiles/issues/74) - Function documentation (includes quality tools)
- Phase 3 of dotfiles improvement plan - Long-term automation goals
