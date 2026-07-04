---
name: qa-triage
description: Triage a QA-labeled report — investigate it against the code, classify it, and draft the technical issue(s) it warrants, stopping for approval before creating anything.
argument-hint: "[issue-number ...]"
---

# QA Triage

Turn a QA report into a triaged decision and, where warranted, one or more well-formed technical issues — without resolving the report off the bat or writing any app code.

QA reports (filed by a tester, usually carrying a `qa` label) are the _tester's view_ of a problem. They describe user-visible symptoms; the engineering fix is often differently scoped — one report may need several tech issues, or several reports may share one root cause. This skill does the standard review-and-extrapolate ritual: read the report, confirm it against the codebase, decide what (if anything) to build, and draft the issue(s) — then **stop for the human to approve** before anything is created.

**Where it sits in the workflow.** This is the _first_ step for a `qa`-labeled issue. Its output feeds the normal pipeline: an approved tech issue goes to `/resolve-issue` → `/create-pr` → `/walkthrough` + `/code-review` → merge. This skill never implements; it only triages and drafts.

**Applicability.** Needs a GitHub repo (`gh`). Built around a QA-report labeling convention but otherwise project-agnostic — no project names, tester identities, or paths are hardcoded. It reads the project's `CLAUDE.md` for local conventions (board, workflow, bilingual i18n, etc.) and embeds the rest itself.

**Not the same as:**

- `/resolve-issue` — it _implements_ an approved issue. This one _creates_ the issue for it to implement. Hand off; don't duplicate.
- `/qa-handoff`, `/walkthrough` — those help a tester _exercise_ the app and _file_ reports. This one _processes_ a report after it's filed.

## The core guardrail

A QA report is an **input, not a directive**. It is taken seriously, but it is not gospel: a tester may misread intended behavior, or suggest a change that would be counterproductive. The product decision — whether and how to act, including on items framed as "fixes" — belongs to the human, worked through a separate tech issue. So this skill's job ends at a **decision gate**: it analyzes and proposes; the human decides. The only thing it ever resolves directly is an explicit, approved trivial-cosmetic fix.

## Your task

When passed more than one issue number, triage each in turn, presenting a full analysis and decision gate per report before moving to the next.

### 1. Fetch the report

- `gh issue view <N> --json number,title,body,labels,author,comments,url` — capture the symptom, steps, expected vs actual, locale, screenshots, and the **author** (needed later for the verification @-mention).
- Note whether it carries the `qa` label. If it clearly isn't a QA report, say so and confirm the user still wants to triage it.
- If the body references a Honeybadger fault, note it — the eventual fix should mark that fault Resolved (re-arms notifications).

### 2. Orient on project conventions

- Read the project's `CLAUDE.md` (and any QA-workflow notes it points to) for: whether the project uses a separate-tech-issue workflow, a project board, type-label taxonomy, bilingual/i18n requirements, and viewport/mobile rules. Adapt to what you find; default to the separate-tech-issue pattern for non-trivial work.
- Resolve the invoker once: `gh api user --jq .login`. You'll compare it to the report author for the @-mention.

### 3. Investigate against the codebase

- Search the code for the surface the report describes and **confirm the symptom is real**. Reproduce the logic path; find the root cause; note the file(s) involved.
- Distinguish _what the tester saw_ from _what the code actually does_ — this is where "not-a-bug" and "wrong-assumption" cases surface. State your evidence (e.g. "no `validates :event_type` exists on the model; the field is an unbacked string column").
- **Weigh evidence of design intent before calling something a bug.** Guards (`if x.present?`), defaults, the absence or presence of a validation, and existing tests reveal whether the current behavior was _chosen_. Code that consistently tolerates the reported state was most likely written to allow it — a strong signal the report is a feature ask or working-as-intended, not a regression.
- For UI/text reports, find the exact source (e.g. the i18n key) and check every affected locale, not just the one in the report.

### 4. Classify

Sort the report into exactly one bucket and recommend the matching action:

| Bucket | What it looks like | Recommended action |
| --- | --- | --- |
| **Not a bug / intended** | The reported behavior is correct, or the suggestion would be counterproductive | Propose closing the QA report with an explanatory comment (@-mention the author so they understand the reasoning and can push back). No tech issue. |
| **Trivial cosmetic** | Typo, label wording, a one-line i18n change with an obvious, low-risk fix | Resolve the QA report directly — recommend handing it straight to `/resolve-issue <qa-N>`. No separate tech issue. |
| **One tech issue** | A real defect or feature with a single, coherent fix | Draft one tech issue (template below). |
| **Multiple / cluster** | The report spans several code areas, or several reports share one root cause | Draft each tech issue; apply the multi-PR closing rule below. |

When unsure between buckets, surface the ambiguity at the gate rather than guessing — especially the "is this even intended behavior?" question, which is the human's to answer.

### 5. Draft the proposal

For every tech issue you'd create, draft it in full (don't create yet) using the **Tech issue template** below:

- **Title**: Conventional Commits prefix matching the work (`feat:`/`fix:`/`chore:`/`docs:`). This doubles as the type label so `/resolve-issue` can infer the branch prefix.
- **Acceptance criteria**: a `- [ ]` checklist `/resolve-issue` can check off. Include "mark the Honeybadger fault Resolved after deploy" when applicable.
- **Back-link**: a `Triggered by QA report #<qa>` line. ("Triggered by" is deliberately a non-keyword verb — it creates a reference, never an auto-close.)
- **Closing plan**: how the eventual PR should close things (see @-mention logic and multi-PR rule below).
- **Labels**: the type label, plus any the project's taxonomy calls for. Do **not** add the `qa` label to tech issues — that label belongs to reports.

### 6. Decision gate — STOP

Present, per report: what you found in the code, the classification with reasoning, and the full draft of each proposed issue (title, body, labels) plus the proposed @-mention. Then **STOP and ask for approval.** The human may approve as-is, edit, reclassify, decline (e.g. close as working-as-intended), or defer. Do not create, comment, edit, or close anything before you get a clear yes.

### 7. On approval, act

- **Create** each approved tech issue: `gh issue create --title … --body-file <tmp> --label <type>`. Use a temp file for the body to avoid shell-quoting pitfalls; remove it after.
- **Board**: if the project uses a GitHub Projects board (per `CLAUDE.md` or `gh project list`), add the new issue(s); otherwise skip.
- **Trivial-cosmetic** approval: no tech issue — hand off to `/resolve-issue <qa-N>` directly. Its closing PR resolves the QA report, so it must still carry the verification @-mention; record this closing line for it: `Closes #<qa> — please verify after deploy, @<author>` (the resolver emits a bare `Closes #N` by default).
- **Not-a-bug** approval: post the agreed explanatory comment and close the QA report (with the @-mention).
- The QA report itself stays **open** for non-trivial work — it closes only when the implementing PR merges (per the closing plan).

### 8. Hand off

Report what was created and recommend the next command: `/resolve-issue <tech-N>`. Do not start implementing.

## @-mention logic (project-agnostic)

The QA-report @-mention is a **verification ping** — it tells whoever should confirm the fix after deploy. That person is, by definition, the report's author.

- **Default**: propose `@<report-author>` (from step 1) in the closing plan.
- **Skip when author == invoker** (step 2) — you don't ping yourself. Say so rather than dropping it silently.
- **Always confirmable** at the decision gate: accept, swap, add others, or clear. There is no fixed-reviewer config — the author default plus the gate covers the cases without hardcoding anyone.
- **Browser-only / non-GitHub testers**: the issue's author is whoever actually filed it; mention that account (or skip if it's you), and note that an out-of-band heads-up to the real tester is the human's call. The skill can't notify someone who isn't on GitHub.
- If the author looks like a bot, propose no mention.

## Conventions to encode (the error-prone ones)

- **Closing-keyword hazard.** GitHub auto-closes an issue on merge when a closing keyword (`close`/`closes`/`closed`, `fix`/`fixes`/`fixed`, `resolve`/`resolves`/`resolved`) appears immediately before any `#N` _anywhere in the PR body_ — not just on the `Closes:` line. When a PR should _reference_ but not close an issue, never put a keyword right before its `#N`: drop the `#` ("QA report 503") or use a non-keyword verb ("addresses", "wraps up"). This is the trap that prematurely closes QA reports.
- **Dual-close + verification @-mention**, on the single PR that closes the QA report:
  `Closes #<tech>, Closes #<qa> — please verify after deploy, @<author>`
- **Multi-PR rule** (one report → multiple tech issues): only the **final** PR closes the QA report. Earlier tech issues' closing plans say _close this tech issue only_ (`Closes #<tech>`) and must carry **no** auto-closing reference to the QA report. The last tech issue's closing plan carries the full dual-close + @-mention line.

## Tech issue template

```markdown
<One-paragraph problem statement grounded in the triage: the real defect/need and
its root cause in the code — not a restatement of the tester's symptom.>

Triggered by QA report #<qa>.

## Acceptance criteria

- [ ] <observable, testable outcome>
- [ ] <edge case / affected locale / regression guard>
- [ ] Mark Honeybadger fault <id> Resolved after deploy   ← only if the report cites one

## Closing plan

When the PR for this issue lands, close with:
`Closes #<this>, Closes #<qa> — please verify after deploy, @<author>`

<For a multi-issue report, replace the line above on every issue EXCEPT the final
one with: "Closes #<this> only — do NOT reference the QA report with a closing
keyword (see closing-keyword hazard)." The final issue carries the dual-close line.>
```

## Tone

- You are triaging for a technical lead who wants the _why_, not just the _what_. Show your evidence from the code; make the classification defensible.
- Be the skeptic the report needs: confirm the symptom, but don't assume the tester's diagnosis or proposed fix is correct.
- When you spot adjacent problems while investigating, flag them as notes — don't silently fold them into scope.
