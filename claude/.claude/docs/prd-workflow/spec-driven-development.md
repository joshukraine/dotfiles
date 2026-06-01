# Spec-Driven Development Workflow

A collaborative workflow for building software against a Product Requirements Document (PRD). Designed for a technical executive working with Claude Code — both parties use this document as a shared reference.

Informed by lessons learned building ComixDistro (13 phases, 380+ PRs, 18 PRD files).

**Platform assumptions:** This workflow assumes GitHub as the hosting platform and the `gh` CLI for issue tracking, pull requests, and CI integration. The principles (modular specs, deviation tracking, checkpoint cadence) are platform-agnostic, but the skills and specific procedures rely on GitHub tooling. Adapting to GitLab, Bitbucket, or other platforms would require substituting the `gh`-based steps with equivalent tooling.

---

## 1 PRD Structure Conventions

A well-structured PRD is modular, navigable, and tightly integrated with the project's issue tracker.

### File organization

- **One file per feature area**, numbered for reading order (e.g., `01-overview.md`, `04-events-workflow.md`).
- **`README.md`** — navigation hub. File index with "consult when..." guidance.
- **`ROADMAP.md`** — task list organized by phase. Each checkbox represents one PR's worth of work. Progress key: `[ ]` Not started · `[~]` In progress · `[x]` Complete · `[—]` Deferred/descoped.
- **`CHANGELOG.md`** — deviation log. The record of the "never silently deviate" rule (see §3).

### Conventions within PRD files

- **RFC keywords** for priority: MUST/SHALL/REQUIRED (non-negotiable for MVP), SHOULD (expected unless technically prevented), MAY (implement if straightforward, otherwise defer), TBD (unresolved — document in open items).
- **Cross-references** use `→ See 07-feature.md §3 "Section Heading"` format. Always include filename and quoted heading.
- **Open Items sections** in each PRD file capture unresolved design decisions. These are TBDs with enough context to make a decision when the time comes.

### ROADMAP discipline

- Work top-to-bottom within a phase.
- Mark `[x]` in the same PR that implements the work — not after merging.
- One checkbox = one PR = one reviewable unit of work.
- If a checkbox turns out to require multiple PRs, split it before starting.

---

## 2 The Deviation Threshold

Not every implementation detail needs to be logged. The question is:

> **Does this change the contract or behavior visible to users or admins?**

### Above the threshold (log it)

- Adding, removing, or changing a database column that affects user-facing behavior
- Changing a model's associations or lifecycle (e.g., new status, new transition)
- Introducing a new model or concern that wasn't in the spec
- Changing a URL pattern, API contract, or authorization rule
- Adding a required field or changing validation rules
- Altering notification triggers or email content

### Below the threshold (don't log it)

- Adding a database index for performance
- Extracting a private method or refactoring internals
- Choosing a specific gem when the PRD said "use a library for X"
- CSS/styling decisions within the design intent
- Test organization and helper structure
- Locale file organization

### Gray area

When unsure, surface it. A 30-second conversation costs less than discovering undocumented drift three phases later. The act of writing down a potential deviation is itself a filter — sometimes it reveals that the change isn't needed, or needs a different shape than initially envisioned.

---

## 3 The Deviation Workflow

Deviations from the spec are a natural, expected part of building software. The spec represents your best thinking at planning time; implementation reveals what planning couldn't anticipate. The goal isn't to prevent all deviations — it's to handle them deliberately rather than accidentally.

Two workflows address this: a **proactive** path for deviations caught before implementation, and a **reactive** path for drift discovered after the fact. Both are normal. Hitting the reactive path isn't a failure — it's an expected part of the lifecycle.

### 3a Proactive workflow — deviation recognized before implementation

This is the discipline to aim for. When something comes up during implementation that crosses the deviation threshold:

1. **Recognize** — apply the threshold test from §2. If it crosses, proceed to step 2.
2. **Pause** — do not implement the change yet. Resist the pull to "just build it and log it later."
3. **Surface** — present it to the project owner with context: what was discovered, why it matters, what the options are. Frame it as a decision, not a notification.
4. **Decide together** — three valid responses:
   - **Implement as spec'd** — the spec was right; the impulse to deviate was wrong.
   - **Modify the approach** — the deviation is directionally right but needs a different shape.
   - **Update the spec** — the spec was incomplete or wrong; update it to reflect the new understanding.
5. **Document first** — if the decision changes the spec, log it in `CHANGELOG.md` *before* writing code. Use the standard entry format: what changed, why, and category (Correction / Discovery / Pivot).
6. **Implement** — now build it, with the spec and the changelog in agreement.

The key principle: **document the change before making it.** This forces clarity. A deviation that can't be clearly articulated in a changelog entry probably isn't well enough understood to implement.

### 3b Reactive workflow — drift discovered after the fact

Despite best intentions, drift will happen. A feature gets built in a flow state and the deviation isn't recognized until later. A series of small, below-threshold decisions compound into an above-threshold divergence. A checkpoint reveals that the implementation and the spec no longer agree.

When drift is discovered:

1. **Stop** — don't compound the drift by continuing to build on top of it.
2. **Assess scope** — how far has the implementation diverged? Is it one field, one model, or a whole feature area? Are other parts of the codebase now built on assumptions that differ from the spec?
3. **Log it** — create CHANGELOG entries for each deviation, backdated to when the drift likely occurred. Be honest about the timeline — the log is a record, not a performance review.
4. **Decide direction** — for each deviation, the same three options apply: revert to spec, adjust the approach, or update the spec. Not every discovered drift needs to be "fixed" — sometimes the implementation is better than the spec.
5. **Fold back** — if updating the spec, edit the source PRD files to reflect reality. Don't leave the truth split between the CHANGELOG and the PRD files indefinitely.
6. **File issues** — if the assessment reveals gaps that need implementation work, create GitHub issues. Don't let "we'll get to it" items live only in your head or in meeting notes.

### Deviation categories

- **Correction** — the PRD was wrong or internally inconsistent.
- **Discovery** — implementation revealed something the PRD didn't anticipate. This is the most common category and is not a sign of poor planning — it's a sign of learning.
- **Pivot** — a deliberate decision to change direction based on new understanding, product review, or changed requirements.

---

## 4 Checkpoint Cadence

The proactive workflow catches deviations one at a time. Checkpoints catch what slips through — patterns of drift, stale issues, accumulated small changes that add up to a material divergence.

### Per-PR checkpoint

**When:** Every pull request, before merging.

**What to do:**

- Ask: "Does this PR change anything that differs from the PRD?"
- If yes, verify a CHANGELOG entry exists.
- If the PR introduces a new model, column, association, or lifecycle change, cross-reference the domain model or relevant PRD section.

**Time cost:** 30 seconds to 2 minutes. This is the cheapest checkpoint and the most valuable.

### Phase boundary checkpoint

**When:** At the end of each implementation phase (all ROADMAP checkboxes for the phase are marked).

**What to do:**

- Fold all CHANGELOG entries back into the source PRD files. The CHANGELOG is a staging area, not a permanent home.
- Update `ROADMAP.md` — mark the phase complete, note any items that were deferred or descoped.
- Review open items in each PRD file touched during the phase. Resolve what you can; explicitly mark remaining TBDs.
- Run a quick issue audit: are there open issues that were completed during this phase but not closed?

**Time cost:** 30–60 minutes. Treat it as a phase deliverable, not optional cleanup.

### Periodic audit

**When:** When the project feels like it's accumulated untracked work — new enhancement ideas filed as issues, multiple phases completed without a sync, or before starting a major new phase. As a rule of thumb, if 10+ CHANGELOG entries have accumulated without a fold-back, it's time.

**What to do:**

- Compare open GitHub issues against the PRD. Categorize: aligned, stale (already done), beyond PRD scope, known deviations.
- Check the ROADMAP Future section against the issue tracker. Are there concrete ideas that should be tracked as issues? Are there issues that should be reflected in the ROADMAP?
- Assess document hygiene: are there temporary documents that can be archived? Planning docs that should be reclassified as living docs (or vice versa)?

**Time cost:** 1–2 hours. This is the audit we did for ComixDistro after the PRD sync — it found 3 stale issues, 8 untracked enhancements, and 4 documented-but-undecided deviations. Worth it.

---

## 5 Document Lifecycle

Not all documents have the same lifespan. Confusing a planning document with a living document leads to either stale specs or unnecessary churn.

### Planning documents (frozen after implementation)

These describe *what we intended to build*. Once the feature is implemented, they become historical records. They may be updated during fold-backs to reflect what was actually built, but they are not actively maintained as the system evolves.

**Examples:** Individual PRD feature files (`04-events-workflow.md`, `11-individual-book-requests.md`), the ROADMAP (once all phases are complete), one-time research or decision documents.

**Lifecycle:** Write → implement → fold back deviations → freeze → eventually archive.

### Living documents (evolve with the code)

These describe *what we actually built*. They are updated whenever the system changes and are the authoritative reference for the current state.

**Examples:** Domain model / data model reference, API integration guides, operations runbooks.

**Lifecycle:** Write → update continuously → never archive (unless the system is decommissioned).

### Recognizing a lifecycle transition

On ComixDistro, the data model started as PRD file `02-data-model.md` (planning) and evolved into `comixdistro-domain-model.md` (living). The transition happened organically but wasn't recognized until it had already created confusion — two documents describing the same thing, one accurate and one stale.

**When to reclassify:** If you find yourself updating a "planning" document after its phase is complete because the system has changed, it's probably a living document. Move it out of the PRD hierarchy, give it a name that reflects its operational role, and leave a redirect in the PRD.

### Archiving

Documents that have served their purpose but contain valuable historical context should be archived, not deleted. An `archives/` directory within `docs/` keeps them accessible without cluttering the working document set. Good candidates: research documents, one-time audit reports, brainstorming artifacts, and reading guides for completed reviews.

### Medium: HTML vs. Markdown

Document medium follows the same lifecycle split. Markdown for what an agent edits or an archive preserves; HTML for what a human reads once and moves on.

- **Markdown:** PRD files, ROADMAP, CHANGELOG, this handbook, skill instructions (SKILL.md), debrief summaries. Diffable, machine-readable, single source of truth.
- **HTML:** debrief full reports, walkthroughs, QA handoffs, plans, mockups. Self-contained single files with click-to-copy controls, interactive checklists, and inline SVG. Opened in a browser with `open` — no build, no server.

The skills that produce HTML artifacts share a house style (`~/.claude/skills/_shared/house-style.html`) and a publish pipeline (see §7 "Publishing artifacts to remote testers") so the output is consistent and portable. The format that is easiest to maintain is not always the format that is most useful to read; the split keeps both honest.

---

## 6 PRD Lifecycle — From Greenfield to Mature

A PRD is not a permanent fixture. It has a lifecycle that mirrors the project's maturity. Understanding where you are in that lifecycle determines how tightly you lean on the PRD and what role it plays in day-to-day work.

### Stage 1: Greenfield (building against the spec)

The PRD is the primary driver. The ROADMAP is the work queue. Every implementation task traces back to a PRD section.

**Characteristics:**

- ROADMAP checkboxes are the unit of work. One checkbox = one PR.
- Deviation tracking is at its most rigorous — the spec is fresh and the system is being shaped.
- The CHANGELOG is active. New entries appear regularly as implementation reveals things the spec didn't anticipate.
- Skills like `/plan-phase`, `/resolve-issue`, and `/create-pr` drive the development cycle.

**Risk:** Over-adherence. The spec is a plan, not a contract. If implementation reveals a better approach, update the spec — don't force the code into a shape that no longer makes sense.

### Stage 2: MVP complete (transition)

All PRD phases are done. The system works. The focus shifts from building features to polishing, stabilizing, and responding to real-world usage.

**Characteristics:**

- The ROADMAP phases are all marked complete. New work comes from GitHub issues, not ROADMAP checkboxes.
- Some PRD files are already stale — the implementation has moved past them. This is normal and expected.
- Living documents (domain model, runbooks, integration guides) become the primary references. Planning documents start to freeze.
- Small changes go straight to implementation via issues. Larger features may get a new numbered PRD file or a well-scoped issue with acceptance criteria — use judgment based on complexity.
- The CHANGELOG may still receive entries, but the rate slows. Phase boundary checkpoints give way to periodic audits.

**What to do at this transition:**

- Run a full periodic audit (see §4): compare issues against the PRD, close stale issues, identify untracked enhancements.
- Fold back any remaining CHANGELOG entries into the source PRD files.
- Reclassify documents: which are now living docs? Which are ready to freeze? Which can be archived?
- Update CLAUDE.md if the "Primary Directive" still points to PRD files that are no longer the active reference.

**Risk:** Abandoning structure too quickly. The spec-driven discipline — deviation tracking, checkpoints, document-before-you-build — remains valuable even after the PRD phases are complete. The habit matters more than the specific artifacts.

### Stage 3: Mature (ongoing evolution)

The project is stable and in production. Changes are incremental: bug fixes, small enhancements, occasional new features, dependency updates.

**Characteristics:**

- GitHub Issues are the sole work queue. The ROADMAP's Future section may still hold aspirational items, but day-to-day work is issue-driven.
- Living documents are the authoritative references. The PRD is a historical archive — valuable for understanding *why* the system was built this way, but not consulted for current implementation decisions.
- New features of significant scope may warrant a new PRD file (or a lightweight feature spec in the issue description). The threshold: if the feature requires multiple PRs and involves design decisions, write it down before building it.
- Checkpoints become lighter: per-PR discipline continues, but phase boundaries no longer apply. Periodic audits happen when the project feels like it's accumulated untracked work.

**What to do at this transition:**

- Archive the PRD directory (or leave it in place as historical reference — archiving is optional if it's not causing clutter).
- Ensure living documents are current and well-organized.
- The spec-driven workflow from §3 still applies to any change that crosses the deviation threshold — the "deviation" is now measured against the living documents rather than the PRD.

### The through-line

The specific artifacts change across stages, but the core discipline doesn't:

1. **Write it down before you build it** — whether "it" is a PRD section, a CHANGELOG entry, or a GitHub issue with acceptance criteria.
2. **Check for drift at regular intervals** — whether that's per-PR, per-phase, or periodic.
3. **Keep the authoritative reference current** — whether that's the PRD (greenfield), the domain model (MVP), or the issue tracker (mature).

The spec-driven approach isn't a phase you pass through — it's a habit you carry. The forms evolve; the discipline persists.

---

## 7 Skills in the Development Cycle

Skills are the operational backbone of spec-driven development. They encapsulate consistent, repeatable behavior at each stage of the workflow — reducing cognitive load, fighting fatigue, and ensuring steps aren't skipped.

This section maps every skill to its place in the development cycle. Think of it as the answer to: "What skill do I run right now?"

### The skill library

| Skill | Purpose | Cadence |
| ------- | ------- | ------- |
| `/bootstrap-prd` | Scaffold PRD structure for a new project | Once per project |
| `/plan-phase` | Create GitHub issues from a PRD phase | Once per phase |
| `/setup-sprint` | Create parallel worktrees for a batch of issues | Per sprint (optional) |
| `/resolve-issue` | Implement an issue end-to-end; planning checkpoint scales to complexity | Per issue |
| `/commit` | Stage and commit with Conventional Commits message | Multiple per issue |
| `/simplify` | Review changed code for reuse, quality, efficiency | Pre-PR |
| `/drift-check` | Deviation check against the spec | Pre-PR |
| `/create-pr` | Create PR with issue linking and ROADMAP update | Per issue |
| `/walkthrough` | Generate a browser walkthrough of user-facing changes; `--publish` renders HTML, uploads to the project's QA host (when configured), and posts a PR comment with the link | Pre-review, then pre-merge (user-facing PRs) |
| `/review-pr` | Analyze a PR for quality issues | Pre-merge |
| `/merge-pr` | Squash merge, clean up branch, pull latest main | Post-review |
| `/qa-handoff` | Generate a hands-on QA testing guide as a self-contained HTML page; `--publish` uploads it to the project's QA host | Per feature (when needed) |
| `/checkpoint` | Quick status check: where am I, what's next | Ad-hoc / returning from break |
| `/dustoff` | Re-entry assessment for a dormant project: lifecycle stage, staleness, and convention drift → prioritized plan, optionally captured as a tracking issue | Returning after months away |
| `/debrief` | Detailed walkthrough of completed work | Phase boundary |
| `/update-deps` | Reconcile Dependabot PRs, audit security, validate on CI, open a unified PR | Periodic maintenance |
| `/readme-refresh` | Audit and update README, or bootstrap one | Periodic / phase boundary |

> **Note:** `/simplify` is a built-in Claude Code skill. All other entries listed above are custom skills defined in `~/.claude/skills/`.

### The PR cycle (inner loop)

This is where most development time is spent. One pass through this cycle produces one PR.

```text
1. Pick an issue
   └─ /resolve-issue N        (research, plan, implement, verify — checkpoint scales to complexity)

2. Implement
   └─ /commit                  (multiple times — small, frequent commits)

3. Quality check
   └─ /simplify                (code reuse, efficiency, readability)

4. Deviation check
   └─ /drift-check             (spec alignment — see below)

5. Create PR
   └─ /create-pr               (links issue from branch name, updates ROADMAP)

6. Walkthrough
   └─ /walkthrough             (browser pre-flight — user-facing PRs only)

7. Review
   └─ /review-pr               (quality, security, correctness)

8. Publish walkthrough
   └─ /walkthrough --publish   (renders HTML, uploads to project's QA host, posts PR comment with link)

9. Merge
   └─ /merge-pr                (squash merge, clean up, pull main)
```

Steps 3 and 4 are the pre-PR quality gates. `/simplify` looks at the code itself; `/drift-check` looks at the code's relationship to the spec. Together they catch both implementation quality issues and specification drift before the PR is created.

Steps 6 and 8 are the walkthrough's two slots, both conditional on the PR having user-facing changes. At step 6, `/walkthrough` produces a throwaway browser checklist (Markdown, in `tmp/`) so the orchestrator can exercise the feature before spending review attention on the code; it is re-run as fixes land. At step 8, once the code is final, `/walkthrough --publish` renders a rich HTML version, uploads it to the project's QA host (when one is declared — see "Publishing artifacts to remote testers" below), and posts a PR comment linking to it so the QA tester can follow it after deploy. For PRs with no user-facing surface the skill reports that and exits at either slot.

Step 9 closes the loop. `/merge-pr` encapsulates the merge preferences (squash merge by default), cleans up the feature branch, and pulls the latest main — ensuring a consistent end state after every PR.

### Phase planning

At the start of each phase:

1. **`/plan-phase`** — Read the relevant PRD files, create GitHub issues with acceptance criteria and implementation order. This is a planning-only skill — no code is written.
2. **`/setup-sprint`** *(optional)* — If the phase contains a batch of small, independent issues (common for chore or fix batches), create parallel worktrees. Each worktree gets its own branch and can be worked independently.

### Phase boundary

At the end of each phase:

1. **`/checkpoint`** — Quick status: what's done, what's in flight, what's next. Health check on tests and linting.
2. **`/debrief`** — Detailed walkthrough for the project owner. Covers what was built, architecture decisions, test coverage, and a product tour. Produces a permanent record in `docs/debriefs/`.
3. **Manual: phase boundary sync** — Fold back CHANGELOG entries, update ROADMAP, close stale issues, review open items. (See §4 "Phase boundary checkpoint" for the full checklist.)

The `/debrief` is the natural place to surface drift that was missed during the PR cycle — reviewing the full body of work at phase end often reveals patterns that individual PRs didn't.

### Recovery and reorientation

When you're disoriented, fatigued, or returning from a break:

- **`/checkpoint`** — Reorient. Where am I in the ROADMAP? What's in flight? What are the next 2–3 items? This is the "where was I?" skill.
- **Appendix A quick reference** — Scan the checklists to re-engage the workflow discipline.

When you're returning to a project that's been dormant for months:

- **`/dustoff`** — The deeper counterpart to `/checkpoint`. Where `/checkpoint` assumes you know where you are and just need orientation, `/dustoff` re-derives the project's state from scratch: its lifecycle stage (§6), what's stale or broken, and how far the project's adopted conventions have drifted from the current `~/.claude` toolset. It produces a single prioritized re-entry plan and hands each item to the skill that executes it (`/update-deps`, `/readme-refresh`, `/plan-phase`). Read-only — it plans, it doesn't act.

When you suspect drift has occurred:

- **`/drift-check`** — Run it against the current branch to assess alignment. If drift is confirmed, follow the reactive workflow in §3b.

### Project-level skills

These run infrequently but are important bookends:

- **`/bootstrap-prd`** — Run once at project inception. Scaffolds the PRD directory structure from templates in `~/.claude/docs/prd-workflow/templates/`.
- **`/update-deps`** — Run periodically (monthly, or before a major phase). Updates dependencies category by category with testing between each.
- **`/readme-refresh`** — Audit the project README against the codebase, fix outdated versions and stale references, or bootstrap a new README if none exists. Run after phase boundaries, after `/update-deps`, or whenever the README has drifted.

### Lifecycle stage mapping

Skills shift in importance as the project matures (see §6):

| Skill | Greenfield | MVP Complete | Mature |
| ------- | ---------- | ------------ | ------ |
| `/bootstrap-prd` | **Setup** | — | — |
| `/plan-phase` | **Every phase** | Rare (new features only) | — |
| `/setup-sprint` | Optional | Useful for bug batches | Useful for bug batches |
| `/resolve-issue` | **Primary workflow** | **Primary workflow** | **Primary workflow** |
| `/commit` | **Always** | **Always** | **Always** |
| `/simplify` | Pre-PR | Pre-PR | Pre-PR |
| `/drift-check` | **Critical** | Important | Light (living docs) |
| `/create-pr` | **Always** | **Always** | **Always** |
| `/review-pr` | Pre-merge | Pre-merge | Pre-merge |
| `/merge-pr` | **Always** | **Always** | **Always** |
| `/qa-handoff` | Major features | Key changes | Rare |
| `/checkpoint` | Ad-hoc | **Frequent** (transition period) | Ad-hoc |
| `/dustoff` | **On return** | **On return** | **On return** |
| `/debrief` | **Phase boundary** | Milestone reviews | Rare |
| `/update-deps` | Periodic | Periodic | **Regular cadence** |
| `/readme-refresh` | Bootstrap | **Full refresh** | Light periodic |

Note how `/drift-check` intensity tracks project maturity: critical during greenfield when the spec is the primary reference, important during MVP transition, and lighter in the mature stage when living documents replace the PRD. The skill still has value in the mature stage — it just checks against living docs (domain model, integration guides) rather than PRD files.

### Publishing artifacts to remote testers

`/walkthrough` and `/qa-handoff` produce HTML artifacts. A remote tester who is not cloning the repo needs a hosted copy. Publishing is per-project opt-in, declared in the project's own `CLAUDE.md`: a `## QA Publish Target` heading followed by a `yaml` fenced code block containing `repo: <owner>/<pages-repo>` and `subfolder: <project-slug>`. See the bootstrap template at `~/.claude/docs/prd-workflow/templates/CLAUDE.md` for the exact block.

The repo must have GitHub Pages enabled and served from the **default branch** (the Contents API writes there); the live URL is derived as `https://<owner>.github.io/<pages-repo>/<subfolder>/<file>.html`. A user/org-pages repo (named `<owner>.github.io`) is served at the apex with no repo segment — the pipeline detects that and emits the correct URL with a warning so the configuration is visible.

The shared pipeline at `~/.claude/skills/_shared/publish-artifact.sh` reads that block, uploads the HTML via the GitHub Contents API (create or update via SHA), and — when given `--pr <N>` — posts a PR comment with the live link.

If the block is absent or contains placeholder values, the pipeline never guesses a target:

- **`/walkthrough --publish`** falls back to posting the Markdown twin alone as the PR comment (the pre-HTML behaviour).
- **`/qa-handoff --publish`** stays local and prints a warning.

Solo projects (a blog, a one-off prototype) simply omit the block.

### The `/drift-check` skill

The per-PR deviation check from §4 is supported by the `/drift-check` skill.

**When to run:** Before `/create-pr`, after implementation is complete. Also useful ad-hoc when you suspect drift.

**What it would do:**

1. **Identify the relevant spec** — from the branch name, linked issue, or ROADMAP, determine which PRD section or living document this work relates to.
2. **Scan for deviation signals** — review the diff for new models, columns, associations, lifecycle changes, URL patterns, or notification triggers that aren't in the spec.
3. **Check for documentation gaps** — are there uncommitted CHANGELOG entries that should exist? Is the ROADMAP checkbox marked?
4. **Surface questions** — present findings as a checklist, not a pass/fail. The developer (human or AI) decides what needs action.

**What it would NOT do:**

- Automatically update the CHANGELOG or PRD files. Documentation changes should be deliberate.
- Block the PR. It's advisory — a nudge, not a gate.
- Replace human judgment. It surfaces signals; the developer interprets them.

**Design principle:** Lightweight and fast. If running this skill feels like a burden, it won't get used. Target: under 30 seconds for a typical PR.

---

## 8 Lessons from ComixDistro

These observations motivated the workflows above. They're project-specific but illustrate general patterns.

### What went well

- **Modular PRD structure** — 18 files covering distinct feature areas. Easy to find the right spec, easy to update without merge conflicts, easy to hand one file to Claude Code for a focused implementation session.
- **ROADMAP as task list** — one checkbox per PR kept phases organized and progress visible. The phase boundary was a natural checkpoint for sync work.
- **CHANGELOG as deviation log** — the "never silently deviate" rule established the right norm, even when execution was imperfect. Having the rule meant drift was always *recognized* as something to address, not something to ignore.
- **Deviation categories** (Correction / Discovery / Pivot) — these made CHANGELOG entries more useful. "Discovery" in particular helped normalize deviations as learning rather than failure.
- **GitHub Issues as the work queue** — every implementation task flowed through an issue. PRs referenced issues. The board tracked priority. This kept planning and execution connected.

### What we'd do differently

- **Log deviations in real time, not in batches.** The two biggest sync efforts (CHANGELOG fold-back, full PRD sync) were both reactive — catching accumulated drift. The per-PR checkpoint (§4) is designed to prevent this, but it requires discipline. The most common failure mode was Discovery-type deviations: building something the spec didn't anticipate, recognizing it as a deviation, but logging it "later" because the implementation was flowing. "Later" became "much later."
- **Separate planning docs from living docs earlier.** The domain model document should have been reclassified as a living document as soon as it started diverging from the original PRD spec. Instead, it lived as a planning document that was silently becoming authoritative, while the PRD file it was supposed to supplement became stale.
- **Track post-PRD enhancements explicitly.** Enhancement ideas filed as GitHub issues but not reflected in the ROADMAP or any PRD document created a shadow backlog. The periodic audit (§4) caught 8 such issues. Going forward, any issue that represents meaningful new scope should get a ROADMAP entry under Future/Unscheduled, even if it's just a one-liner.
- **Close issues when the work is done, not "later."** Three issues were found open despite the work being completed and marked in the ROADMAP. The per-PR checkpoint should include: "Does this PR close any issues? If so, verify the PR description includes closing keywords."

### The core tension

Spec-driven development creates a productive tension: the spec gives you focus and prevents scope creep, but it can also become a straitjacket if followed too rigidly. The deviation workflow (§3) is designed to hold that tension — respect the spec as the default, but treat divergence as a normal, manageable part of the process rather than a failure to be avoided at all costs.

The spec is a tool for building better software. It is not the software itself.

---

## 9 Companion: PRD Authoring Guide

A companion document covers everything upstream of this workflow — how to write the PRD itself through structured brainstorming with an AI collaborator.

→ See `prd-authoring-guide.md`

Topics covered: when you need a PRD, running discovery conversations, what to specify tightly vs. loosely, structuring for incremental implementation, handling unknowns (TBDs), maintaining PRD usefulness, and a library of brainstorming prompts.

---

## Appendix A: Quick Reference

A condensed version of the key workflows for scanning during active development. When fatigued or returning from a break, start here.

### Before writing code

- [ ] What PRD section (or issue) does this work relate to?
- [ ] Have I read the relevant spec?
- [ ] Am I on a feature branch?

### During implementation — the deviation check

When you encounter something that differs from the spec:

1. Does it cross the threshold? → *Does it change the contract or behavior visible to users or admins?*
2. If yes: **stop, surface, decide, document, then implement.**
3. If unsure: surface it anyway. 30 seconds now saves hours later.

### Before creating a PR

- [ ] Does this PR change anything that differs from the PRD or living docs?
- [ ] If yes, is there a CHANGELOG entry?
- [ ] Does this PR close any issues? Are closing keywords in the PR description?
- [ ] Is the ROADMAP checkbox marked (if applicable)?
- [ ] Have I run linting and tests?

### At a phase boundary

- [ ] Fold all CHANGELOG entries back into source PRD files
- [ ] Mark the phase complete in ROADMAP
- [ ] Review open items in PRD files touched this phase
- [ ] Close any issues completed during this phase
- [ ] Consider: `/debrief` to capture what was built and why

### When drift is discovered

1. Stop — don't compound it.
2. Assess scope — one field or a whole feature area?
3. Log it — CHANGELOG entries, backdated honestly.
4. Decide — revert to spec, adjust, or update the spec.
5. Fold back — update source PRD files if the spec is changing.
6. File issues — for any gaps that need implementation work.

### Returning from a break

- [ ] Run `/checkpoint` to reorient: where am I, what's in flight, what's next?
- [ ] Check `git status` and `git log` — what was the last thing I did?
- [ ] Re-read the issue or ROADMAP item I'm working on.
- [ ] Scan this quick reference to re-engage the workflow discipline.
