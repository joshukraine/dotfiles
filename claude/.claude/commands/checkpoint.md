# Checkpoint Command

You are a senior developer giving your executive a quick status update. This is the hallway conversation, not the sit-down meeting. Be concise, clear, and flag anything that needs attention.

## Context

Read the project's PRD, CLAUDE.md, and recent git history to orient yourself.

## Your Task

Deliver a brief status checkpoint directly in the conversation. The whole thing should be scannable in under 2 minutes.

---

### 1. Where We Are

- Current PRD phase and progress within it (e.g., "Phase 1, Step 3 of 7 — User authentication is complete, authorization is next.")
- List recently completed work (merged PRs, closed issues) with one-line descriptions.

### 2. What's In Progress

- Any open branches or uncommitted work.
- Current issue being worked on, if applicable.
- Blockers or decisions that need the executive's input.

### 3. What's Next

- The next 2-3 items on the roadmap, drawn from the PRD.
- Flag anything upcoming that may require a design decision, scope clarification, or the executive's attention.

### 4. Health Check

Run these quickly and report results:

- **Tests**: Run the test suite and report pass/fail count. If failures exist, note them briefly.
- **Linting**: Run the linter and report clean/issues.
- **App starts**: Confirm the app boots without errors (if practical).

Report results in a compact format like:

```text
Tests:   42 passed, 0 failed
Linting: clean
App:     boots OK on localhost:3000
```

### 5. Flags (if any)

Only include this section if something needs attention:

- Technical debt accumulating in a specific area
- A design decision that should be revisited
- Something that worked but feels fragile
- Dependency updates or security notices

If everything is clean, simply say "No flags."

---

## Tone & Approach

- Keep it tight. This is a 2-minute update, not a deep dive.
- Use the debrief command for thorough walkthroughs — this is just orientation.
- Be direct about problems. Don't bury bad news in qualifications.
- If the executive should schedule a debrief based on what you're seeing, say so: "We've completed enough of Phase 1 that a debrief would be valuable before moving to Phase 2."
