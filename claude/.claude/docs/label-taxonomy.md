# Label Taxonomy

A unified vocabulary for classifying work across commits, branches, issues, and project boards. This taxonomy eliminates ambiguity by ensuring the same terms mean the same things everywhere.

---

## Design Principles

1. **One vocabulary everywhere** — the same short terms (`feat`, `fix`, `chore`, `docs`, `test`) appear in commits, branches, and issue labels. Learning one set of terms covers every surface.

2. **Each surface does one job** — labels classify the *type* of work. The priority field classifies *urgency*. No surface duplicates another's job.

3. **Conventional Commits stays granular** — commit-level types like `refactor`, `style`, `ci`, `build`, and `perf` remain available for fine-grained commit messages. They roll up into the broader categories at the issue and branch level.

---

## Work Type Categories

| Category | Meaning | When to Use |
| ---------- | --------- | ------------- |
| `feat` | New capability or user-facing behavior | Adding something that didn't exist before — a new page, endpoint, workflow, or integration |
| `fix` | Correcting broken or incorrect behavior | Something worked wrong and now works right — bug fixes, data corrections, logic errors |
| `chore` | Maintenance that doesn't change user-facing behavior | Dependency updates, CI changes, refactoring, build configuration, code cleanup |
| `docs` | Documentation changes | README updates, inline documentation, architecture decision records, PRD changes |
| `test` | Test-only changes | Adding missing tests, fixing flaky tests, improving test infrastructure |

---

## Resolving Common Ambiguities

**Enhancement or feature?** Use `feat`. The taxonomy does not distinguish between "new" and "improved" — both add user-facing capability.

**Refactoring: `chore` or `refactor`?** At the issue and branch level, use `chore`. In commit messages, use `refactor:` for the fine-grained type. The commit rolls up into the broader `chore` category.

**Dependency update?** Use `chore`. Updating gems, npm packages, or system dependencies is maintenance work.

**CI pipeline change?** Use `chore`. In commit messages, use `ci:` for precision. The issue and branch use the broader `chore` category.

**Typo in code — `fix` or `chore`?** If the typo caused incorrect behavior (wrong variable name, misspelled method call), it is a `fix`. If it was cosmetic (comment typo, log message spelling), it is a `chore`.

---

## Surface-by-Surface Reference

### 1. Conventional Commits

Full commit type table with category roll-up:

| Commit Type | Category | Example |
| ------------- | ---------- | --------- |
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
| -------- | ---------- | --------- |
| `feat/` | feat | `feat/gh-42-password-reset` |
| `fix/` | fix | `fix/gh-87-pagination-offset` |
| `chore/` | chore | `chore/gh-15-update-dependencies` |
| `docs/` | docs | `docs/gh-33-api-documentation` |
| `test/` | test | `test/gh-51-add-model-validation-tests` |

**Format:** `<prefix>/gh-<issue#>-<short-description>`

- Use the GitHub issue number after `gh-`.
- Use lowercase kebab-case for the description.
- Keep the description short but meaningful.

### 3. GitHub Issue Labels

**Type labels** (one per issue — required):

| Label | Color | Description |
| ------- | ------- | ------------- |
| `feat` | `#1D76DB` | New capability or user-facing behavior |
| `fix` | `#D73A4A` | Correcting broken or incorrect behavior |
| `chore` | `#E4E669` | Maintenance, refactoring, dependencies |
| `docs` | `#0075CA` | Documentation changes |
| `test` | `#BFD4F2` | Test-only changes |

**Triage labels** (optional, added during review):

| Label | Color | Description |
| ------- | ------- | ------------- |
| `triage` | `#F9D0C4` | Needs review before work begins |
| `blocked` | `#B60205` | Cannot proceed — dependency or decision needed |
| `wontfix` | `#FFFFFF` | Reviewed and rejected |
| `duplicate` | `#CFD3D7` | Duplicate of another issue |

**Auto-labels** (applied by GitHub Actions or bot):

| Label | Color | Description |
| ------- | ------- | ------------- |
| `dependencies` | `#0366D6` | Applied by Dependabot |

### 4. GitHub Projects Board

**Track field (priority):**

| Priority | Emoji | When to Use |
| ---------- | ------- | ------------- |
| Critical | :rotating_light: | Blocking other work or affecting users now |
| Normal | *(none)* | Standard priority — most issues live here |
| Low | :ice_cube: | Nice to have, do when convenient |

### 5. Status Columns

| Column | What Lives Here |
| -------- | ---------------- |
| **Backlog** | Triaged issues not yet scheduled for work |
| **Up Next** | Committed to for the current or next sprint |
| **In Progress** | Actively being worked on (branch exists) |
| **In Review** | PR open, awaiting review |
| **Done** | PR merged and issue closed |

---

## Slash Command Integration

| Command | Labels Applied | Board Column | Branch Created |
| --------- | --------------- | -------------- | ---------------- |
| `/sprint-issue` | Type label + priority | Up Next | `<prefix>/gh-<#>-<desc>` |
| `/setup-sprint` | Bulk label + priority | Up Next | — |

---

## Migration Checklist

When adopting this taxonomy on an existing repository:

### Labels to Create

- [ ] `feat` — New capability or user-facing behavior
- [ ] `fix` — Correcting broken or incorrect behavior
- [ ] `chore` — Maintenance, refactoring, dependencies
- [ ] `docs` — Documentation changes
- [ ] `test` — Test-only changes
- [ ] `triage` — Needs review before work begins
- [ ] `blocked` — Cannot proceed
- [ ] `wontfix` — Reviewed and rejected
- [ ] `duplicate` — Duplicate of another issue

### Labels to Remove

These GitHub defaults are replaced by the taxonomy above:

- [ ] `bug` (replaced by `fix`)
- [ ] `enhancement` (replaced by `feat`)
- [ ] `documentation` (replaced by `docs`)
- [ ] `good first issue` (not used — priority field handles sequencing)
- [ ] `help wanted` (not used — assignment handles ownership)

### Labels to Rename

- [ ] *(none by default — add project-specific renames here)*

### Labels to Keep

- [ ] `dependencies` (auto-applied by Dependabot)
- [ ] Any labels required by GitHub Actions workflows

### Project Board Changes

- [ ] Create GitHub Project with 5 status columns
- [ ] Add Priority field (Critical / Normal / Low)
- [ ] Enable auto-workflows (PR merged → Done, issue closed → Done)

### Documentation Updates

- [ ] Update CONTRIBUTING.md with label taxonomy reference
- [ ] Update PR template with label checklist
- [ ] Reference this taxonomy in project CLAUDE.md

### Existing Issues

- [ ] Re-label open issues using the new taxonomy
- [ ] Move open issues to appropriate board columns
- [ ] Set priority on all open issues
