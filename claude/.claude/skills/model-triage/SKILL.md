---
name: model-triage
description: Adopt the per-issue model-selection convention in a repo — tier every open issue, apply the model: labels, board field, and callouts behind an approval gate. Also runs in maintenance mode to sweep up unlabeled issues and label/field drift.
disable-model-invocation: true
argument-hint: "[--maintenance]"
---

# Model Triage

Roll the per-issue model-selection convention into a repository: tier each open issue, then apply the `model:` labels, the board's `Model` field, and any body callouts — all behind a single approval gate. The convention, its heuristic, and the manual runbook this encodes live in `~/.claude/docs/model-selection-strategy.md`; the label vocabulary lives in `~/.claude/docs/label-taxonomy.md`.

This is a **rollout tool, not a routine one.** Model labels are assigned at issue creation alongside the type label. Run this skill once when adopting the convention in a repo that already has open issues, and after that only in maintenance mode when drift has accumulated.

## Where this runs

From the **target repository's checkout** — you need the issues _and_ the code, because tiering an issue means judging what a fix would actually touch. If you must run from elsewhere, every `gh issue` call needs `--repo <owner>/<name>`; without it the command silently targets whatever repo you are standing in.

## Arguments

- **(no args)** — full rollout: tier every open issue that should carry a label.
- **`--maintenance`** — sweep mode: tier only issues _missing_ a label, and reconcile label ↔ board-field drift. Leaves existing labels alone unless an issue's scope has visibly changed.

## The tiering heuristic

Assign a tier by asking what a _wrong answer_ costs and how far the reasoning reaches. Full treatment in the strategy doc; the working summary:

- **Fable (flagship)** — a wrong answer would _silently_ corrupt canonical/persistent data, **or** the reasoning spans several modules with non-obvious ripple. This is the insurance case. Expect it rare, and expect each one to have a nameable reason.
- **Opus (workhorse)** — well-specified features with a test scaffold and a contained blast radius; migrations / data-model; thin specs; security-adjacent work. The default when you genuinely can't tell.
- **Sonnet (light)** — docs, a single regression test, i18n / copy, mechanical pattern-following where the spec leaves little to interpret and failure is visible.

Lean one tier down for docs/tests, one tier up for anything touching data integrity.

**Calibration:** ComixDistro's settled pass was 4 Fable / 32 Opus / 25 Sonnet across 61 issues — roughly **6% flagship**. If your pass lands far above that, you are not discriminating, you are just spending. Check the two calibration references in the strategy doc before presenting.

### Issues that get no tier

Some issues have nothing to build directly, and a tier on them is noise:

- **epics and tracking issues** — the children carry the tiers
- **content hubs** — durable reference/index issues
- **`qa` reports** — the tech issue derived via `/qa-triage` carries the tier

Call these out explicitly as deliberate exclusions rather than silently skipping them; an unexplained gap looks identical to an oversight.

## Your task

### Step 0 — Preflight

Establish that everything the apply step needs exists, and stop early if it doesn't:

1. **Token scope** — `gh auth status` must list `project` in the token scopes. If it's missing, stop: the user must run `gh auth refresh -s project` interactively. You cannot grant it for them.
2. **Locate the board** — `gh project list --owner <OWNER>`; capture the project number and node ID (`PVT_…`). If the repo has no board, the label pass can still proceed — say so and skip the field work rather than stopping.
3. **Labels exist** — `gh label list`. Create any missing ones from the taxonomy, exactly as specified there:

   ```bash
   gh label create "model: fable"  --color B60205 --description "Recommended model: Fable 5 (reserve for subtle/multi-module correctness)"
   gh label create "model: opus"   --color FBCA04 --description "Recommended model: Opus 4.8 (well-scoped features, refactors)"
   gh label create "model: sonnet" --color 0E8A16 --description "Recommended model: Sonnet (docs, single tests, mechanical edits)"
   ```

4. **`Model` field exists** — `gh project field-list <N> --owner <OWNER> --format json`. If absent, create it once:

   ```bash
   gh project field-create <N> --owner <OWNER> \
     --name "Model" --data-type SINGLE_SELECT --single-select-options "Fable,Opus,Sonnet"
   ```

5. **Board membership** — `gh project item-list <N> --owner <OWNER> --limit 200 --format json`. Diff against the open-issue list; **an issue not on the board cannot receive a field value.** Note the strays now so the apply step can `gh project item-add` them first. Trust `item-list` over any claim an issue body makes about its own board membership.

Report the preflight result compactly: what existed, what you created, what needs adding to the board.

### Step 1 — Gather

- `gh issue list --state open --limit 200 --json number,title,labels,body`.
- In `--maintenance` mode, narrow to issues with no `model:` label — plus any whose scope has visibly changed since labeling.

### Step 2 — Tier

Read each issue's body and, where scope is unclear, the code a fix would touch. For each, decide:

- its **tier**, with a one-line reason grounded in the heuristic (what a wrong answer costs / how far the reasoning reaches);
- whether it is a **deliberate exclusion** (epic / tracker / hub / qa report);
- whether it warrants a **body callout** — only where the tier choice carries real nuance a bare label cannot convey, e.g. "workhorse, but escalate _this specific sub-problem_ to flagship if it gets gnarly." Plain light-tier docs issues need none. A callout on every issue is a callout on none.

Note anything else the pass turns up — duplicates, already-shipped work, issues whose spec has drifted from the code. A careful read of every open issue surfaces this whether you want it or not, and it is worth more than the tiering.

### Step 3 — Present + APPROVAL GATE

Present the full mapping before touching anything:

```text
Tiering — 23 issues (2 Fable / 12 Opus / 9 Sonnet)

  #58   Fable   chord_only_line? has four dependents; a miss silently corrupts song files
  #49   Opus    --transpose; test scaffold exists, contained. Watch: enharmonic spelling
  #50   Sonnet  docs over a settled pipeline, no correctness stakes
  …

Excluded (no tier, deliberate):
  #12   epic — children carry the tiers
  #77   qa report — derived tech issue carries the tier

Proposed callouts (3):
  #49   "Opus, but escalate the enharmonic-spelling logic to Fable if it proves gnarly"
  …

Also noticed:
  #61   appears to duplicate #44
  #83   spec references a helper that no longer exists

Board: 2 open issues are not board items (#71, #84) — will add before the field pass.
```

**STOP for explicit approval.** Nothing is labeled, no field is set, and no body is edited before the user says go. They may retier anything, drop callouts, or expand the exclusions. This gate is the whole safety model of the skill: it writes to every open issue in the repo, and a bad pass is tedious to unwind.

### Step 4 — Apply

Only after approval, in this order:

1. **Board strays first** — `gh project item-add <N> --owner <OWNER> --url <issue-url>` for each, or their field values silently no-op.
2. **Labels** — `gh issue edit <n> --add-label "model: <tier>"`.
3. **Field values** — collect the field ID and option IDs (`gh project field-list … --format json`) and the item IDs (`gh project item-list … --format json`), then per issue:

   ```bash
   gh project item-edit --id <ITEM_ID> --project-id <PROJECT_NODE_ID> \
     --field-id <MODEL_FIELD_ID> --single-select-option-id <OPTION_ID>
   ```

4. **Callouts** — **round-trip the body, never retype it.** Fetch, prepend, write back:

   ```bash
   gh issue view <n> --json body --jq .body > /tmp/body.md
   # build /tmp/head.md: the callout blockquote, a blank line, ---, a blank line
   cat /tmp/head.md /tmp/body.md > /tmp/final.md
   gh issue edit <n> --body-file /tmp/final.md
   ```

   Callout template:

   ```markdown
   > **🤖 Recommended model: <Model>.** <One sentence: why this tier, and the single watch-item or escalation trigger if any.>
   ```

5. **Board README** — if the board's README has no "Model = recommended build tier" section, append it. The settled wording lives in the ComixDistro board #11 README; the template board carries it for new projects.

### Step 5 — Verify

- Run the drift check and confirm the only issues returned are the approved exclusions:

  ```bash
  gh issue list --state open --limit 200 --json number,labels --jq '[.[] | {n: .number, m: [.labels[].name | select(startswith("model"))]}] | map(select(.m | length != 1)) | map(.n)'
  ```

- Spot-check a few board cards against their labels, and one edited body to confirm the callout landed with the original text intact below it.
- Report the final distribution (`N Fable / N Opus / N Sonnet`, flagship share) and how it compares to the calibration references.

## Important

- **The approval gate is a hard stop.** This skill writes labels, board fields, and issue bodies across an entire repo. Nothing is applied speculatively.
- **Never retype an issue body.** Callouts are prepended to a round-tripped body via `--body-file`. Retyping loses content, and the loss is silent.
- **The label is the source of truth; the field mirrors it.** If they disagree, the label wins — fix the field.
- **This is a backstop, not the primary mechanism.** Model labels belong at issue creation, alongside the type label. If maintenance mode keeps finding large numbers of unlabeled issues, the fix is upstream at issue creation, not more frequent sweeps — say so in the report rather than quietly re-sweeping.
- **Flag what the read surfaces.** Tiering requires reading every open issue closely, which reliably turns up duplicates and stale specs. Report them; that byproduct is often worth more than the labels.
