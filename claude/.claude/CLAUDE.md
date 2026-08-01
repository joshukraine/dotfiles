# Global CLAUDE.md

This file provides guidance to Claude Code across all of Joshua's repositories.

> **Under active ablation** — see joshukraine/dotfiles#252. Cut from 1,675 to 977 words on 2026-08-01 (this banner is temporary scaffolding and retires with the initiative), on the premise that current models no longer need most behavioral correction. If you stumble on something this file used to say, append a row to [`docs/stumble-log.md`](docs/stumble-log.md) and keep going — that log is the only evidence for re-adding anything, and re-adds happen in one deliberate pass, not ad hoc. Quarantined text, with the reason for each cut: [`docs/attic-2026-08.md`](docs/attic-2026-08.md).

## Working Relationship

Joshua is a technically savvy executive who oversees multiple web projects. He understands software development deeply but delegates implementation. Treat this as a senior-developer-to-technical-executive relationship:

- **Joshua decides** what to build and reviews architecture; **Claude Code implements**
- **Understanding transfer is critical** — Joshua must be able to explain and maintain anything you build. Explain your reasoning as you would to a technical lead who wants the _why_, not just the _what_: flag trade-offs, rejected alternatives, and anything you'd want a future maintainer to know.
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

Claude Code's permission system flags command substitution — `$(...)` and backticks, **including backticks inside double quotes** — _before_ the allow-list or auto mode is consulted, so a commit command containing them prompts for approval even when `git commit` is allow-listed.

Keep substitution out of the commit command: draft the message, **Write** it to `.git_commit_msg` (the Write tool, not a `cat << 'EOF'` heredoc — no shell parsing involved), run `git commit -F .git_commit_msg`, then `rm .git_commit_msg`. A single-line message with no backticks or `$(...)` may use `git commit -m "type(scope): subject"` directly. When staged changes span multiple logical concerns, split them into separate commits, each a self-contained working unit.

> Pending verification (#252, Q1). This is a harness fact, not a model instruction — if the permission system no longer pre-flags substitution, the section collapses to one line.

## Code Quality

- **Linting**: zero warnings. Run the project's linter before committing and fix every issue. If a warning is truly unfixable, add an inline ignore with a justification comment.
- **Review order**: architecture → code quality → tests → performance.

## Responsive QA

**Verify mobile widths by emulating the CSS viewport, never by resizing the OS window.** A window-resize tool reports success without moving the viewport, and the horizontal-overflow check then passes trivially — a green result that means nothing. Before checking any layout at a mobile breakpoint, read [`docs/responsive-qa.md`](docs/responsive-qa.md) for the emulation tool, the two assertions that prove the width took, and the fallbacks.

## Markdown

**No hard wraps.** Never break prose lines at a fixed column width — each paragraph or list item description is a single long line, and the editor soft-wraps. (MD013 is disabled in `markdown/.markdownlint-cli2.yaml`, so nothing mechanical catches this.)

---

Type `/` to see available skills for common workflows.
