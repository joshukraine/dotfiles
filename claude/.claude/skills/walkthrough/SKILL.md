---
name: walkthrough
description: Generate a hands-on browser walkthrough of a PR's user-facing changes to exercise before review; --publish posts the final version to the PR for QA.
disable-model-invocation: true
argument-hint: "[PR-number-or-branch] [--publish]"
---

# Walkthrough

Generate a concise, click-by-click manual walkthrough of the current branch's user-facing changes, so the human orchestrator can exercise the feature in a browser **before** the formal `/code-review`. Seeing a feature work is faster than reading code or a PR description for catching UX problems.

This skill does not modify code or perform code review. With `--publish` it renders a rich HTML version, publishes it to the project's configured QA host (when one is declared in the project's `CLAUDE.md`), and posts a PR comment linking to it with the Markdown body as a collapsible fallback. Without `--publish` it only writes local scratch files.

**Where it sits in the workflow — two slots:**

- **Generate** (default) — run after `/create-pr` and before `/code-review`, and re-run as needed. The orchestrator's iterative pre-flight check.
- **Publish** (`--publish`) — run once after `/code-review` and any review fixes, just before merge (or after merge, to backfill a walkthrough that was missed). Posts the final walkthrough to the PR so the QA tester can follow it after deploy.

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

> No user-facing changes detected in this PR — a browser walkthrough doesn't apply. Proceed to `/code-review`.

If the change is user-facing — or a mix where the UI surface is worth exercising — continue.

### 3. Map flows, personas, and credentials

- From the changed views/controllers/routes, determine which screens and user journeys changed.
- Identify every user role/persona that touches the changed flows.
- Find concrete test accounts for each persona by reading the project's seed data (e.g. `db/seeds.rb`), fixtures, or factories. Use exact credentials. Reserved-example logins (`@example.com` and friends) stay click-to-copy when published; real-looking ones become placeholders — see Credentials in published artifacts under Publishing.
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

- Save to the project's `tmp/` directory — `tmp/pr-<N>-walkthrough.md` (or `tmp/<branch-slug>-walkthrough.md` if there is no PR). Use the project-local `tmp/`, not the system `/tmp`.
- This document is the orchestrator's editable scratch copy: not committed, not part of the PR. The PR comment posted later by `--publish` is the published snapshot.
- Send the file to the user and tell them the path.

### 7. Recommend the next step

> Exercise the walkthrough in the browser. If anything is off, fix it on the branch and re-run `/walkthrough` to refresh. When it looks right, proceed to `/code-review` — then publish the final version with `/walkthrough --publish` before merge.

## Publishing the final walkthrough (`--publish`)

Run once, after `/code-review` and any review fixes — normally just before merge, but also valid on an **already-merged** PR to backfill a walkthrough that was missed. This renders the walkthrough as rich HTML, publishes it to the project's configured QA host (if any), and posts a PR comment with the live link and a collapsible Markdown fallback.

**Credentials in published artifacts.** A login may be a click-to-copy control only when it is a *reserved, non-routable example identity*: the email domain is an RFC 2606 reserved-for-documentation domain (`example.com`, `example.net`, `example.org`) or the `.example` TLD, and any accompanying password is an obviously-fake seed value (e.g. `password`), not a real secret. Such logins are documentation, not credentials — guaranteed unregisterable and non-deliverable — so publishing them as copy controls is safe and removes the single most repetitive step in any walkthrough (login). Anything else — a real or real-looking domain, an actual person's address, a live tenant, or a real password/token/API key — must be a plain-text placeholder (`<code>&lt;your-admin-email&gt;</code>`), never a copy control; pair it with a one-line note (local testers use the seeded login from `db/seeds.rb`; production testers use their own account). Never publish a real password, token, or secret in any form. The publish step stays human-gated regardless.

1. **Resolve the PR.** Use the PR number or branch given as an argument; otherwise find the PR for the current branch (`gh pr view`). The PR may be **open or merged** — both are valid publish targets. Only stop if no PR exists at all.
2. **Re-run the gate.** If the change is not user-facing (the **Gate** step above), there is nothing to publish — say so and stop.
3. **Regenerate from the PR diff.** Do not reuse a possibly-stale scratch file — review may have changed the code, and on a merged PR the branch is likely deleted. Rebuild the walkthrough content from `gh pr diff <N>` exactly as steps 1–5 describe, so the published copy matches the code that merged.
4. **Save the Markdown twin** to `tmp/pr-<N>-walkthrough-published.md` (the project-local `tmp/`, not the system `/tmp`). This Markdown is what fills the PR-comment fallback and is also used as the no-target fallback if the project has not declared a QA Publish Target. Prepend a short block-quote note at the very top: testers verifying on production should use the production app and their own account in place of the local server and seed logins; the steps and expected results are identical. This is the normal case for a post-merge publish.
5. **Render the HTML twin** using this skill's `template.html` and the shared house style:
    - Read `template.html` (this skill's directory) for the structure and `../_shared/house-style.html` for the look.
    - Inline the shared house style — copy its `<style>` block in place of the `<!-- HOUSE STYLE ... -->` marker in `<head>`, and its `<script>` block in place of the second marker before `</body>`. The output must be a single self-contained `.html` (no external assets).
    - Strip every instructional comment from the output (the head how-to block and the body notes). The artifact must be clean.
    - Fill the metadata tokens: `{{PROJECT}}`, `{{PR}}`, `{{PR_LINK}}` (Markdown link to the PR), `{{FEATURE}}` (short feature name), `{{BRANCH}}`, `{{COMMIT}}` (short SHA), `{{DATE}}`, `{{ESTIMATE}}`.
    - Keep the production-verification callout in the HTML version too (it is part of the template). Convert the Markdown setup, logins, parts, not-browser-testable, and cleanup content into the HTML structure described inline in the template. Every command/URL the tester will paste is a `<button type="button" class="copy" data-copy="VALUE">VALUE</button>` control, and so are reserved-example logins (see Credentials in published artifacts above) — login is the most repetitive step, so keep it click-to-copy. Only non-example/real credentials are the exception: render those as plain `<code>&lt;your-admin-email&gt;</code>`, not copy buttons.
    - Save to `tmp/pr-<N>-walkthrough-published.html`.
6. **Build the PR-comment body** at `tmp/pr-<N>-walkthrough-comment.md`: a `<details>` block wrapping the Markdown twin so the link sits above and the Markdown is a collapsible fallback below.

    ```markdown
    <details><summary>Markdown fallback</summary>

    <contents of tmp/pr-<N>-walkthrough-published.md>

    </details>
    ```

    Do not include the link yourself — the publish pipeline prepends it.
7. **Decide who to notify.** A PR comment only notifies people already participating in the PR. If a QA reporter/tester should follow the walkthrough and is not already a participant (e.g. they were never @-mentioned in the PR body), @-mention their handle either inside the comment body file or as a one-line appendix at the end of it. Get the handle from the linked QA report's author, the PR body, or by asking the user; if in doubt, ask.
8. **Confirm before posting.** Show the final HTML (open it locally with `open`) and the comment-body Markdown to the user and get explicit approval. Posting a PR comment is outward-facing and notifies others — never post without a clear yes.
9. **Publish.** Call the shared publish pipeline. It resolves the project's QA Publish Target, uploads the HTML when one is declared, and posts the PR comment.

    ```bash
    ~/.claude/skills/_shared/publish-artifact.sh \
      --html tmp/pr-<N>-walkthrough-published.html \
      --label "PR #<N> walkthrough" \
      --pr <N> \
      --comment-body tmp/pr-<N>-walkthrough-comment.md \
      --md-fallback-only tmp/pr-<N>-walkthrough-published.md
    ```

    Behaviour:
    - **Target declared** → uploads the HTML, posts a PR comment with the live link above the collapsible Markdown body.
    - **Target undeclared** → prints a warning, posts the Markdown body alone as the PR comment (the pre-HTML-pivot behaviour).

10. Confirm to the user that it is posted, share the Pages URL (if any) printed by the pipeline, and note who will be notified (PR participants, plus anyone @-mentioned).

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
