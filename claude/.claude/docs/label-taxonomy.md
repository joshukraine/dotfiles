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

### 4. GitHub Projects Board

**Priority field** (single select):

| Priority | Emoji | When to Use |
| --- | --- | --- |
| Critical | :red_circle: | Blocking other work or affecting users now |
| Normal | :white_circle: | Standard priority — most issues live here |
| Low | :black_circle: | Nice to have, do when convenient |

**Status columns:**

| Column | What Lives Here |
| --- | --- |
| **Backlog** | Triaged issues not yet scheduled for work |
| **Up Next** | Committed to for the current or next sprint |
| **In Progress** | Actively being worked on (branch exists) |
| **In Review** | PR open, awaiting review |
| **Done** | PR merged and issue closed |
