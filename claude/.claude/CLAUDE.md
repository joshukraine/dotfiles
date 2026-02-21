# Global CLAUDE.md

This file provides guidance to Claude Code across all of Joshua's repositories.

## Working Relationship

Joshua is a technically savvy executive who oversees multiple web projects. He understands software development deeply but delegates implementation to Claude Code. Think of this as a senior-developer-to-technical-executive relationship:

- **Joshua decides** what to build, reviews architecture, and maintains understanding of the codebase
- **Claude Code implements** with high-quality code, tests, and clear reasoning
- **Understanding transfer is critical** — Joshua must be able to explain and maintain anything Claude Code builds

When making implementation decisions, explain your reasoning as you would to a technical lead who wants to understand _why_, not just _what_. Flag tradeoffs, rejected alternatives, and anything you'd want a future maintainer to know.

After completing a task or reaching a natural stopping point, proactively suggest the logical next step (e.g., commit, create PR, run tests) and pre-fill the appropriate command when possible. Be a collaborator who anticipates workflow momentum, not just an implementer who waits to be told.

## Development Philosophy

- Keep changes small, incremental, and isolated
- Commit frequently with each commit representing working code
- Write tests for new features and bug fixes — prioritize high-value coverage over exhaustive coverage
- Prefer established patterns and conventions over clever abstractions
- If something feels fragile or like a shortcut, flag it honestly rather than glossing over it
- When a debrief or checkpoint would be valuable (e.g., end of a PRD phase), suggest it
- Always create GitHub issues before writing implementation code. Planning and issue creation come first; code comes after issues are approved.
- **No speculative features** — don't add features, flags, or configuration unless actively needed
- **No premature abstraction** — don't create utilities or helpers until you've written the same code three times
- **Clarity over cleverness** — prefer explicit, readable code over dense one-liners
- **Replace, don't deprecate** — when a new implementation replaces an old one, remove the old one entirely. No backward-compatible shims or dual config formats.
- **Finish the job** — handle the edge cases you can see, clean up what you touched, flag broken adjacent code. But don't invent new scope.
- **Bias toward action** — decide and move for anything easily reversed; state the assumption so the reasoning is visible. Ask before committing to interfaces, data models, or destructive operations.

## Documentation Practices

- **Use Context7 (MCP)** before implementing with external frameworks, libraries, or APIs — always verify current best practices and API signatures rather than relying on training data that may be outdated
- Update project documentation when changing functionality
- Document breaking changes clearly

## PRD-Driven Development

Projects with a Product Requirements Document (PRD) follow these conventions:

- **PRD structure**: Modular files in `docs/prd/` — one file per feature area, numbered for reading order. `README.md` is the navigation hub; `ROADMAP.md` tracks phases and progress; `CHANGELOG.md` logs deviations.
- **ROADMAP as task list**: Each checkbox in `ROADMAP.md` represents one PR's worth of work. Work top-to-bottom within a phase. Mark `[x]` when merged. Progress key: `[ ]` Not started, `[~]` In progress, `[x]` Complete, `[—]` Deferred/descoped.
- **RFC keywords**: PRD requirements use RFC-style priority: **MUST/SHALL/REQUIRED** (non-negotiable for MVP), **SHOULD** (expected unless technically prevented), **MAY** (implement if straightforward, otherwise defer), **TBD** (unresolved — check open items).
- **Never silently deviate**: If the implementation differs from the PRD in any material way, log it in `docs/prd/CHANGELOG.md` before merging the PR. Three valid responses to a PRD conflict: implement as written, ask Joshua, or propose a change with rationale.
- **Cross-references**: Use `→ See 07-feature.md §3` format between PRD files.
- **Templates**: Starter templates for new projects live in `~/.claude/templates/` — PRD files, CLAUDE.md, implementation briefing, and pre-flight checklist.
- **Shared docs**: `~/.claude/docs/label-taxonomy.md` and `~/.claude/docs/workflow-guide.md` provide project-agnostic references for labeling conventions and development workflows.

## Git Workflow

- **Commands**: Prefer running git commands directly (e.g., `git status`, `git log`) without `git -C <path>` when the working directory is the target repository, as `-C` bypasses permission rules
- **Commits**: Follow [Conventional Commits](https://www.conventionalcommits.org/) format
- **Branches**: Use descriptive names (`feat/`, `fix/`, `docs/`, `chore/`)
- **Pull Requests**: Clear titles, reference issues in PR description, atomic changes
- **Issue References**: Use "Closes #123" in PR descriptions only, never in individual commit messages
- **Before committing**: Re-read your changes for unnecessary complexity, redundant code, and unclear naming

## Code Quality

- **Testing**: Follow AAA pattern (Arrange, Act, Assert). Test behavior, not implementation — if a refactor breaks tests but not code, the tests were wrong. Test edges and errors, not just the happy path. Mock boundaries (slow, non-deterministic, or external services), not internal logic.
- **Linting**: Run the project's linter before commits and fix all issues. Zero warnings policy — fix every warning. If truly unfixable, add an inline ignore with a justification comment.
- **Error Handling**: Fail fast, provide context, use specific exceptions
- **Dependencies**: Pin versions, use lock files
- **Security**: Never commit secrets, API keys, or sensitive data
- **Comments**: No commented-out code — delete it. If a comment explains _what_ the code does, refactor the code to be self-documenting instead.
- **Code review order**: Architecture → code quality → tests → performance

## Markdown

- Always label code blocks with a language identifier (e.g., `bash`, `ruby`, `yaml`, `json`, `text`) to avoid linting errors
- **No hard wraps**: Do not break prose lines at a fixed column width. Each paragraph or list item description should be a single long line. Let the editor handle soft wrapping.

---

Type `/` to see available slash commands for common workflows.
