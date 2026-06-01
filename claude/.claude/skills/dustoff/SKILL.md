---
name: dustoff
description: Assess a project that's been dormant for months and produce a prioritized re-entry plan — lifecycle stage, what's stale or broken, and how far the project's tooling has drifted from current conventions — delegating every fix to the skill that owns it, and optionally capturing the plan as a tracking issue that survives sessions.
disable-model-invocation: true
---

# Dust Off

Take stock of a project that's been sitting untouched for months and produce a single, prioritized **re-entry plan** for getting it back into active development. Dependencies have fallen behind, tests may be broken, and the project's adopted conventions have probably drifted from the current `~/.claude` toolset. This skill assesses all of that and tells you, in priority order, what to do first — but it does not do the work itself.

It is **read-only with respect to the codebase**, and advisory. It inspects, reports, and recommends; it never updates dependencies, edits project files, marks ROADMAP checkboxes, or writes code. Its one deliberate write is optional and opt-in: capturing the finished plan as a tracking issue (or a `DUSTOFF.md`) so it survives the session — see step 5. The deliverable is a plan, and every item on that plan names the existing skill (or manual step) that acts on it.

**Where it sits in the workflow.** This is the *first* thing you run when returning to a dormant project — before picking up an issue, before `/plan-phase`, before any new work. Its output feeds the normal cycle: a clean assessment hands off to `/update-deps`, `/readme-refresh`, `/plan-phase`, and `/resolve-issue` to actually execute the catch-up.

**Applicability.** Works in any repo. It reads both the **project** (the working directory) and the **current conventions** under `~/.claude` to measure drift between them. It degrades gracefully — no PRD, no README, no CI, or no `gh` are all handled, with the relevant phase noting what it couldn't check rather than failing.

**Not the same as:**

- `/checkpoint` — that's mid-stream orientation: a 2-minute hallway update that *assumes you already know where you are* in an active push. This is the sit-down re-entry assessment for when you *don't* — you've been away for months and need to re-derive the project's state, staleness, and lifecycle stage from scratch.
- `/update-deps`, `/readme-refresh`, `/plan-phase` — those *do* the work (update dependencies, fix the README, create issues). This one only *flags* the need and hands off. Delegate; don't duplicate.
- `/drift-check` — that checks a branch diff against the project spec before a PR. This checks the whole project's adopted *tooling and conventions* against the current `~/.claude` standard at re-entry. Different drift, different scope.

## The core guardrail

The output is a plan, not a fix — dustoff routes work to other skills, it doesn't perform it. (Capturing the plan as a tracking issue in step 5 is the one write it makes, and only when you approve it.) The one-line test for any step you're tempted to add or take: *"Does this belong to re-entry assessment, or am I about to re-implement `/update-deps` (or `/readme-refresh`, or `/plan-phase`)?"* If it's the latter, stop — flag it as a plan item and hand off. The value of this skill is the synthesis, not the mechanics it would otherwise duplicate.

## Your task

Work through the five steps below. Steps 1–4 are read-only; step 5 is the one optional, opt-in write (capturing the plan). Gather findings as you go and present a **single consolidated re-entry plan** at the end of step 4 — not a separate report per step. If the working directory isn't a git repository, say so and stop; there's no dormant project to dust off.

### 1. Orient — how dusty, and where in the lifecycle

- **Dormancy duration**: `git log -1 --format=%cd --date=short` for the last commit date; `git log -20 --format='%cd %s' --date=short` to see the cadence before it stopped (steady work that abruptly halted reads differently than a project that was always sporadic).
- **Read the project's own account of itself**: the project `CLAUDE.md`, `docs/prd/ROADMAP.md` (if present), and the `README`. Don't trust them as current — they're inputs to assess, not ground truth.
- **Determine the lifecycle stage** per the handbook (`~/.claude/docs/prd-workflow/spec-driven-development.md` §6 "PRD Lifecycle") and **state it explicitly with evidence**:
  - **Greenfield** — building against the spec; ROADMAP checkboxes are the active work queue, many unchecked.
  - **MVP-complete (transition)** — all ROADMAP phases marked complete; new work coming from issues; living docs starting to take over from the PRD.
  - **Mature** — issue-driven; PRD is historical; living docs are authoritative.
  - Evidence to cite: ratio of checked-to-unchecked ROADMAP items, whether work flows from the ROADMAP or from issues, presence of living docs (domain model, runbooks), and the CHANGELOG's activity.
- **No PRD?** Place the project from git history, the README, and any living docs instead. The lifecycle question still applies — it just measures against whatever authoritative reference exists.

### 2. Take stock — read-only health

Detect before you assume (the `/update-deps` and `/readme-refresh` approach): identify the package manager, the test/lint commands, the CI workflow, and the boot command from what the repo actually contains. Prefer a single project gate (`bin/ci`, `bin/test`, `script/test`, a `Makefile`/`Justfile` target) over guessing individual runners.

- **Health check** (report-only — never fix here): run the tests, the linter, and a boot check. Report results in the compact `/checkpoint` format:

  ```text
  Tests:   <pass/fail counts, or "couldn't run — <reason>">
  Linting: <clean / N issues / couldn't run>
  Boot:    <boots OK / fails — <error> / not checked>
  ```

  If a command isn't discoverable, say what you looked for rather than inventing one.
- **Open work**: `gh issue list --state open` and `gh pr list --state open`. Call out **open Dependabot PRs separately** — they're the clearest dependency-staleness signal. (No `gh` or no remote? Note it and skip.)
- **Deployment posture**: detect a deploy target (`fly.toml`, `Procfile`, `render.yaml`, `netlify.toml`, `app.json`, `Dockerfile`, `docker-compose.yml`, `.github/workflows/*deploy*`). Report **deployed-public vs. local-only**. If deployed, flag that live status can't be confirmed from the repo alone — that's a manual check for the plan.
- **Dependency staleness — flag, don't fix**: a one-line summary is enough (`bundle outdated`/`npm outdated` counts, or simply the count of open Dependabot PRs). Do **not** run updates — that's `/update-deps`'s job and it belongs in the plan, not here.

### 3. Toolset / convention drift

This is the check no off-the-shelf tool does: how far has the project's adopted tooling fallen behind the **current** conventions, given that `~/.claude` itself keeps evolving? Read the current standard, then compare the project against it. Keep every finding **concrete** — name the specific missing block or file and the skill/template that closes the gap. No vague "things may have changed."

- **Read the current standard** under `~/.claude`: the bootstrap templates (`~/.claude/docs/prd-workflow/templates/CLAUDE.md` and `templates/prd/`), the handbook (`spec-driven-development.md`), and the skills directory (`~/.claude/skills/`).
- **CLAUDE.md markers**: compare the project's `CLAUDE.md` against the current template. Flag marker sections the template has that the project lacks (e.g. a `## QA Publish Target` block), and conventions that have since changed.
- **PRD structure**: if `docs/prd/` exists, check it against the current expected structure — `README.md` (nav hub), `ROADMAP.md`, `CHANGELOG.md` (deviation log), numbered feature files. Flag missing pieces (a PRD with no CHANGELOG predates the deviation-log convention).
- **Skill/workflow evolution (heuristic, framed softly)**: use git history to date the last skill-driven activity and flag where it predates a current capability — e.g. "the last dependency PR (#84, ~5 months ago) predates the Dependabot-aware `/update-deps`; a fresh run is worth it." Frame these as *worth re-running*, not as asserted facts about exact dates you can't verify from inside the project.

### 4. Synthesize — the re-entry plan

Fold everything into **one prioritized, housekeeping-first plan**. This is the whole point of the skill. Order strictly by what unblocks new development:

1. **Critical / broken** — failing tests, security advisories, a broken boot. These block new work and come first.
2. **Stale housekeeping** — dependency updates, README drift, convention catch-up from step 3.
3. **Reorientation** — where you left off (the last in-flight ROADMAP item or open issue) and the recommended next development step.

Every item **names the action to take on it** — a skill invocation or an explicit manual step:

```text
Re-Entry Plan — <project> (dormant ~<duration>, <lifecycle stage>)
================================================================

Critical (do first — blocks new work):
  ✗ 3 failing tests in spec/models/order_spec.rb   → investigate before anything else
  ✗ bundler-audit reports CVE-2026-xxxx in nokogiri → /update-deps (security)

Housekeeping:
  ⚠ 4 open Dependabot PRs, deps ~5mo stale          → /update-deps
  ⚠ README says Rails 7.1; Gemfile.lock shows 8.0   → /readme-refresh
  ⚠ CLAUDE.md missing '## QA Publish Target' block  → review against current template
  ⚠ docs/prd/ has no CHANGELOG.md                    → adopt current PRD convention

Reorientation:
  • Lifecycle: MVP-complete transition (all 5 phases marked, work is now issue-driven)
  • Last in flight: issue #42 "export to CSV" (branch exists, no PR)
  • Suggested next step: run the §6 MVP-transition checklist, then /plan-phase for new work
  • Deployed at fly.io — confirm the live app still boots (manual)
```

The plan is the deliverable. Present it in full — then move to step 5 to decide how to keep it.

### 5. Persist the plan — so it survives the session

A long-dormant project's plan can run to a dozen items across several sessions; don't let it scroll off the terminal. After presenting the plan, offer to capture it. This is the skill's one write, and it's opt-in:

- **Default offer — a tracking issue.** File the plan as a single GitHub issue (title like `chore: dust off <project>`), with a tiered checklist body (from step 4) where each item is a `- [ ]` so progress is visible ("3 of 9") and checkable across sessions. Apply the `chore` label **if it exists** (`gh label list`) — don't assume it does. If it's absent, create it or file without a label rather than letting `gh issue create --label` error out; the title convention is what the refresh step keys on, not the label. Add it to the project board if one exists (`gh project list`, or per `CLAUDE.md`).
- **Resume, don't duplicate.** Before creating, search for an existing open dust-off issue by the title convention (`gh issue list --search "dust off in:title" --state open`). If one exists, offer to **refresh** it — reconcile new findings, preserve already-checked items — rather than open a second.
- **No `gh` or no remote.** Fall back to writing a `DUSTOFF.md` at the project root with the same checklist. Same survives-the-session benefit, no GitHub dependency. Ask whether to commit it (durable, shared with collaborators) or add it to `.gitignore` (a private scratch worklist) — don't leave it as a silent untracked file.
- **Decline path.** If the user wants it terminal-only, that's fine — leave the plan on screen and stop.

Whichever way it's captured, **stop there** — do not start executing the plan. Offer to kick off the top item (e.g. "Want me to start with `/update-deps`?") and let the user choose. The discrete new-work items (a discovered bug, failing tests with no obvious cause) become their own issues when you pick them up — via `/plan-phase` or the owning skill — and the tracking issue links to them. Dustoff doesn't file those itself.

## Tone

- You're a senior developer giving an executive an honest re-entry assessment after a project sat idle. Lead with what's broken; don't bury bad news under qualifications.
- Be concrete about drift — a named missing block beats "your config might be out of date."
- Right-size every finding. You're flagging and routing, not solving. If you catch yourself running the full `/update-deps` analysis, you've crossed the line — flag it and move on.
