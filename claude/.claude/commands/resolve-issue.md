# Resolve GitHub Issue Command

Systematically resolve GitHub issues with a comprehensive workflow that handles features, bug fixes, enhancements, and other development tasks.

## Your task

**CRITICAL: Use TodoWrite tool to track all 6 steps before beginning**
Create todo items for: Get issue details → Research → Plan → Implement → Verify → Report Back
Mark each as completed only when fully finished.

**IMPORTANT: Progress Reporting**
After completing each major step, provide a brief summary of what was accomplished before moving to the next step.

Follow steps 1-6 below for thorough issue resolution.

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

   **CHECKPOINT**:
   - Present implementation plan to user and ask for approval before proceeding to implementation
   - Offer to copy scratchpad path to clipboard (`pbcopy`) for easy access

4. **Create branch and implement with commit checkpoints**:
   - **CHECKPOINT 1**: Create feature branch: `git checkout -b fix/gh-$ARGUMENTS` or `git checkout -b feat/gh-$ARGUMENTS`
   - **CHECKPOINT 2**: Verify you are on the new branch with `git branch --show-current`
   - **CHECKPOINT 3**: Implement using multiple commits (see rules below)
   - **CHECKPOINT 4**: After implementation, run `git log --oneline` to verify multiple commits exist
   - Follow commit standards from global CLAUDE.md
   - **IMPORTANT**: Do NOT include issue references (like "Closes #$ARGUMENTS") in commit messages

   **MANDATORY: Multiple Commit Strategy**

   GitHub issues require multiple commits. Commit frequently using these rules:
   1. **Commit every major component** - Don't wait until everything is done
   2. **Commit when you reach 30-50 lines** of changes across files
   3. **Each commit must be working code** - no broken states
   4. **Typical range: 3-8 commits** for most GitHub issues

   **When to commit:**
   - Added new files or major functionality ✅ COMMIT
   - Modified configuration or setup ✅ COMMIT
   - Completed a logical piece (model, controller, view, test) ✅ COMMIT
   - Written 30+ lines of code ✅ COMMIT NOW

5. **Verify solution after final checkpoint**:
   - **CHECKPOINT 1**: Run `git log --oneline` and confirm commits exist
   - **CHECKPOINT 2**: Run comprehensive tests across all changes
   - **CHECKPOINT 3**: Verify the original issue is resolved completely
   - Check for regressions and update documentation if needed
   - **STOP**: Do not proceed to step 6 until all checkpoints pass

6. **Implementation Complete - Report Back**:
   - **CHECKPOINT**: Summarize all completed work:
     - Files modified/created
     - Commits made (`git log --oneline` summary)
     - Tests status
     - Issue resolution confirmation
   - **STOP**: Ask user if they want to create PR now
   - **Recommendation**: Run `/create-pr --issue $ARGUMENTS` when ready
   - **DO NOT** automatically create PR - wait for user approval

## If You Get Lost During Implementation

1. **Check your todo list** - What step are you currently on?
2. **Verify current state**:
   - Run `git status` - Are you on a feature branch?
   - Run `git log --oneline` - Do commits exist?
3. **If missing branch/commits**: Restart from step 4 (Create branch and implement)
4. **If implementation is done**: Continue to step 5 (Verify solution)

## Important: Issue References vs Commit Messages

- **Commit messages**: Describe what the commit does, NO issue references
- **PR description**: Contains "Closes #$ARGUMENTS" to link the entire PR to the issue
- **Why**: Issues should close when PRs merge, not when individual commits are made

## Workflow Example

```bash
/resolve-issue 123
```

- Full research and scratchpad documentation
- Systematic planning and implementation with commit checkpoints
- Appropriate commit count: 1 commit for small issues, 3-12 for substantial work
- Thorough testing and detailed PR

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

- **TodoWrite tool**: Required for tracking all 6 workflow steps with progress visibility
- **`/create-pr`**: Recommended for PR creation with `--issue $ARGUMENTS` flag for automatic linking
- **`/setup-scratch`**: Referenced for workspace organization and scratchpad management
- **`/review-pr`**: Integrates with PR review workflow after implementation
- **`claude/.claude/CLAUDE.md`**: Follows commit standards and branch naming conventions
- **Git workflow**: Enhanced checkpoint system ensures reliable branch management and multi-commit strategy
- **Scratchpad system**: Structured documentation in `scratchpads/` with categorized subfolders for debugging, planning, and notes
