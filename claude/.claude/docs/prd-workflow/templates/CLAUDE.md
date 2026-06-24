# CLAUDE.md — [Project Name]

[One-paragraph project description: what it is, who it serves, key technology choices.]

## Quick-Start Commands

```bash
<!-- TODO: replace with actual commands -->
bin/dev                    # Start app
bin/rails test             # Run tests
bin/standardrb --fix       # Lint and auto-fix
```

## Key Files

| File | Purpose |
| --- | --- |
| `docs/prd/README.md` | PRD index — start here for any feature question |
| `docs/prd/ROADMAP.md` | Task list with checkboxes, one PR per item |
| `docs/prd/CHANGELOG.md` | PRD deviation log — update before merging any deviation |
| `~/.claude/docs/label-taxonomy.md` | Work type labels, branch naming, board configuration |

## Architectural Guardrails

<!-- TODO: add project-specific guardrails -->

1. **[Guardrail 1]** — [brief explanation]
2. **[Guardrail 2]** — [brief explanation]

## Handling Ambiguity

| Decide and Move | Stop and Ask |
| --- | --- |
| View organization, helper naming | New database column not in the data model |
| CSS/styling choices | Changing a model association |
| Test helper structure | Altering a public-facing URL pattern |
| Error message wording | Adding a dependency not in the tech stack |

**The test:** Is the decision easily reversed (code change, no migration)? Decide and move — state the assumption. Does it create a migration or change a public interface? Ask first.

## Conventions

- **Commits:** Conventional Commits with scope — `feat(model): description`
- **Branches:** `feat/`, `fix/`, `chore/`, `docs/`, `test/` prefixes
- **Linting:** <!-- TODO: linter name -->, zero warnings, run before every commit
- **PRD deviations:** Log in `docs/prd/CHANGELOG.md` before merging — never silently deviate
- **Testing:** <!-- TODO: framework -->, AAA pattern, <!-- TODO: test runner command -->

## QA Testing Policy

**Launch status: PRE-LAUNCH.**

QA — walkthroughs (`/walkthrough`) and `/verify` runs — is gated on launch status:

- **Pre-launch (current):** running QA against the **production** site is fine. Production holds disposable test data that gets wiped at cutover, so reviewers without a local environment (e.g. non-technical testers) can exercise features there freely.
- **Post-launch:** QA is **local-dev-only**. Never run walkthroughs, `/verify`, or any QA flow — especially data-mutating ones — against the live site, which holds real user data. Published walkthroughs become local-dev reproduction guides with a "local dev only" banner.

Flip this flag to **POST-LAUNCH** as part of the launch cutover. The `/walkthrough` skill reads it: pre-launch it offers the production-testing callout; post-launch it emits the local-dev-only warning instead.

## QA Publish Target

<!--
  Opt-in: tester-facing HTML from `/walkthrough` and `/qa-handoff` will be
  published to the repo + subfolder declared below, and a live GitHub Pages
  link will be posted as the PR comment.

  Delete this entire section to keep tester artifacts local-only. With no
  declaration, `--publish` falls back to a Markdown PR comment and never
  guesses a remote target.

  Required fields:
    - repo:      <owner>/<repo>  — must have GitHub Pages enabled
    - subfolder: <slug>          — path under the repo; isolates this project

  Live URL is derived: https://<owner>.github.io/<repo>/<subfolder>/<file>.html
-->

```yaml
repo: <owner>/<repo>
subfolder: <project-slug>
```
