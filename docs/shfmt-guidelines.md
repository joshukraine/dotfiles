# shfmt Usage Guidelines

This document outlines best practices for using shfmt in the dotfiles repository to prevent formatting from breaking functionality.

## Overview

shfmt is a shell formatter that automatically formats shell scripts. While it helps maintain consistent code style, certain formatting changes can inadvertently break script functionality.

## Known Issues

### Space Redirects (`-sr` flag)

The `-sr` flag adds spaces after redirect operators (e.g., `>/dev/null` becomes `> /dev/null`). While this is valid shell syntax, it has been known to cause issues with certain scripts, particularly those involving complex directory navigation or find commands.

**Status**: The `-sr` flag has been removed from our shfmt configuration to prevent these issues.

## Current Configuration

Our `lint-shell --fix` command uses shfmt with the following flags:

- `--apply-ignore`: Respect EditorConfig ignore rules
- `-i 2`: Two-space indentation
- `-ci`: Indent switch cases
- `-bn`: Place binary operators at the beginning of lines

Note: The `-sr` (space redirects) flag has been intentionally excluded.

## Protected Scripts

The following scripts are excluded from automatic shfmt formatting via `.editorconfig` ignore rules:

- `bin/.local/bin/run-tests` - Test runner with complex directory navigation
- `setup.sh` - Critical system setup script
- `laptop/.local/share/laptop/setup` - Laptop configuration script
- `scripts/validate-config.sh` - Configuration validation with complex patterns
- `shared/generate-fish-abbr.sh` - Abbreviation generator
- `shared/generate-zsh-abbr.sh` - Abbreviation generator

## Usage Guidelines

### Before Running shfmt

1. **Test Critical Scripts**: Always test critical scripts after formatting
2. **Use Version Control**: Commit changes before running mass formatting
3. **Review Changes**: Use `git diff` to review formatting changes
4. **Run Tests**: Execute `run-tests --fast all` after formatting

### Adding New Scripts to EditorConfig Ignore

Add scripts to the `.editorconfig` ignore section when:

- The script has complex find/grep patterns
- Directory navigation logic is critical to functionality
- The script has been thoroughly tested and works correctly
- Formatting changes have previously broken the script

To add a script to the ignore list, edit `.editorconfig` and add the script path to the ignore section:

```ini
# Critical scripts excluded from shfmt formatting
[{existing-scripts,new/script/path.sh}]
ignore = true
```

### Safe Formatting Practices

1. **Format incrementally**: Format one script at a time rather than mass formatting
2. **Test immediately**: Run the script after formatting to verify functionality
3. **Use pre-commit hooks**: Our pre-commit hooks test critical scripts automatically
4. **Document issues**: If formatting breaks a script, document the issue and add to `.editorconfig` ignore rules

## Pre-commit Protection

The repository includes pre-commit hooks that:

1. Run shellcheck on all shell scripts
2. Test critical scripts functionality (e.g., `run-tests`)
3. Validate shell syntax before commits

This provides an additional safety net against formatting-induced breakage.

## Recovery Process

If shfmt breaks a script:

1. **Revert the changes**: Use `git checkout -- <script>` to restore
2. **Add to .editorconfig**: Add the script path to the ignore section in `.editorconfig`
3. **Document the issue**: Update this guide with details
4. **Test thoroughly**: Ensure the script works correctly after reverting

## Future Considerations

- Consider creating integration tests for all critical scripts
- Evaluate alternative formatters if issues persist
- Maintain a test suite that validates script functionality post-formatting
