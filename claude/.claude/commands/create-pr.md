# Create Pull Request Command

Create a pull request from the current branch with proper formatting and issue linking.

## Command Options

- `$ARGUMENTS`: Optional PR number or `--issue N` to explicitly link an issue
- `--skip-issue-link`: Skip automatic issue linking
- `--draft`: Create PR as draft (default is ready-to-review)

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

5. **Update ROADMAP**:
   - Check if the work corresponds to a checkbox item in `docs/prd/ROADMAP.md`
   - If a matching item exists, mark it complete (`[x]`) and commit the change to the branch before creating the PR
   - If no matching item exists, skip this step

6. **Identify and link related issues**:
   - **If `--issue N` or issue number provided as argument**: Use "Closes #N" in PR description
   - **Default (no argument)**: Automatically extract issue number from branch name (`fix/gh-123` → Issue #123). Also check the issue description and any linked issues to ensure ALL related issues are referenced with closing keywords (e.g., "Closes #X, Closes #Y").
   - **If `--skip-issue-link`**: Skip issue linking entirely
   - **If no issue number can be determined**: Warn the user and ask whether to proceed without issue linking
   - **Default format**: Always use "Closes #N" (assume PR fully resolves issue)

7. **Create the PR**:
   - Use `gh pr create` with generated title and description
   - Set base branch (usually main/master)
   - **Default to ready** (no `--draft` flag) unless `--draft` flag is explicitly passed

8. **Confirm and display**:
   - Show PR URL and title
   - Confirm issue linking (e.g., "✅ Linked to issue #123" or "⚠️ No issues linked")

## PR Description Template

```markdown
## Summary

- What this PR does
- Key changes made

## Changes

- List of changes from commits

## Testing

- [ ] Tests pass
- [ ] Manual testing done

Closes #123
```

## Example Usage

```bash
# Default: Automatically detects issue from branch name (e.g., fix/gh-123-description)
/create-pr

# Explicit issue linking (when branch name doesn't contain an issue number)
/create-pr --issue 123

# Skip issue linking entirely
/create-pr --skip-issue-link
```
