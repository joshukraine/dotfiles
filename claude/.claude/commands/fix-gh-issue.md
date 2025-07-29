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
   - Think harder about how to break the issue down into a series of small, manageable tasks.
   - Identify files that need changes
   - Consider edge cases and testing requirements
   - **Create scratchpad documentation** in appropriate subfolder:
     - `scratchpads/debugging/` for bugs, fixes, errors
     - `scratchpads/planning/` for features, enhancements, new functionality
     - `scratchpads/notes/` for documentation, research, general issues
   - Filename: `issue-$ARGUMENTS-$(date +%Y%m%d-%H%M%S).md`

4. **Create branch and implement**:
   - Create feature branch: `git checkout -b fix/gh-$ARGUMENTS` or `git checkout -b feat/gh-$ARGUMENTS`
   - Implement changes in small, logical commits
   - Follow commit standards from global CLAUDE.md
   - Test changes after each commit

5. **Verify solution**:
   - Run relevant tests
   - Verify the original issue is resolved
   - Check for regressions
   - Update documentation if needed

6. **Create pull request**:
   - Use `/create-pr --issue $ARGUMENTS` command for comprehensive PR creation
   - **CRITICAL**: The --issue flag ensures automatic "Closes #$ARGUMENTS" linking
   - Add `--draft` flag if `--draft-pr` specified
   - **Verify**: Confirm the PR description contains the issue reference before completing
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

- `fix/gh-123-short-description` for bug fixes
- `feat/gh-123-short-description` for new features
- `docs/gh-123-short-description` for documentation

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
