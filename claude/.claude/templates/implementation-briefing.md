# [Project Name] — Implementation Briefing for Claude Code

*This document tells Claude Code how to work on [Project Name]. It is the primary directive for every implementation session. Read it before writing any code.*

---

## 1. PRD Navigation

### Phase-to-File Lookup

Before starting any ROADMAP phase, read the listed PRD files.

| Phase | Name | Read Before Starting |
| ------- | ------ | ---------------------- |
| 0 | Project Foundation | *list relevant PRD files* |
| *Add rows for each phase* | | |

### How to Use ROADMAP.md

`ROADMAP.md` is the task list. Each checkbox is one PR's worth of work. Work through items top-to-bottom within a phase. Mark `[x]` when the PR is merged.

---

## 2. PRD Change Management

### The "Never Silently Deviate" Rule

If the implementation differs from the PRD in any material way — a different column name, a changed workflow, a skipped requirement — log it in `docs/prd/CHANGELOG.md` before merging the PR. No exceptions.

### Three Valid Responses to a PRD Conflict

1. **Implement as written.** The PRD may account for constraints you don't see.
2. **Ask the project owner.** Describe the conflict and propose alternatives.
3. **Propose a PRD change.** Draft a CHANGELOG entry with the rationale.

Never silently do something different.

### What Is NOT a Deviation

Choosing an implementation approach the PRD leaves unspecified is not a deviation. The PRD defines *what* to build; *how* is your domain.

---

## 3. Architectural Guardrails

These are non-negotiable. Do not deviate without explicit approval.

**1. [Guardrail name].**
[Explanation of the guardrail and why it matters.]

*Add numbered guardrails specific to the project.*

---

## 4. Handling Ambiguity

| Decide and Move | Stop and Ask |
| ----------------- | -------------- |
| View organization, helper naming | New database column not in the data model |
| CSS/styling decisions | Changing a model association |
| Test helper naming | Altering a public-facing URL pattern |
| Error message wording | Adding a new dependency not in the tech stack |

**The test:** Is the decision easily reversed (code change, no migration)? Decide and move. Does it create a migration or change a public interface? Ask.

---

## 5. Key Conventions

### Branching

Branch names use conventional prefixes: `feat/`, `fix/`, `chore/`, `docs/`, `test/`.

### Commits

Conventional Commits with a model or feature area scope:

```text
feat(model): add new field
fix(feature): correct validation logic
chore(ci): update GitHub Actions pipeline
```

### PR Checklist

Before opening a PR, verify:

- [ ] Tests pass
- [ ] Linter passes
- [ ] ROADMAP checkbox marked
- [ ] `docs/prd/CHANGELOG.md` updated (if PRD deviation occurred)

---

## 6. Testing Conventions

### Test Categories

| Directory | Tests | Key Patterns |
| ----------- | ------- | ------------- |
| *Fill in based on project framework* | | |

---

## 7. UI/UX Conventions *(optional — include for projects with significant frontend)*

*Document layout patterns, component libraries, responsive strategy, and interaction conventions.*

---

## 8. Patterns That Are Easy to Get Wrong *(optional — include when project has known pitfalls)*

### 1. [Pattern Name]

[Description of the pitfall and how to avoid it.]

> PRD reference: [link to relevant section]

---

## 9. Code Style *(optional — include for language-specific conventions)*

*Document linting tools, naming conventions, and design principles (e.g., POODR for Ruby).*

---

## 10. Quick Reference *(optional — include for complex projects)*

### Key File Locations

| File | Purpose |
| ------ | --------- |
| *Fill in key files* | |

### Terminology Quick-Reference

| Term | Definition |
| ------ | ----------- |
| *Fill in domain terms* | |

### Development Commands

| Command | Purpose |
| --------- | --------- |
| *Fill in key commands* | |
