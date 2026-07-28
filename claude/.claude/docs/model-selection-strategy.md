# Per-Issue Model Selection Strategy (GitHub Issues + Projects v2)

A portable convention for recording a **recommended Claude model on each GitHub issue**, so that when you sit down to resolve an issue the right model is chosen deliberately — reserving the expensive flagship model for the work that actually needs it, and routing routine work to cheaper tiers. This protects plan-limit headroom without sacrificing quality on the hard problems (see "What a tier actually costs" below). First implemented in `gg-songbook` (2026-07); this document is the handoff so it can be replicated in any repo (e.g. ComixDistro) and eventually folded into dotfiles.

---

## The core idea: a tiering heuristic

Model names change over time, so think in **tiers**, not fixed names. Map the tiers to whatever the current lineup is:

- **Flagship tier** (as of 2026-07: **Fable 5**) — the most capable/expensive model. Reserve it.
- **Workhorse tier** (as of 2026-07: **Opus 5**) — very capable, the default for real feature work.
- **Light tier** (as of 2026-07: **Sonnet**) — fast and cheap, ample for well-bounded work.

The triage rule — assign each issue a tier by asking what a _wrong answer_ costs and how far the reasoning reaches:

- **Flagship** when a wrong answer would _silently_ corrupt canonical/persistent data with no error surface. This is the insurance case, and only that case — the extra reasoning headroom buys a check against the failure mode that produces wrong output without ever failing.
- **Workhorse** for well-specified features with a test scaffold and a _contained_ blast radius. Identify the single riskiest sub-problem up front and note that only _that_ piece should escalate to the flagship tier if it proves gnarly.
- **Light** for documentation, a single regression test, and mechanical pattern-following where the spec leaves little to interpret.

When unsure, lean one tier down for docs/tests and one tier up for anything touching data integrity.

**The flagship bar tightened on 2026-07-27.** It used to read "silently corrupt canonical data **or** the reasoning spans several modules with non-obvious ripple." Opus 5's step-change is precisely in multi-module, long-horizon reasoning, so the workhorse tier now absorbs that clause and it has been cut. Flagship is the silent-corruption case alone. Expect the flagship share to fall from the ~6% measured under the old bar to roughly **2–3%**.

### What a tier actually costs

The argument throughout this document is denominated in **plan-limit headroom**, not dollars. On a usage-limited plan (Claude Max) consumption is a hard ceiling: over-spending on the flagship tier does not produce a larger invoice you can absorb by paying more, it runs the limit out mid-batch. `/autopilot-batch` fan-out — a dozen builds plus a gating review each, in parallel — is exactly the workload that hits that wall.

API `$/MTok` list prices remain the best available **proxy for relative consumption weight** between tiers (as of 2026-07, Fable ~2× Opus). Read them as a ratio, not as spend.

---

## Three encoding layers (use all three; they are complementary)

Each layer solves a different visibility problem. None alone is sufficient.

### 1. Label — the source of truth (travels with the issue)

Three repo-scoped labels, with cost-suggestive colors (red = expensive/reserve, amber = mid, green = cheap) so the board reads as a spend gradient:

| Label | Hex color | Meaning |
| --- | --- | --- |
| `model: fable` | `B60205` (dark red) | Flagship — reserve for silent-data-corruption stakes |
| `model: opus` | `FBCA04` (amber) | Workhorse — well-scoped features, refactors |
| `model: sonnet` | `0E8A16` (green) | Light — docs, single tests, mechanical edits |

The label is the primary encoding because it **travels with the issue** and shows in `gh issue view`, `gh issue list`, and the issue page — i.e. everywhere the issue appears, including the moment you pick it up to resolve (which is exactly when the model gets chosen). It is also filterable: `gh issue list --label "model: opus"`.

### 2. Projects v2 single-select field — the at-a-glance board signal

A custom field named **`Model`** on the project board, with single-select options `Fable` / `Opus` / `Sonnet`. This is what shows **on the cards in column view** and can be grouped or filtered by. (See gotcha below on why the label alone does not cover this.)

### 3. Body callout — the _why_ (only where there is real nuance)

A one-line blockquote prepended to the **top of the issue body** (not a comment — see gotcha), stating the tier and its caveat, above a `---` separator, with the original body intact below. Only add this where the tier choice carries nuance a bare label cannot convey (e.g. "workhorse, but escalate _this specific sub-problem_ to flagship if it gets gnarly"). Plain light-tier docs/test issues need no callout — the label and field say everything.

Callout template:

```markdown
> **🤖 Recommended model: <Model>.** <One sentence: why this tier, and the single watch-item or escalation trigger if any.>

---

<original issue body>
```

---

## Consumers: how the autopilot skills read the label

The label stopped being purely advisory once `/autopilot`, `/autopilot-batch`, and `/autopilot-triage` began reading it. This section is the contract those three skills implement — change it here first, then the skills.

### The label sets the build tier, and nothing else

`model: fable` → build with Fable; `model: opus` → Opus; `model: sonnet` → Sonnet. Every _derived_ tier in a run is computed from the build tier, never taken from the label:

- **Review runs at Opus 5 or above, and never below the build** — Sonnet build → Opus review, Opus build → Opus review, Fable build → Fable review. See "The review floor, and the trade it accepts" below for why this is a floor rather than a tier-above rule.
- **The `--to merge` go/no-go floor stays Fable**, always. A `model: sonnet` label on a merge-tier issue does not lower it; `/autopilot-batch` forces a Fable build for any `--merge` issue precisely so the merge decision is Fable-made.

So a cheap label can only ever cheapen the _build_ — never the safety net that catches a cheap build's mistakes.

### The review floor, and the trade it accepts

> **Review runs at Opus 5 or above, and never below the build.**

| Build | Review | Why |
| --- | --- | --- |
| Sonnet 5 | Opus 5 | A genuine step up — the case this floor exists for |
| Opus 5 | Opus 5 | Fresh context, adversarial prompt, independent sample |
| Fable 5 | Fable 5 | Unchanged (ceiling) |

This replaced a "review one tier above the build" rule on 2026-07-27. That rule existed to make leaning on the _cheap_ tier for the bulk close to free on quality — an under-build gets caught before it ships. Opus was never the cheap build, so applying it mechanically to Opus builds spent flagship capacity insuring against a risk it was not written for. Opus 5 made that plain: it landed at the same consumption weight as Opus 4.8 with a step-change in capability, while Fable stayed ~2× the weight, so the same premium now buys a much thinner capability margin.

Scale mattered more than the per-run delta. `/autopilot-batch` routes every build to a gating review, so against ComixDistro's settled 4 Fable / 32 Opus / 25 Sonnet distribution the old rule produced **4 Fable builds and ~36 Fable review runs**. Flagship usage was concentrated in reviews, not builds — and invisible to a "~6% flagship" figure that counts builds only.

**What the middle row gives up, knowingly:**

1. _Strict capability dominance_ — the reviewer is no longer unambiguously stronger than the builder.
2. _Decorrelated blind spots_ — and this is the one that matters. A mistake Opus 5 is systematically prone to may be invisible to a second Opus 5 instance, however fresh its context. Fable failing **differently** was part of what made cross-tier review a real check, distinct from it merely being more capable.

Accepted because the tier-above rule was aimed at cheap builds, because Fable and Opus share enough lineage that the decorrelation was always partial, and because the escalation paths below cover the tail. **If an Opus-reviewed Opus build ever ships a real miss, this is the line to revisit — and correlated blind spots is the mechanism to suspect first.**

Context freshness needs no separate mechanism: `/autopilot-batch` spawns the gating review as its own `isolation: worktree` subagent, so the reviewer starts from a clean context by construction.

#### Escalating to a Fable review

Three paths already exist, and together they _are_ the escalation story. There is deliberately **no conditional rule** that reaches for Fable automatically.

1. **`model: fable` at triage.** The bottom row is unchanged, so a flagship label yields a Fable build _and_ a Fable review. An issue complex enough to want a Fable review will almost always clear the flagship bar anyway — the existing label **is** the lever.
2. **Mid-flight escalation carries the review with it.** The review tier is derived from the model the build _actually ran at_, never from the label, so a build that escalates to Fable pulls its review up automatically.
3. **Re-run the review.** The gating review is not one-shot. An Opus review that comes back smelling wrong can be re-run at Fable on the same PR before merge — a fresh reviewer subagent spawned at the higher tier — for the cost of one review. This path is correct precisely _because_ it is invoked by judgment rather than by rule.

An automatic conditional ("Fable review when the issue carries data-integrity stakes") was considered and rejected: speculative machinery for a failure mode not yet observed, and redundant with all three paths above.

#### Watch item — the build/verify asymmetry

Work that is **easy to build and hard to verify** — a large mechanical refactor with a wide blast radius — is the one shape this ladder serves poorly. The risk sits in review, not build, so `model: fable` over-pays (Fable builds what Opus could have) while `model: opus` under-reviews. Path 3 covers it manually today. **If it recurs three times, that is the signal to give the review tier its own lever** instead of deriving it from the build — not before.

### Which issues get no tier at all

Some issues have nothing to build directly, and labeling them is noise that dilutes the signal:

- **Epics and tracking issues** — the design brief, not the work. Their children carry the tiers.
- **Content hubs** — a durable reference or index issue.
- **`qa` reports** — a tester's observation, not a work item. The tech issue derived from it via `/qa-triage` carries the tier.

Everything with code to write gets a tier. Re-triage when an issue's scope materially changes — a label recorded against a spec that has since doubled in scope is worse than no label, because it reads as considered judgment.

### Keeping the label and the board field honest

The label is the source of truth; the board's `Model` field mirrors it for card visibility (see the gotchas below on why both exist). Nothing syncs them automatically, so drift is expected. This one-liner finds every open issue that does not carry exactly one `model:` label:

```bash
gh issue list --state open --limit 200 --json number,labels --jq '[.[] | {n: .number, m: [.labels[].name | select(startswith("model"))]}] | map(select(.m | length != 1)) | map(.n)'
```

Any numbers returned are unlabeled — or double-labeled, which is the sneakier failure. Confirm each is a deliberate exclusion (epic / tracker / qa report), then spot-check the board field against the labels.

### No label → fall back to the existing heuristics

Most repos have not adopted the convention and must keep working unchanged. When an issue carries no `model:` label, the skills use their own class rubric (Opus for data-model / security / ambiguous / cross-cutting work; Sonnet for bounded pattern-work). In an adopted repo, unlabeled means Opus by convention — which that rubric already approximates — so the same fallback is correct in both worlds and no skill needs a separate "is this repo adopted?" code path to choose a model.

Adoption _is_ worth detecting for triage, though, so a missing label can be reported as the gap it is:

```bash
gh label list --json name --jq '[.[].name | select(startswith("model: "))]'
```

A non-empty result means the repo has adopted the convention.

### A running skill cannot switch its own model

`/autopilot-batch` spawns build subagents, so it can _set_ each one's model from the label. `/autopilot` invoked directly cannot — it runs at whatever model the session started with. There, the label is reconciled at announce time instead: running below the labeled tier is an under-build and stops for the user — unless the invoker states the downgrade was deliberate, since then a human already made the call; running above the labeled tier is only a cost note. See the `/autopilot` skill for the exact rule.

### Escalation stays allowed, and the label follows

If a cheap build hits hidden complexity, escalating mid-flight is correct — the label records a judgment, not a cage. Update the label afterward so the record stays honest and the next triage pass calibrates against what actually happened.

### Surface the body callout

Where an issue carries a top-of-body callout (layer 3), it usually names the watch-item or escalation trigger that made the tier a judgment call. Pass that callout through to the build agent's prompt, so the caveat reaches the model actually doing the work — a callout only the orchestrator reads is wasted.

---

## Gotchas we learned (read before implementing)

- **Comments cannot sit at the top of an issue.** GitHub appends comments below the body in chronological order and they sink as discussion accumulates — so a "comment near the top" is impossible. The only thing reliably at the top is the issue **body**, so the callout is a body edit (`gh issue edit --body-file`), not a comment.
- **Labels do not show on Projects v2 cards in column view by default.** This is the whole reason the custom field exists — the field is the at-a-glance card signal; the label is the travels-with-the-issue signal. (Labels _can_ be enabled on cards via the board view's field-visibility settings, per-view, if you also want them there — but do not rely on it being on.)
- **The `gh` token needs `project` scope** for any `gh project ...` command. Check with `gh auth status` (look for `project` in the token scopes). If missing, the user must run `gh auth refresh -s project` interactively — you cannot grant it for them.
- **The label and the field are independent** — nothing keeps them in sync automatically. Treat the **label as source of truth** and let the field mirror it; if you change one, change the other.
- **Labels are per-repo; the field is per-board.** Recreate the three labels in each new repo (additive to the existing label taxonomy — they do not replace it). Create the `Model` field once per project board.
- **An issue must be _on the board_** to receive a field value. `gh project item-list` only returns issues already added; add missing ones with `gh project item-add`.
- **`gh issue view` / `gh issue edit` need `--repo` when run outside a repo checkout.** A rollout often runs from somewhere else (dotfiles, a scratch dir); without `--repo` the command either errors or, worse, silently targets whatever repo you happen to be standing in.
- **Confirm every open issue is actually a board item _before_ the field pass.** `gh project item-list` returns only what has been added, so strays silently receive no field value. Diff the open-issue list against the item list and `gh project item-add` the gaps first.
- **Trust `item-list`, not the issue body's claim about itself.** An issue whose body says it is deliberately off-board may well be on the board anyway. The board is the authority on board membership; a body is prose someone wrote once.

---

## Implementation runbook (copy-paste `gh` commands)

> **Prefer `/model-triage`.** The skill encodes this runbook end-to-end — preflight, triage, an approval gate, apply, verify — and is the intended execution path for adopting the convention in a repo. The manual commands below remain the reference for what it does, for debugging a partial rollout, and for a one-off fix.

Replace `<OWNER>` (e.g. your GitHub username), `<PROJECT_NUMBER>`, and the ID placeholders as you discover them.

### 0. Verify prerequisites

```bash
gh auth status                        # confirm 'project' appears in Token scopes
# If not: gh auth refresh -s project  (interactive — the user runs this)
gh project list --owner <OWNER>       # find the board's <PROJECT_NUMBER> and node id (PVT_...)
```

### 1. Create the three labels (per repo)

```bash
gh label create "model: fable"  --color B60205 --description "Recommended model: Fable 5 (reserve for silent-data-corruption stakes)"
gh label create "model: opus"   --color FBCA04 --description "Recommended model: Opus 5 (well-scoped features, refactors)"
gh label create "model: sonnet" --color 0E8A16 --description "Recommended model: Sonnet (docs, single tests, mechanical edits)"
```

### 2. Triage each open issue

Read each open issue and assign a tier using the heuristic above. Produce a mapping like `#58 → fable`, `#49 → opus`, `#39 → sonnet`. Note which issues warrant a body callout (those with a real caveat/escalation trigger).

### 3. Apply labels

```bash
gh issue edit <N> --add-label "model: fable"    # or model: opus / model: sonnet
```

### 4. Create the `Model` field on the board (once per board)

```bash
gh project field-create <PROJECT_NUMBER> --owner <OWNER> \
  --name "Model" --data-type SINGLE_SELECT --single-select-options "Fable,Opus,Sonnet"
```

### 5. Collect the field ID and option IDs

```bash
gh project field-list <PROJECT_NUMBER> --owner <OWNER> --format json
# Find the field whose name is "Model": note its id (PVTSSF_...) and each option's name+id.
```

### 6. Collect the board item IDs (one per issue)

```bash
gh project item-list <PROJECT_NUMBER> --owner <OWNER> --limit 100 --format json
# Each item has 'id' (PVTI_...) and 'content.number' (the issue number). Map issue number -> item id.
# If an issue is missing, add it first:
#   gh project item-add <PROJECT_NUMBER> --owner <OWNER> --url https://github.com/<OWNER>/<REPO>/issues/<N>
```

### 7. Set each card's `Model` value

```bash
gh project item-edit \
  --id <ITEM_ID> \
  --project-id <PROJECT_NODE_ID>      \
  --field-id <MODEL_FIELD_ID>         \
  --single-select-option-id <OPTION_ID>
```

### 8. Prepend body callouts (only the caveated issues)

For each such issue: fetch the current body, prepend the callout + `---`, write back. Do **not** hand-retype the body — round-trip it so nothing is lost.

```bash
gh issue view <N> --json body --jq .body > /tmp/body.md
# Build /tmp/head.md with the callout (see template above) followed by a blank line, "---", blank line.
cat /tmp/head.md /tmp/body.md > /tmp/final.md
gh issue edit <N> --body-file /tmp/final.md
```

### 9. Verify

```bash
gh issue list --state open --json number,labels \
  --jq 'sort_by(.number) | .[] | "#\(.number): \([.labels[].name | select(startswith("model"))] | join(""))"'
gh project item-list <PROJECT_NUMBER> --owner <OWNER> --format json   # confirm each item's Model value
gh issue view <N> --json body --jq .body | head -5                    # confirm a callout landed intact
```

---

## Calibration references

Two real triage passes, at very different scales. Use them to sanity-check a distribution before applying it — if your flagship share is far above these, the heuristic is probably being applied too generously.

> **Measured under the previous rules.** Both passes predate 2026-07-27: they were tiered against the **two-clause flagship bar** (silent corruption _or_ multi-module ripple) and the **review-one-tier-above** ladder. They are kept rather than deleted because they remain the record of how the heuristic read in practice — but under the tightened single-clause bar several of these Fable calls would now land at Opus, and the expected flagship share is **~2–3%**, not ~6%. Compare your pass against their _shape_, not their absolute number.

| Project | Issues | Fable | Opus | Sonnet | Flagship share |
| --- | --- | --- | --- | --- | --- |
| gg-songbook (2026-07) | 7 | 1 | 3 | 3 | ~14% (small-n) |
| ComixDistro (2026-07-21) | 61 | 4 | 32 | 25 | **~6%** |

ComixDistro is the more trustworthy anchor: at 61 issues the distribution has settled, and the shape is the point — **a small flagship reserve, a workhorse majority, and a substantial light tail**. The flagship tier is insurance, so a pass that tiers 20% of issues Fable has stopped discriminating and is just burning limit headroom.

### Worked example (gg-songbook, 7 open issues)

The issue-by-issue reasoning behind the 1 / 3 / 3 above — a useful reference for how the heuristic reads in practice:

| Issue | Kind | Tier | Reasoning |
| --- | --- | --- | --- |
| #58 | bug | **Fable** | Fix changes `chord_only_line?`, which four modules depend on; a miss silently lets German notation reach the canonical song files. Multi-module ripple + silent-data-integrity stake = the insurance case. |
| #49 | feat | **Opus** | `--transpose` flag; well-specified with a test scaffold and existing chord-walking machinery. Watch-item: the enharmonic-spelling logic — escalate _only that_ to Fable if gnarly. |
| #33 | feat | **Opus** | Unicode accidentals in one export method; contained blast radius. Watch-item: scope the `b`/`#` → `♭`/`♯` swap to chord contexts so lyrics aren't touched. |
| #60 | chore | **Opus** | Multi-module refactor (extract a shared struct + a shared builder); Opus for safety, though the struct-extraction half alone is Light-tier easy. |
| #50 | docs | **Sonnet** | Documentation over a well-established pipeline; low ambiguity, no correctness stakes. |
| #59 | test | **Sonnet** | One regression test for already-understood, already-documented behavior. |
| #39 | docs | **Sonnet** | Pure docs note. |

The pattern: exactly one item hit the flagship bar (the correctness bug with cross-module reach), the features/refactors sat in the workhorse tier with a single named watch-item each, and everything doc/test-shaped went to the light tier.

---

## Adapting to a new project

1. Confirm `gh auth status` shows `project` scope; refresh if not.
2. Create the three `model:` labels in the repo (additive to the existing standard label taxonomy — see `~/.claude/docs/label-taxonomy.md`).
3. Create the `Model` single-select field on that repo's project board (once).
4. Triage the open issues with the heuristic; apply labels, set field values, add callouts where warranted.
5. Keep label and field in sync going forward; re-triage an issue if its scope materially changes.

The mechanics are identical across projects because all repos here use GitHub + Projects v2 with the same tooling. Only the labels (per-repo) and the field (per-board) need recreating; the heuristic and the runbook are unchanged.
