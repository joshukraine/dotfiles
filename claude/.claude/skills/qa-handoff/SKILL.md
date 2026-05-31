---
name: qa-handoff
description: Generate a hands-on QA testing guide with walkthrough scenarios and exploratory testing checklist. --publish uploads the HTML to the project's configured QA host.
disable-model-invocation: true
argument-hint: "[--publish] [--pr <N>]"
---

# QA Handoff

**Applicability:** This command is designed for Rails applications that follow a PRD-driven development workflow with `docs/prd/ROADMAP.md` and a debriefs structure under `docs/debriefs/`. If the current project is not a Rails application or does not follow this structure, stop and tell the user this skill is not applicable to the current project.

---

You are a senior developer preparing a hands-on testing guide for a QA colleague. Your colleague is technically capable — they run the app locally, can execute the test suite, and are excellent at finding gaps in behavior and UX. They are NOT tracking implementation details, architecture decisions, or code-level rationale. Write for someone who understands the product but needs a clear, step-by-step guide to exercise the new work.

## Context

1. Read the project's `CLAUDE.md` and `docs/prd/ROADMAP.md` to orient yourself. Identify the project name, current phase, and any project-specific testing guidance (viewport requirements, audience-specific considerations, etc.).
2. Check `docs/debriefs/full/` for the most recent debrief. If one exists for the current work, use its Product Tour section as your primary source for walkthrough scenarios. Adapt the content for a QA audience: strip architecture rationale, keep the step-by-step actions and expected behaviors, and add exploratory testing prompts.
3. If no recent debrief exists, build the walkthrough from scratch by reviewing recent git history, seed data, routes, and controllers.
4. Read `db/seeds.rb` to identify available test accounts and their credentials. Reference these exactly in the walkthrough scenarios.
5. Review the Gemfile and recent migrations for any setup changes the tester needs to know about.

## Output Format

Render the handoff as a single self-contained **HTML** page using this skill's `template.html` and the shared house style — not a Markdown document. The tester opens it in a browser and gets click-to-copy logins, an interactive exploratory checklist, and a one-click link to the project's existing QA issue form for reporting findings.

### Rendering

1. **Read `template.html`** (this skill's directory) for the structure and `../_shared/house-style.html` for the look. The template's head comment documents every token.
2. **Inline the shared house style** — copy its `<style>` block in place of the `<!-- HOUSE STYLE ... -->` marker in `<head>`, and its `<script>` block in place of the second marker before `</body>`. The output must be a single self-contained `.html` (no external assets). Do not link a stylesheet.
3. **Strip every instructional comment** from the output (the head how-to block and the body notes). The artifact must be clean. (HTML comments do not nest, so a leftover one can break rendering, not just clutter it.)
4. **Resolve the QA report URL (`{{REPORT_URL}}`).** Find the project's GitHub repo via `gh repo view --json nameWithOwner --jq .nameWithOwner`. Look in `.github/ISSUE_TEMPLATE/` for a QA template (filename matching `qa`, case-insensitive — prefer YAML issue forms over plain Markdown). Build the URL:
    - **QA template found:** `https://github.com/<owner>/<repo>/issues/new?template=<filename>`. Leave the title blank so the template's own `QA: <short description>` placeholder guides the tester.
    - **No QA template:** `https://github.com/<owner>/<repo>/issues/new`.
    - **No GitHub remote:** omit the CTA. Replace the Feedback section's button paragraph with a one-line note pointing at the project's actual tracker.
5. **Fill the metadata tokens:** `{{PROJECT}}`, `{{TITLE}}` (e.g. `Phase N: Phase Title`), `{{DATE}}`, `{{BRANCH}}`, `{{COMMIT}}` (short SHA from `HEAD`), `{{DEBRIEF_REF}}` (path to the related debrief, or `N/A`), `{{REPORT_URL}}` (from step 4).
6. **Make every real command and URL the tester will paste a click-to-copy control:** `<button type="button" class="copy" data-copy="VALUE">VALUE</button>`.

**Credentials.** The handoff HTML is a single file that is both committed and (with `--publish`) uploaded to a public QA host. A login may be a click-to-copy control only when it is a *reserved, non-routable example identity*: an RFC 2606 reserved domain (`example.com`/`.net`/`.org`) or the `.example` TLD, with any password an obviously-fake seed value (e.g. `password`). Such fakes are documentation, not credentials — and login is the most repetitive step, so keep them click-to-copy. Any real or real-looking login (real domain, actual person, live tenant, real password/token) must be a plain placeholder (`<code>&lt;your-admin-email&gt;</code>`), never a copy control; add a one-line note (local: seeded logins from `db/seeds.rb`; production: your own account). Never publish a real secret in any form.

### Section content

Fill each section token with the content described below.

**What's New (`{{WHATS_NEW}}`)** — a plain-language summary of what was built, for someone who understands the product but isn't tracking implementation details. 2-4 short paragraphs; connect to the roadmap. No file paths, class names, or architecture jargon.

**Getting Current (`{{SETUP}}`)** — exact setup steps, each command a copy control: pull/install (`git pull`, `bundle install`, `bin/rails db:migrate`, `bin/rails db:seed`), whether a full `bin/rails db:reset` is needed, new gems/system packages, new env vars or credentials, and the command to start the app plus the URL to confirm it boots. List specifics — never "some dependencies changed." Say "None" where a category is unchanged.

**Guided Walkthrough (`{{WALKTHROUGH}}`)** — one `<div class="story">` per scenario, in order. Each: a descriptive `.story-head` with a `.role-pill` for the user type; a click-to-copy login when it is a reserved-example identity, otherwise a placeholder (see Credentials), plus a copyable starting URL; extremely literal numbered steps; and a `.expect` expected result precise enough that a deviation is obvious. Include at least one scenario per affected role. Read the project's `CLAUDE.md` for audience/viewport guidance (mobile-first user types, dual-audience designs) and add matching scenarios.

**Exploratory Testing (`{{EXPLORATORY}}`)** — an interactive `<ul class="checklist">`; each item `<li><label><input type="checkbox" data-check="..."> ...</label></li>`. Draw from debrief-flagged thin coverage, permission boundaries (accessing another user's data, role escalation), responsive/mobile checks for UI changes, and edge cases a developer might skip. The checkboxes are a self-tracking aid the tester ticks as they go — make each item self-describing.

**Test Suite (`{{TESTS}}`)** — commands to run the full suite and the targeted files most relevant to the new work, each a copy control. Note any known skips or expected failures.

**Feedback** — already built into the template: a CTA button linking to the QA issue form via `{{REPORT_URL}}`. Do not reconstruct the form. If you fell back to the "no GitHub remote" case in step 4, replace the button paragraph with the tracker note instead.

---

## Save Location

Save the completed handoff to:

```text
docs/qa-handoffs/YYYY-MM-DD-[brief-topic].html
```

Create `docs/qa-handoffs/` if it doesn't exist; use the same date-and-slug convention as debriefs. After saving, open it so the result is in front of you (single self-contained file — instant, no server):

```bash
open docs/qa-handoffs/YYYY-MM-DD-[brief-topic].html
```

Then tell the user where the file is and that the tester should: follow **Getting Current**, work through the walkthrough and tick the exploratory checklist, then click **File a QA report** for any findings — that opens the project's QA issue form (with drag-and-drop screenshots and auto-tagging) so the report lands in the tracker.

## Publishing for remote testers (`--publish`)

A remote tester who is not cloning the repo needs a hosted copy. With `--publish`, the skill uploads the saved HTML to the project's configured QA host so the tester can open it from a URL.

1. **Generate and save the HTML locally first** (the steps above). `--publish` operates on the saved file; it does not regenerate it.
2. **Build a one-line blurb file** at `tmp/qa-handoff-comment.md` describing what is inside the HTML so a PR reader has context. One short paragraph — the HTML is the artifact, not a Markdown twin. Example:

    ```markdown
    Click-to-copy logins, interactive exploratory checklist, and a one-click
    deep link to the project's QA report form are inside.
    ```

3. **Confirm before publishing.** This is outward-facing: it pushes a file to a shared repo and, when `--pr <N>` is given, posts a PR comment. Get explicit approval first.
4. **Call the shared publish pipeline:**

    ```bash
    ~/.claude/skills/_shared/publish-artifact.sh \
      --html docs/qa-handoffs/YYYY-MM-DD-[brief-topic].html \
      --label "QA handoff: <Title>" \
      [--pr <N>] \
      [--comment-body tmp/qa-handoff-comment.md]
    ```

    Behaviour:
    - **Target declared, no `--pr`** → uploads the HTML, prints the live Pages URL. Share that URL with the tester.
    - **Target declared, `--pr <N>` given** → also posts a PR comment with the live link above the blurb.
    - **Target undeclared** → prints a warning and stays local. No PR comment (`--md-fallback-only` is not used here because the HTML is the artifact — a Markdown twin would lose the click-to-copy logins and the interactive checklist that make the handoff useful).

5. Report back to the user with the Pages URL (and PR-comment confirmation when applicable).

## Tone & Approach

- Be friendly and practical, not formal. The reader is a colleague, not a client.
- Err on the side of over-explaining steps rather than under-explaining. The goal is zero ambiguity in the walkthrough.
- If you discover something during QA handoff generation that looks broken or concerning, flag it clearly as a note to the developer, not as something for the tester to fix.
