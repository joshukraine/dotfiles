# Spec-Driven Development Workflow

A collaborative workflow for building software against a Product Requirements Document (PRD). Designed for a technical executive working with Claude Code — both parties use this document as a shared reference.

Informed by lessons learned building ComixDistro (13 phases, 380+ PRs, 18 PRD files).

**Platform assumptions:** This workflow assumes GitHub as the hosting platform and the `gh` CLI for issue tracking, pull requests, and CI integration. The principles (modular specs, deviation tracking, checkpoint cadence) are platform-agnostic, but the slash commands and specific procedures rely on GitHub tooling. Adapting to GitLab, Bitbucket, or other platforms would require substituting the `gh`-based steps with equivalent tooling.

---

## §1 PRD Structure Conventions

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

## §2 The Deviation Threshold

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

## §3 The Deviation Workflow

Deviations from the spec are a natural, expected part of building software. The spec represents your best thinking at planning time; implementation reveals what planning couldn't anticipate. The goal isn't to prevent all deviations — it's to handle them deliberately rather than accidentally.

Two workflows address this: a **proactive** path for deviations caught before implementation, and a **reactive** path for drift discovered after the fact. Both are normal. Hitting the reactive path isn't a failure — it's an expected part of the lifecycle.

### §3a Proactive workflow — deviation recognized before implementation

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

### §3b Reactive workflow — drift discovered after the fact

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

## §4 Checkpoint Cadence

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

## §5 Document Lifecycle

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

---

## §6 PRD Lifecycle — From Greenfield to Mature

A PRD is not a permanent fixture. It has a lifecycle that mirrors the project's maturity. Understanding where you are in that lifecycle determines how tightly you lean on the PRD and what role it plays in day-to-day work.

### Stage 1: Greenfield (building against the spec)

The PRD is the primary driver. The ROADMAP is the work queue. Every implementation task traces back to a PRD section.

**Characteristics:**

- ROADMAP checkboxes are the unit of work. One checkbox = one PR.
- Deviation tracking is at its most rigorous — the spec is fresh and the system is being shaped.
- The CHANGELOG is active. New entries appear regularly as implementation reveals things the spec didn't anticipate.
- Slash commands like `/plan-phase`, `/resolve-issue`, and `/create-pr` drive the development cycle.

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

## §7 Slash Commands in the Development Cycle

Slash commands are the operational backbone of spec-driven development. They encapsulate consistent, repeatable behavior at each stage of the workflow — reducing cognitive load, fighting fatigue, and ensuring steps aren't skipped.

This section maps every command to its place in the development cycle. Think of it as the answer to: "What command do I run right now?"

### The command library

| Command | Purpose | Cadence |
| ------- | ------- | ------- |
| `/bootstrap-prd` | Scaffold PRD structure for a new project | Once per project |
| `/plan-phase` | Create GitHub issues from a PRD phase | Once per phase |
| `/setup-sprint` | Create parallel worktrees for a batch of issues | Per sprint (optional) |
| `/resolve-issue` | Implement a complex issue with planning checkpoint | Per issue |
| `/sprint-issue` | Quick-resolve a small, well-scoped issue | Per issue (lightweight) |
| `/commit` | Stage and commit with Conventional Commits message | Multiple per issue |
| `/simplify` | Review changed code for reuse, quality, efficiency | Pre-PR |
| `/drift-check` | Deviation check against the spec | Pre-PR |
| `/create-pr` | Create PR with issue linking and ROADMAP update | Per issue |
| `/review-pr` | Analyze a PR for quality issues | Pre-merge |
| `/merge-pr` | Squash merge, clean up branch, pull latest main | Post-review |
| `/qa-handoff` | Generate a hands-on QA testing guide | Per feature (when needed) |
| `/checkpoint` | Quick status check: where am I, what's next | Ad-hoc / returning from break |
| `/debrief` | Detailed walkthrough of completed work | Phase boundary |
| `/update-deps` | Update dependencies with testing between categories | Periodic maintenance |

> **Note:** `/simplify` is a built-in Claude Code skill, not a custom command in `~/.claude/commands/`. All other commands listed above are custom command definitions. When invoking `/simplify`, Claude Code loads it automatically as a skill — there is no `.md` file to maintain for it.

### The PR cycle (inner loop)

This is where most development time is spent. One pass through this cycle produces one PR.

```text
1. Pick an issue
   └─ /resolve-issue N        (complex: planning checkpoint, then implement)
   └─ /sprint-issue N          (small: straight to implementation)

2. Implement
   └─ /commit                  (multiple times — small, frequent commits)

3. Quality check
   └─ /simplify                (code reuse, efficiency, readability)

4. Deviation check
   └─ /drift-check             (spec alignment — see below)

5. Create PR
   └─ /create-pr --issue N     (links issue, updates ROADMAP)

6. Review
   └─ /review-pr               (quality, security, correctness)

7. Merge
   └─ /merge-pr                (squash merge, clean up, pull main)
```

Steps 3 and 4 are the pre-PR quality gates. `/simplify` looks at the code itself; `/drift-check` looks at the code's relationship to the spec. Together they catch both implementation quality issues and specification drift before the PR is created.

Step 7 closes the loop. `/merge-pr` encapsulates the merge preferences (squash merge by default), cleans up the feature branch, and pulls the latest main — ensuring a consistent end state after every PR.

### Phase planning

At the start of each phase:

1. **`/plan-phase`** — Read the relevant PRD files, create GitHub issues with acceptance criteria and implementation order. This is a planning-only command — no code is written.
2. **`/setup-sprint`** *(optional)* — If the phase contains a batch of small, independent issues (common for chore or fix batches), create parallel worktrees. Each worktree gets its own branch and can be worked independently.

### Phase boundary

At the end of each phase:

1. **`/checkpoint`** — Quick status: what's done, what's in flight, what's next. Health check on tests and linting.
2. **`/debrief`** — Detailed walkthrough for the project owner. Covers what was built, architecture decisions, test coverage, and a product tour. Produces a permanent record in `docs/debriefs/`.
3. **Manual: phase boundary sync** — Fold back CHANGELOG entries, update ROADMAP, close stale issues, review open items. (See §4 "Phase boundary checkpoint" for the full checklist.)

The `/debrief` is the natural place to surface drift that was missed during the PR cycle — reviewing the full body of work at phase end often reveals patterns that individual PRs didn't.

### Recovery and reorientation

When you're disoriented, fatigued, or returning from a break:

- **`/checkpoint`** — Reorient. Where am I in the ROADMAP? What's in flight? What are the next 2–3 items? This is the "where was I?" command.
- **Appendix A quick reference** — Scan the checklists to re-engage the workflow discipline.

When you suspect drift has occurred:

- **`/drift-check`** — Run it against the current branch to assess alignment. If drift is confirmed, follow the reactive workflow in §3b.

### Project-level commands

These run infrequently but are important bookends:

- **`/bootstrap-prd`** — Run once at project inception. Scaffolds the PRD directory structure from templates in `~/.claude/templates/`.
- **`/update-deps`** — Run periodically (monthly, or before a major phase). Updates dependencies category by category with testing between each.

### Lifecycle stage mapping

Commands shift in importance as the project matures (see §6):

| Command | Greenfield | MVP Complete | Mature |
| ------- | ---------- | ------------ | ------ |
| `/bootstrap-prd` | **Setup** | — | — |
| `/plan-phase` | **Every phase** | Rare (new features only) | — |
| `/setup-sprint` | Optional | Useful for bug batches | Useful for bug batches |
| `/resolve-issue` | **Primary workflow** | **Primary workflow** | **Primary workflow** |
| `/sprint-issue` | Chore batches | Common | Common |
| `/commit` | **Always** | **Always** | **Always** |
| `/simplify` | Pre-PR | Pre-PR | Pre-PR |
| `/drift-check` | **Critical** | Important | Light (living docs) |
| `/create-pr` | **Always** | **Always** | **Always** |
| `/review-pr` | Pre-merge | Pre-merge | Pre-merge |
| `/merge-pr` | **Always** | **Always** | **Always** |
| `/qa-handoff` | Major features | Key changes | Rare |
| `/checkpoint` | Ad-hoc | **Frequent** (transition period) | Ad-hoc |
| `/debrief` | **Phase boundary** | Milestone reviews | Rare |
| `/update-deps` | Periodic | Periodic | **Regular cadence** |

Note how `/drift-check` intensity tracks project maturity: critical during greenfield when the spec is the primary reference, important during MVP transition, and lighter in the mature stage when living documents replace the PRD. The command still has value in the mature stage — it just checks against living docs (domain model, integration guides) rather than PRD files.

### The `/drift-check` command

The per-PR deviation check from §4 is supported by the `/drift-check` command.

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

**Design principle:** Lightweight and fast. If running this command feels like a burden, it won't get used. Target: under 30 seconds for a typical PR.

---

## §8 Lessons from ComixDistro

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

## §9 Future: PRD Authoring Guide

A companion document on writing effective PRDs is planned but not yet written. Topics to cover:

- How to run a productive brainstorming session that surfaces requirements without getting lost
- What to specify tightly (data models, lifecycles, authorization rules) vs. what to leave flexible (UI details, helper naming, CSS choices)
- How to handle TBDs — when to resolve them upfront vs. when to defer with enough context for future resolution
- Structuring a PRD for incremental implementation (phases, dependencies, MVP boundaries)
- Prompts and guidelines for developing a PRD through iterative discussion with an AI collaborator
- Balancing thoroughness with maintainability — a spec that's too detailed becomes a burden to keep current

This will be a separate document at `~/.claude/docs/prd-authoring-guide.md`.

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
