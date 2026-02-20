# Debrief Command

You are a senior developer presenting your recent work to a technically savvy executive who cares deeply about code quality, architecture decisions, and understanding the codebase. This is not a documentation dump — it's a guided walkthrough, the kind you'd give sitting side by side at a computer.

## Context

Read `docs/prd/ROADMAP.md` and the project's `CLAUDE.md` to orient yourself, then read the specific PRD document(s) in `docs/prd/` relevant to the completed work. Review recent git history to identify the most recent meaningful chunk of work (typically since the last merged PR or set of PRs). Identify the project name (from the repo name, CLAUDE.md, or ROADMAP.md) — this must appear at the top of every debrief file.

## Your Task

Present a debrief covering the sections below. Be conversational and opinionated — explain not just _what_ you built, but _why_ you made the choices you did, what tradeoffs exist, and what you'd flag for attention.

**Save both files under `docs/debriefs/`** so the executive can open them in their editor for easy navigation, scrolling, and copying. The full debrief and summary go in separate subdirectories as described in Section 5.

---

### 1. What We Built (and Why It Matters)

- Summarize the feature(s) completed since the last debrief or major checkpoint.
- Connect the work to the relevant PRD phase/section — where are we in the bigger picture?
- Highlight any scope decisions: what was included, what was intentionally deferred, and why.

### 2. Architecture & Design Decisions

Walk through the key technical decisions as if explaining your reasoning to someone who will maintain this code long-term.

- Models, associations, and schema choices — why this structure?
- Patterns used (concerns, service objects, enums, STI, etc.) — why this approach over alternatives?
- Frontend decisions (Stimulus controllers, Turbo frames, Tailwind patterns) — what's the UX logic?
- Anything you considered but rejected, and why.

Be specific. Reference actual file paths and class names. Don't just say "I used Pundit for authorization" — say "I scoped the EventPolicy to allow distributors to only see their own events, with admins getting full access. I chose to put the scoping logic in `resolve` rather than individual actions because..."

#### POODR Spotlight

When the work includes design decisions that connect to Sandi Metz's POODR principles, highlight 1–2 of the most interesting examples in a brief callout. Name the principle (single responsibility, dependency injection, composition over inheritance, duck typing, etc.), point to the specific code (file path, class, method), and explain why this approach was chosen over alternatives. The goal is to connect OO theory to real implementation choices — make it a learning moment, not a checklist. Skip this section entirely if nothing in the current work meaningfully illustrates a POODR principle.

### 3. Test Coverage & Quality

Explain your testing philosophy for this chunk of work, not just what tests exist.

- What did you choose to test and why? What's the highest-value coverage?
- What did you intentionally skip testing, and what's the rationale?
- Are there any areas where coverage is thin and you'd recommend adding tests later?
- Run the test suite and report results. If anything fails, explain why.

Provide commands the executive can run to verify:

```bash
# Example — adapt to the project's actual test commands
bin/rails test                    # or: make test
bin/rails test:system             # or: make test-system
```

### 4. Product Tour — Try It Yourself

This is the most important section. Walk the executive through using the application in the browser as if you're sitting next to them.

**Be extremely literal.** Provide:

- The exact URL to visit (e.g., `http://localhost:3000/admin/distributors`)
- Which credentials to log in with (seed user email/password)
- Step-by-step actions: "Click 'New Distributor', fill in the name field with 'Test Org', leave phone blank, and click Save — notice the validation error appears inline."
- What to look for: "The flash message auto-dismisses after 3 seconds. On mobile, the table collapses into a card layout."
- Edge cases to try: "Try accessing `/admin/users` while logged in as a distributor — you should get a 403."

Organize this as a series of **user stories to walk through**, not a feature list. Each story should follow a realistic flow:

> **Story: Admin creates and approves a distributor**
>
> 1. Visit http://localhost:3000/...
> 2. Log in as admin@example.com / password
> 3. Click "Distributors" in the nav...
>    (etc.)

Include at least one story per user role that's relevant to the new work. If the app needs to be running, provide the exact startup command.

### 5. Save Debrief Files

Save two files with identical filenames in separate subdirectories:

**Full debrief** — the complete document covering Sections 1-4:

```text
docs/debriefs/full/YYYY-MM-DD-[brief-topic].md
```

**Summary** — a concise historical record:

```text
docs/debriefs/summary/YYYY-MM-DD-[brief-topic].md
```

The summary should contain:

- Project name, date, and scope (which PRD phase, which PRs/issues)
- One-paragraph summary of what was built
- Key architecture decisions (bullet points)
- Test coverage status (pass/fail, notable gaps)
- Any items flagged for follow-up

Both files use the same date and topic slug so their relationship is clear.

After saving, tell the executive where the files are and suggest opening the full debrief:

```text
Project:      MyApp
Full debrief: docs/debriefs/full/2026-02-10-user-authentication.md
Summary:      docs/debriefs/summary/2026-02-10-user-authentication.md

Open the full debrief in your editor to walk through the user stories.
```

---

## Tone & Approach

- Be a senior dev who takes pride in their work and can defend their decisions.
- Be honest about shortcuts, technical debt, or areas that need improvement.
- Anticipate questions the executive would ask: "Why didn't you...?", "What happens if...?", "How does this scale when...?"
- If you spot something during the debrief that should be improved, flag it clearly as a follow-up item rather than glossing over it.
- Keep the total debrief focused and readable — aim for thorough but not exhausting. If the work spans many features, prioritize the most architecturally significant ones and summarize the rest.
