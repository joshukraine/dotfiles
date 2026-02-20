# QA Handoff Command

**Applicability:** This command is designed for Rails applications that follow a PRD-driven development workflow with `docs/prd/ROADMAP.md` and a debriefs structure under `docs/debriefs/`. If the current project is not a Rails application or does not follow this structure, stop and tell the user this command is not applicable to the current project.

---

You are a senior developer preparing a hands-on testing guide for a QA colleague. Your colleague is technically capable — they run the app locally, can execute the test suite, and are excellent at finding gaps in behavior and UX. They are NOT tracking implementation details, architecture decisions, or code-level rationale. Write for someone who understands the product but needs a clear, step-by-step guide to exercise the new work.

## Context

1. Read the project's `CLAUDE.md` and `docs/prd/ROADMAP.md` to orient yourself. Identify the project name, current phase, and any project-specific testing guidance (viewport requirements, audience-specific considerations, etc.).
2. Check `docs/debriefs/full/` for the most recent debrief. If one exists for the current work, use its Product Tour section as your primary source for walkthrough scenarios. Adapt the content for a QA audience: strip architecture rationale, keep the step-by-step actions and expected behaviors, and add exploratory testing prompts.
3. If no recent debrief exists, build the walkthrough from scratch by reviewing recent git history, seed data, routes, and controllers.
4. Read `db/seeds.rb` to identify available test accounts and their credentials. Reference these exactly in the walkthrough scenarios.
5. Review the Gemfile and recent migrations for any setup changes the tester needs to know about.

## Output Format

Generate a markdown document with the following sections. Follow this structure exactly.

---

### Header

```markdown
# QA Handoff — Phase [N]: [Phase Title]

**Project:** [project name]
**Date:** [YYYY-MM-DD]
**Branch:** `main` (or feature branch if applicable)
**Commit:** [short SHA from HEAD]
**Debrief reference:** [path to related debrief, or "N/A" if none]
```

### Section 1: What's New

A plain-language summary of what was built in this phase or milestone. Write for someone who understands the product but isn't tracking implementation details. 2-4 paragraphs covering the key features, changes, or capabilities added. Connect the work to the roadmap — where are we in the bigger picture?

No file paths, class names, or architecture jargon.

### Section 2: Getting Current

Specific setup instructions to get the tester's local environment up to date. Check for each of these and report concretely:

- Commands to pull and install (`git pull`, `bundle install`, `bin/rails db:migrate`, `bin/rails db:seed`)
- Whether a full `bin/rails db:reset` is needed instead of `db:migrate`
- New gem dependencies or system packages
- New environment variables or credentials changes
- The command to start the app (typically `bin/dev`) and the URL to confirm it boots

Don't say "some dependencies changed" — list them. If nothing changed in a category, say "None."

### Section 3: Guided Walkthrough

A series of numbered scenarios the tester should work through in order. Each scenario includes:

- **A descriptive name** as the heading
- **Role** — which user type (from seed data)
- **Login** — exact email and password from seed data
- **URL** — exact starting URL
- **Steps** — extremely literal, numbered instructions. The tester should be able to follow these without guessing.
- **Expected behavior** — precise enough that a deviation is obvious.

Include at least one scenario per user role affected by the new work. Read the project's `CLAUDE.md` for any audience-specific or viewport-specific testing guidance (e.g., mobile-first user types, dual-audience designs) and include appropriate scenarios.

### Section 4: Exploratory Testing

An open-ended checklist (using `- [ ]` checkboxes) of areas to poke at. The goal is to surface anything that feels off, confusing, or broken. Draw from:

- Areas the debrief flagged as "thin test coverage" or "worth manual verification"
- Permission boundary tests (accessing another user's data, role escalation)
- Responsive/mobile checks if the work has UI changes
- Edge cases a careful tester would try that a developer might not

### Section 5: Test Suite Verification

Commands to run the test suite, including both the full suite and targeted test files most relevant to the new work. Note any known skips or expected failures.

```bash
# Full suite
bin/rails test

# System tests
bin/rails test:system

# Phase-specific tests
bin/rails test test/models/[relevant_file].rb
```

### Section 6: Feedback

A section for the tester to fill in, with these subsections:

- **Bugs or Broken Behavior** — anything that didn't work as described or produced an error
- **Things That Felt Off** — UI confusion, clunky flows, odd wording
- **Edge Cases or Gaps** — scenarios they tried that weren't covered
- **Ideas or Suggestions** — feature ideas, UX improvements
- **Other Notes** — anything else

Include a note that brief bullet points and gut reactions are welcome — this section shouldn't feel like homework.

---

## Save Location

Save the completed QA handoff to:

```text
docs/qa-handoffs/YYYY-MM-DD-[brief-topic].md
```

Create the `docs/qa-handoffs/` directory if it doesn't exist. Use the same date-and-slug convention as debriefs. After saving, tell the user:

```text
QA handoff saved: docs/qa-handoffs/YYYY-MM-DD-[brief-topic].md

Hand this file to your QA colleague. They should:
1. Pull the latest code
2. Follow the "Getting Current" section
3. Work through the walkthrough and exploratory testing
4. Fill in the Feedback section and return it to you
```

## Tone & Approach

- Be friendly and practical, not formal. The reader is a colleague, not a client.
- Err on the side of over-explaining steps rather than under-explaining. The goal is zero ambiguity in the walkthrough.
- If you discover something during QA handoff generation that looks broken or concerning, flag it clearly as a note to the developer, not as something for the tester to fix.
