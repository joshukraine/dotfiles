---
name: drift-check
description: Pre-PR advisory check for deviations from the project spec. Read-only analysis.
disable-model-invocation: true
---

# Drift Check Command

Pre-PR deviation check against the project spec. Run this before `/create-pr` to verify alignment between implementation and documentation.

> **Reference:** See `~/.claude/docs/prd-workflow/spec-driven-development.md` §2–§4 for the deviation threshold, workflow, and checkpoint cadence that this command operationalizes.

## Your task

Perform a lightweight, advisory review of the current branch's changes against the project's spec and living documents. This is a read-only check — do not modify any files.

### Step 1: Identify scope

- Run `git log main..HEAD --oneline` to see all commits on this branch
- Run `git diff main...HEAD --stat` to see all files changed
- Determine which feature area this work relates to (from branch name, commit messages, or changed files)

### Step 2: Identify the relevant spec

- Check for `docs/prd/ROADMAP.md` — if it exists, identify which phase or item this work relates to
- Check for `docs/prd/` files that cover the feature area
- Check for living documents (domain model, integration guides, runbooks) that describe the current state of the affected models or features
- If no spec exists for this work (e.g., a bug fix or chore with no PRD entry), note that and skip to Step 4

### Step 3: Scan for deviation signals

Review `git diff main...HEAD` for changes that cross the deviation threshold:

**Flag if present:**

- New or removed database migrations (new models, columns, associations)
- Changes to model validations or lifecycle (status enums, state transitions)
- New or changed URL patterns (routes file changes)
- Changes to authorization rules (policy files)
- New or altered mailer actions or notification triggers
- API contract changes (new endpoints, changed request/response shapes)

**For each flagged change**, check whether the relevant spec or living document already describes it. If it does, no action needed. If it doesn't, this is a potential deviation.

### Step 4: Check documentation gaps

- If `docs/prd/CHANGELOG.md` exists, check whether any deviations found in Step 3 have already been logged
- If `docs/prd/ROADMAP.md` exists and this work corresponds to a checkbox item, check whether the checkbox is marked `[x]`
- Check whether the branch's linked issue (from branch name `gh-<N>`) has closing keywords in any commit or is ready to be referenced in a PR description

### Step 5: Report findings

Present a concise report with these sections:

```text
## Drift Check — [branch name]

### Spec Reference
[Which PRD section or living document this work relates to, or "No spec found"]

### Deviation Signals
[List any changes that cross the threshold but aren't in the spec]
[Or: "No deviations detected"]

### Documentation Status
- CHANGELOG: [entry exists / entry needed / not applicable]
- ROADMAP: [checkbox marked / checkbox not marked / not applicable]
- Issue linking: [ready / needs attention]

### Recommended Actions
[Bulleted list of any actions needed before creating the PR]
[Or: "Clear to proceed with /create-pr"]
```

## Important

- This is **advisory, not blocking**. The developer decides what needs action.
- Do **not** modify any files — no CHANGELOG entries, no ROADMAP updates, no code changes.
- Do **not** re-read files you've already seen in this session unless needed for the deviation check.
- Keep it **fast**. Target: under 30 seconds for a typical PR. Don't exhaustively read every PRD file — focus on the one or two that are relevant.
- If no PRD exists for the project, check against living documents (domain model, README, CLAUDE.md architectural guardrails). The deviation threshold still applies — it just measures against whatever the authoritative reference is.
