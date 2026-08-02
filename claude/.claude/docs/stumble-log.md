# Stumble Log

Running record of places where Claude got something wrong that a removed instruction would have prevented. **This log is the only admissible evidence for re-adding anything to a `CLAUDE.md` file** (decision D1 on joshukraine/dotfiles#252).

## Why this exists

The ablation method only works if the observation half actually happens. Cutting instructions and then re-adding them from memory or intuition reproduces the original file — the whole point is to let reality decide. So: cut in one pass, work normally, write down every stumble, and re-add only what earns it.

## How to use it

**For Claude:** when you realize you did something Joshua had to correct — and a line that used to be in a `CLAUDE.md` would have prevented it — append a row before moving on. Do this unprompted; it is part of finishing the task. Do not re-add the instruction yourself.

**For Joshua:** when you catch yourself giving a correction you feel like you've given before, add a row (or tell Claude to). The "again?" feeling is the signal.

**Rules:**

- One row per incident, not per category. Three separate wrong-branch-prefix incidents are three rows.
- Record what _actually happened_, not the instruction you wish existed. The fix column is a hypothesis.
- **Do not re-add during the observation window** (Phase 2, ~2 weeks from 2026-08-01). Log and keep going. Re-adds happen in one deliberate Phase 3 pass.
- A line comes back only if it appears here **more than once**. Single incidents are noise.
- Re-add at the narrowest scope that fixes it: skill > project `CLAUDE.md` > global.

## Log

| Date | Repo | What happened | Candidate fix | Scope |
| --- | --- | --- | --- | --- |
| 2026-08-01 | comix_distro | First run of the trimmed `/resolve-issue` on #512. The trim cut Step 1's "extract title, description, labels, **and comments**" as GENERIC, leaving only `gh issue view N` — which prints the body but not the comment thread. That session read the comments anyway, by habit, and the three comments held roughly a third of the real scope plus one that **superseded an acceptance criterion still written in the body**. Following the skill literally would have shipped incomplete work while ticking every AC. Near-miss, not a failure — but only because of an unreliable habit. | Fixed in #254: the fetch step now runs `gh issue view N` **and** `gh issue view N --comments` unconditionally, with the rationale inline. **Closed out 2026-08-02** — #512 ran to completion on the fixed skill with no further surprises, and is merged and deployed. | skill |

## Watch list

Cuts flagged during Phase 1 as the likeliest to come back, so a stumble here is expected rather than surprising. Listing them does **not** pre-authorize a re-add — they still need two logged incidents.

| Candidate | Why it's at risk |
| --- | --- |
| Update docs when functionality changes | Doc drift is silent; `/drift-check` is opt-in and easy to skip |
| No commented-out code | A real model habit; only partially covered by "match surrounding idiom" |
| Mock boundaries, not internal logic | The most opinionated testing line in the removed block |
| Keep changes small and isolated | Cheap to state, and large diffs are hard to review after the fact |

## Non-candidates

Never re-add these to the global file regardless of what the log says — they are structural decisions, not preferences:

- Anything already near-verbatim in Claude Code's own system prompt (see the `HARNESS` entries in [`attic-2026-08.md`](attic-2026-08.md)). If a system-prompt-covered behavior regresses, that is a model or harness observation worth reporting, not a `CLAUDE.md` line.
- Anything relevant to fewer than half of repositories. That belongs in a project `CLAUDE.md` or a skill — the global file loads in every session, including Ukrainian-translation and dotfiles sessions with no code in them.
