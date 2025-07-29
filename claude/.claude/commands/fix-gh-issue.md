# Fix GitHub Issue Command

Analyze and fix GitHub issues systematically with a comprehensive default workflow.

## Command Options

- `--quick`: Skip research and scratchpad phases for simple fixes
- `--draft-pr`: Create PR as draft

## Your task

**Default workflow (comprehensive approach):**

Follow steps 1-6 below for thorough issue resolution.

**Quick workflow (`--quick` flag):**

Execute steps 1, 4, 5, 6 only - skip research and documentation phases.

1. **Get issue details**:
   - Use `gh issue view $ARGUMENTS` to get issue details
   - Extract issue title, description, labels, and comments
   - Identify issue complexity and scope

2. **Research and understand**:
   - Search scratchpads for previous work: `grep -r "issue-$ARGUMENTS" scratchpads/`
   - Search related PRs: `gh pr list --search "fix issue $ARGUMENTS"`
   - Search codebase for relevant files and patterns
   - Review similar issues: `gh issue list --label <relevant-labels>`

3. **Plan and document solution**:
   - Break down into small, manageable tasks
   - Identify files that need changes
   - Consider edge cases and testing requirements
   - Create scratchpad documentation: `scratchpads/debugging/issue-$ARGUMENTS-$(date +%Y%m%d).md`

4. **Create branch and implement**:
   - Create feature branch: `git checkout -b fix/issue-$ARGUMENTS` or `git checkout -b feat/issue-$ARGUMENTS`
   - Implement changes in small, logical commits
   - Follow commit standards from global CLAUDE.md
   - Test changes after each commit

5. **Verify solution**:
   - Run relevant tests
   - Verify the original issue is resolved
   - Check for regressions
   - Update documentation if needed

6. **Create pull request**:
   - Use `/create-pr` command for comprehensive PR creation
   - Link to original issue: "Fixes #$ARGUMENTS"
   - Add `--draft` flag if `--draft-pr` specified
   - Request appropriate reviewers

## Workflow Examples

**Standard comprehensive workflow:**

```bash
/fix-gh-issue 123
```

- Full research and scratchpad documentation
- Systematic planning and implementation
- Thorough testing and detailed PR

**Quick workflow for simple fixes:**

```bash
/fix-gh-issue 123 --quick
```

- Skip research and scratchpad phases
- Direct implementation and testing
- Streamlined PR creation

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
