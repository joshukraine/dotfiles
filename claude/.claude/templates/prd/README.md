# [Project Name] — Product Requirements Document

This directory contains the modular PRD for [Project Name]. Each file is a self-contained specification that can be referenced independently during implementation.

## How to Use This PRD

**For Claude Code / AI-assisted implementation:** Reference the specific PRD section relevant to your current task. Start here to find the right file, then consult the referenced section for requirements.

**For human reviewers:** Read `01-overview.md` for context, then dive into the feature spec that matters to you.

## File Index

| File | Contents | Consult When... |
| ------ | ---------- | ----------------- |
| `CHANGELOG.md` | Material deviations from the PRD discovered during implementation | Reviewing or recording a "never silently deviate" decision |
| `ROADMAP.md` | Implementation phases, progress tracking | Planning sprints, checking phase boundaries |
| `01-overview.md` | Vision, personas, design principles, tech stack | Onboarding to the project, understanding goals |
| *Add rows as PRD files are created* | | |

## Conventions

- **"MUST", "SHALL", "REQUIRED"** — non-negotiable for MVP launch.
- **"SHOULD"** — expected for MVP unless a specific technical constraint prevents it.
- **"MAY"** — nice to have; implement if straightforward, otherwise defer.
- **"TBD"** — explicitly unresolved; document in an open items file with context and resolution guidance.
- **Cross-references** use the format `→ See 07-feature.md §3` to point to other PRD sections.
