# Per-Issue Model Selection Strategy (GitHub Issues + Projects v2)

A portable convention for recording a **recommended Claude model on each GitHub issue**, so that when you sit down to resolve an issue the right model is chosen deliberately — reserving the expensive flagship model for the work that actually needs it, and routing routine work to cheaper tiers. This controls usage/cost without sacrificing quality on the hard problems. First implemented in `gg-songbook` (2026-07); this document is the handoff so it can be replicated in any repo (e.g. ComixDistro) and eventually folded into dotfiles.

---

## The core idea: a tiering heuristic

Model names change over time, so think in **tiers**, not fixed names. Map the tiers to whatever the current lineup is:

- **Flagship tier** (as of 2026-07: **Fable 5**) — the most capable/expensive model. Reserve it.
- **Workhorse tier** (as of 2026-07: **Opus 4.8**) — very capable, the default for real feature work.
- **Light tier** (as of 2026-07: **Sonnet**) — fast and cheap, ample for well-bounded work.

The triage rule — assign each issue a tier by asking what a _wrong answer_ costs and how far the reasoning reaches:

- **Flagship** when a wrong answer would _silently_ corrupt canonical/persistent data, **or** the reasoning spans several modules with non-obvious ripple effects. This is the insurance case — the extra reasoning headroom prevents a subtle miss that produces wrong output with no error.
- **Workhorse** for well-specified features with a test scaffold and a _contained_ blast radius. Identify the single riskiest sub-problem up front and note that only _that_ piece should escalate to the flagship tier if it proves gnarly.
- **Light** for documentation, a single regression test, and mechanical pattern-following where the spec leaves little to interpret.

When unsure, lean one tier down for docs/tests and one tier up for anything touching data integrity.

---

## Three encoding layers (use all three; they are complementary)

Each layer solves a different visibility problem. None alone is sufficient.

### 1. Label — the source of truth (travels with the issue)

Three repo-scoped labels, with cost-suggestive colors (red = expensive/reserve, amber = mid, green = cheap) so the board reads as a spend gradient:

| Label | Hex color | Meaning |
| --- | --- | --- |
| `model: fable` | `B60205` (dark red) | Flagship — reserve for subtle/multi-module correctness |
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

- **Review runs one tier above the build** — Sonnet build → Opus review, Opus build → Fable review, Fable build → Fable review (Fable is the ceiling, so a flagship build gets a flagship peer rather than nothing).
- **The `--to merge` go/no-go floor stays Fable**, always. A `model: sonnet` label on a merge-tier issue does not lower it; `/autopilot-batch` forces a Fable build for any `--merge` issue precisely so the merge decision is Fable-made.

So a cheap label can only ever cheapen the _build_ — never the safety net that catches a cheap build's mistakes.

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

---

## Implementation runbook (copy-paste `gh` commands)

Replace `<OWNER>` (e.g. your GitHub username), `<PROJECT_NUMBER>`, and the ID placeholders as you discover them.

### 0. Verify prerequisites

```bash
gh auth status                        # confirm 'project' appears in Token scopes
# If not: gh auth refresh -s project  (interactive — the user runs this)
gh project list --owner <OWNER>       # find the board's <PROJECT_NUMBER> and node id (PVT_...)
```

### 1. Create the three labels (per repo)

```bash
gh label create "model: fable"  --color B60205 --description "Recommended model: Fable 5 (reserve for subtle/multi-module correctness)"
gh label create "model: opus"   --color FBCA04 --description "Recommended model: Opus 4.8 (well-scoped features, refactors)"
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

## Worked example (gg-songbook, 7 open issues)

The concrete triage that produced **1 Flagship / 3 Workhorse / 3 Light** — a useful calibration reference for applying the heuristic:

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
