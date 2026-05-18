---
name: walkthrough
description: Generate a hands-on browser walkthrough of a PR's user-facing changes to exercise before review; --publish posts the final version to the PR for QA.
disable-model-invocation: true
argument-hint: "[PR-number-or-branch] [--publish]"
---

# Walkthrough

Generate a concise, click-by-click manual walkthrough of the current branch's user-facing changes, so the human orchestrator can exercise the feature in a browser **before** the formal `/review-pr`. Seeing a feature work is faster than reading code or a PR description for catching UX problems.

This skill does not modify code or perform code review. With `--publish` it posts the walkthrough as a PR comment; otherwise it only writes a local scratch file.

**Where it sits in the workflow — two slots:**

- **Generate** (default) — run after `/create-pr` and before `/review-pr`, and re-run as needed. The orchestrator's iterative pre-flight check.
- **Publish** (`--publish`) — run once after `/review-pr` and any review fixes, just before merge (or after merge, to backfill a walkthrough that was missed). Posts the final walkthrough to the PR so the QA tester can follow it after deploy.

**Not the same as:**

- `/debrief` — a heavy architecture and test-coverage write-up for milestones.
- `/qa-handoff` — a broad, committed QA guide for a whole phase. `/walkthrough --publish` is the per-PR counterpart: one change, posted to the PR.

## Command Options

- `--publish`: Post the final walkthrough as a comment on the PR, regenerating it first so it matches the code under review. Run once, after review — normally just before merge, but it also works on an already-merged PR to backfill a missed walkthrough. See the Publishing section.

## Your task

If invoked with `--publish`, follow the **Publishing the final walkthrough** section below instead. Otherwise, generate a new walkthrough:

### 1. Identify the change set

- If a PR number or branch is given as an argument, use it. Otherwise use the current branch against its base (`main`/`master`).
- Get the diff and changed files: `gh pr diff <N>` for a PR, or `git diff <base>...HEAD`.
- Note the open PR number for the branch, if any (`gh pr view`).

### 2. Gate: is a walkthrough applicable?

Classify the diff:

- **User-facing** — changes to views/templates, controllers, routes, view helpers, JavaScript/Stimulus, mailers and mailer views, UI-facing i18n strings, or front-end components.
- **Not user-facing** — only models, lib, service objects, migrations with no UX effect, tests, CI config, dependency bumps, or docs.

If the diff has **no user-facing surface**, STOP. Do not generate a document. Tell the user plainly:

> No user-facing changes detected in this PR — a browser walkthrough doesn't apply. Proceed to `/review-pr`.

If the change is user-facing — or a mix where the UI surface is worth exercising — continue.

### 3. Map flows, personas, and credentials

- From the changed views/controllers/routes, determine which screens and user journeys changed.
- Identify every user role/persona that touches the changed flows.
- Find concrete test accounts for each persona by reading the project's seed data (e.g. `db/seeds.rb`), fixtures, or factories. Use exact credentials.
- Determine the local login mechanism by reading the project (password, magic link via a dev mail catcher, a dev-only shortcut) and describe it literally.
- Read `CLAUDE.md` for project-specific concerns to fold in: default locale and bilingual requirements, mobile-first/viewport rules, theme, accessibility.

### 4. Determine setup specifics

- The command to start the app and the URL to confirm it boots.
- Whether the diff adds migrations, env vars, credentials, or dependencies the user must apply first — list them concretely, never "some changes."
- Whether seed data needs loading or a reset.

### 5. Generate the walkthrough document

Use the template below. Principles:

- One numbered **Part** per distinct flow or persona. Cover every affected persona.
- Steps are literal and clickable — the reader should never have to guess.
- Every step or part has an explicit ✅ **expected result**, precise enough that a deviation is obvious.
- Clearly label what is **new in this PR** versus **pre-existing context** shown to complete the picture.
- Fold in locale and responsive checks when the project's guardrails call for them.
- Call out anything in the change that is **not browser-testable** (e.g. a model validation behind a constrained UI) so the reader knows it is covered only by automated tests.
- Keep it brief — this is a pre-flight check, not exhaustive QA. Favor the highest-signal paths.
- If you notice something that looks broken while writing the walkthrough, flag it to the user directly — do not bury it as a test step.

### 6. Save and surface

- Save to `tmp/pr-<N>-walkthrough.md` (or `tmp/<branch-slug>-walkthrough.md` if there is no PR).
- `tmp/` is gitignored in most projects — confirm it is. If not, choose another gitignored scratch path, or tell the user the file must not be committed.
- This document is the orchestrator's editable scratch copy: not committed, not part of the PR. The PR comment posted later by `--publish` is the published snapshot.
- Send the file to the user and tell them the path.

### 7. Recommend the next step

> Exercise the walkthrough in the browser. If anything is off, fix it on the branch and re-run `/walkthrough` to refresh. When it looks right, proceed to `/review-pr` — then publish the final version with `/walkthrough --publish` before merge.

## Publishing the final walkthrough (`--publish`)

Run once, after `/review-pr` and any review fixes — normally just before merge, but also valid on an **already-merged** PR to backfill a walkthrough that was missed. This posts the final walkthrough as a comment on the PR, where the QA tester can follow it after deploy.

1. **Resolve the PR.** Use the PR number or branch given as an argument; otherwise find the PR for the current branch (`gh pr view`). The PR may be **open or merged** — both are valid publish targets. Only stop if no PR exists at all.
2. **Re-run the gate.** If the change is not user-facing (step 2 above), there is nothing to publish — say so and stop.
3. **Regenerate from the PR diff.** Do not reuse a possibly-stale scratch file — review may have changed the code, and on a merged PR the branch is likely deleted. Rebuild the walkthrough from `gh pr diff <N>` exactly as steps 1–5 describe, so the published copy matches the code that merged.
4. **Prepend a production-verification note** — a short block quote at the very top stating that QA testers verifying on production should use the production app and their own account in place of the local server and seed logins; the steps and expected results are identical. This is the normal case for a post-merge publish, since the feature is already deployed.
5. **Decide who to notify.** A PR comment only notifies people already participating in the PR. If a QA reporter/tester should follow the walkthrough and is not already a participant (e.g. they were never @-mentioned in the PR body), @-mention their handle in the comment so they get a directed notification. Get the handle from the linked QA report's author, the PR body, or by asking the user; if in doubt, ask.
6. **Confirm before posting.** Show the final document — including any @-mention — to the user and get explicit approval. Posting a PR comment is outward-facing and notifies others — never post without a clear yes.
7. **Post the comment:** `gh pr comment <N> --body-file <file>`.
8. Confirm to the user that it is posted, and who will be notified (PR participants, plus anyone @-mentioned).

## Document template

```markdown
# PR #<N> — Manual Walkthrough: <short feature name>

A quick browser exercise of <feature> before formal review. ~<estimate> minutes.

## Setup

1. Start the app: `<command>` → <URL>
2. <Seed / reset / migration / dependency steps, or "No setup beyond the above.">
3. <Locale / viewport notes if relevant.>

**Logins** (<auth mechanism>):

| Role | Credentials | Notes |
|------|-------------|-------|
| <role> | <exact account> | <why this account> |

<One literal sentence on how to log in.>

## Part 1 — <flow name>  *(new in this PR)*

1. <Literal step.>
   ✅ <Expected result.>
2. ...

## Part N — <flow name>  *(pre-existing — for context)*

...

## Not browser-testable

<Anything covered only by automated tests, and why — or omit this section.>

## Cleanup

<How to restore state. Note the file is gitignored scratch — delete when done.>
```

## Tone

- Practical and friendly. The reader is the orchestrator, not a client.
- Over-explain clicks rather than under-explain — zero ambiguity in the steps.
- Brevity over completeness: the highest-signal paths, not every permutation.
