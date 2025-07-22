Please review the GitHub pull request: $ARGUMENTS

Follow these steps:

# RESEARCH

1. Use `gh pr view $ARGUMENTS --json number,title,body,headRepository,baseRepository` to get basic PR details
2. Use `gh pr view $ARGUMENTS` to display the PR overview
3. Understand the context of this PR
   – Search scratchpads for previous thoughts related to this PR or related issues
   – Check if this PR addresses a specific GitHub issue
   – Review the PR description and linked issues for background
4. Create a scratchpad file: `pr-review-{number}-{timestamp}.md`
   – Include PR title, number, and link
   – Document the PR's purpose and scope

# COLLECT

1. Gather all feedback and status information:
   – Fetch PR-level comments: `gh api /repos/{owner}/{repo}/issues/{number}/comments`
   – Fetch code review comments: `gh api /repos/{owner}/{repo}/pulls/{number}/comments`
   – Fetch review summaries: `gh api /repos/{owner}/{repo}/pulls/{number}/reviews`
   – Check CI/CD status: `gh pr checks $ARGUMENTS`
   – Fetch status checks: `gh api /repos/{owner}/{repo}/commits/{sha}/status`
   – Fetch check runs: `gh api /repos/{owner}/{repo}/commits/{sha}/check-runs`

2. Analyze code quality and architecture:
   – Review code changes for refactoring opportunities (large files, duplicate code, complex functions)
   – Check for consistent coding patterns and style adherence
   – Identify potential performance or maintainability issues
   – Assess architectural decisions and suggest improvements

3. Assess test coverage and quality:
   – Review existing test coverage for new/modified code
   – Identify gaps in test coverage that should be addressed
   – Check test quality and effectiveness
   – Suggest additional test scenarios if needed

4. Verify issue integration and PR metadata:
   – Check what GitHub issues this PR addresses or closes
   – Verify PR body contains proper "Closes #N" references for all related issues
   – Review linked issues for integrated/dependent issues that should also be closed
   – Assess if PR description accurately reflects the current scope of work

5. Filter and categorize all blocking issues:
   – Skip outdated comments (where referenced code has changed)
   – Skip resolved comments or threads marked as resolved
   – Skip simple appreciation comments
   – Focus on actionable feedback: code changes, bug reports, security concerns, performance issues
   – Include all failed automated checks: tests, linting, security scans, build failures

6. Document all identified issues in the scratchpad:
   – Create a checklist format for tracking progress
   – Think harder about the severity and impact of each issue
   – Prioritize issues based on this analysis
   – Group related issues together

# PLAN

1. Break down the review work into small, manageable tasks
2. Think harder about how to prioritize and sequence the issues for maximum efficiency
3. For each blocking issue, determine:
   – What specific action is needed
   – Estimated complexity and time required
   – Dependencies between issues
   – Testing requirements after changes
4. Prioritize quality improvements:
   – Address critical refactoring opportunities that improve maintainability
   – Plan test coverage improvements for new/modified functionality
   – Ensure proper issue closing references are added to PR body
   – Verify PR description accurately reflects final scope
5. Update scratchpad with the detailed plan
6. Present the plan and ask for confirmation before proceeding

# EXECUTE

1. Work through each issue systematically:
   – Present the issue context and analysis
   – Show file, line, diff hunk for comments; error details for failed checks
   – Ask: "Would you like to address this issue? (y/n/skip)"
   – If yes: Help implement the fix or change
   – If no: Document the decision rationale
   – Update scratchpad with action taken

2. After each change:
   – Test the changes appropriately
   – Use puppeteer via MCP for UI changes if applicable
   – Run relevant test suites
   – Commit changes with descriptive messages referencing the PR
   – Reply to comments indicating what was done
   – Update scratchpad with commit hash and completion status

# TEST

– Run the full test suite to ensure nothing is broken
– Verify all automated checks now pass
– If any tests are failing, fix them before proceeding
– Ensure all CI/CD checks are green
– Test manually if automated coverage is insufficient

# FINALIZE

– Mark all resolved issues as complete in scratchpad
– Reply to any remaining comments with explanations for declined suggestions
– Verify quality improvements completed:
  – Confirm critical refactoring opportunities have been addressed
  – Validate test coverage is adequate for new/modified functionality
  – Ensure all related GitHub issues have proper "Closes #N" references in PR body
  – Verify PR description accurately reflects final scope and changes
– Summarize the review session in the scratchpad
– Note final PR status: ready to merge, needs more work, blocked by external factors
– If PR is ready, suggest next steps (merge, request final review, etc.)

Remember to use the GitHub CLI (`gh`) for all GitHub-related tasks.
