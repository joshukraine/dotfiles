---
name: autopilot-batch
description: Fan out a batch of autopilot-queued issues to parallel background worktree subagents — each runs /autopilot at the build model from its 'model:' label — with a gating review at Opus 5 or above and never below the build (Opus reviews Sonnet and Opus builds, Fable reviews Fable builds).
disable-model-invocation: true
argument-hint: "[--merge <issue#,…>]"
---

# Autopilot Batch

Run the vetted `autopilot-queued` queue as a parallel batch: one background `isolation: worktree` subagent per issue, each running `/autopilot <n>` end-to-end at the build model its `model:` label calls for, with a gating `review` at **Opus 5 or above and never below the build** (Opus for Sonnet- and Opus-built PRs, Fable for Fable-built PRs). This is the **run** half of the triage → run split; `/autopilot-triage` is the **vet** half that fills the queue.

Use this when you have a queue of independent, well-scoped issues and want them all carried to review-ready PRs in one unattended pass. For a single issue, use `/autopilot` directly.

## Where this runs (read first)

Run this **from the target application repository** — the repo whose issues and app these are (e.g. the Rails app) — on a clean default branch, pulled up to date. **Not from dotfiles.** `isolation: worktree` creates each worktree from the _orchestrator's current repo_, so the cwd decides where the fan-out worktrees land; running from the wrong repo produces worktrees of the wrong tree. If the cwd is the dotfiles repo (or any repo that doesn't own these issues), stop and say so.

## Arguments

- **(no args)** — run every `autopilot-queued` issue at tier `--to pr`. The whole batch stops at review-ready PRs; nothing merges.
- **`--merge <issue#,…>`** — authorize tier `--to merge` for the listed issues only (e.g. `--merge 847,851`). Everything else stays `--to pr`. Merge is still gated per issue by `/autopilot`'s Step 8 narrow-class gate, which degrades any non-qualifying issue back to `--to pr`. Passing `--merge` IS your per-issue authorization to merge those issues; it is not a standing capability.

Default tier is `--to pr` by design — merge is opt-in, per issue, never batch-wide.

## The build-model policy — the label decides the build, review runs at Opus or above

Each issue's _build_ subagent runs at a model chosen per issue; the _gating review_ always runs at **Opus 5 or above, and never below the build**. Ladder, cheapest to most capable: **Sonnet 5 → Opus 5 → Fable 5**.

### Resolving each issue's build model

**Read the issue's `model:` label first.** Repos that have adopted the per-issue model convention (`~/.claude/docs/model-selection-strategy.md`) carry one on every open issue, recording the build tier assigned at triage. Step 1's issue list already returns labels, so no extra call is needed:

- `model: sonnet` → build with **Sonnet 5**; `model: opus` → **Opus 5**; `model: fable` → **Fable 5**.
- **No `model:` label → fall back to the class rubric below.** Most repos have not adopted the convention and must keep working unchanged; in an adopted repo, unlabeled means Opus by convention — which the rubric already approximates — so the same fallback is right in both worlds.

The fallback rubric, unchanged:

- **Opus 5** — data-model / migrations, auth / security boundaries, inventory / shipment correctness, thin or ambiguous specs, cross-cutting refactors. Also the model whenever you genuinely can't tell the class (safe default — Opus never under-builds).
- **Sonnet 5** — bounded, well-specified, pattern-following work: i18n / copy, views / Tailwind, config, a single test, straightforward CRUD, docs.

State each issue's model at the confirm gate **and where it came from** — `label` or `rubric (no label)` — with a one-line why for every rubric call. An override you make at the gate is worth writing back to the issue's label afterward, so the record stays honest for the next run.

### The review tier is derived, never labeled

The gating review (Step 4) is computed from the build tier and is never read from the label. One invariant: **review runs at Opus 5 or above, and never below the build.**

| Build | Gating review |
| --- | --- |
| Sonnet 5 | Opus 5 |
| Opus 5 | Opus 5 (fresh context, adversarial prompt, independent sample) |
| Fable 5 | Fable 5 (ceiling) |

This is the structural safety net: an under-build is caught and fixed at review, never shipped. That is exactly what makes leaning on the cheaper tier for the bulk close to free on quality while saving real latency and limit headroom at fan-out scale — so **a `model: sonnet` label must never downgrade the review.** It sets the build only.

The floor replaced a "one tier above the build" rule on 2026-07-27. That rule was written to insure _cheap_ builds; Opus was never the cheap build, and at fan-out scale it sent nearly every review in the batch to Fable. A Fable review is now reached by **escalation rather than by rule** — via a `model: fable` label, via a mid-flight escalation (the table reads the model the build _actually ran at_), or by simply re-spawning the reviewer at Fable on the PR. See `~/.claude/docs/model-selection-strategy.md` § "The review floor, and the trade it accepts" for the reasoning and the trade it knowingly accepts.

### Merge issues are always Fable-built

A build subagent runs the whole `/autopilot` loop at **one** model (a subagent can't switch mid-run), so whichever model builds a `--to merge` issue also makes its merge go/no-go inside `/autopilot` Step 8. The floor is non-negotiable: the merge decision is always Fable — the autonomous merge is the highest-stakes call in the pipeline, so it gets the most capable model. Therefore: **any issue opted into `--to merge` is built by Fable**, regardless of what its `model:` label or the class rubric would otherwise pick — a `model: sonnet` label on a merge-tier issue does not buy a cheaper merge decision. Sonnet and Opus only ever build `--to pr` issues, which stop at a review-ready PR and pass the gating review (Step 4) before you see them. This keeps every autonomous merge Fable-decided without the orchestrator having to re-implement the merge gate. The cost — running the rare, narrow merge class at Fable rates — is negligible because `--to merge` is opt-in and uncommon.

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

**First, write each issue's isolated CI wrapper.** Do this yourself, before spawning anything — one file per issue, at `/tmp/autopilot-ci-i<n>`, `chmod +x`:

```bash
#!/usr/bin/env bash
# Isolated CI for autopilot issue <n>. Written by /autopilot-batch; not part of the repo.
exec env PARALLEL_WORKERS=1 RAILS_ENV=test \
  DATABASE_URL=postgres:///<app>_test_i<n> \
  bin/ci "$@"
```

This is the whole point of the mechanism: **the three variables are typed once, by you, instead of re-threaded onto every command by an agent for the length of a run.** The Bash tool does not persist shell state between calls, so an `export` at the start of an agent's run does nothing and the variables would otherwise have to be re-typed on every test, CI, and `db:test:prepare` invocation — including the ones initiated from inside `/autopilot`, which the agent invokes rather than controls. A wrapper cannot be half-remembered.

Two deliberate choices:

- **It lives in `/tmp`, not in `bin/`.** Build agents commit frequently, and a `bin/ci-isolated` inside the worktree is an untracked file that `git add -A` would sweep into the PR.
- **It does not `cd`.** `bin/ci` resolves against the agent's cwd, so the same wrapper serves the build agent and the later review agent in their different worktrees. Run from anywhere else it fails loudly with "no such file" — a visible failure, never a silent run against the wrong database.

Then, for each issue, spawn a **background** subagent:

- `isolation: worktree` — its own checkout, so parallel edits across issues can't collide.
- `run_in_background: true` — they run concurrently.
- `model:` the issue's assigned build model — from its `model:` label, or the rubric when it has none; Fable for any `--to merge` issue. Because the subagent is spawned _at_ that model, `/autopilot`'s own announce-time reconciliation normally finds a match and passes straight through. **If you spawn an agent _below_ its issue's label** — a downgrade you approved at the confirm gate — say so explicitly in the prompt ("building at Opus is a deliberate override of this issue's `model: fable` label, approved at the batch confirm gate"), or the agent will treat it as an under-build and stop.
- prompt: if the issue body opens with a **model callout** (a `> 🤖 Recommended model: …` blockquote), quote it in the prompt — it names the watch-item or escalation trigger behind the tier choice, and it is wasted if only the orchestrator reads it. Then: run `/autopilot <n> --to <tier>` to completion, with this instruction stated explicitly — **your CI command for this entire run is `/tmp/autopilot-ci-i<n>`, run in the foreground, from your worktree root. Never bare `bin/ci`, and never `bin/rails test` directly. This holds inside `/autopilot` too — its Step 7 defers to the CI command you were given.** (See the foreground-CI note under **Important**; the wrapper already carries the serial and isolated-database settings, so there is nothing to re-type.) Then report back, as the final message, the PR number and URL, the loop outcome (which steps ran / were n·a), a one-line summary of the change, and, if it stopped at the escape hatch, exactly where and why.

Spawn them together so they run in parallel. Each subagent lands on an auto-named worktree branch (`worktree-agent-…`); inside it, `/autopilot` → `/resolve-issue` creates the proper `feat/gh-<n>-…` branch, commits, pushes, and opens the PR from it. Nothing to pre-create.

### Step 3 — As each build finishes

When a build subagent reports a review-ready PR:

- **Drop the queue label:** `gh issue edit <n> --remove-label autopilot-queued`. The issue is now in-flight, not pending — lifecycle-contract step 3.
- **Remove that issue's build worktree before spawning its review** — `git worktree remove --force <path>`, using `git worktree list` to find it. The build agent is finished and its work is pushed, so the worktree is dead weight; but leaving it in place is what causes the `gh signoff` failure described in Step 4. While it exists it still holds the PR branch checked out, so the reviewer's `gh pr checkout <PR>` cannot take that branch and silently leaves it on a detached HEAD. Removing it first makes the checkout ordinary and the whole failure mode disappear.
- Kick off its gating review (Step 4) right away — don't wait for the whole batch: **Opus** for a Sonnet or Opus build, **Fable** for a Fable build. (A `--to merge` issue was Fable-built and Fable-reviewed inside its own `/autopilot` run — no orchestrator review needed.)

A subagent that **stopped** at the escape hatch keeps its `autopilot-queued` label (still pending) and is set aside for the final report — do not review or merge it.

### Step 4 — Gating review (every `--to pr` build)

For each review-ready PR, spawn a review subagent per the derivation table above — **Opus** for a Sonnet-built or Opus-built PR, **Fable** for a Fable-built PR. Derive this from the model the build actually ran at, **not** from the issue's `model:` label: if a build was overridden at the confirm gate or escalated mid-flight, the review must follow the real build tier, not the recorded one. That is also what makes a mid-flight escalation to Fable pull its own review up with it.

- `model: opus` (Sonnet or Opus build) or `model: fable` (Fable build), `isolation: worktree`.
- prompt: check out the PR branch (`gh pr checkout <PR>`), run the built-in `review <PR>` — it takes a PR number and **no effort level**, so depth comes from the spawn tier above plus, for a large or security-/data-sensitive diff, fanning out additional adversarial lenses; **mutation-test** the key claims either way (delete or disable the change and confirm the covering test actually fails — a test that stays green with the feature removed is the miss a read-only review cannot see). Then fix real correctness bugs and clear quality wins, commit and push (this updates the open PR), then re-run CI with **`/tmp/autopilot-ci-i<n>`** — the same wrapper the build agent used, so the review reuses that issue's database — so the required sign-off attaches to the final commit. Report the verdict: clean / _N_ fixes applied / a finding that needs a product decision (→ flag it for the human, don't guess).
- Also state in the prompt: **if `gh signoff` fails with `current branch is not tracking a remote branch`, you are on a detached HEAD** — `gh pr checkout` could not take the branch. It is the only red step in an otherwise green run and reads like a test failure, which is what makes it expensive. Step 3 removes the build worktree first precisely to prevent this, so if it still happens, say so rather than working around it silently. The recovery is either a throwaway tracking branch (`git switch -c signoff-<PR>` then push with `-u`), or — after confirming the tree is clean and `HEAD` equals `origin/<pr-branch>` — `gh signoff create -f`.

This is the review floor: every `--to pr` build is reviewed at Opus or above — never below itself — before the PR is "review-ready" for you, so a build-model miss is caught and fixed, never shipped. If a review comes back thin on a diff you are uneasy about, re-spawning the reviewer at Fable on the same PR is the escalation path: one review's worth of headroom, invoked by judgment rather than by rule. `--to merge` issues don't pass through here — they were Fable-built and Fable-reviewed inside their own `/autopilot` run, and merged there only if the narrow-class gate passed.

### Step 5 — Reclaim worktrees

Build worktrees are already gone — Step 3 removes each one as its build finishes. What remains after the batch settles are the **review** worktrees, plus the build worktree of any issue that stopped at the escape hatch (left deliberately: its work is unpushed and removing it would discard the run).

Sweep the rest: `git worktree list` to find the leftover `…/worktrees/agent-*` entries, `git worktree remove --force <path>` each one, then `git worktree prune`. The branches live on the remote (pushed as `feat/gh-<n>-…`), so removing the local worktrees is safe. Delete any `signoff-<PR>` helper branches a reviewer had to create (see Step 4), and remove the per-issue CI wrappers: `rm -f /tmp/autopilot-ci-i*`.

**Drop the per-issue test databases too** — they are the batch's largest leftover and nothing else reclaims them:

```bash
psql -lqt | cut -d'|' -f1 | tr -d ' ' \
  | grep -E "^<app>_test_i[0-9]+([-_][0-9]+)?$" \
  | while read -r db; do dropdb "$db"; done
```

The `_i[0-9]+` segment is what keeps this off the project's own `<app>_test` and its worker databases, which belong to the human's local runs — the pattern matches only databases this batch created. Run the leak check under **Important** _before_ this, not after: dropping the evidence first would hide a bypass you needed to know about.

## Completion report

Post a batch summary:

```text
## Autopilot batch — N issues

| Issue | PR | Build | Review | Outcome |
| ----- | -- | ----- | ------ | ------- |
| #847  | #M | Fable (merge tier) | (internal)      | merged + deployed ✓ |
| #851  | #P | Sonnet (label)     | clean (Opus)    | PR-ready |
| #863  | #Q | Opus (rubric)      | 2 fixes (Opus)  | PR-ready |
| #870  | —  | —                  | —               | STOPPED — <reason>, needs you |

- Queue: <k> resolved to PRs, <j> stopped and still labeled `autopilot-queued`.
- Model labels: <none missing | #N, #M had no `model:` label in an adopted repo — triage gap, ran on the rubric>.
- Merged: <list, or none — all held at PR-ready>.
- Your call: review + `/merge-pr` on the PR-ready ones; pick up the stopped issues.
```

## Important

- **Run from the target app repo, never dotfiles** — the worktree isolation depends on it.
- **Default is `--to pr` for the whole batch.** Only issues named in `--merge` can merge, and only through `/autopilot`'s narrow-class gate; a mislabeled one degrades to `--to pr` inside its own run.
- **Every autonomous merge is Fable-decided** — `--merge` issues are Fable-built, so the merge go/no-go is Fable. Every `--to pr` build is reviewed at Opus or above, never below itself (Step 4), before it reaches you.
- **The `model:` label sets the build tier only.** The review tier is derived from the build (Opus floor, never below the build) and the merge floor is Fable, so no label can cheapen either — the safety net that catches a cheap build's mistakes is never itself cheapened. An issue with no label runs on the rubric exactly as before, which is what keeps unadopted repos working unchanged.
- **One stop never halts the batch.** A stopped issue is set aside with its label intact; the rest continue. A wrong merge is the only truly bad outcome, and the gates above prevent it.
- **Compose, don't re-implement.** Build subagents run the real `/autopilot`; review subagents run the built-in `review <PR>`. This skill only orchestrates, gates the model floor, and manages the queue label and worktrees — so improvements to those skills flow through untouched. **`/code-review` is not an option here** — it is a user-triggered command for a working diff and is not model-invocable, which is why the reviewer takes the PR-number variant. A subagent that finds a skill uninvocable must say so, never substitute a hand-rolled review that reports as the real one.
- **Agents never type the isolation variables — the Step 2 wrapper carries them.** `/tmp/autopilot-ci-i<n>` is the only CI command an agent runs, and it is the enforcement point for both settings below. Pre-create that issue's database once before the first run (`env PARALLEL_WORKERS=1 RAILS_ENV=test DATABASE_URL=postgres:///<app>_test_i<n> bin/rails db:test:prepare`) — that is the one place the variables are still written out by hand, and it happens once per issue rather than on every command.
- **Why the database must be isolated (`RAILS_ENV=test DATABASE_URL=…` per agent).** Several worktree agents run CI at once; if they all share the project's one default test DB they deadlock against each other — and against any _other_ session using that same DB (a common case: a second Claude working in the primary checkout). `PARALLEL_WORKERS=1` does **not** solve this — it only fixes fork-starvation _within_ one run. Each agent gets a name distinct from the project's default test DB, e.g. `<app>_test_i<issue#>` (`…_test_i847`), reused by that issue's gating review. **`RAILS_ENV=test` is not optional:** `DATABASE_URL` only maps to the _test_ connection under `RAILS_ENV=test`. Omit it and `db:test:prepare` silently falls through to the shared default test DB (clobbering the other session), while `bin/ci`'s setup runs `db:prepare` in _development_ — creating the isolated DB stamped `development` and seeding it, which then breaks data-counting tests and makes `db:seed:replant` abort with `EnvironmentMismatchError`. Batch-scoped: standalone `/autopilot` runs (one worktree, no contention) don't need it.
- **Why CI must run serially (`PARALLEL_WORKERS=1`).** Several worktree subagents run CI at once, and on macOS the parallel Minitest system-test workers fork-starve under that combined load — producing flaky failures and fork-crash storms that aren't real, then costly retries. A single test worker sidesteps it. Batch-scoped: standalone `/autopilot` runs can stay parallel.
- **Verify the isolation held before you report the batch.** After the run, check that no per-worker databases leaked:

  ```bash
  psql -lqt | cut -d'|' -f1 | tr -d ' ' | grep -E "<app>_test_i[0-9]+[-_][0-9]+"
  ```

  It should return nothing. A hit means some command ran without `PARALLEL_WORKERS=1` — the wrapper was bypassed somewhere. Say so in the report rather than cleaning up quietly; that is the signal the mechanism is leaking. (Observed 2026-07-27: `…_test_i367_0` through `_i367_11`, twelve worker databases from a single missed prefix.) **The `[-_]` is deliberate** — Rails has used both `<base>-<n>` and `<base>_<n>` for parallel worker databases depending on version, and both are present on this machine today, so a pattern hardcoding one separator silently passes on a project using the other.
- **`gh signoff` fails on a detached HEAD.** It resolves `@{push}`, so it needs a branch with an upstream. A reviewer that lands detached — because `gh pr checkout` could not take a branch another worktree still held — gets `current branch is not tracking a remote branch` as the single red step in an otherwise green run, which reads like a test failure. Step 3's worktree removal is the structural prevention; the recoveries are a throwaway `signoff-<PR>` tracking branch pushed with `-u`, or `gh signoff create -f` once the tree is clean and `HEAD` matches `origin/<pr-branch>`.
- **Subagents run `bin/ci` in the FOREGROUND — never as a background shell task.** A subagent that backgrounds `bin/ci` and ends its turn "to wait for the notification" orphans the process: the shell task dies with the agent's turn, no completion callback ever fires, and the run stalls silently at an open PR with no sign-off (observed 2026-07-17, #957/PR #960 — looked hung for ~1.5h with no CI process alive). Background Bash is safe only in the orchestrator's main session, where task exit re-invokes the conversation. If a build agent does stall this way, recovery is `SendMessage` to the agent (context intact): tell it the background task is dead and to re-run CI in the foreground.
