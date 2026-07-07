# Label Taxonomy

A unified vocabulary for classifying work across commits, branches, issues, and project boards. The same terms mean the same things everywhere.

---

## Work Type Categories

| Category | Meaning | When to Use |
| --- | --- | --- |
| `feat` | New capability or user-facing behavior | Adding something that didn't exist before — a new page, endpoint, workflow, or integration |
| `fix` | Correcting broken or incorrect behavior | Something worked wrong and now works right — bug fixes, data corrections, logic errors |
| `chore` | Maintenance that doesn't change user-facing behavior | Dependency updates, CI changes, refactoring, build configuration, code cleanup |
| `docs` | Documentation changes | README updates, inline documentation, architecture decision records, PRD changes |
| `test` | Test-only changes | Adding missing tests, fixing flaky tests, improving test infrastructure |

---

## Resolving Common Ambiguities

**Enhancement or feature?** Use `feat`. The taxonomy does not distinguish between "new" and "improved" — both add user-facing capability.

**Refactoring: `chore` or `refactor`?** At the issue and branch level, use `chore`. In commit messages, use `refactor:` for the fine-grained type.

**Dependency update?** `chore`.

**CI pipeline change?** `chore`. In commit messages, use `ci:` for precision.

**Typo in code — `fix` or `chore`?** If the typo caused incorrect behavior (wrong variable name, misspelled method call), it is a `fix`. If it was cosmetic (comment typo, log message spelling), it is a `chore`.

---

## Surface-by-Surface Reference

### 1. Conventional Commits

| Commit Type | Category | Example |
| --- | --- | --- |
| `feat` | feat | `feat(auth): add password reset flow` |
| `fix` | fix | `fix(api): correct pagination offset calculation` |
| `docs` | docs | `docs(readme): update deployment instructions` |
| `test` | test | `test(models): add validation edge case coverage` |
| `chore` | chore | `chore(deps): update dependencies` |
| `refactor` | chore | `refactor(services): extract notification logic into service object` |
| `style` | chore | `style(views): apply consistent indentation to templates` |
| `ci` | chore | `ci: add staging deployment workflow` |
| `build` | chore | `build: switch from Webpack to esbuild` |
| `perf` | chore | `perf(queries): add database index for user lookup` |

**Format:** `type(scope): lowercase imperative description`

- Scope is optional but encouraged. Use the model, feature area, or subsystem name.
- No period at the end.
- Body and footer follow Conventional Commits spec when needed.

### 2. Branch Prefixes

| Prefix | Category | Example |
| --- | --- | --- |
| `feat/` | feat | `feat/gh-42-password-reset` |
| `fix/` | fix | `fix/gh-87-pagination-offset` |
| `chore/` | chore | `chore/gh-15-update-dependencies` |
| `docs/` | docs | `docs/gh-33-api-documentation` |
| `test/` | test | `test/gh-51-add-model-validation-tests` |

**Format:** `<prefix>/gh-<issue#>-<short-description>`

- Use the GitHub issue number after `gh-`.
- Use lowercase kebab-case for the description.

### 3. GitHub Issue Labels

**Type labels** (one per issue — required):

| Label | Color | Description |
| --- | --- | --- |
| `feat` | `#1D76DB` | New capability or user-facing behavior |
| `fix` | `#D73A4A` | Correcting broken or incorrect behavior |
| `chore` | `#E4E669` | Maintenance, refactoring, dependencies |
| `docs` | `#0075CA` | Documentation changes |
| `test` | `#BFD4F2` | Test-only changes |

**Triage labels** (optional, added during review):

| Label | Color | Description |
| --- | --- | --- |
| `triage` | `#F9D0C4` | Needs review before work begins |
| `blocked` | `#B60205` | Cannot proceed — dependency or decision needed |
| `wontfix` | `#FFFFFF` | Reviewed and rejected |
| `duplicate` | `#CFD3D7` | Duplicate of another issue |

**Workflow labels** (drive the autonomy and QA skill loops):

| Label | Color | Description |
| --- | --- | --- |
| `qa` | `#5DBCD2` | Tester-filed QA report — the input to `/qa-triage` and `/qa-triage-batch` |
| `autopilot-queued` | `#5319E7` | Vetted by `/autopilot-triage` for autonomous resolution; pending an `/autopilot-batch` run |

### 4. GitHub Projects Board

The board carries **two independent axes — keep them separate.** Importance is the priority field; sequence/intent is the status column. "I want to do this next" is expressed by moving an issue to **Up Next** and ordering it — _not_ by bumping its priority.

**Priority field = importance** ("how much it hurts to wait"). A custom Project single-select field (named `Track` on the ComixDistro board) and the **single source of priority truth** — do _not_ also use GitHub's native org-level Priority field (public preview as of 2026-03); two priority fields drift and contradict. Revisit migrating to the native field once it GAs.

| Priority | Emoji | Means | The test |
| --- | --- | --- | --- |
| Critical | :red_circle: | Live-user-impacting correctness / security / data-loss, or a hard blocker | "Jump the queue regardless of current interest?" Keep **near-empty**. |
| Normal | :yellow_circle: | Real work we intend to do — most features and fixes | The default. |
| Low | :green_circle: | Genuinely deferrable: nice-to-have, icebox, do-if-time | "Fine if it waits a quarter." Not "boring." |

**Status columns = sequence / intent** ("when"):

| Column | What Lives Here |
| --- | --- |
| **Parked** | Deliberately idle: waiting on elapsed time or production data (soak / decision issues). _Not_ "blocked." |
| **Backlog** | Triaged issues not yet scheduled for work |
| **Up Next** | Committed to next; order within the column = sequence |
| **In Progress** | Actively being worked on (branch exists) |
| **In Review** | PR open, awaiting review |
| **Done** | PR merged and issue closed |
