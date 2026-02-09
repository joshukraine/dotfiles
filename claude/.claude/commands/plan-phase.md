# Plan Phase Command

Plan the next phase of development from the PRD, create GitHub issues, and
prepare for implementation. This command bridges planning and building — it
creates the structure but writes no application code.

## Your task

Work through the steps below in order. Each step has a hard stop — do not
proceed past a CHECKPOINT without explicit user approval.

---

> **Tip for the user**: You can activate Claude Code's plan mode (shift+tab)
> during Steps 1-2 for an extra guardrail against premature code changes.
> Toggle out of plan mode before Step 3 so that Claude Code can run
> `gh issue create` commands.

### Step 1: Orient

- Read the project's PRD and CLAUDE.md
- Review recent git history and merged PRs to understand current state
- Identify which PRD phase or section comes next
- Check for any open GitHub issues that may already cover upcoming work

### Step 2: Draft the plan

Present a clear, concise plan for the next phase:

- **Phase name and PRD reference** (e.g., "Phase 2: User Authentication — PRD section 4")
- **Scope summary**: What this phase accomplishes in 2-3 sentences
- **Proposed issues**: A numbered list of discrete, implementable issues. Each
  issue should include:
  - A clear title following the pattern: `feat: ...` or `fix: ...` or `chore: ...`
  - A one-line description of what the issue covers
  - Estimated complexity (small / medium / large)
- **Implementation order**: Which issues depend on others and the recommended
  sequence
- **Out of scope**: Anything explicitly deferred to a later phase

Keep the number of issues manageable — typically 3-7 per phase. If the phase
is larger, break it into sub-phases.

**CHECKPOINT 1**: Present the plan and wait for user approval. The user may
adjust scope, reorder issues, split or combine items, or request changes.
Do not proceed until the user explicitly approves.

---

### Step 3: Create GitHub issues

After plan approval, create each issue on GitHub using the `gh` CLI:

```bash
gh issue create --title "feat: [title]" --body "[description]"
```

Each issue body should include:

- **Context**: Which PRD phase/section this relates to
- **Requirements**: Specific acceptance criteria drawn from the PRD
- **Technical notes**: Key implementation details, relevant files, patterns to
  follow
- **Dependencies**: Any issues that must be completed first

Create the issues in implementation order. Record each issue number as it is
created.

### Step 4: Report and hand off

After all issues are created, present a summary:

```text
Phase: [name]
Issues created:
  #41 - feat: Add User model with Devise authentication (medium)
  #42 - feat: Add Pundit authorization policies (small)
  #43 - feat: Add admin dashboard with user management (large)

Recommended starting point:
  /resolve-issue 41
```

**CHECKPOINT 2**: Present this summary and wait for user approval before any
implementation begins. Do not write application code, create branches, or
modify any files beyond GitHub issues.

When the user is ready to begin, suggest the `/resolve-issue` command for the
first issue in sequence.

---

## Important

- **This command creates GitHub issues only.** It does not write application
  code, create branches, modify source files, or run tests.
- **Both checkpoints are hard stops.** Do not proceed without explicit approval.
- **If a context window clear is needed**, it is safe to do so after Step 4 —
  the issues exist on GitHub and will survive the clear.
- **Keep issues focused.** Each issue should be completable in a single PR. If
  an issue feels too large, split it.
