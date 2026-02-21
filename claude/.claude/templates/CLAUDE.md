# CLAUDE.md — [Project Name]

[One-paragraph project description: what it is, who it serves, key technology choices.]

## Primary Directive

Read `docs/[project]-implementation-briefing.md` before writing any code. It defines how to navigate the PRD, handle deviations, and avoid common implementation pitfalls.

## Quick-Start Commands

```bash
bin/dev                    # Start app
bin/rails db:prepare       # Create/migrate database(s)
bin/rails test             # Run tests
bin/standardrb --fix       # Lint and auto-fix
```

## Key Files

| File | Purpose |
| ------ | --------- |
| `docs/prd/README.md` | PRD index — start here for any feature question |
| `docs/prd/ROADMAP.md` | Task list with checkboxes, one PR per item |
| `docs/prd/CHANGELOG.md` | PRD deviation log — update before merging any deviation |
| `~/.claude/docs/workflow-guide.md` | GitHub Projects, permission presets, worktrees, sprints |
| `~/.claude/docs/label-taxonomy.md` | Work type labels, branch naming, board configuration |

## Architectural Guardrails

1. **[Guardrail 1]** — [brief explanation]
2. **[Guardrail 2]** — [brief explanation]

## Key Terminology

| Term | Definition |
| ------ | ----------- |
| **[Term 1]** | [Definition] |
| **[Term 2]** | [Definition] |

## Conventions

- **Commits:** Conventional Commits with scope — `feat(model): description`
- **Branches:** `feat/`, `fix/`, `chore/`, `docs/`, `test/` prefixes
- **Linting:** [Linter], zero warnings, run before every commit
- **PRD deviations:** Log in `docs/prd/CHANGELOG.md` before merging — never silently deviate
- **Testing:** [Framework], AAA pattern, [test runner command]
