# Shared Documentation Index

Entry point for all cross-project documentation, workflows, and templates under `~/.claude/docs/`.

## PRD Workflow

Everything related to spec-driven (PRD-based) development lives in `prd-workflow/`.

| Document | Purpose | Consult When... |
| --- | --- | --- |
| [`prd-workflow/spec-driven-development.md`](prd-workflow/spec-driven-development.md) | Handbook: deviation tracking, checkpoints, document lifecycle, skill map | Implementing against a PRD, handling a deviation, running a phase boundary sync |
| [`prd-workflow/prd-authoring-guide.md`](prd-workflow/prd-authoring-guide.md) | How to write a PRD through structured brainstorming | Starting a new project, planning a major feature area |
| [`prd-workflow/templates/`](prd-workflow/templates/) | Starter files for new projects (`CLAUDE.md`, `docs/prd/` scaffolding) | Running `/bootstrap-prd` to scaffold a new project |

## Standalone References

| Document | Purpose | Consult When... |
| --- | --- | --- |
| [`label-taxonomy.md`](label-taxonomy.md) | Unified vocabulary for commits, branches, issues, and project boards | Naming a branch, choosing a commit type, setting up GitHub labels |
| [`model-selection-strategy.md`](model-selection-strategy.md) | Per-issue `model:` label convention — the tiering heuristic, the runbook to adopt it in a repo, and how the autopilot skills consume it | Triaging issues for model tier, adopting the convention in a new repo, changing how autopilot picks a build model |
| [`responsive-qa.md`](responsive-qa.md) | Verifying a layout at a mobile breakpoint so the result is trustworthy — viewport emulation vs. window resizing, the two assertions that prove the width took, and the fallbacks | **Before** checking any layout at a mobile width through a browser-automation MCP |

## Config Trim Initiative (Aug 2026)

Working files for the always-loaded-config ablation tracked in joshukraine/dotfiles#252. Both are temporary by design — they retire when the initiative closes.

| Document | Purpose | Consult When... |
| --- | --- | --- |
| [`attic-2026-08.md`](attic-2026-08.md) | Text quarantined out of the global `CLAUDE.md`, with the reason for each cut | Re-adding an instruction, or wondering why something is no longer in the global file |
| [`stumble-log.md`](stumble-log.md) | The running record of missed instructions — **the only admissible evidence for a re-add** | Claude got something wrong that a removed line would have prevented; or running the Phase 3 re-add pass |

## Skills

Custom skills live in `~/.claude/skills/`. See the spec-driven development handbook — [`spec-driven-development.md`](prd-workflow/spec-driven-development.md) §7 "Skills in the Development Cycle" — for a full skill map and lifecycle stage guidance.
