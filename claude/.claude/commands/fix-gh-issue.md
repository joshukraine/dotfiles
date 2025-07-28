# Fix GitHub Issue Command

Analyze and fix GitHub issues systematically with optional complexity modes.

## Command Options

- `--quick`: Quick fix mode for simple issues (skip scratchpad, minimal research)
- `--no-scratchpad`: Skip creating scratchpad documentation
- `--draft-pr`: Create PR as draft

## Your task

1. **Get issue details**:
   - Use `gh issue view $ARGUMENTS` to get issue details
   - Extract issue title, description, labels, and comments
   - Identify issue complexity (simple bug fix vs complex feature)

2. **Choose workflow based on complexity**:
   - **Quick mode** (`--quick` or simple issues): Skip to step 4
   - **Standard mode**: Continue with research phase

3. **Research and understand** (Skip for quick mode):
   - Search scratchpads for previous thoughts: `grep -r "issue-$ARGUMENTS" scratchpads/`
   - Search related PRs: `gh pr list --search "fix issue $ARGUMENTS"`
   - Search codebase for relevant files and patterns
   - Review similar issues: `gh issue list --label <relevant-labels>`

4. **Plan the solution**:
   - Break down into small, manageable tasks
   - Identify files that need changes
   - Consider edge cases and testing requirements
   - **If not `--no-scratchpad`**: Document plan in `scratchpads/debugging/issue-$ARGUMENTS-$(date +%Y%m%d).md`

5. **Create branch and implement**:
   - Create feature branch: `git checkout -b fix/issue-$ARGUMENTS` or `git checkout -b feat/issue-$ARGUMENTS`
   - Implement changes in small, logical commits
   - Follow commit standards from global CLAUDE.md
   - Test changes after each commit

6. **Verify solution**:
   - Run relevant tests
   - Verify the original issue is resolved
   - Check for regressions
   - Update documentation if needed

7. **Create pull request**:
   - Use `/create-pr` command for comprehensive PR creation
   - Link to original issue: "Fixes #$ARGUMENTS"
   - Add `--draft` flag if `--draft-pr` specified
   - Request appropriate reviewers

## Quick Mode Workflow

For simple bug fixes and minor changes:

```bash
/fix-gh-issue 123 --quick
```

1. Get issue details
2. Create branch immediately
3. Make focused changes
4. Test and commit
5. Create PR with issue link

## Standard Mode Workflow

For complex issues requiring research:

```bash
/fix-gh-issue 123
```

1. Full research phase
2. Scratchpad documentation
3. Comprehensive planning
4. Systematic implementation
5. Thorough testing
6. Detailed PR creation

## Scratchpad Template

When scratchpad is created, use this structure:

```markdown
# Issue #$ARGUMENTS: [Issue Title]

**Link**: https://github.com/{owner}/{repo}/issues/$ARGUMENTS

## Problem Summary

- Brief description of the issue
- Expected vs actual behavior

## Research Notes

- Related files/components
- Similar issues or PRs
- Technical context

## Implementation Plan

1. [ ] Task 1
2. [ ] Task 2
3. [ ] Task 3

## Testing Plan

- [ ] Test case 1
- [ ] Test case 2

## Notes

- Implementation decisions
- Edge cases considered
```

## Branch Naming Conventions

Follow global CLAUDE.md standards:

- `fix/issue-123-short-description` for bug fixes
- `feat/issue-123-short-description` for new features
- `docs/issue-123-short-description` for documentation

## Error Handling

- **Issue not found**: "Issue #$ARGUMENTS not found or not accessible"
- **Already on feature branch**: "Switch to main branch before starting new issue"
- **No repository context**: "Run this command from within a git repository"
- **Issue already closed**: "Issue #$ARGUMENTS is already closed. Continue anyway? (y/n)"

## Integration with Other Commands

- Uses `/create-pr` for PR creation
- References `/setup-scratch` for workspace organization
- Follows commit standards from global CLAUDE.md
- Integrates with `/review-pr` for PR review workflow
