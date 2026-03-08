# Shared Documentation Index

Entry point for all cross-project documentation, workflows, and templates under `~/.claude/docs/`.

## PRD Workflow

Everything related to spec-driven (PRD-based) development lives in `prd-workflow/`.

| Document | Purpose | Consult When... |
| --- | --- | --- |
| [`prd-workflow/spec-driven-development.md`](prd-workflow/spec-driven-development.md) | Handbook: deviation tracking, checkpoints, document lifecycle, slash command map | Implementing against a PRD, handling a deviation, running a phase boundary sync |
| [`prd-workflow/prd-authoring-guide.md`](prd-workflow/prd-authoring-guide.md) | How to write a PRD through structured brainstorming | Starting a new project, planning a major feature area |
| [`prd-workflow/templates/`](prd-workflow/templates/) | Starter files for new projects (`CLAUDE.md`, `docs/prd/` scaffolding) | Running `/bootstrap-prd` to scaffold a new project |

## Standalone References

| Document | Purpose | Consult When... |
| --- | --- | --- |
| [`label-taxonomy.md`](label-taxonomy.md) | Unified vocabulary for commits, branches, issues, and project boards | Naming a branch, choosing a commit type, setting up GitHub labels |

## Slash Commands

Custom slash commands live in `~/.claude/commands/`. See the spec-driven development handbook (§7 "Slash Commands in the Development Cycle") for a full command map and lifecycle stage guidance.
