---
name: autopilot
description: Carry a well-scoped GitHub issue through the full dev loop autonomously, stopping at a per-run tier boundary (PR-ready, or merge+deploy for small reversible changes).
argument-hint: "[issue-number] [--to pr|merge]"
---

# Autopilot

Drive a single GitHub issue through the project's full development loop with minimal supervision, stopping at a boundary you authorize up front. This composes the existing skills (`/resolve-issue`, `/simplify`, `/create-pr`, `/verify`, `/walkthrough`, `/code-review`) plus `bin/ci` — it does not reinvent them.

Use this when an issue is clear and well-specified and you want it carried to a review-ready PR (or, for small reversible changes, all the way to merge) without invoking each step by hand. For issues that need close collaboration, use the individual skills instead.

## Arguments

`$ARGUMENTS` contains the issue number and an optional tier flag:

- **`--to pr`** (default): run the full loop and **stop at a review-ready PR**. No merge, no deploy. This is the well-lit path — the human merge gate catches everything.
- **`--to merge`**: run the full loop, then merge (which auto-deploys) **only if the change passes the narrow-class gate** in Step 8. Otherwise it degrades to `--to pr` and stops. Passing `--to merge` IS your per-run authorization to merge this one issue; it is not a standing capability.

Examples: `/autopilot 754` (→ pr), `/autopilot 754 --to pr`, `/autopilot 847 --to merge`.

Parse the issue number and tier from `$ARGUMENTS`. If no tier is given, default to `pr`. If the tier is unrecognized, stop and ask.

> **Model note (Phase 1):** Autopilot runs at the session's current model. Per-stage model delegation (e.g. Sonnet implements, Opus reviews) is Phase 2 — see dotfiles #212.

## The "stop and ask" escape hatch (applies to every step)

Autopilot is autonomous, not reckless. **Stop immediately, report what you found, and wait for the user** if any of these arise — do not guess or push through:

- The `/resolve-issue` planning checkpoint (Step 3 of that skill) judges the issue **complex or ambiguous** — multiple subsystems, real design choices, or unclear acceptance criteria.
- A decision surfaces that the project's own guardrails reserve for the user: a **new DB column not in the data model, a changed model association, an altered public URL, a new dependency, or a change to the event status lifecycle** (see the project CLAUDE.md "Handling Ambiguity" table).
- Tests fail in a way you cannot confidently resolve, or a fix would require inventing scope beyond the issue.
- The spec conflicts with what you find in the code (three valid responses per global CLAUDE.md: implement as written, ask, or propose a change — the latter two mean stop).
- A permission prompt blocks progress and there is no compliant alternative path.

When you stop, post a concise summary: what's done, where you stopped, exactly what you need from the user, and the recommended next command.

## Your task

Announce the run first: issue number, tier, and the boundary ("will stop at review-ready PR" / "will merge + deploy if the narrow-class gate passes"). Confirm you are starting from an appropriate base (a clean `main`/`master`, or an existing worktree branch for this issue). Then work the loop:

### Step 1 — Resolve

Invoke `/resolve-issue <number>` and let it run its 6 steps, with these autopilot overrides:

- **Honor its planning checkpoint as the escape hatch above.** Proceed autonomously for a small, well-scoped issue; stop and ask for a complex/ambiguous one.
- **Override its Step 6 stop.** `/resolve-issue` ends by asking whether to create a PR — in autopilot, do not stop there; continue the loop.
- **Commit protocol:** follow the global CLAUDE.md file-based commit flow (write the message with the Write tool, `git commit -F .git_commit_msg`, remove it). Never put `$(...)` or backticks in a commit command.
- **AC checkboxes are best-effort and must never block the run.** If `/resolve-issue` checks off acceptance-criteria boxes, use `gh issue edit <n> --body-file <file>` (never `--body "$(...)"`, which the auto-mode classifier flags). If the write still prompts or fails, skip it and note "AC boxes left for manual check-off" — the real issue↔PR link is `Closes #N` in the PR body, so the checkboxes are cosmetic.

### Step 2 — Simplify

Invoke `/simplify` to review the changed code for reuse, simplification, and efficiency, and apply the fixes. Commit any resulting changes (file-based commit flow). This is quality-only; it does not hunt for bugs.

### Step 3 — Create the PR

Invoke `/create-pr`. It infers the issue from the branch name and opens a **ready-to-review** PR with `Closes #<number>`. Capture the PR number for the next steps. (Per the project workflow, the PR is opened _before_ verify/walkthrough by design — the diff is reviewable while those checks run.)

### Steps 4–5 — Verify and Walkthrough (user-facing changes only)

Match the verification to the change's actual surface — don't reflexively invoke `/verify`:

- **Visible / interactive surface** (a page, form, or flow a user drives): invoke `/verify <PR>` then `/walkthrough <PR>`. Both may report "not applicable" and exit — that's expected; skip them when they do.
- **Runtime behavior but no visible surface, fully test-covered** (e.g. i18n key resolution under `raise_on_missing_translations`, a config value, a computed default): substitute a **targeted inline verification** for the browser `/verify` — run the specific test or exercise the behavior directly to confirm it resolves, and note what you checked in the debrief. A browser walkthrough adds nothing here, so skip it.
- **No runtime surface at all** (docs, comments, a pure refactor with green tests): skip both.

- **QA is local-dev-only.** The app is POST-LAUNCH (real distributor data). Never drive the production site — no walkthroughs, `/verify`, or data-mutating flows against live. Local dev only. (See project CLAUDE.md "QA Testing Policy".)
- **Start the app the headless-reliable way**, never `bin/dev` (its Tailwind watcher exits without a TTY and foreman SIGTERMs the whole group, killing the server). Use:

  ```bash
  bin/rails tailwindcss:build   # one-shot compile
  bin/rails server              # separate process
  ```

- For 375px mobile checks use the chrome-devtools `emulate` tool (true viewport), not window resize. Assert `window.innerWidth` and no horizontal overflow.
- Do **not** run `/walkthrough --publish` — publishing stays a human-gated action.

### Step 6 — Code review

Invoke `/code-review`, choosing the effort level to fit the change rather than a fixed setting:

- **Default `high`** — broad coverage for an unattended run.
- **Escalate to `max`** when the review is the last line of defense or the change is higher-risk: tier `--to merge` (ships to prod with no human review before deploy), or a large / multi-subsystem / security- or data-sensitive diff.
- **Drop to `medium`** for a small, mechanical `--to pr` change (a few-line copy/i18n/config tweak) that a human will still review after — max coverage there is mostly noise.
- **Never auto-select `ultra`** — it's a billed, cloud, user-triggered review; leave it for the user to invoke.

State the level you picked and why in one line. Then triage the findings against the issue's spec:

- Fix real correctness bugs and clear quality wins; commit and push (updates the open PR).
- **Adjacent cleanup that finishes the same change is allowed.** If the review surfaces the same defect in a sibling spot (e.g. a duplicated helper the diff only half-updated), fix it too rather than leaving the job half-done — and **flag the expansion in the debrief**. Being blocked by "technically out of scope" defeats autopilot's purpose. (For `--to merge`, the Step 8 narrow-class gate independently re-checks the _final_ diff, so cleanup that escapes the whitelist safely degrades the run to `--to pr` rather than shipping unseen.)
- A finding flagged "speculative" may actually be **AC-mandated** — check the issue before dismissing it.
- If a finding needs a product decision, that's the escape hatch — stop and ask.

### Step 7 — Local CI + sign-off

Run `bin/ci`. This runs the full pipeline and produces the `gh signoff` that is the required branch-protection gate. Re-run it after any review/walkthrough fix so the sign-off attaches to the commit that will merge. If `bin/ci` fails, stop and report (do not merge or leave a broken PR silently).

### Step 8 — Boundary

**Tier `pr`:** Stop here. Post the debrief-style summary below. Do **not** merge. Recommend the user run `/merge-pr <PR>` after their review.

**Tier `merge`:** First run the **narrow-class gate**. Auto-merge proceeds only if **all** hold:

- [ ] no DB migration — nothing under `db/migrate/`, no `db/schema.rb` change
- [ ] no changed model association and no altered public route (`config/routes.rb` public paths, `has_many`/`belongs_to`/etc.)
- [ ] no new gem/dependency — no `Gemfile`, `Gemfile.lock`, or `package.json` change
- [ ] the diff is confined to config / locales / views / copy / a small setting
- [ ] `bin/ci` is green **and** `/code-review` surfaced no correctness findings

Inspect with `git diff --stat <base>...HEAD` and check the changed paths. **If any check fails, do not merge** — announce which check failed, degrade to tier `pr` (post the summary, recommend `/merge-pr`), and stop.

If all checks pass, merge (this mirrors `/merge-pr`, which stays user-gated by design; you merge here only because `--to merge` authorized this one issue):

1. Confirm CI is green: `gh pr checks <PR>` (hard gate — never merge on a failing check).
2. `gh pr merge <PR> --squash` (no `--delete-branch`; GitHub auto-deletes the remote branch).
3. Update local state: `git switch <base> && git pull`, then `git branch -D <branch>` (squash merges need force-delete).
4. **Post-deploy vigilance** (merge auto-deploys to Fly): watch the deploy with `gh run watch` (or `gh run list`), smoke-test prod once it's green (`/up` health check + a key route), and check/resolve any related Honeybadger fault. Report the deploy outcome.

## Completion report (both tiers)

Post a debrief-style summary:

```text
## Autopilot — issue #N ([--to pr | --to merge])

- PR: #M — <title>   <url>
- Loop: resolve ✓  simplify ✓  create-pr ✓  verify [✓/n·a]  walkthrough [✓/n·a]  code-review ✓  bin/ci ✓ (signed off)
- Files: <count> changed
- Notable decisions / cleanups: <one or two lines>
- AC checkboxes: <checked / left for manual>
- Boundary: <held at PR-ready | merged + deployed (deploy <status>, Honeybadger <status>)>
- Your call: <review + /merge-pr #M | nothing — shipped | I stopped because …>
```

## Important

- **`--to pr` is the default and never merges or deploys.** Only an explicit `--to merge` can, and only through the narrow-class gate.
- **The narrow-class gate is a hard filter, not advice.** A mislabeled migration-bearing issue cannot ship unseen — worst case autopilot stops and asks.
- **`/merge-pr`, `/walkthrough --publish`, and deploy-on-merge stay human-gated.** Autopilot's merge path is the single authorized exception, scoped to one issue by the `--to merge` flag.
- **Prefer composing the real skills over re-implementing them** so their improvements flow through. The only inlined logic is the Step 8 merge, because `/merge-pr` is deliberately not model-invocable.
- **Push resilience.** A `git push` can fail transiently with an SSH signing-agent error (`sign_and_send_pubkey … communication with agent failed`) — a self-healing round-trip hiccup with the SSH agent, **not** an auth denial (which would read `agent refused operation`). Retry with short backoff (~3 attempts) before treating a push as failed; only stop and report if it still fails after retries. Applies wherever autopilot pushes — the `/create-pr` push in Step 3 and any review-fix push in Step 6.
- **When in doubt, stop and ask.** A stalled autopilot that pings you is a good outcome; a wrong merge is not.
