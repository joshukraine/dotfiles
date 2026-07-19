---
name: qa-triage-batch
description: Fan out /qa-triage across a queue of qa-labeled reports in parallel, reconcile them across reports to cluster shared root causes, present one consolidated decision gate, and — on approval — create the resulting tech issues.
disable-model-invocation: true
argument-hint: "[report# …]"
---

# QA Triage Batch

Run the open `qa`-labeled reports as a parallel batch: one background subagent per report runs `/qa-triage`'s analysis to its draft, a cross-report pass reconciles all the drafts at once, and a single consolidated gate replaces the N separate per-report STOPs. On approval, the orchestrator creates the tech issues, closes the not-a-bugs, and recommends `/resolve-issue` for trivial-cosmetics.

Use this when a backlog of QA reports has accumulated. For a single report, use `/qa-triage` directly — the batch only earns its keep when there are several, because its real value is **cross-report reconciliation**: a single run is blind to the others, so it can't see that several reports share one root cause. A batch is the only vantage that sees all N at once.

Sibling to `/autopilot-batch` in the autopilot family (Phase 3). It mirrors that skill's _shape_ — announce → fan out → gate → act → report, plus the escape hatch — but its back half differs on purpose (it creates issues rather than merging PRs, gates _before_ creation rather than after, and reconciles across items). The two share conventions, not code.

## Where this runs (read first)

Run this **from the target application repository** — the repo whose `qa` reports and app code these are (e.g. the Rails app). **Not from dotfiles.** You need the reports _and_ the code, because `/qa-triage` confirms every symptom against the source. Unlike `/autopilot-batch`, there is **no worktree dependency** — the fan-out is read-only code investigation (no server, no port 3000, no shared DB, no file writes), so all subagents share the one working tree safely. If the cwd is dotfiles (or any repo that doesn't own these reports), stop and say so.

## Arguments

- **(no args)** — triage every open `qa`-labeled report (minus any already in-flight; see Step 1).
- **`[report# …]`** — scope to the listed reports only (e.g. `503 511 488`). Everything else is untouched. Use this to re-run a subset without re-triaging the whole backlog.

## The model policy — "Opus analyzes, Fable reconciles"

Analysis runs at **Opus 4.8**; the reconcile runs at **Fable**. Unlike `/autopilot-batch`'s fan-out scale — where a cheaper-builds/tier-above-reviews split saves real cost and latency — a QA batch is low-volume (a handful of reports), so there is no cost case for going below Opus on analysis, and classification ("is this a bug or intended behavior?") is judgment work. There is no review floor behind the analysis the way `/autopilot-batch` has one; the **human gate is the only safety net**, so favor quality. The reconcile is the genuinely hard cross-report judgment — the _whole_ reason to batch — and it is a single subagent, so running it at Fable buys the best judgment exactly where it matters most, for a negligible cost delta. Earn a Sonnet-analyze split later (rule of three) only if the volume grows or an obviously-bounded report pattern emerges.

## Escape hatch (batch-level)

A single report that can't be confidently triaged must not halt the batch. If an analysis subagent can't reproduce the symptom in the code, or the report is genuinely ambiguous, it stops and reports — that report is surfaced at the consolidated gate as **"needs your eyes,"** never silently dropped, and nothing is drafted for it. One uncertain report never stops the rest. Halt the _whole_ batch only for a systemic problem: the cwd is the wrong repo, or there are no open `qa` reports to triage.

## Your task

Announce the run first: how many `qa` reports are open, how many are being triaged vs. skipped as already in-flight (Step 1), and that you will fan out one background subagent per report.

### Step 0 — Preconditions

- Confirm the cwd is the target app repo (see "Where this runs"), on a clean default branch, then `git pull`.
- Resolve the invoker once: `gh api user --jq .login`. Each report's analysis needs it to decide the verification @-mention (skip the mention when author == invoker), and the orchestrator needs it again when acting.

### Step 1 — Assemble the batch (self-healing)

- `gh issue list --label qa --state open --json number,title,author,body`. If scoped by arg, restrict to those numbers.
- **Skip reports already in-flight.** A report that has already been triaged carries a tech issue back-referencing it (`Triggered by QA report #<n>`). Drop those — they are being handled, not pending. Use search only to _narrow_, then confirm the exact back-reference client-side — GitHub full-text search tokenizes `#<n>` loosely, so it neither guarantees the exact number nor an exact phrase, and matching on it alone would both miss links and skip the wrong reports:

  ```bash
  # Fetch every issue carrying the back-reference phrase, then filter by exact substring.
  gh issue list --state all --search 'Triggered by QA report in:body' \
    --json number,body \
    --jq '[.[] | select(.body | contains("Triggered by QA report #<n>")) | .number]'
  ```

  A non-empty result means report `<n>` is already linked — skip it. This mirrors `/autopilot-triage`'s self-heal (which keys on a structured `headRefName` match for existing PRs), keyed here on an exact body substring instead. Report what was skipped and why.
- If nothing remains: stop — the QA queue is clear.

### Step 2 — Fan out the analysis

For each report, spawn a **background** subagent:

- `model: opus`, `run_in_background: true`. **No `isolation: worktree`** — read-only investigation, shared tree is safe.
- prompt: run `/qa-triage <n>` through its analysis and draft (steps 1–5) and **STOP at its decision gate (step 6). Create, comment on, close, and edit nothing** — you have no human to approve, and the skill's gate is exactly where you halt. Then return, as the final message, a **structured triage record** (not prose):

  ```text
  report:        #<n> — <title>
  author:        <login>   (mention: <@author | skip: == invoker | skip: bot>)
  bucket:        not-a-bug | trivial-cosmetic | one-issue | multiple
  root_cause:    <one-line root cause grounded in the code>
  files:         <the file(s)/surface the fix touches>   ← the clustering key
  drafts:        <for each proposed tech issue: title, full body, labels, closing plan>
  ambiguities:   <anything to raise at the gate — or "none">
  escape_hatch:  <"" | "STOPPED — <why>: couldn't confirm / genuinely ambiguous">
  ```

Spawn them together so they run in parallel. Since they create nothing, there is no per-report label lifecycle to manage and no worktree to reclaim.

### Step 3 — Barrier + reconcile

Wait for **all** analysis subagents (this is a genuine barrier — cross-report clustering needs every record). Then spawn one **`model: fable`** reconcile subagent, passing it all N structured records:

- prompt: cluster reports that **share a root cause** (overlapping `root_cause` / `files` → one tech issue that closes _all_ of them — see the cluster closing plan in Step 5), flag **duplicate drafts** to collapse, and flag **conflicts** (two reports asking for opposite behavior). Return the clusters **as suggestions with a one-line rationale each — never auto-merge.** A report that doesn't cluster stays standalone.

The reconcile _proposes_; the human disposes. Do not collapse drafts on the reconcile's say-so alone.

### Step 4 — Consolidated gate — STOP

Present **one** board-level view — every report's classification, its drafted issue(s), and the reconcile's proposed clusters — grouped so the shared-root-cause suggestions are visible:

```text
Cluster A — order.rb weight rounding (reconcile: high confidence)
  #503  one-issue   fix: round shipment weight up      @tester1
  #511  one-issue   [dup of #503 draft — collapse?]    @tester2

Ungrouped
  #488  not-a-bug   event_type unvalidated by design   @tester3
  #492  trivial     typo in uk.yml checkout label       → /resolve-issue
  #495  STOPPED     can't reproduce in code — needs your eyes

Approve / edit / decline / reclassify across the batch?
```

Show the full drafted body for each proposed issue (or write drafts to temp files and reference them — you need those files anyway for `--body-file` in Step 5). Then **STOP and wait.** The human may approve as-is, accept or split a cluster, edit a draft, reclassify a report, decline one (e.g. close as working-as-intended), or defer. **Create, close, comment on, and edit nothing before a clear yes.**

### Step 5 — Act on approval

The orchestrator acts centrally (not the subagents), applying `/qa-triage`'s closing-keyword hazard and each issue's closing plan in one place:

- **Create** each approved tech issue as drafted: `gh issue create --title … --body-file <tmp> --label <type>`; remove the temp file after. The `/qa-triage` draft already carries its closing plan — a standalone `Closes #<tech>, Closes #<qa> — please verify after deploy, @<author>`, or, when `/qa-triage` split one report into several issues (the "multiple" bucket), that report's multi-PR plan where only the final issue's PR closes the report. Create those as drafted; don't rewrite them.
- **Clustered reports (N reports → 1 issue):** the batch's own case — `/qa-triage` never sees a cluster, so the closing plan is the orchestrator's to write. Create **one** merged tech issue whose single PR closes the tech issue **and every clustered report at once**: `Closes #<tech>, Closes #<qa1>, Closes #<qa2>, … — please verify after deploy, @<author1> @<author2>` (each `Closes` keyword sits directly before its own `#N`; @-mention each report's author, skipping any that == invoker). This is the opposite mapping from `/qa-triage`'s multi-PR rule (1 report → N issues) — do not conflate them.
- **Board:** if the project uses a GitHub Projects board, add the new issue(s); otherwise skip.
- **Not-a-bug** (approved): post the agreed explanatory comment and close the QA report, with the verification @-mention (skip if author == invoker).
- **Trivial-cosmetic** (approved): do **not** implement — this skill produces planning artifacts, not fixes. Surface the recommended `/resolve-issue <qa-N>` command in the report; its closing PR must still carry the report's `Closes #<qa> — please verify after deploy, @<author>` line.
- The QA reports for non-trivial work stay **open** — they close only when the implementing PR merges (per each closing plan).

### Step 6 — Completion report + handoff

Post a batch summary:

```text
## QA triage batch — N reports

| Report | Bucket | Action | Result |
| ------ | ------ | ------ | ------ |
| #503   | one-issue (cluster A) | created #560 | open — awaiting fix |
| #511   | one-issue (cluster A) | folded into #560 | open — awaiting fix |
| #488   | not-a-bug | closed w/ comment @tester3 | done |
| #492   | trivial   | → /resolve-issue 492 | recommended |
| #495   | —         | STOPPED — needs you | pending |

- Created: <list of tech issues>.  Closed: <not-a-bug reports>.  Stopped: <reports needing you>.
- Next: the created tech issues are ready for /autopilot-triage to vet into the autopilot queue,
  then /autopilot-batch to fan them out to PRs.
```

## Important

- **Run from the target app repo, never dotfiles** — you need the reports and the code together.
- **The subagents create nothing.** Every analysis subagent stops at `/qa-triage`'s own gate and returns a draft; all creation/closing happens once, centrally, only after the consolidated human gate. This is the load-bearing guardrail.
- **Cross-report reconciliation is the point.** Speed is a bonus; seeing all N at once to cluster shared root causes is the reason to batch. The reconcile _suggests_ clusters — the human confirms.
- **One consolidated gate, not N.** The batch's whole ergonomic win is replacing N per-report STOPs with a single board-level decision.
- **One stop never halts the batch.** A report that can't be confidently triaged is surfaced at the gate for you; the rest proceed.
- **Compose, don't re-implement.** Subagents run the real `/qa-triage`; this skill only orchestrates the fan-out, the reconcile, the gate, and the central act-on-approval — so improvements to `/qa-triage` flow through untouched. It does **not** implement fixes (that stays `/resolve-issue` → PR, optionally via `/autopilot-batch`), and it is a sibling skill, not a flag on `/autopilot-batch` — do not extract a shared batch engine (still under rule-of-three).
