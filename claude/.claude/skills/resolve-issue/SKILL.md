---
name: resolve-issue
description: Full issue workflow — fetch details, research, plan solution, implement, and verify.
argument-hint: "[issue-number]"
---

# Resolve GitHub Issue

Take the issue at `gh issue view $ARGUMENTS` through to a verified, committed implementation on a feature branch — stopping short of the PR.

## Plan before implementing

Right-size the ceremony to the issue:

- **Small and well-scoped** (a few files, an obvious approach) — state the plan in a line and proceed. Don't wait for a reply.
- **Complex or ambiguous** (multiple subsystems, design choices, real risk) — present the implementation plan and **wait for explicit approval**.

When unsure which applies, treat it as complex and ask.

## Branch

Check `git branch --show-current` first:

- **Already on a feature branch for this issue** (`<prefix>/gh-$ARGUMENTS-…`) — reuse it, do not create a second branch. This includes re-entering this step inside an autopilot fan-out worktree.
- **Otherwise** — `git switch -c <prefix>/gh-$ARGUMENTS-<short-description>`

The prefix comes from the issue's type label. If the project defines its own branch convention, that wins.

| Type label | Prefix |
| --- | --- |
| `feat` | `feat/` |
| `fix` | `fix/` |
| `chore` | `chore/` |
| `docs` | `docs/` |
| `test` | `test/` |

No type label? Bug fixes are `fix/`, new functionality `feat/`, everything else `chore/`.

## Commit as you go

Commit each working component rather than everything at the end — typically 3–8 commits for an issue, each one working code.

**Never reference the issue number in a commit message.** Issues close when the PR merges, so the closing keyword belongs in the PR description, not the commits.

## Before reporting done

Run the project's full test suite and confirm no regressions. **Do not proceed until it passes.**

Then check off the acceptance criteria the work satisfied — fetch the issue body, flip `- [ ]` to `- [x]` for what's now done, and write it back:

```bash
gh issue view $ARGUMENTS --json body --jq '.body'
gh issue edit $ARGUMENTS --body "$updated_body"
```

## Hand off — do not create the PR

Summarize what changed: files touched, commits made, test status, and which acceptance criteria are now met. Then **stop and ask**.

Recommend `/simplify` first for anything non-trivial, then `/create-pr` — it infers the issue number from the branch name.
