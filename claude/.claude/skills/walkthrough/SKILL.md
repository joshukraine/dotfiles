---
name: walkthrough
description: Generate a hands-on browser walkthrough of a PR's user-facing changes for the orchestrator to exercise before formal review.
disable-model-invocation: true
argument-hint: "[PR-number-or-branch]"
---

# Walkthrough

Generate a concise, click-by-click manual walkthrough of the current branch's user-facing changes, so the human orchestrator can exercise the feature in a browser **before** the formal `/review-pr`. Seeing a feature work is faster than reading code or a PR description for catching UX problems.

This skill produces a throwaway checklist. It does not change code, commit, or review.

**Where it sits in the workflow:** after `/create-pr`, before `/review-pr` — the orchestrator's pre-flight check.

**Not the same as:**

- `/debrief` — a heavy architecture and test-coverage write-up for milestones.
- `/qa-handoff` — a polished, committed guide handed to a separate QA tester.

This is lighter than both: a private, ephemeral aid for the person about to merge the PR.

## Your task

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
- This document is ephemeral: never commit it, never add it to the PR.
- Send the file to the user and tell them the path.

### 7. Recommend the next step

> Exercise the walkthrough in the browser. If anything is off, fix it on the branch. When it looks right, run `/review-pr`.

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
