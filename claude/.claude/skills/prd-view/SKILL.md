---
name: prd-view
description: Render a PRD Markdown file as a rich, self-contained HTML reading view (Dashboard style) and open it in the browser. The Markdown stays authoritative; the HTML is a derived, ephemeral presentation.
argument-hint: "[docs/prd/NN-feature.md]"
---

# PRD View

Render one canonical PRD Markdown file as a rich **HTML reading view** — a sticky-sidebar "Dashboard" the human scans, jumps around, and collapses to fight overwhelm. The point is engagement: long monochrome specs go under-read, and an unread spec is not authoritative in practice.

This view is **derived and ephemeral**. The Markdown file is the single source of truth. The HTML is a presentation generated on demand, written to a gitignored `tmp/` and never committed — so it cannot drift and there is never a second source of truth. It is also a **vetting instrument**: when the rendered view surfaces something wrong or surprising, the fix goes into the _Markdown_, and you regenerate — never patch the HTML.

The cardinal rule follows from that: **present, do not embellish.** Every claim in the output must be traceable to the source file. Add no requirements, decisions, or structure the spec does not state. Diagrams encode only facts the spec gives. If the source is ambiguous or self-contradictory, _surface that_ (a `callout.flag`) rather than silently resolving it — surfacing it is the vetting loop working.

## Input

- `$ARGUMENTS`: the path to one PRD Markdown file (e.g. `docs/prd/11-individual-book-requests.md`).
- If no path is given, list the `docs/prd/*.md` files and ask which one to render. Render exactly one file per run (a whole-`docs/prd/` bundle is out of scope).

## Your task

### 1. Read and orient

Read the target file in full. Identify the **project name** from the repo's `CLAUDE.md`, `docs/prd/README.md`, or repo name — it becomes the sidebar breadcrumb (e.g. "ComixDistro PRD"). Note the file's number and title for `{{DOC_TITLE}}` (e.g. "11 · Individual Book Requests").

### 2. Understand the structure

Map the file before rendering. Identify:

- Its `##` sections (each becomes one collapsible card).
- Tables — especially a **data-model** table (fields, types, required/optional).
- Code/JSON blocks (keep as `<pre>`).
- **Structural prose or ASCII** that wants to be a diagram: status/state lifecycles, architecture (services, hosting, data flow), sequences. These become inline SVG — **never** reproduce ASCII art.
- **RFC keywords** (MUST / SHALL / SHOULD / MAY) — these are load-bearing; chip them.
- **Cross-references** (`→ See file.md §N`) — keep them as explicit pointers back to the canonical Markdown.

### 3. Choose the metric strip (4–6 cards)

The at-a-glance strip is what gives confidence of completeness. Pick the **4–6 most salient counts for this specific file** — there is no fixed vocabulary. Good candidates, depending on the file:

- lifecycle states · data models · fields · RFC `SHOULD`/`MUST` requirements · API endpoints · user roles/personas · channels/pools · phases · external integrations.

Count honestly from the source. If a terse file has no meaningful counts, fall back to structural ones (sections, cross-refs) or omit the strip entirely rather than padding it with filler. Each card is `<div class="metric"><div class="v">N</div><div class="k">label</div></div>`.

### 4. Render into the template

The structure lives in `template.html` (this skill's directory); the look + click-to-copy live in `../_shared/house-style.html`. Produce the view by:

1. **Read `template.html`** and use it as the exact structure. Its head comment documents every token and component snippet.
2. **Inline the shared house style** — copy the `<style>` block from `../_shared/house-style.html` in place of the `<!-- HOUSE STYLE: … -->` marker, and its `<script>` block in place of the `<!-- HOUSE SCRIPT: … -->` marker. Copy the **actual `<style>…</style>` and `<script>…</script>` elements** (they begin at column 0): the file opens with a documentation comment that _mentions_ `<style>`/`<script>` by name — do not capture that comment text or its closing `-->`, or you will nest the real CSS inside a broken element and lose all styling. Output must be one self-contained file — no external assets, no build step, works from `file://`.
3. **Fill the tokens.** Build `{{TOC}}` (one `<li>` per section), `{{METRICS}}`, and `{{SECTIONS}}` (one `details.section` card per source `##` section, each with a `<span class="badge">§N</span>`). Open the high-signal early sections (context, architecture, model) by default; collapse deep-reference tails (exhaustive field lists, future considerations) so the page stays scannable.
4. **Apply the conversions** as you fill each section:
   - Data-model tables → keep the table, but mark types with `.pill` and required/optional with `.req` / `.opt`. Group or summarize a very long field list if it reads as a wall, but never drop fields silently — note any grouping.
   - Lifecycle / architecture / sequence → inline `<svg>` inside `<figure class="diagram">`. The diagram must match the spec exactly (same states, same transitions, same components).
   - RFC keywords → `<span class="kw">SHOULD</span>`.
   - Pasteable values (endpoints, commands, seed values) → `<button class="copy" data-copy="VALUE">VALUE</button>`.
   - Cross-refs → keep the `→ See file.md §N` pointer (a `<code>§N</code>` tag is fine) so the reader can reach the canonical detail.
5. **Strip every instructional comment** — the template's head how-to block and all snippet comments guide filling only and must not appear in the output. _Keep_ the template's interactive shell verbatim, though: its supplemental `<style>`/`<script>` and the back-to-top, expand/collapse-all, and click-to-copy source-path controls are real content, not instructional.

### 5. Save and open

Write to a stable, gitignored path inside the **project that owns the PRD** (reuse the same filename per source file, so re-runs just need a browser refresh):

```text
tmp/prd-view/<source-file-basename>.html
```

Then open it so the reader doesn't have to — it is a single self-contained file, so this is instant and needs no server:

```bash
open tmp/prd-view/<source-file-basename>.html
```

`open` uses the default browser; pin one if the Clipboard API needs it: `open -a "Google Chrome" <file>`.

### 6. Report and invite the vetting loop

Tell the reader the path and that it was opened, then explicitly invite the loop:

```text
View:   tmp/prd-view/11-individual-book-requests.html  (opened in your browser)
Source: docs/prd/11-individual-book-requests.md  (authoritative)
```

Close by inviting correction: if anything in the view looks wrong, thin, or surprising, we fix the **Markdown** and regenerate. That round-trip is the feature.

## Important

- **Local-only.** This view is for the author, like `/debrief`. No publishing, no hosting, no PR comments.
- **Ephemeral.** Output lives in gitignored `tmp/` and is regenerated on demand — never commit it, never treat it as a source.
- **One file in, one view out.** No whole-`docs/prd/` bundle, no cross-file navigation — that is deferred.
- **Faithful, not creative.** When in doubt about a diagram or a count, prefer the simplest correct rendering or omit it. Surfacing a gap beats inventing a detail.
