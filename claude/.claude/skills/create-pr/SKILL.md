---
name: create-pr
description: Create a pull request with auto-generated description, issue linking, ROADMAP updates, and PR-metadata validation.
disable-model-invocation: true
argument-hint: "[base-branch]"
---

# Create Pull Request

Create a pull request from the current branch with proper formatting and issue linking.

## Command Options

All flags are optional. By default, the issue number is inferred from the branch name and the PR is created as ready-to-review.

- `--issue N`: Override automatic issue linking with a specific issue number (or comma-separated list: `--issue 123,175`)
- `--skip-issue-link`: Skip issue linking entirely
- `--draft`: Create PR as draft

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
   - Get commit history: `git log origin/<base-branch>..HEAD --oneline` (use the base branch identified in step 1)
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

6. **Identify and link related issues** (discover → classify → confirm; don't rely on recall):
   - **If `--skip-issue-link`**: skip this step entirely.
   - **Determine the primary issue(s) P:**
     - `--issue N` (accepts a comma-separated list, e.g. `--issue 123,175`) → use directly as Close targets; skip discovery.
     - Otherwise extract from the branch name (`fix/gh-123-...` → P=123). If none can be determined, warn and ask whether to proceed with no linking.
   - **Discover candidates mechanically** (do not depend on having read the issue earlier in the session):
     - Fetch the primary issue's body and comments: `gh issue view P --json number,title,body,comments`
     - Extract every `#<number>` reference from that output.
     - For each referenced issue M, get its state: `gh issue view M --json number,title,state` — drop anything already closed or that is a PR.
   - **Classify each open candidate by the language around the mention:**
     - `closes` / `fixes` / `resolves #M`, or M is an unchecked task-list item this PR completes → **Close** (`Closes #M`)
     - `part of` / `blocked by` / `relates to` / `see` / `parent #M` → **Reference** (`Refs #M`, no closing keyword)
     - ambiguous → default to **Reference** and flag it
   - **Confirm before creating the PR:**
     - Only the primary issue P, no other open candidates → proceed silently with `Closes #P`.
     - More than one candidate, or any ambiguous one → print a short table (issue · title · proposed Close/Ref) and ask for a one-line confirm/override first.
   - **Format:** one keyword per line so GitHub parses them all — `Closes #N` per close target, `Refs #N` per reference.

7. **Create the PR**:
   - Use `gh pr create` with generated title and description
   - Set base branch (usually main/master)
   - **Default to ready** (no `--draft` flag) unless `--draft` flag is explicitly passed

8. **Confirm and validate**:
   - Show PR URL and title
   - Confirm issue linking (e.g., "✅ Linked to issue #123" or "⚠️ No issues linked")
   - **Cross-check linking:** every Close/Ref target identified in step 6 actually appears in the final description. If one is missing, warn before the PR is considered done (guards against silently dropping a second issue).
   - **Validate PR metadata (warn, don't block):** confirm the title follows Conventional Commits and the description contains a closing keyword (`Closes #N`). If either is missing, surface a warning so it can be fixed before review. (These checks previously lived in the retired `/review-pr`.)

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

# Explicit multi-issue linking (PR closes more than one issue)
/create-pr --issue 123,175

# Skip issue linking entirely
/create-pr --skip-issue-link
```
