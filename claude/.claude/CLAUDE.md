# Global CLAUDE.md

This file provides guidance to Claude Code across all of Joshua's repositories.

> **Under active ablation** — see joshukraine/dotfiles#252. Cut from 1,675 to 1,015 words on 2026-08-01 (this banner is temporary scaffolding and retires with the initiative), on the premise that current models no longer need most behavioral correction. If you stumble on something this file used to say, append a row to [`docs/stumble-log.md`](docs/stumble-log.md) and keep going — that log is the only evidence for re-adding anything, and re-adds happen in one deliberate pass, not ad hoc. Quarantined text, with the reason for each cut: [`docs/attic-2026-08.md`](docs/attic-2026-08.md).

## Working Relationship

Joshua is a technically savvy executive who oversees multiple web projects. He understands software development deeply but delegates implementation. Treat this as a senior-developer-to-technical-executive relationship:

- **Joshua decides** what to build and reviews architecture; **Claude Code implements**
- **Understanding transfer, not tutoring** — Joshua must be able to explain and maintain anything you build, so give him the _why_: trade-offs, rejected alternatives, and what a future maintainer would need to know. Pitch it at a senior engineer joining the project, not a student. Skip concept tutorials for tech he already ships in production, skip narrating what the code plainly says, and don't stop to offer a choice when one option is clearly right. Don't over-correct into terseness either — when the reasoning is load-bearing, spell it out. The discriminator: **explain the decision, not the syntax.**
- At a natural stopping point, **suggest the logical next step and pre-fill the command** (commit, PR, tests). Anticipate workflow momentum rather than waiting to be told.

## Language

Joshua is fluent in Ukrainian (25+ years living in Ukraine; reads, writes, and speaks it daily). When he asks for Ukrainian text — a message, a translation, a reply to send — **give him the Ukrainian and stop.** No English back-translation or explanation of what it means; he understands it. The only note worth adding is when a specific word or phrasing was a real judgment call (register, tone, regional usage, an ambiguous term) — a one-line rationale there is welcome. Skip the comprehension recap.

## Development Philosophy

- **Issues before code** — the output of planning is one or more GitHub issues, approved before implementation begins
- **No speculative features** — no features, flags, or configuration until actively needed
- **No premature abstraction** — no utility or helper until you've written the same code three times
- **Replace, don't deprecate** — when a new implementation replaces an old one, remove the old one entirely. No backward-compatible shims, no dual config formats.
- **Commit frequently**, each commit a working unit
- **Ask before** committing to interfaces, data models, or destructive operations
- Suggest `/debrief` or `/checkpoint` when one would be valuable (e.g. a PRD phase boundary)

## PRD-Driven Development

Conventions for projects with a Product Requirements Document. Full workflow and document index: [`docs/README.md`](docs/README.md).

- **Structure**: modular files in `docs/prd/`, one per feature area, numbered for reading order. `README.md` navigates, `ROADMAP.md` tracks phases, `CHANGELOG.md` logs deviations.
- **ROADMAP as task list**: each checkbox is one PR's worth of work; work top-to-bottom within a phase. Mark `[x]` in the same PR that does the work — not after merging. Key: `[ ]` not started · `[~]` in progress · `[x]` complete · `[—]` deferred/descoped.
- **RFC keywords**: **MUST/SHALL/REQUIRED** = non-negotiable for MVP · **SHOULD** = expected unless technically prevented · **MAY** = implement if straightforward, otherwise defer · **TBD** = unresolved, check open items.
- **Never silently deviate**: log any material deviation in `docs/prd/CHANGELOG.md` before merging the PR. Three valid responses to a PRD conflict — implement as written, ask Joshua, or propose a change with rationale.
- **Cross-references**: `→ See 07-feature.md §3 "Section Heading"` — always the filename plus the quoted heading, never a bare `§N`.

## Git Workflow

- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/). Never reference issue numbers in a commit message.
- **Branches**: descriptive, with the type prefix from [`docs/label-taxonomy.md`](docs/label-taxonomy.md) (`feat/`, `fix/`, `docs/`, `chore/`).
- **Issue linking**: "Closes #123" goes in the PR description only — issues close when PRs merge, not when commits land. Check the issue and anything linked to it so **every** issue the PR resolves gets a closing keyword, not just one.
- **Merges**: prefer squash (`gh pr merge --squash`) to keep history clean.
- Run git commands directly rather than via `git -C <path>` when the working directory is already the target repo — `-C` bypasses permission rules.

## Git Commit Protocol

**Never put backticks or `$(...)` inside a double-quoted `git commit -m` message — the shell executes them.** Verified 2026-08-01 (#252 Q1): a backticked phrase is silently deleted from the message, and `$(...)` runs and inlines its output. Neither aborts the commit, so the mangled message just lands.

Default flow for any real message: draft it, **Write** it to `.git_commit_msg` (the Write tool — no shell parsing involved), run `git commit -F .git_commit_msg`, then `rm .git_commit_msg`.

Single-quoting also preserves both literally, which is fine for a one-liner containing no apostrophe:

```bash
git commit -m 'fix(parser): guard the `nil` case'
```

When staged changes span multiple logical concerns, split them into separate commits, each a self-contained working unit.

## Code Quality

- **Linting**: zero warnings. Run the project's linter before committing and fix every issue. If a warning is truly unfixable, add an inline ignore with a justification comment.
- **Review order**: architecture → code quality → tests → performance.

## Responsive QA

**Verify mobile widths by emulating the CSS viewport, never by resizing the OS window.** A window-resize tool reports success without moving the viewport, and the horizontal-overflow check then passes trivially — a green result that means nothing. Before checking any layout at a mobile breakpoint, read [`docs/responsive-qa.md`](docs/responsive-qa.md) for the emulation tool, the two assertions that prove the width took, and the fallbacks.

## Markdown

**No hard wraps.** Never break prose lines at a fixed column width — each paragraph or list item description is a single long line, and the editor soft-wraps. (MD013 is disabled in `markdown/.markdownlint-cli2.yaml`, so nothing mechanical catches this.)

---

Type `/` to see available skills for common workflows.
