# Create Pull Request Command

Create a pull request from the current branch with proper formatting and issue linking.

## Command Options

- `--draft`: Create as draft PR
- `--issue N`: Explicitly link to issue #N (recommended for reliability)
- `--skip-issue-link`: Skip automatic issue linking

## Your task

1. **Verify prerequisites**:
   - Confirm current branch is not `main`/`master`
   - Check that branch has commits ahead of base branch
   - Ensure branch is pushed to remote (push if needed)

2. **Generate PR title**:
   - Use branch name as fallback
   - If single commit ahead: use commit message as title
   - If multiple commits: create descriptive title based on branch name and commit themes
   - Follow Conventional Commits format from global CLAUDE.md

3. **Analyze commits for description**:
   - Get commit history: `git log origin/main..HEAD --oneline`
   - Group commits by type (feat, fix, docs, etc.)
   - Identify patterns and overall theme

4. **Create comprehensive description**:
   - **Summary section**: 2-3 bullet points describing what this PR does
   - **Changes section**: Categorized list of changes from commits
   - **Testing section**: How the changes should be tested
   - **Notes section**: Any implementation details or decisions

5. **Identify and link related issues**:
   - **PRIORITY 1**: If `--issue N` flag provided, use issue #N (most reliable)
   - **PRIORITY 2**: Extract issue number from branch name patterns:
     - `fix/gh-123` or `feat/gh-123` → Issue #123 (preferred format)
     - `fix/issue-123` or `feat/issue-123` → Issue #123 (legacy format)
     - `docs/gh-456` → Issue #456
   - **PRIORITY 3**: Scan commit messages for issue references (#123, fixes #456)
   - **PRIORITY 4**: Search recent issues for related keywords from commits
   - **CRITICAL**: Include issue reference in PR description:
     - Use "Closes #123" for issues this PR fully resolves
     - Use "Related to #123" for partial fixes or enhancements
     - Use "Addresses #123" for issues that need more work after this PR
   - **MANDATORY VALIDATION**: Before creating PR, confirm issue reference will be included
   - **If `--skip-issue-link` provided**: Skip automatic issue detection and linking

6. **Create the PR**:
   - **PRE-CREATION CHECK**: Verify issue reference is included in description (unless --skip-issue-link)
   - Use `gh pr create` with generated title and description
   - Add `--draft` flag if specified
   - Set base branch (usually main/master)

7. **Confirm and display**:
   - Show PR URL
   - Display title and description used
   - **IMPORTANT**: Explicitly confirm which issues were linked (e.g., "✅ Linked to issue #123")
   - If no issues were detected, clearly state "⚠️ No issues were linked to this PR"

## PR Description Template

```markdown
## Summary

- Brief description of what this PR accomplishes
- Key changes or features added
- Problem being solved

## Changes

### ✨ Features

- New feature descriptions

### 🐛 Bug Fixes

- Bug fix descriptions

### 📚 Documentation

- Documentation updates

### 🔧 Other

- Other changes

## Testing

- [ ] Manual testing performed
- [ ] Existing tests pass
- [ ] New tests added (if applicable)

## Notes

- Any implementation decisions
- Breaking changes (if any)
- Dependencies or follow-up work needed

## Related Issues

Closes #123
```

## Example Workflows

### Automatic Detection (Legacy)

```bash
# Current branch: feat/gh-123-user-authentication
# Commits ahead: 3 commits about login, session management, tests
# → Detected issue #123 from branch name

Title: "feat: add user authentication system"
```

### Explicit Issue Linking (Recommended)

```bash
/create-pr --issue 123
# → Guaranteed linking to issue #123, regardless of branch name
# → More reliable, prevents missed references

Title: "feat: add user authentication system"
```

Description example:

```markdown
## Summary

- Add complete user authentication system with login/logout
- Implement secure session management
- Add comprehensive test coverage

## Changes

### ✨ Features

- User login with email/password validation
- Secure session management with JWT tokens
- Password reset functionality

### 🧪 Testing

- Unit tests for authentication logic
- Integration tests for login flow

## Testing

- [x] Manual testing performed
- [x] All existing tests pass
- [x] New tests added for auth flows

Closes #123
```

## Error Handling

- If no commits ahead of base: "No changes to create PR for"
- If branch not pushed: Offer to push with `git push -u origin <branch>`
- If PR already exists: Display existing PR URL
- If no remote repository: "This repository has no remote configured"

## Integration with Global Standards

Follow PR best practices from global CLAUDE.md:

- Clear titles using Conventional Commits format
- Reference related issues
- Keep PRs focused and atomic when possible
