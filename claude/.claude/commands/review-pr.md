# Review Pull Request Command

Review GitHub pull requests and report findings. This command analyzes and reports — it does not make changes or commit code.

## Command Options

- `--quick`: Fast review focusing on blocking issues only
- `--thorough`: Comprehensive review with architecture and test analysis
- `--security`: Security-focused review for sensitive changes

## Your task

1. **Get PR details**:
   - Run `gh pr view $ARGUMENTS --json number,title,body,additions,deletions,changedFiles`
   - Run `gh pr diff $ARGUMENTS` to review the actual changes
   - Extract PR context, linked issues, and purpose

2. **Choose review depth** based on flags or PR characteristics:

   If no flag is provided, choose automatically:
   - **Quick**: Total changes < 50 lines, no config/schema/security files
   - **Security**: Changes touch auth, crypto, env vars, or API access control
   - **Thorough**: Everything else

3. **Check existing feedback**:
   - Fetch review comments: `gh api /repos/{owner}/{repo}/pulls/{number}/comments`
   - Check CI/CD status: `gh pr checks $ARGUMENTS`
   - Note any unresolved threads or failing checks

4. **Analyze the PR**:

   **All reviews** check for:
   - PR metadata: title follows Conventional Commits, description includes issue reference ("Closes #N")
   - Failing CI checks or unresolved review comments
   - Obvious bugs, logic errors, or missing error handling

   **Thorough reviews** additionally check:
   - Architecture and design patterns
   - Test coverage and test quality
   - Performance and maintainability concerns
   - Refactoring opportunities

   **Security reviews** additionally check:
   - Authentication and authorization logic
   - Hard-coded secrets or credentials
   - Input validation and sanitization
   - API security and access controls
   - Error messages that could leak internal details

5. **Report findings**:

   Organize findings by severity:
   - **Blocking**: Must fix before merge (bugs, security issues, failing tests)
   - **Should fix**: Important but not critical (missing tests, code quality)
   - **Consider**: Suggestions and improvements (refactoring, naming, patterns)

   For each finding, include:
   - The specific file and lines involved
   - What the issue is and why it matters
   - A suggested fix or approach

6. **Recommend next steps**:
   - If clean: "This PR looks good to merge."
   - If fixes needed: Suggest using `/resolve-issue` or manual edits as appropriate.
   - **Do NOT make changes, commit, or push.** This command is read-only.
