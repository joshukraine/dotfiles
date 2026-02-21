# [Project Name] — Pre-Flight Checklist

Before beginning Phase 0 implementation, work through each item below. Items are grouped by priority: **Before Phase 0** items should be completed first, **During Early Phase 0** items can be addressed as part of initial setup, and **Ongoing** items establish patterns that persist throughout development.

**Progress key:** `[ ]` Not started · `[~]` In progress · `[x]` Complete · `[--]` Skipped / not applicable

---

## Before Phase 0

### 1. [ ] Validate PRD Completeness

**What:** Review PRD documents for structural issues, content contradictions, or ambiguities that could cause confusion during implementation.

**Why:** The PRD is the primary specification. Structural issues that survive into implementation cause confusion and incorrect decisions during coding.

**Done when:** PRD has been reviewed, issues triaged, and resulting updates committed.

---

### 2. [ ] Resolve Phase 0-Blocking Decisions

**What:** Review any open or TBD items and identify which decisions directly affect Phase 0. Resolve those decisions and update the relevant PRD files.

**Why:** Phase 0 establishes the project foundation. Ambiguity at this stage gets baked into architectural decisions.

**Done when:** Every open item is categorized as "resolved for Phase 0" or "confirmed safe to defer."

---

### 3. [ ] Create Implementation Briefing

**What:** Create a document that tells Claude Code how to work on this project. Use the template at `~/.claude/templates/implementation-briefing.md`.

**Why:** The PRD is written for a human audience. Claude Code needs a translation layer for how to *use* the specification during implementation.

**Done when:** The document exists, covers PRD navigation / conventions / guardrails, and is referenced in CLAUDE.md.

---

### 4. [ ] Review Slash Commands for Compatibility

**What:** Review existing custom slash commands against the project's architecture for potential conflicts.

**Why:** Slash commands built for general development may subtly conflict with project-specific architectural decisions.

**Done when:** Each command reviewed and flagged as compatible or requiring updates.

---

### 5. [ ] Validate External Dependencies

**What:** Confirm that all external services and resources are in the expected state (accounts provisioned, APIs accessible, third-party repos structured as expected).

**Why:** Discovering a mismatch between assumptions and reality during Phase 0 derails momentum.

**Done when:** Each dependency verified and discrepancies documented.

---

### 6. [ ] Establish PRD Change Management Process

**What:** Define how the PRD evolves during implementation. Set up the `docs/prd/CHANGELOG.md`, establish the "never silently deviate" rule, and define sync session cadence.

**Why:** Without a clear process, PRDs either become stale or become a bottleneck.

**Done when:** CHANGELOG exists, the rule is in the implementation briefing, and sync cadence is defined.

---

## During Early Phase 0

### 7. [ ] Set Up Code Style Guidance

**What:** Add lightweight code style guidance to the implementation briefing that establishes design principles as the default approach.

**Why:** Early sessions establish patterns. A lightweight reference sets the tone without adding overhead.

**Done when:** The directive is in the implementation briefing and is concise enough to be useful.

---

### 8. [ ] Curate UI Component Collection *(if applicable)*

**What:** Select specific UI component variants for each category the project will need. Organize into a reference collection.

**Why:** Early views establish the de facto design language. Choosing the component vocabulary in advance produces a cohesive UI from the start.

**Done when:** Curated collection exists, organized by category, with notes on when to use each one.

---

## Ongoing

### 9. [ ] PRD Evolution Management

**What:** Log every PRD deviation in CHANGELOG.md as it occurs. Conduct periodic sync sessions to fold changes back into the PRD.

**Done when:** This is never "done" — it's a discipline maintained throughout development.

---

### 10. [ ] Phase-Level Briefing and Review Cycle

**What:** Before starting each ROADMAP phase: identify relevant PRD sections, review changelog, brief Claude Code with phase context, and review implementation after completion.

**Done when:** Recurring practice established after the first full phase cycle.

---

## Quick Reference: Sequencing

| Priority | Items | When |
| ---------- | ------- | ------ |
| **Do first** | 1 (PRD validation), 2 (blocking decisions) | Before writing any code |
| **Do before coding** | 3 (briefing), 4 (slash commands), 5 (dependencies), 6 (change mgmt) | Before Phase 0 |
| **Do during Phase 0** | 7 (code style), 8 (UI components) | As part of project setup |
| **Ongoing** | 9 (PRD evolution), 10 (phase briefing) | Throughout development |
