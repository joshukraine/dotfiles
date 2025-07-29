# Review Pull Request Command

Review GitHub pull requests with configurable depth and focus.

## Command Options

- `--quick`: Fast review focusing on blocking issues only
- `--thorough`: Comprehensive review with architecture and test analysis
- `--security`: Security-focused review for sensitive changes
- `--auto-detect`: Automatically choose review depth based on PR characteristics

## Your task

1. **Get PR details**:
   - Use `gh pr view $ARGUMENTS --json number,title,body,headRepository,baseRefName`
   - Use `gh pr view $ARGUMENTS` to display PR overview
   - Extract PR context, linked issues, and purpose

2. **Choose review approach**:
   - **Default (no flags)**: Standard review covering common issues
   - **`--auto-detect`**: Analyze PR size and files to determine depth automatically
   - **Explicit flags**: Use specified review type

3. **Create working notes**:
   - Create scratchpad: `scratchpads/pr-reviews/pr-{number}-$(date +%Y%m%d-%H%M%S).md`
   - Document PR purpose, scope, and initial observations

4. **Collect feedback and status**:
   - Fetch existing comments: `gh api /repos/{owner}/{repo}/issues/{number}/comments`
   - Fetch code review comments: `gh api /repos/{owner}/{repo}/pulls/{number}/comments`
   - Check CI/CD status: `gh pr checks $ARGUMENTS`
   - Filter for actionable feedback (skip resolved threads, appreciation comments)

5. **Analyze based on review type**:

   **Standard Review** (default):
   - Focus on blocking issues from comments and failed checks
   - Basic code quality and logic review
   - **Verify issue reference**: Check PR description contains proper issue link (use "Closes #123" as standard)
   - Verify other PR metadata (title format, description completeness)

   **Quick Review** (`--quick`):
   - Only blocking issues and critical failures
   - Skip architecture and test coverage analysis

   **Thorough Review** (`--thorough`):
   - Include architecture and refactoring opportunities
   - Assess test coverage and quality
   - Comprehensive code quality analysis

   **Security Review** (`--security`):
   - Focus on authentication/authorization logic
   - Check for hard-coded secrets or credentials
   - Analyze input validation and sanitization
   - Review API security and access controls

6. **Plan and prioritize**:
   - Break down issues into manageable tasks
   - Prioritize by severity: critical bugs → security → quality improvements
   - Note dependencies between issues
   - Update scratchpad with detailed plan

7. **Execute systematically**:
   - Work through each issue with context
   - Ask: "Would you like to address this issue? (y/n/skip)"
   - Implement fixes with appropriate testing
   - Commit changes with descriptive messages
   - Update scratchpad with progress

8. **Verify and finalize**:
   - Run full test suite to ensure no regressions
   - Verify all CI/CD checks pass
   - Mark resolved issues complete in scratchpad
   - Reply to comments with explanations
   - Note final PR status and next steps

## Auto-Detection Logic (--auto-detect only)

Analyze PR characteristics to choose review depth:

```bash
# Get PR stats
gh pr view $ARGUMENTS --json additions,deletions,changedFiles
gh pr diff $ARGUMENTS --name-only
```

**Quick Review** if:

- Total changes < 50 lines
- No architectural files (package.json, configs, schemas)
- No security-sensitive files

**Security Review** if changes touch:

- Authentication/authorization files
- Cryptographic implementations
- Environment variable handling
- API endpoints with data access

**Thorough Review** for everything else

## Scratchpad Template

```markdown
# PR Review #$ARGUMENTS: [PR Title]

**Link**: https://github.com/{owner}/{repo}/pull/$ARGUMENTS
**Type**: [Quick/Standard/Thorough/Security] Review

## PR Summary

- Purpose: Brief description
- Related issues: #123, #456
- Key changes: Major modifications

## Issues Found

### Critical (Must Fix)

- [ ] Missing issue reference in PR description (add "Closes #123" if applicable)
- [ ] Issue 1 with context
- [ ] Issue 2 with context

### Quality Improvements (Optional)

- [ ] Refactoring opportunity 1
- [ ] Test coverage gap 2

## Progress

- [x] Initial analysis complete
- [ ] Issue 1 addressed
- [ ] Issue 2 addressed
- [ ] Final verification

## Notes

- Implementation decisions
- Review feedback given
```

## Review Focus by Type

### Standard Review

- Blocking issues from comments and CI failures
- Basic logic and error handling
- **Issue reference validation**: Ensure PR description includes proper issue link ("Closes #123" is the standard)
- Other PR metadata (title format, description completeness)
- Essential test coverage

### Quick Review

- Only critical and blocking issues
- Failed automated checks
- Basic functionality verification

### Thorough Review

- All standard review items (including issue reference validation)
- Architecture and design patterns
- Comprehensive test coverage analysis
- Performance and maintainability
- Refactoring opportunities

### Security Review

- Authentication/authorization vulnerabilities
- Input validation and sanitization
- Secret management and exposure
- API security and access controls
- Error handling that could leak information

## Error Handling

- **PR not found**: "PR #$ARGUMENTS not found or not accessible"
- **Already merged**: "PR #$ARGUMENTS is already merged"
- **No repository context**: "Run from within a git repository"
- **API rate limits**: "GitHub API rate limit reached, wait and retry"

## Integration with Global Standards

Follow PR review best practices from global CLAUDE.md:

- Focus on actionable feedback
- Reference security principles
- Maintain code quality standards
- Ensure proper testing practices
