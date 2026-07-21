---
name: autopilot-batch
description: Fan out a batch of autopilot-queued issues to parallel background worktree subagents — each runs /autopilot at the build model from its 'model:' label — with a gating review one model tier above every build (Opus reviews Sonnet builds, Fable reviews Opus builds).
disable-model-invocation: true
argument-hint: "[--merge <issue#,…>]"
---

# Autopilot Batch

Run the vetted `autopilot-queued` queue as a parallel batch: one background `isolation: worktree` subagent per issue, each running `/autopilot <n>` end-to-end at the build model its `model:` label calls for, with a gating `/code-review` one model tier above every build (Opus for Sonnet-built PRs, Fable for Opus-built PRs). This is the **run** half of the triage → run split; `/autopilot-triage` is the **vet** half that fills the queue.

Use this when you have a queue of independent, well-scoped issues and want them all carried to review-ready PRs in one unattended pass. For a single issue, use `/autopilot` directly.

## Where this runs (read first)

Run this **from the target application repository** — the repo whose issues and app these are (e.g. the Rails app) — on a clean default branch, pulled up to date. **Not from dotfiles.** `isolation: worktree` creates each worktree from the _orchestrator's current repo_, so the cwd decides where the fan-out worktrees land; running from the wrong repo produces worktrees of the wrong tree. If the cwd is the dotfiles repo (or any repo that doesn't own these issues), stop and say so.

## Arguments

- **(no args)** — run every `autopilot-queued` issue at tier `--to pr`. The whole batch stops at review-ready PRs; nothing merges.
- **`--merge <issue#,…>`** — authorize tier `--to merge` for the listed issues only (e.g. `--merge 847,851`). Everything else stays `--to pr`. Merge is still gated per issue by `/autopilot`'s Step 8 narrow-class gate, which degrades any non-qualifying issue back to `--to pr`. Passing `--merge` IS your per-issue authorization to merge those issues; it is not a standing capability.

Default tier is `--to pr` by design — merge is opt-in, per issue, never batch-wide.

## The build-model policy — the label decides the build, review runs one tier above

Each issue's _build_ subagent runs at a model chosen per issue; the _gating review_ always runs **one model tier above that build**. Ladder, cheapest to most capable: **Sonnet 5 → Opus 4.8 → Fable 5**.

### Resolving each issue's build model

**Read the issue's `model:` label first.** Repos that have adopted the per-issue model convention (`~/.claude/docs/model-selection-strategy.md`) carry one on every open issue, recording the build tier assigned at triage. Step 1's issue list already returns labels, so no extra call is needed:

- `model: sonnet` → build with **Sonnet 5**; `model: opus` → **Opus 4.8**; `model: fable` → **Fable 5**.
- **No `model:` label → fall back to the class rubric below.** Most repos have not adopted the convention and must keep working unchanged; in an adopted repo, unlabeled means Opus by convention — which the rubric already approximates — so the same fallback is right in both worlds.

The fallback rubric, unchanged:

- **Opus 4.8** — data-model / migrations, auth / security boundaries, inventory / shipment correctness, thin or ambiguous specs, cross-cutting refactors. Also the model whenever you genuinely can't tell the class (safe default — Opus never under-builds).
- **Sonnet 5** — bounded, well-specified, pattern-following work: i18n / copy, views / Tailwind, config, a single test, straightforward CRUD, docs.

State each issue's model at the confirm gate **and where it came from** — `label` or `rubric (no label)` — with a one-line why for every rubric call. An override you make at the gate is worth writing back to the issue's label afterward, so the record stays honest for the next run.

### The review tier is derived, never labeled

The gating review (Step 4) is computed from the build tier — one tier above — and is never read from the label:

| Build | Gating review |
| --- | --- |
| Sonnet 5 | Opus 4.8 |
| Opus 4.8 | Fable 5 |
| Fable 5 | Fable 5 (ceiling — a flagship build gets a flagship peer) |

This is the structural safety net: an under-build is caught and fixed at review, never shipped. That is exactly what makes leaning on the cheaper tier for the bulk close to free on quality while saving real cost and latency at fan-out scale — so **a `model: sonnet` label must never downgrade the review.** It sets the build only.

### Merge issues are always Fable-built

A build subagent runs the whole `/autopilot` loop at **one** model (a subagent can't switch mid-run), so whichever model builds a `--to merge` issue also makes its merge go/no-go inside `/autopilot` Step 8. The floor is non-negotiable: the merge decision is always Fable — the autonomous merge is the highest-stakes call in the pipeline, so it gets the most capable model. Therefore: **any issue opted into `--to merge` is built by Fable**, regardless of what its `model:` label or the class rubric would otherwise pick — a `model: sonnet` label on a merge-tier issue does not buy a cheaper merge decision. Sonnet and Opus only ever build `--to pr` issues, which stop at a review-ready PR and are tier-above-reviewed (Step 4) before you see them. This keeps every autonomous merge Fable-decided without the orchestrator having to re-implement the merge gate. The cost — running the rare, narrow merge class at Fable rates — is negligible because `--to merge` is opt-in and uncommon.

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
- Build the run plan: for each issue, its assigned build model, its **source** (`label` or `rubric (no label)`, with a one-line why for rubric calls), and its tier (`pr`, or `merge` if named in `--merge` — and remember a `--merge` issue is forced to a Fable build whatever its label says).
- Note any queued issue **missing a `model:` label in a repo that has adopted the convention** — check with `gh label list --json name --jq '[.[].name | select(startswith("model: "))]'`; a non-empty result means adopted. Missing labels are a triage gap, not a blocker: the rubric covers the issue, but flag them at the gate so triage can be corrected.

**CONFIRM GATE:** Present the run plan — issue list, per-issue model + source, per-issue tier — and get a go-ahead before spawning. Membership was already vetted at triage; this is a light confirm that the models and tiers are right and the queue is still current, plus your chance to override a model call. Not a re-litigation of the queue.

### Step 2 — Fan out the builds

For each issue, spawn a **background** subagent:

- `isolation: worktree` — its own checkout, so parallel edits across issues can't collide.
- `run_in_background: true` — they run concurrently.
- `model:` the issue's assigned build model — from its `model:` label, or the rubric when it has none; Fable for any `--to merge` issue. Because the subagent is spawned _at_ that model, `/autopilot`'s own announce-time reconciliation finds a match and passes straight through.
- prompt: if the issue body opens with a **model callout** (a `> 🤖 Recommended model: …` blockquote), quote it in the prompt — it names the watch-item or escalation trigger behind the tier choice, and it is wasted if only the orchestrator reads it. Then: run `/autopilot <n> --to <tier>` to completion — running every `bin/ci` / test / `db:test:prepare` invocation on the agent's **own isolated test database, serially, and in the foreground** (`PARALLEL_WORKERS=1 RAILS_ENV=test DATABASE_URL=postgres:///<app>_test_i<n> bin/ci`; see the test-DB-isolation, serial-CI, and foreground-CI notes under **Important**) — then report back, as the final message, the PR number and URL, the loop outcome (which steps ran / were n·a), a one-line summary of the change, and, if it stopped at the escape hatch, exactly where and why.

Spawn them together so they run in parallel. Each subagent lands on an auto-named worktree branch (`worktree-agent-…`); inside it, `/autopilot` → `/resolve-issue` creates the proper `feat/gh-<n>-…` branch, commits, pushes, and opens the PR from it. Nothing to pre-create.

### Step 3 — As each build finishes

When a build subagent reports a review-ready PR:

- **Drop the queue label:** `gh issue edit <n> --remove-label autopilot-queued`. The issue is now in-flight, not pending — lifecycle-contract step 3.
- Kick off its tier-above gating review (Step 4) right away — don't wait for the whole batch: **Opus** for a Sonnet build, **Fable** for an Opus build, **Fable** for a Fable build. (A `--to merge` issue was Fable-built and Fable-reviewed inside its own `/autopilot` run — no orchestrator review needed.)

A subagent that **stopped** at the escape hatch keeps its `autopilot-queued` label (still pending) and is set aside for the final report — do not review or merge it.

### Step 4 — Tier-above gating review (every `--to pr` build)

For each review-ready PR, spawn a review subagent one model tier above its build, per the derivation table above — **Opus** for a Sonnet-built PR, **Fable** for an Opus-built or Fable-built PR. Derive this from the model the build actually ran at, **not** from the issue's `model:` label: if a build was overridden at the confirm gate or escalated mid-flight, the review must follow the real build tier, not the recorded one.

- `model: opus` (Sonnet build) or `model: fable` (Opus or Fable build), `isolation: worktree`.
- prompt: check out the PR branch (`gh pr checkout <PR>`), run `/code-review` at `high` (escalate to `max` for a large or security-/data-sensitive diff), fix real correctness bugs and clear quality wins, commit and push (this updates the open PR), then re-run `bin/ci` on that issue's **isolated test database, serially** (`PARALLEL_WORKERS=1 RAILS_ENV=test DATABASE_URL=postgres:///<app>_test_i<n> bin/ci` — reuse the build agent's DB for the issue; see the test-DB-isolation and serial-CI notes under **Important**) so the required sign-off attaches to the final commit. Report the verdict: clean / _N_ fixes applied / a finding that needs a product decision (→ flag it for the human, don't guess).

This is the review floor: every `--to pr` build is reviewed one tier above itself before the PR is "review-ready" for you, so a build-model miss is caught and fixed, never shipped. `--to merge` issues don't pass through here — they were Fable-built and Fable-reviewed inside their own `/autopilot` run, and merged there only if the narrow-class gate passed.

### Step 5 — Reclaim worktrees

Fan-out worktrees that produced commits are **not** auto-removed. After the batch settles, reclaim them: `git worktree list` to find the leftover `…/worktrees/agent-*` entries, `git worktree remove --force <path>` each finished one, then `git worktree prune`. The branches live on the remote (pushed as `feat/gh-<n>-…`), so removing the local worktrees is safe.

## Completion report

Post a batch summary:

```text
## Autopilot batch — N issues

| Issue | PR | Build | Review | Outcome |
| ----- | -- | ----- | ------ | ------- |
| #847  | #M | Fable (merge tier) | (internal)      | merged + deployed ✓ |
| #851  | #P | Sonnet (label)     | clean (Opus)    | PR-ready |
| #863  | #Q | Opus (rubric)      | 2 fixes (Fable) | PR-ready |
| #870  | —  | —                  | —               | STOPPED — <reason>, needs you |

- Queue: <k> resolved to PRs, <j> stopped and still labeled `autopilot-queued`.
- Model labels: <none missing | #N, #M had no `model:` label in an adopted repo — triage gap, ran on the rubric>.
- Merged: <list, or none — all held at PR-ready>.
- Your call: review + `/merge-pr` on the PR-ready ones; pick up the stopped issues.
```

## Important

- **Run from the target app repo, never dotfiles** — the worktree isolation depends on it.
- **Default is `--to pr` for the whole batch.** Only issues named in `--merge` can merge, and only through `/autopilot`'s narrow-class gate; a mislabeled one degrades to `--to pr` inside its own run.
- **Every autonomous merge is Fable-decided** — `--merge` issues are Fable-built, so the merge go/no-go is Fable. Every `--to pr` build is reviewed one tier above itself (Step 4) before it reaches you.
- **The `model:` label sets the build tier only.** The review tier is derived from the build (one above) and the merge floor is Fable, so no label can cheapen either — the safety net that catches a cheap build's mistakes is never itself cheapened. An issue with no label runs on the rubric exactly as before, which is what keeps unadopted repos working unchanged.
- **One stop never halts the batch.** A stopped issue is set aside with its label intact; the rest continue. A wrong merge is the only truly bad outcome, and the gates above prevent it.
- **Compose, don't re-implement.** Build subagents run the real `/autopilot`; review subagents run the real `/code-review`. This skill only orchestrates, gates the model floor, and manages the queue label and worktrees — so improvements to those skills flow through untouched.
- **Isolate each agent's test database (`RAILS_ENV=test DATABASE_URL=…` per agent).** Several worktree agents run `bin/ci` at once; if they all share the project's one default test DB they deadlock against each other — and against any _other_ session using that same DB (a common case: a second Claude working in the primary checkout). `PARALLEL_WORKERS=1` does **not** solve this — it only fixes fork-starvation _within_ one run. Give each agent its own database — a name distinct from the project's default test DB, e.g. `<app>_test_i<issue#>` (`…_test_i847`) — and pass it on **every** test/CI/db command: `PARALLEL_WORKERS=1 RAILS_ENV=test DATABASE_URL=postgres:///<app>_test_i<issue#> bin/ci`. Pre-create it once with `PARALLEL_WORKERS=1 RAILS_ENV=test DATABASE_URL=postgres:///<app>_test_i<issue#> bin/rails db:test:prepare` before the first `bin/ci`, and reuse the same DB for that issue's gating review (Step 4). **`RAILS_ENV=test` is not optional:** `DATABASE_URL` only maps to the _test_ connection under `RAILS_ENV=test`. Omit it and `db:test:prepare` silently falls through to the shared default test DB (clobbering the other session), while `bin/ci`'s setup runs `db:prepare` in _development_ — creating the isolated DB stamped `development` and seeding it, which then breaks data-counting tests and makes `db:seed:replant` abort with `EnvironmentMismatchError`. Batch-scoped: standalone `/autopilot` runs (one worktree, no contention) don't need it.
- **Run `bin/ci` serially in the batch (`PARALLEL_WORKERS=1 bin/ci`).** Several worktree subagents run `bin/ci` at once, and on macOS the parallel Minitest system-test workers fork-starve under that combined load — producing flaky failures and fork-crash storms that aren't real, then costly retries. A single test worker sidesteps it. This applies to both the build subagents' internal `bin/ci` (Step 2) and the gating review's `bin/ci` (Step 4). It is batch-scoped: standalone `/autopilot` runs (one worktree, no contention) can stay parallel.
- **Subagents run `bin/ci` in the FOREGROUND — never as a background shell task.** A subagent that backgrounds `bin/ci` and ends its turn "to wait for the notification" orphans the process: the shell task dies with the agent's turn, no completion callback ever fires, and the run stalls silently at an open PR with no sign-off (observed 2026-07-17, #957/PR #960 — looked hung for ~1.5h with no CI process alive). Background Bash is safe only in the orchestrator's main session, where task exit re-invokes the conversation. If a build agent does stall this way, recovery is `SendMessage` to the agent (context intact): tell it the background task is dead and to re-run CI in the foreground.
