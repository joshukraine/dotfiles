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
