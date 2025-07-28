# Update Dependencies Command

Update project dependencies safely with testing between updates and documentation of breaking changes.

## Command Options

- `--dry-run`: Show what would be updated without making changes
- `--major`: Include major version updates (default: minor/patch only)
- `--package <name>`: Update specific package only
- `--no-test`: Skip running tests between updates

## Your task

1. **Detect package manager**:
   - Check for `package.json` (npm/yarn/pnpm)
   - Check for `Gemfile` (bundler)
   - Check for `requirements.txt` or `pyproject.toml` (pip/poetry)
   - Check for `Cargo.toml` (cargo)
   - Check for `go.mod` (go modules)

2. **Analyze current dependencies**:
   - List outdated packages with current and available versions
   - Categorize updates: patch, minor, major
   - Identify security-related updates (high priority)

3. **Plan update strategy**:
   - Security updates first (always include)
   - Patch updates (safe, low risk)
   - Minor updates (moderate risk, new features)
   - Major updates (high risk, breaking changes) - only if `--major` flag

4. **Execute updates incrementally**:
   - Update one category at a time
   - Run tests after each category (unless `--no-test`)
   - Create separate commits for each category
   - Stop and report if tests fail

5. **Document changes**:
   - Note any breaking changes in commit messages
   - List significant new features or deprecations
   - Record any configuration changes needed

6. **Handle test failures**:
   - Identify which update caused the failure
   - Offer to revert that specific update
   - Suggest investigating the breaking change
   - Continue with remaining updates if desired

## Package Manager Commands

### npm/yarn/pnpm

```bash
# Check outdated
npm outdated
yarn outdated
pnpm outdated

# Update specific package
npm update <package>
yarn upgrade <package>
pnpm update <package>
```

### Ruby (Bundler)

```bash
# Check outdated
bundle outdated

# Update specific gem
bundle update <gem>
```

### Python (pip/poetry)

```bash
# Check outdated (pip)
pip list --outdated

# Update with poetry
poetry show --outdated
poetry update <package>
```

### Rust (Cargo)

```bash
# Check outdated
cargo outdated

# Update dependencies
cargo update <package>
```

### Go

```bash
# Check for updates
go list -u -m all

# Update dependencies
go get -u <package>
```

## Update Categories

1. **Security Updates** (Always applied)
   - Packages with known security vulnerabilities
   - Critical security patches

2. **Patch Updates** (Applied by default)
   - Bug fixes, security patches
   - Version format: 1.2.3 → 1.2.4

3. **Minor Updates** (Applied by default)
   - New features, backwards compatible
   - Version format: 1.2.3 → 1.3.0

4. **Major Updates** (Only with --major flag)
   - Breaking changes, API changes
   - Version format: 1.2.3 → 2.0.0

## Commit Message Format

Use conventional commits format from global CLAUDE.md:

```text
chore(deps): update dependencies

Security updates:
- lodash: 4.17.19 → 4.17.21 (security fix)

Patch updates:
- react: 17.0.1 → 17.0.2
- express: 4.17.1 → 4.17.3

Minor updates:
- typescript: 4.2.0 → 4.3.0 (new features)
- eslint: 7.32.0 → 8.0.0

Breaking changes:
- Node.js 14+ now required for typescript 4.3+
```

## Example Workflow

```bash
# Detect: package.json found, using npm
# Found 12 outdated packages:
#   Security: lodash (4.17.19 → 4.17.21)
#   Patch: react (17.0.1 → 17.0.2), express (4.17.1 → 4.17.3)
#   Minor: typescript (4.2.0 → 4.3.0)
#   Major: eslint (7.32.0 → 8.0.0) [requires --major flag]

1. Update security packages → test → commit
2. Update patch versions → test → commit
3. Update minor versions → test → commit
4. Suggest major updates for separate consideration
```

## Error Handling

- **No package manager detected**: "No supported package manager found"
- **No outdated packages**: "All dependencies are up to date"
- **Test failures**: Offer to revert problematic update
- **Network issues**: Suggest retrying or checking connectivity
- **Lock file conflicts**: Guide through resolution

## Testing Integration

After each update category:

1. **Run existing test suite**: `npm test`, `bundle exec rspec`, etc.
2. **Check build process**: `npm run build`, `cargo build`, etc.
3. **Verify linting passes**: `npm run lint`, `rubocop`, etc.
4. **Run type checking**: `tsc --noEmit`, `mypy`, etc.

## Integration with Global Standards

Follow dependency best practices from global CLAUDE.md:

- Pin versions in production
- Test breaking changes thoroughly
- Document system requirements
- Use lock files for consistent environments
