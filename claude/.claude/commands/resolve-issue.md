# Resolve GitHub Issue Command

Systematically resolve GitHub issues with a comprehensive workflow that handles features, bug fixes, enhancements, and other development tasks.

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

4. **Create branch and implement with commit checkpoints**:
   - Create feature branch: `git checkout -b fix/gh-$ARGUMENTS` or `git checkout -b feat/gh-$ARGUMENTS`
   - **CRITICAL**: Implement using commit checkpoint workflow (see below)
   - Follow commit standards from global CLAUDE.md
   - **IMPORTANT**: Do NOT include issue references (like "Closes #$ARGUMENTS") in commit messages
   - Test changes after each commit

   **Commit Checkpoint Workflow:**

   **First, assess the scope of changes needed:**

   **✅ Single commit appropriate for:**
   - Simple bug fixes affecting 1-2 files with minimal changes (< 20 lines total)
   - Configuration updates, typo fixes, small documentation changes
   - Single-line logic fixes or minor validation additions
   - Issues that can be completely resolved in one logical step

   **🚫 Multiple commits required for:**
   - New features or substantial enhancements
   - Changes affecting multiple files or components
   - Issues requiring both implementation AND tests
   - Any work involving database changes, UI updates, AND business logic
   - Changes totaling more than 20-30 lines across multiple concerns

   **For multi-commit work, commit after each logical component** using these guidelines:

   **For features/enhancements:**
   1. 🔧 **Infrastructure**: Models, migrations, database changes → commit
   2. 🎮 **Core logic**: Controllers, services, business logic → commit
   3. 🎨 **User interface**: Views, templates, basic styling → commit
   4. ✨ **Enhancements**: Advanced styling, JavaScript, polish → commit
   5. 🧪 **Testing**: Test files and coverage → commit

   **For bug fixes:**
   1. 🔍 **Reproduce**: Add failing test that reproduces the bug → commit
   2. 🔧 **Fix**: Implement the minimal fix → commit
   3. ✅ **Verify**: Additional tests and edge cases → commit

   **For each checkpoint:**
   - Stop implementation work
   - Run relevant tests to ensure nothing is broken
   - Create descriptive commit explaining what was accomplished
   - Continue to next checkpoint

   **Commit Quality Standards:**
   - Each commit should be a working, testable state
   - Commit messages describe what was built, not what issue is being fixed
   - Aim for 3-6 commits for medium tasks, 6-12 for large tasks
   - If you've written 50+ lines without committing, you've waited too long

   **Example 1: Small Issue - Single Commit (Issue #42)**

   ```bash
   # ✅ CORRECT: Single commit for small scope
   git commit -m "fix: add missing email validation to User model"
   # Only touches 1 file, adds 1 line of validation - appropriate for single commit
   ```

   **Example 2: Large Issue - Multiple Commits (Issue #25)**

   ```bash
   # ❌ WRONG: One big commit for substantial work
   git commit -m "feat: implement complete Post resource with CRUD operations"

   # ✅ CORRECT: Checkpoint commits for substantial work
   git commit -m "feat: add Post model with validations and migration"
   git commit -m "feat: add PostsController with CRUD actions"
   git commit -m "feat: add Post views for index, show, and form pages"
   git commit -m "style: add Tailwind CSS styling to Post views"
   git commit -m "test: add comprehensive Post resource test coverage"
   ```

5. **Verify solution after final checkpoint**:
   - **Ensure you followed commit checkpoint workflow appropriately**:
     - Small issues (< 20 lines, single concern): 1 descriptive commit is acceptable
     - Medium-large issues: Multiple commits should exist (2-12 commits typical)
   - Run comprehensive tests across all changes
   - Verify the original issue is resolved completely
   - Check for regressions
   - Update documentation if needed
   - **Final verification**: `git log --oneline` should show appropriate commit count for scope

6. **Create pull request**:
   - Use `/create-pr --issue $ARGUMENTS` command for comprehensive PR creation
   - **CRITICAL**: The --issue flag ensures automatic "Closes #$ARGUMENTS" linking IN THE PR DESCRIPTION ONLY
   - Add `--draft` flag if `--draft-pr` specified
   - **Verify**: Confirm the PR description contains the issue reference before completing
   - Request appropriate reviewers

## Important: Issue References vs Commit Messages

- **Commit messages**: Describe what the commit does, NO issue references
- **PR description**: Contains "Closes #$ARGUMENTS" to link the entire PR to the issue
- **Why**: Issues should close when PRs merge, not when individual commits are made

## Workflow Examples

**Standard comprehensive workflow:**

```bash
/resolve-issue 123
```

- Full research and scratchpad documentation
- Systematic planning and implementation with commit checkpoints
- Appropriate commit count: 1 commit for small issues, 3-12 for substantial work
- Thorough testing and detailed PR

**Quick workflow for simple fixes:**

```bash
/resolve-issue 123 --quick
```

- Skip research and scratchpad phases
- Direct implementation with appropriate commit strategy (1 commit for tiny fixes, 2-4 for moderate scope)
- Streamlined testing and PR creation

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
