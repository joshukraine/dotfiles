---
name: qa-handoff
description: Generate a hands-on QA testing guide as a self-contained HTML page — for Rails apps or static (Hugo) sites. --publish uploads the HTML to the project's configured QA host.
disable-model-invocation: true
argument-hint: "[--publish] [--pr <N>]"
---

# QA Handoff

You are a senior developer preparing a hands-on testing guide for a QA colleague. Your colleague understands the product but is NOT tracking implementation details, architecture decisions, or code-level rationale. Write for someone who needs a clear, step-by-step guide to exercise the new work and find gaps in behavior and UX.

## Step 0: Detect the project type

Pick the mode from what's in the repo:

- **Rails app** — a `Gemfile` plus `config/application.rb` or `bin/rails`. Follow the **Rails path** (template `template.html`).
- **Static site (Hugo)** — a Hugo config (`hugo.toml` / `hugo.yaml` / `hugo.json`, or `config.toml` / `config/_default/`) with a `content/` directory (or another static-site generator). Follow the **Static-site path** (template `template-static.html`).
- **Neither** — tell the user this skill targets Rails apps and static sites, and stop.

Both paths produce the same kind of artifact — a single self-contained HTML page built from the shared house style and shipped through the shared publish pipeline. They differ only in which template and section content they use.

**Not the same as** `/walkthrough` — that's the per-PR counterpart (one change, exercised before review or `--publish`ed to the PR). This is the broad, committed QA guide for a whole phase.

## Context

**Both paths:** Read the project's `CLAUDE.md` (project name, any audience/viewport guidance, the `## QA Publish Target` block) and `docs/prd/ROADMAP.md` if present (current phase). Check `docs/debriefs/full/` for the most recent debrief; if one covers the current work, reuse its Product Tour as the basis for the walkthrough (strip rationale, keep the actions and expected behaviors). Otherwise build the walkthrough from recent git history.

**Rails path also:** Read `db/seeds.rb` to identify test accounts and credentials (reference them exactly). Review the `Gemfile` and recent migrations for setup the tester needs.

**Static-site path also:** Identify the **deploy-preview URL** the tester should open — a Netlify deploy preview is the typical source; if it isn't obvious from `CLAUDE.md` or the repo, ask the user. Note the local preview command (`hugo server`) and whether the preview is access-gated. Check the Hugo config for **multiple languages** (`languages` / `defaultContentLanguage`, an `i18n/` dir, or `content/<lang>/`) — if multilingual, include the Languages & Translations section. Identify **forms and external integrations** and their backends (Netlify Forms, an external API, a separate app), and note any restricted to certain domains (e.g. a CORS allowlist) so the guide can tell testers which environment to use. For URL continuity, remember Hugo migrations often preserve old paths by slug-matching rather than redirect maps — check both that preserved URLs still resolve and that removed URLs are intentionally gone.

## Output Format

Render the handoff as a single self-contained **HTML** page using the shared house style — not a Markdown document. Use the template for your mode:

- **Rails:** `template.html`
- **Static site:** `template-static.html`

### Rendering

1. **Read your mode's template** (this skill's directory) for the structure and `../_shared/house-style.html` for the look. The template's head comment documents every token.
2. **Inline the shared house style** — copy its `<style>` block in place of the `<!-- HOUSE STYLE ... -->` marker in `<head>`, and its `<script>` block in place of the second marker before `</body>`. The output must be a single self-contained `.html` (no external assets). Do not link a stylesheet.
3. **Strip every instructional comment** from the output (the head how-to block and the body notes). The artifact must be clean. (HTML comments do not nest, so a leftover one can break rendering, not just clutter it.) _Static template only:_ delete any optional section that doesn't apply — the **Languages & Translations** section for a single-language site, and the **Key Flows & Forms** section for a purely informational site — along with its TOC entry.
4. **Resolve the QA report URL (`{{REPORT_URL}}`).** Find the project's GitHub repo via `gh repo view --json nameWithOwner --jq .nameWithOwner`. Look in `.github/ISSUE_TEMPLATE/` for a QA template (filename matching `qa`, case-insensitive — prefer YAML issue forms over plain Markdown). Build the URL:
    - **QA template found:** `https://github.com/<owner>/<repo>/issues/new?template=<filename>`. Leave the title blank so the template's own placeholder guides the tester.
    - **No QA template:** `https://github.com/<owner>/<repo>/issues/new`.
    - **No GitHub remote:** omit the CTA. Replace the Feedback section's button paragraph with a one-line note pointing at the project's actual tracker.
5. **Fill the metadata tokens:** `{{PROJECT}}`, `{{TITLE}}` (e.g. `Phase N: Phase Title`), `{{DATE}}`, `{{BRANCH}}`, `{{COMMIT}}` (short SHA from `HEAD`), `{{REPORT_URL}}` (step 4); then the mode-specific one — Rails: `{{DEBRIEF_REF}}` (path to the related debrief, or `N/A`); static: `{{PREVIEW_URL}}` (the deploy-preview URL).
6. **Make every real command and URL the tester will paste a click-to-copy control:** `<button type="button" class="copy" data-copy="VALUE">VALUE</button>`.

**Credentials.** The handoff HTML is a single file that is both committed and (with `--publish`) uploaded to a public QA host. A login may be a click-to-copy control only when it is a _reserved, non-routable example identity_: an RFC 2606 reserved domain (`example.com`/`.net`/`.org`) or the `.example` TLD, with any password an obviously-fake seed value (e.g. `password`). Such fakes are documentation, not credentials. Any real or real-looking login (real domain, actual person, live tenant, real password/token) must be a plain placeholder (`<code>&lt;your-admin-email&gt;</code>`), never a copy control; add a one-line note (Rails local: seeded logins from `db/seeds.rb`; production: your own account). **Static sites** usually have no logins at all — but if the deploy preview is password-gated, treat that access the same way: a placeholder plus a one-line note, never a real secret. Never publish a real secret in any form.

### Section content — Rails path

Fill each token with the content below.

**What's New (`{{WHATS_NEW}}`)** — a plain-language summary of what was built. 2–4 short paragraphs; connect to the roadmap. No file paths, class names, or architecture jargon.

**Getting Current (`{{SETUP}}`)** — exact setup steps, each command a copy control: pull/install (`git pull`, `bundle install`, `bin/rails db:migrate`, `bin/rails db:seed`), whether a full `bin/rails db:reset` is needed, new gems/system packages, new env vars or credentials, and the command to start the app plus the URL to confirm it boots. List specifics — never "some dependencies changed." Say "None" where a category is unchanged.

**Guided Walkthrough (`{{WALKTHROUGH}}`)** — one `<div class="story">` per scenario, in order. Each: a descriptive `.story-head` with a `.role-pill` for the user type; a click-to-copy login when it is a reserved-example identity, otherwise a placeholder (see Credentials), plus a copyable starting URL; extremely literal numbered steps; and a `.expect` expected result precise enough that a deviation is obvious. Include at least one scenario per affected role. Read `CLAUDE.md` for audience/viewport guidance and add matching scenarios.

**Exploratory Testing (`{{EXPLORATORY}}`)** — an interactive `<ul class="checklist">`; each item `<li><label><input type="checkbox" data-check="..."> ...</label></li>`. Draw from debrief-flagged thin coverage, permission boundaries (accessing another user's data, role escalation), responsive/mobile checks, and edge cases a developer might skip. Make each item self-describing.

**Test Suite (`{{TESTS}}`)** — commands to run the full suite and the targeted files most relevant to the new work, each a copy control. Note any known skips or expected failures.

**Feedback** — built into the template: a CTA button linking to the QA issue form via `{{REPORT_URL}}`. Do not reconstruct the form.

### Section content — Static-site path

Fill each token with the content below. The checklist sections use an interactive `<ul class="checklist">` (each item `<li><label><input type="checkbox" data-check="..."> ...</label></li>`).

**What's New (`{{WHATS_NEW}}`)** — a plain-language summary of what changed on the site (new or updated pages, redesigns, migrated content). 2–4 short paragraphs connecting to the goal. No jargon.

**Where to Test (`{{WHERE}}`)** — the **deploy-preview URL** as a copy control (a Netlify deploy preview is typical). Add the local option for testers who clone: `git pull`, then `hugo server`, and the localhost URL — each a copy control. If the preview is access-gated, add a one-line preview-access note (placeholder only — see Credentials). **Call out environment limits:** some checks cannot be done on a per-PR deploy preview — an external API with a CORS allowlist, or form-email notifications that only fire in production. For each, say which environment it must be done in (per-PR preview vs. branch deploy vs. production) so testers don't file false "broken form" reports.

**Guided Walkthrough (`{{WALKTHROUGH}}`)** — one `<div class="story">` per key page or flow, in reading order. The `.role-pill` is the visitor type (Visitor / Donor / Mobile visitor). Give a copyable starting URL (preview URL + path), literal numbered steps, and a `.expect` result. Cover the new/changed pages; add a mobile scenario per any `CLAUDE.md` viewport guidance.

**Content & Links (`{{CONTENT}}`)** — checklist: copy accuracy (no lorem/placeholder; names, dates, figures, and contact info correct); every nav/footer/CTA link resolves; navigation works (menu, breadcrumbs, footer). **URL continuity from the old site:** Hugo migrations often preserve URLs by slug-matching rather than redirect maps, so check both directions — (a) every preserved old URL still resolves at the same path, and (b) every _removed_ old URL is intentionally gone (redirect it if it was indexed/linked, or accept the 404).

**Languages & Translations (`{{I18N}}`) — optional** — include only for multilingual sites; delete the section and its TOC entry for a single-language site. Checklist: the language switcher works and appears only where a translation actually exists (not on single-language pages); each language's URLs resolve (e.g. `/` and `/en/...`) and routes with no translation 404 intentionally rather than rendering a broken page; **hreflang tags are present** linking the language variants; translated pages show the target language throughout (no silent fallback to the default language); language-specific metadata (`og:locale`) is correct.

**Key Flows & Forms (`{{FLOWS}}`) — optional** — include for sites with conversion/action paths; delete the section and its TOC entry for a purely informational site. Exercise the site's primary actions end to end as a checklist:

- **Donations** (when present — first-class for donor-giving sites): each give route works (mail-a-check address correct; PayPal link lands on the right account; any new platform flow completes).
- **Forms by backend:** list each form with its backend, _where it can actually be tested_ (see Where to Test), and its success UX (often an inline message rather than a redirect). Verify each confirmation.
- **External-app handoffs:** links/CTAs that hand off to a separate app or domain land correctly.
- **Disabled/empty states:** if a form or flow can be toggled off (out-of-stock, closed), the off state replaces it cleanly.

**Responsive & Visual (`{{RESPONSIVE}}`)** — checklist: mobile/tablet/desktop layouts; images load and aren't distorted; logos, brand colors, favicon, and any PWA manifest render; no horizontal overflow; text readable; nav collapses correctly on small screens; **no flash-of-unstyled-content (FOUC)** on load, especially for sticky or scroll-reactive headers.

**Meta & Sharing (`{{META}}`)** — checklist: page titles and meta descriptions present and accurate; social share cards (`og:image`, `og:title`, `twitter:*`) render when a page is shared; canonical URLs correct.

**Accessibility (`{{A11Y}}`)** — checklist: images have meaningful alt text **in the site's language(s)**; color contrast is sufficient; keyboard navigation reaches all interactive elements with a visible focus state; heading order is logical. Spot checks, not an exhaustive audit.

**Build & Health (`{{BUILD}}`)** — commands as copy controls: a clean production build (`hugo --gc --minify`) with no errors or warnings. **A green build is not enough** — also verify: interactive JS still works _after_ minification (tree-shaking can silently drop handlers a dev build kept, shipping a clean build with broken forms); the pinned Hugo version matches across deploy config and CI (`netlify.toml`, `.github/workflows/`); on the preview, no browser console errors and no mixed-content (all https). Actual broken-link crawling stays out of scope — Content & Links covers links by hand.

**Feedback** — built into the template: a CTA button linking to the QA issue form via `{{REPORT_URL}}`. Do not reconstruct the form.

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

Then tell the user where the file is and how the tester should use it: Rails — follow **Getting Current**, work the walkthrough, tick the exploratory checklist; static — open the **deploy-preview URL** from **Where to Test**, work the walkthrough, tick the checklists. In both cases, click **File a QA report** for any findings so it lands in the tracker.

## Publishing for remote testers (`--publish`)

A remote tester who is not cloning the repo needs a hosted copy. With `--publish`, the skill uploads the saved HTML to the project's configured QA host so the tester can open it from a URL. (This is unchanged across modes — the publish pipeline is framework-agnostic.)

1. **Generate and save the HTML locally first** (the steps above). `--publish` operates on the saved file; it does not regenerate it.
2. **Build a one-line blurb file** at `tmp/qa-handoff-comment.md` describing what is inside the HTML so a PR reader has context. One short paragraph — the HTML is the artifact, not a Markdown twin.
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
    - **Target undeclared** → prints a warning and stays local. No PR comment (`--md-fallback-only` is not used here because the HTML is the artifact — a Markdown twin would lose the click-to-copy controls and the interactive checklists that make the handoff useful).

5. Report back to the user with the Pages URL (and PR-comment confirmation when applicable).

## Tone & Approach

- Be friendly and practical, not formal. The reader is a colleague, not a client.
- Err on the side of over-explaining steps rather than under-explaining. The goal is zero ambiguity in the walkthrough.
- If you discover something during QA handoff generation that looks broken or concerning, flag it clearly as a note to the developer, not as something for the tester to fix.
