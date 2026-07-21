---
name: autopilot-triage
description: Vet open issues for autonomous resolution and queue the qualifying ones with the autopilot-queued label — the start-of-day "fill the queue" half of the triage → run split.
argument-hint: "[label-or-filter]"
---

# Autopilot Triage

Vet a pool of open issues against the autonomy rubric and, after your confirmation, tag the ones that qualify with the `autopilot-queued` label. `/autopilot-batch` later reads that label and runs the batch. This is the **vet** half of the triage → run split; the two are decoupled on purpose — triage once (cheap, start-of-day), run the batch whenever and from wherever.

The `autopilot-queued` label is **membership only**: it means "vetted and pending," nothing more. Tier is decided at run time by your `--merge` opt-in, never encoded in it. The build model rides on a separate, pre-existing label (`model: fable` / `model: opus` / `model: sonnet`) that issue triage assigns — this skill **reports** that label, it does not assign one.

## Where this runs

Run from the **target application repository** — you need the issues _and_ the code, because vetting scope means looking at what a fix would actually touch. Triage is read-only except for the label writes it makes _after_ your confirm.

## Arguments

- **(no args)** — vet all open issues.
- **`[label-or-filter]`** — narrow the candidate pool, e.g. a phase label or `chore` / `fix`. Passed through to `gh issue list --label`.

## The autonomy rubric

An issue **qualifies** for autopilot when all hold:

- **Complete spec** — clear acceptance criteria; you could hand it off with no back-and-forth.
- **Bounded scope** — a few files, one subsystem, a known pattern to follow (the positive exemplar: a "localize these hardcoded strings" i18n issue).
- **No product / UX / design decision** — nothing that needs your judgment about _what_ to build.
- **Testable** — its resolution can be proven by the suite (or a targeted inline check).

An issue is **disqualified** when it trips any of `/autopilot`'s own escape-hatch triggers — the same guardrails, applied _before_ the run instead of during it:

- a new DB column / migration, a changed model association, an altered public route, a new dependency, or an event-status-lifecycle change;
- a thin or ambiguous spec, or one that conflicts with the code;
- multiple subsystems, a real design choice, or anything you'd want to review mid-flight.

When a candidate is borderline, **disqualify it** — a false negative costs you one manual issue; a false positive burns an unattended run on something that should have stopped. State a one-line reason for every skip; those reasons are useful signal.

For each qualifying issue, also note — as a **preview**, not a commitment:

- **Build model** — **report the issue's `model:` label** if it has one; that label is what `/autopilot-batch` will actually build with (see `~/.claude/docs/model-selection-strategy.md`). If it has none, preview the rubric fallback the batch will use instead — Opus for data-model / security / ambiguous / cross-cutting; Sonnet for bounded pattern-work (i18n / views / config / a single test / CRUD / docs) — and mark it as a preview, not a fact. Either way this is so you can eyeball and adjust before the run. (A `--merge` opt-in overrides both at run time: merge issues are always Fable-built, because the merge go/no-go runs at the build model and the merge floor is Fable.)
- **Missing `model:` label in an adopted repo** — flag it. Check adoption once per run:

  ```bash
  gh label list --json name --jq '[.[].name | select(startswith("model: "))]'
  ```

  A non-empty result means the repo has adopted the convention, so a queued issue without a `model:` label is a **triage gap** — worth fixing, but never a reason to skip the issue. The batch treats it as Opus by convention via the rubric. Do not apply the label yourself: model tiering is assigned when the issue is triaged, and quietly stamping a tier here would launder a guess into the record. Point the gap at **`/model-triage --maintenance`**, which is the skill that owns that write.
- **Merge-tier candidate?** — flag issues that look safe for `--to merge` (confined to config / locales / views / copy; no migration / route / dependency). These are _suggestions_ you opt into with `--merge` at run time; the batch defaults everything to `--to pr`.

## Your task

### Step 1 — Reconcile (self-healing)

Before proposing anything, clean the existing queue so an interrupted prior run can't leave stale membership:

- `gh issue list --label autopilot-queued --state open --json number,title`.
- For each, check whether a PR already exists for it — a branch named for the issue:

  ```bash
  gh pr list --state all --json number,headRefName,state \
    --jq '.[] | select(.headRefName | test("gh-<n>-"))'
  ```

- If a PR exists (open or merged), the issue is in-flight or done, not pending — strip the label: `gh issue edit <n> --remove-label autopilot-queued`.
- Report what was reconciled (or "queue clean — nothing to reconcile").

### Step 2 — Gather candidates

- `gh issue list --state open [--label <filter>] --json number,title,labels,body`.
- Drop any already labeled `autopilot-queued` (already vetted) or already carrying a PR (from Step 1's check).

### Step 3 — Vet

Assess each candidate against the rubric — read the issue body and, where scope is unclear, the code a fix would touch. Assign a verdict (queue / skip), a one-line why, and for queue candidates the build model (from its `model:` label, or a rubric preview if unlabeled) + merge-tier flag.

### Step 4 — Present + CONFIRM GATE

Present the triage table — proposed queue and skips together, so the exclusions are visible:

```text
Queue:
  #851  Sonnet (label)   pr     localize checkout flash messages — complete spec, i18n pattern
  #863  Sonnet (label)   merge? copy tweak on the about page — config/copy only, no code paths
  #847  Opus (label)     pr     recompute shipment weight rounding — bounded but touches money math
  #855  Opus (no label!) pr     backfill the shipment CSV export — no `model:` label, rubric preview

Skip:
  #870  needs a data-model decision (new column not in the schema)
  #872  spec ambiguous — two conflicting acceptance criteria

Model-label gaps (adopted repo): #855 — run `/model-triage --maintenance` to fill it.
```

**CONFIRM GATE:** This is the human gate the lifecycle requires — the label is applied **only after you confirm**. Present the proposed queue and wait. You may trim, add, or adjust a model call. Nothing is labeled before you say go.

### Step 5 — Apply the label

Only after confirmation:

- Ensure the label exists (first run bootstraps it): `gh label list` and look for `autopilot-queued`; if absent, create it:

  ```bash
  gh label create autopilot-queued \
    --description "Vetted by /autopilot-triage; pending an /autopilot-batch run" \
    --color 5319e7
  ```

- For each confirmed issue: `gh issue edit <n> --add-label autopilot-queued`.

### Step 6 — Report + handoff

Summarize: how many were queued (list + build model with its source + which are merge-tier candidates), how many reconciled/removed, how many skipped (with reasons), and any `model:` label gaps in an adopted repo. Then the handoff:

> Queue ready — _N_ issues. Run it from this repo with `/autopilot-batch`. To authorize merge for the flagged candidates, add `--merge <#,#>`.

## Important

- **The confirm gate is a hard stop.** The label is never applied speculatively — only issues you approve get queued (lifecycle step 1).
- **Membership only.** `autopilot-queued` encodes neither model nor tier. Tier is a run-time decision; the model comes from the issue's own `model:` label (or the batch's rubric fallback). Do not invent autopilot-specific tier labels, and do not apply a `model:` label here — report what triage assigned, and flag what it missed.
- **Reconcile first, always.** Every run self-heals the queue before proposing, so a crashed or interrupted prior run leaves no stale membership.
- **Decoupled by design.** Triage and run are separate sessions on purpose — vet cheaply now, run the batch later / from anywhere. Do not fold the batch run into this skill.
- **When borderline, skip.** Autopilot's value is unattended throughput on issues that genuinely don't need you; a wrongly-queued issue that should have stopped defeats that.
