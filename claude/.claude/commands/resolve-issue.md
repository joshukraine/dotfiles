# Resolve GitHub Issue Command

Systematically resolve GitHub issues with a structured workflow.

## Your task

Track your progress through the 6 steps below. Report completion of each step before moving to the next.

### Step 1: Get issue details

- Run `gh issue view $ARGUMENTS` to get issue details
- Extract title, description, labels, and comments
- Identify complexity and scope

### Step 2: Research and understand

- Search related PRs: `gh pr list --search "fix issue $ARGUMENTS"`
- Search codebase for relevant files and patterns
- Review similar issues if applicable

### Step 3: Plan solution

- Break the issue into small, manageable tasks
- Identify files that need changes
- Consider edge cases and testing requirements

**CHECKPOINT**: Present implementation plan to user and ask for approval before proceeding.

### Step 4: Create branch and implement

- Create feature branch: `git switch -c fix/gh-$ARGUMENTS` or `feat/gh-$ARGUMENTS`
- Verify branch: `git branch --show-current`
- Implement with frequent commits (see commit strategy below)
- **Do NOT include issue references** in commit messages

**Commit Strategy:**

- Commit every major component — don't wait until everything is done
- Each commit must be working code
- Typical range: 3-8 commits for most issues
- Track which acceptance criteria from the issue have been satisfied as you go

### Step 5: Verify solution

- Run `git log --oneline` to confirm commits exist
- Run comprehensive tests across all changes
- Verify the original issue is resolved completely
- Check for regressions
- Update the issue to check off all completed acceptance criteria checkboxes:
  fetch the current body with `gh issue view $ARGUMENTS --json body --jq '.body'`,
  replace `- [ ]` with `- [x]` for completed items, then update with
  `gh issue edit $ARGUMENTS --body "$updated_body"`
- **STOP**: Do not proceed until all checks pass

### Step 6: Report back

- Summarize: files modified, commits made, test status, resolution confirmation
- **STOP**: Ask user if they want to create PR now
- Recommend: `/create-pr --issue $ARGUMENTS`
- **Do NOT automatically create PR**

## Branch Naming

- `fix/gh-123-short-description` for bug fixes
- `feat/gh-123-short-description` for features
- `docs/gh-123-short-description` for documentation

## Important

- **Commit messages**: Describe what the commit does, NO issue references
- **PR description**: Contains "Closes #$ARGUMENTS" to link the PR to the issue
- **Why**: Issues close when PRs merge, not when individual commits land
