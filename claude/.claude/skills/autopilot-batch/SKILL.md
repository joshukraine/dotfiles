---
name: autopilot-batch
description: Fan out a batch of autopilot-queued issues to parallel background worktree subagents — each runs /autopilot — with an Opus gating review on every Sonnet-built PR.
disable-model-invocation: true
argument-hint: "[--merge <issue#,…>]"
---

# Autopilot Batch

Run the vetted `autopilot-queued` queue as a parallel batch: one background `isolation: worktree` subagent per issue, each running `/autopilot <n>` end-to-end, with an Opus gating `/code-review` on every PR a Sonnet subagent builds. This is the **run** half of the triage → run split; `/autopilot-triage` is the **vet** half that fills the queue.

Use this when you have a queue of independent, well-scoped issues and want them all carried to review-ready PRs in one unattended pass. For a single issue, use `/autopilot` directly.

## Where this runs (read first)

Run this **from the target application repository** — the repo whose issues and app these are (e.g. the Rails app) — on a clean default branch, pulled up to date. **Not from dotfiles.** `isolation: worktree` creates each worktree from the _orchestrator's current repo_, so the cwd decides where the fan-out worktrees land; running from the wrong repo produces worktrees of the wrong tree. If the cwd is the dotfiles repo (or any repo that doesn't own these issues), stop and say so.

## Arguments

- **(no args)** — run every `autopilot-queued` issue at tier `--to pr`. The whole batch stops at review-ready PRs; nothing merges.
- **`--merge <issue#,…>`** — authorize tier `--to merge` for the listed issues only (e.g. `--merge 847,851`). Everything else stays `--to pr`. Merge is still gated per issue by `/autopilot`'s Step 8 narrow-class gate, which degrades any non-qualifying issue back to `--to pr`. Passing `--merge` IS your per-issue authorization to merge those issues; it is not a standing capability.

Default tier is `--to pr` by design — merge is opt-in, per issue, never batch-wide.

## The build-model policy — "Sonnet builds, Opus reviews"

Each issue's _build_ subagent runs at a model chosen for the issue's class; the _gating review_ is always Opus. Assign the build model per issue by reading its labels and scope:

- **Opus 4.8** — data-model / migrations, auth / security boundaries, inventory / shipment correctness, thin or ambiguous specs, cross-cutting refactors. Also the model whenever you genuinely can't tell the class (safe default — Opus never under-builds).
- **Sonnet 5** — bounded, well-specified, pattern-following work: i18n / copy, views / Tailwind, config, a single test, straightforward CRUD, docs.

State each issue's model and a one-line why at the confirm gate. The Opus gating review (Step 4) is the structural safety net — a Sonnet under-build is caught and fixed there, never shipped — so leaning on Sonnet for the bulk is close to free on quality and a real save on cost and latency at fan-out scale.

### Merge issues are always Opus-built

A build subagent runs the whole `/autopilot` loop at **one** model (a subagent can't switch mid-run), so whichever model builds a `--to merge` issue also makes its merge go/no-go inside `/autopilot` Step 8. The floor is non-negotiable: the merge decision is always Opus. Therefore: **any issue opted into `--to merge` is built by Opus**, regardless of what its class-rubric would otherwise pick. Sonnet only ever builds `--to pr` issues, which stop at a review-ready PR and are Opus-reviewed (Step 4) before you see them. This keeps every autonomous merge Opus-decided without the orchestrator having to re-implement the merge gate. The cost — not using Sonnet for the rare, narrow merge class — is negligible because `--to merge` is opt-in and uncommon.

## Escape hatch (batch-level)

A single issue stopping must not halt the batch. If a build subagent hits `/autopilot`'s own escape hatch (a complex/ambiguous issue, a guardrail decision, an unresolvable failure), it stops and reports — that issue is left for you, keeps its queue label, and the rest of the batch continues. Surface every stop prominently in the final report. Stop the _whole_ batch only for a systemic problem: the cwd is the wrong repo, auth to the remote is failing for everyone, or the queue is empty.

## Your task

Announce the run first: how many issues are queued, the tier split (all `--to pr`, or which are `--to merge`), and that you will fan out one background worktree subagent per issue.

### Step 0 — Preconditions

- Confirm the cwd is the target app repo (see "Where this runs"), on a clean default branch, then `git pull`.
- **Pre-warm one push approval.** Run a single `git ls-remote origin` up front so any SSH-agent signing approval is granted once, before fan-out — the batch then runs unattended. (Per-push resilience during the run is already handled inside `/autopilot`: transient `sign_and_send_pubkey … communication with agent failed` errors are retried with backoff.)

### Step 1 — Assemble the batch

- `gh issue list --label autopilot-queued --state open --json number,title,labels`.
- If the list is empty: stop — nothing is queued. Recommend `/autopilot-triage` to vet candidates and fill the queue.
- Build the run plan: for each issue, its assigned build model (+ a one-line why) and its tier (`pr`, or `merge` if named in `--merge` — and remember a `--merge` issue is forced to an Opus build).

**CONFIRM GATE:** Present the run plan — issue list, per-issue model, per-issue tier — and get a go-ahead before spawning. Membership was already vetted at triage; this is a light confirm that the models and tiers are right and the queue is still current, plus your chance to override a model call. Not a re-litigation of the queue.

### Step 2 — Fan out the builds

For each issue, spawn a **background** subagent:

- `isolation: worktree` — its own checkout, so parallel edits across issues can't collide.
- `run_in_background: true` — they run concurrently.
- `model:` the issue's assigned build model (Sonnet or Opus per the policy above; Opus for any `--to merge` issue).
- prompt: run `/autopilot <n> --to <tier>` to completion — running any `bin/ci` invocation serially (`PARALLEL_WORKERS=1 bin/ci`; see the serial-CI note under **Important**) — then report back, as the final message, the PR number and URL, the loop outcome (which steps ran / were n·a), a one-line summary of the change, and, if it stopped at the escape hatch, exactly where and why.

Spawn them together so they run in parallel. Each subagent lands on an auto-named worktree branch (`worktree-agent-…`); inside it, `/autopilot` → `/resolve-issue` creates the proper `feat/gh-<n>-…` branch, commits, pushes, and opens the PR from it. Nothing to pre-create.

### Step 3 — As each build finishes

When a build subagent reports a review-ready PR:

- **Drop the queue label:** `gh issue edit <n> --remove-label autopilot-queued`. The issue is now in-flight, not pending — lifecycle-contract step 3.
- If the build model was **Sonnet**, kick off its Opus gating review (Step 4) right away — don't wait for the whole batch. If the build model was **Opus**, its internal `/code-review` already ran at Opus, so no orchestrator review is needed; it's review-ready as-is.

A subagent that **stopped** at the escape hatch keeps its `autopilot-queued` label (still pending) and is set aside for the final report — do not review or merge it.

### Step 4 — Opus gating review (Sonnet-built PRs only)

For each PR built by a **Sonnet** subagent, spawn an **Opus** review subagent:

- `model: opus`, `isolation: worktree`.
- prompt: check out the PR branch (`gh pr checkout <PR>`), run `/code-review` at `high` (escalate to `max` for a large or security-/data-sensitive diff), fix real correctness bugs and clear quality wins, commit and push (this updates the open PR), then re-run `bin/ci` **serially** (`PARALLEL_WORKERS=1 bin/ci`; see the serial-CI note under **Important**) so the required sign-off attaches to the final commit. Report the verdict: clean / _N_ fixes applied / a finding that needs a product decision (→ flag it for the human, don't guess).

This is the Opus floor: it runs on every Sonnet build before the PR is "review-ready" for you, so a Sonnet miss is caught and fixed, never shipped. `--to merge` issues don't pass through here — they were Opus-built and Opus-reviewed inside their own `/autopilot` run, and merged there only if the narrow-class gate passed.

### Step 5 — Reclaim worktrees

Fan-out worktrees that produced commits are **not** auto-removed. After the batch settles, reclaim them: `git worktree list` to find the leftover `…/worktrees/agent-*` entries, `git worktree remove --force <path>` each finished one, then `git worktree prune`. The branches live on the remote (pushed as `feat/gh-<n>-…`), so removing the local worktrees is safe.

## Completion report

Post a batch summary:

```text
## Autopilot batch — N issues

| Issue | PR | Build | Review | Outcome |
| ----- | -- | ----- | ------ | ------- |
| #847  | #M | Opus   | (internal) | merged + deployed ✓ |
| #851  | #P | Sonnet | clean       | PR-ready |
| #863  | #Q | Sonnet | 2 fixes     | PR-ready |
| #870  | —  | —       | —          | STOPPED — <reason>, needs you |

- Queue: <k> resolved to PRs, <j> stopped and still labeled `autopilot-queued`.
- Merged: <list, or none — all held at PR-ready>.
- Your call: review + `/merge-pr` on the PR-ready ones; pick up the stopped issues.
```

## Important

- **Run from the target app repo, never dotfiles** — the worktree isolation depends on it.
- **Default is `--to pr` for the whole batch.** Only issues named in `--merge` can merge, and only through `/autopilot`'s narrow-class gate; a mislabeled one degrades to `--to pr` inside its own run.
- **Every autonomous merge is Opus-decided** — `--merge` issues are Opus-built, so the merge go/no-go is Opus. Every Sonnet build is Opus-reviewed (Step 4) before it reaches you.
- **One stop never halts the batch.** A stopped issue is set aside with its label intact; the rest continue. A wrong merge is the only truly bad outcome, and the gates above prevent it.
- **Compose, don't re-implement.** Build subagents run the real `/autopilot`; review subagents run the real `/code-review`. This skill only orchestrates, gates the model floor, and manages the queue label and worktrees — so improvements to those skills flow through untouched.
- **Run `bin/ci` serially in the batch (`PARALLEL_WORKERS=1 bin/ci`).** Several worktree subagents run `bin/ci` at once, and on macOS the parallel Minitest system-test workers fork-starve under that combined load — producing flaky failures and fork-crash storms that aren't real, then costly retries. A single test worker sidesteps it. This applies to both the build subagents' internal `bin/ci` (Step 2) and the Opus gating review's `bin/ci` (Step 4). It is batch-scoped: standalone `/autopilot` runs (one worktree, no contention) can stay parallel.
