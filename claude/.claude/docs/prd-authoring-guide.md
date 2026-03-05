# PRD Authoring Guide

How to write a Product Requirements Document through structured brainstorming with an AI collaborator. Companion to `spec-driven-development.md`, which covers what happens **after** the PRD exists — deviation tracking, checkpoints, document lifecycle.

Informed by the brainstorming sessions that produced the ComixDistro and Bible First PRDs.

---

## 1 When You Need a PRD

Not every piece of work needs a PRD. The decision framework:

| Scope | What to write | Example |
| ----- | ------------- | ------- |
| Single PR, clear implementation | GitHub issue with acceptance criteria | "Add city field to Distributor" |
| Multiple PRs, some design decisions | Feature spec (detailed issue or lightweight doc) | "Add onboarding flow for new users" |
| Multiple PRs across feature areas, data model decisions, lifecycle design | Full modular PRD | "Build a literature distribution management app" |

**The threshold:** If the work requires multiple PRs *and* involves design decisions that constrain future work (data model, authorization rules, status lifecycles), write it down before building it.

A PRD is not an overhead tax — it's a thinking tool. The act of writing forces you to resolve ambiguity that would otherwise surface as rework during implementation. The question isn't "is this work important enough for a PRD?" — it's "will I make better decisions if I think through this systematically before coding?"

---

## 2 The Brainstorming Phase

This is the core of PRD authoring: a structured conversation between you and an AI collaborator that surfaces requirements, resolves ambiguity, and produces material ready to organize into PRD files. The brainstorming phase is not freeform chatting — it follows a deliberate arc.

### Setting up the conversation

The quality of the brainstorming output is directly proportional to the quality of the context you provide upfront. Before starting the discovery arc, give the AI collaborator:

- **Domain knowledge** — what problem does this project solve? Who are the users? What does the workflow look like today (manual processes, existing tools)?
- **Constraints** — tech stack decisions already made, budget/timeline limits, regulatory requirements, deployment environment.
- **Personas** — who will use this system? What are their technical comfort levels? What matters most to each persona?
- **Prior art** — existing systems this replaces or extends. Screenshots, workflows, or documentation from the current process.
- **Non-goals** — what this project is explicitly *not* trying to do. Fences prevent scope creep before it starts.

Don't drip-feed context across the conversation. Front-load it. A single, comprehensive context dump at the start produces better results than corrections and clarifications scattered across twenty exchanges.

### The discovery arc

Productive brainstorming follows a natural progression from abstract to concrete. Each phase builds on the previous one:

1. **Vision** — what does this system do, in one paragraph? Who is it for? What does success look like?
2. **Personas** — who uses it, what do they need, what are their constraints? Personas ground the rest of the conversation in real user needs rather than abstract features.
3. **Feature areas** — what are the major capabilities? Group related functionality. This is where the modular PRD structure starts to emerge — each feature area is a candidate for its own PRD file.
4. **Data model** — what are the entities, their attributes, and their relationships? This is where vague feature descriptions become concrete. Many design decisions crystallize when you ask "what does this look like in the database?"
5. **Lifecycles** — what statuses do key entities pass through? Who triggers each transition? What happens at each step? Status lifecycles are the skeleton of workflow logic.
6. **Edge cases** — what happens when things go wrong? What are the boundary conditions? What does the user see when they do something unexpected? Edge cases often reveal missing requirements and unstated assumptions.

You don't have to follow this sequence rigidly, but resist the urge to jump to edge cases before the data model is clear, or to design lifecycles before personas are established. The arc exists because each phase provides context that makes the next phase more productive.

### Staying focused

Brainstorming sessions have a natural tendency to sprawl. Three techniques to keep them productive:

**The parking lot.** When a tangent surfaces — an interesting idea, a "what about..." question, a feature that doesn't belong to the current phase — capture it explicitly ("Let's park that for now and come back to it") rather than following it. Keep a running list of parked items to revisit at the end of the session or in a separate session.

**The MVP filter.** For every feature or requirement that surfaces, ask: "Is this MVP or later?" Don't debate it extensively — just tag it and move on. The RFC keywords (MUST/SHOULD/MAY) from the PRD conventions are useful here. If you can't quickly agree on MUST vs. MAY, that's a signal the feature needs more discussion — park it.

**Time-boxing feature areas.** Don't spend 80% of the session on the first feature area and rush through the rest. Set a rough time budget per area. If a feature area is consuming disproportionate time, that's usually a signal it needs to be split into smaller areas, not that it needs more brainstorming in one sitting.

### Knowing when you're done

A brainstorming session has produced enough material when:

- You can name all the feature areas and describe each in a sentence.
- The core data model is sketched — entities, key attributes, relationships. Not every column, but the shape.
- Status lifecycles for the primary entities are mapped out, including who triggers each transition.
- You have a rough phase ordering — what depends on what, what's MVP, what's later.
- You've accumulated a parking lot of deferred items and edge cases to address in later sessions or during implementation.

You are *not* done when you've only discussed the happy path. You are *not* done when the data model is still vague ("we'll figure out the fields later"). You *are* done when you could hand the notes to a developer and they'd know where to start.

---

## 3 What to Specify Tightly vs. Loosely

Not everything in a PRD needs the same level of detail. Over-specifying wastes planning time and creates unnecessary rigidity. Under-specifying creates ambiguity that leads to rework.

### Specify tightly

These decisions are hard to change later, affect multiple parts of the system, or define the contract between components:

- **Data models** — entities, attributes, types, relationships, required fields. A missing column is a migration; a wrong relationship is a redesign.
- **Status lifecycles** — states, transitions, who can trigger each transition. These define the core workflow and are referenced throughout the codebase.
- **Authorization rules** — who can see/do what. Security decisions need to be explicit and centralized.
- **Notification triggers** — what events trigger emails, in-app alerts, or other notifications. These create user expectations that are hard to walk back.
- **Validation rules** — what constitutes valid data at system boundaries. Specify the *what* (e.g., "phone number is required and must be valid format") even if you leave the *how* flexible (exact regex, library choice).
- **URL patterns** — public-facing URLs are a contract. Internal routes are less critical, but anything users might bookmark or share deserves thought.

### Specify loosely

These decisions are easily changed, don't affect system contracts, and benefit from implementation judgment:

- **UI layout and styling** — describe the information to display and the user's task, not pixel positions or exact CSS. "Show a card for each event with status, date, and location" is better than a wireframe that constrains layout.
- **Helper naming and code organization** — how to structure modules, name private methods, organize test files. These are implementation details.
- **Error message wording** — specify *when* errors appear, not the exact copy. "Show an error when the user submits without required fields" is enough.
- **Form field ordering** — unless the order has UX significance (e.g., a multi-step wizard), leave it to implementation.

### The gray area

Some decisions need partial specification — enough to constrain the important parts while leaving room for implementation judgment:

- **Validation rules** — specify *what* is validated and the business logic ("one active event per distributor at a time"), but leave implementation details flexible (model validation vs. database constraint vs. both).
- **URL patterns** — specify the structure for user-facing URLs, leave admin/internal routes flexible.
- **Form fields** — specify which fields exist and which are required, leave ordering and grouping flexible.
- **Search and filtering** — specify what users need to find, leave the UI mechanism flexible (search box vs. filters vs. both).

### The heuristic

Ask: **"If a developer made this decision differently than I imagine, would I care?"**

If the answer is "yes, because it changes the user experience / data model / security posture" — specify it tightly.

If the answer is "no, as long as it works and is maintainable" — specify it loosely or skip it entirely.

If the answer is "maybe, depends on what they choose" — specify the constraint ("MUST support filtering by status") and leave the mechanism open.

---

## 4 Structuring for Incremental Implementation

A PRD that can't be built incrementally is a PRD that will be ignored. Structure matters.

### One file per feature area

This is the modular structure from the templates in `~/.claude/templates/prd/`. Each file is self-contained enough that a developer can read it in isolation and understand the feature. Cross-references connect them; duplication is avoided.

Good file boundaries follow natural domain seams. On ComixDistro:

- `04-events-workflow.md` — event creation through completion
- `05-shipments.md` — shipment tracking tied to events
- `06-event-reports.md` — accountability reporting after events

Bad file boundaries split things that need to be understood together or group things that have nothing in common. If two sections constantly cross-reference each other, they probably belong in one file. If a file covers three unrelated features, it should be split.

### Phase ordering by dependency

Phases build on each other. Infrastructure comes first, then core models, then workflows, then UI polish. The principle: each phase should produce a working system, not a half-built feature. A user should be able to use the system (even if limited) after each phase.

Typical phase progression:

1. **Foundation** — project scaffolding, CI, linting, deployment pipeline
2. **Authentication and authorization** — who can access the system
3. **Core data models** — the entities that everything else references
4. **Primary workflows** — the main thing users do with the system
5. **Secondary workflows** — supporting features, admin tools, reporting
6. **Polish** — notifications, search, dashboard, UI refinements

Don't plan more than 3-4 phases in detail. Later phases are sketched — they'll be refined based on what you learn building the earlier ones.

### The ROADMAP translation

Each PRD section translates to ROADMAP checkboxes. The sizing principle: **one checkbox = one PR = one reviewable unit of work**. If a checkbox feels like it needs multiple PRs, split it before starting. If several checkboxes are trivially small and tightly coupled, consider combining them.

→ See `spec-driven-development.md` §1 "ROADMAP discipline" for the operational rules.

### MVP boundaries

RFC keywords define the cut line:

- **MUST** — the system doesn't make sense without this. Non-negotiable for the first usable version.
- **SHOULD** — expected and important, but the system functions without it. Build it unless technically prevented.
- **MAY** — nice to have. Build if it's straightforward and doesn't delay higher-priority work.

Be ruthless about MUST. The most common PRD failure mode is labeling everything as MUST because it all feels important. If everything is MUST, nothing is — you've just described an undifferentiated backlog.

A useful filter: **"If this feature didn't exist on launch day, would users notice?"** If no, it's SHOULD at best.

### Cross-references

Link between PRD files using the established format: `→ See 07-feature.md §3 "Section Heading"`. Always include the filename and quoted heading so the link is navigable even if section numbers shift.

Keep the cross-reference graph shallow. If file A references file B which references file C which references file A, you have a tangle. Prefer hub-and-spoke: the README is the hub, individual files reference each other only when directly related.

---

## 5 Handling Unknowns

Every PRD has unknowns. The question is not "can we eliminate all unknowns before building?" — it's "which unknowns must we resolve now, and which can wait?"

### Resolve now

Decisions that block implementation or constrain other decisions must be resolved before coding starts:

- **Data model shape** — you can't build features on a model you haven't designed. Adding columns later is easy; changing relationships is hard.
- **Authentication and authorization model** — this affects every feature. Decide the approach upfront.
- **Core lifecycle** — the primary entity's status lifecycle is the skeleton of the application. Everything hangs off it.
- **Integration contracts** — if external systems are involved, nail down the interface shape. Building against a vague API contract leads to rework.

If you can't resolve one of these during brainstorming, that's a signal you need more information — user research, technical spikes, or stakeholder input. Don't paper over it with a TBD.

### Defer with context

Decisions that can wait if you capture enough information for future resolution:

- **Specific UI flows** — the exact sequence of screens for a multi-step process can be deferred if the data model and lifecycle are clear. You know *what* the user needs to accomplish; the *how* can be designed closer to implementation.
- **Notification copy** — the triggers are specified tightly (§3), but the exact email subject lines and body text can wait.
- **Third-party integration details** — if you know you'll integrate with a service but don't yet have API credentials or documentation, capture the integration requirements and defer the implementation details.
- **Admin UI specifics** — admin interfaces are internal tools. Specify what admins need to *do*, defer how the interface is organized.

### The TBD format

A well-written TBD is not just a question mark — it's a decision brief for your future self. Include:

- **The question** — what needs to be decided?
- **The options considered** — what approaches were discussed?
- **The constraints** — what factors should influence the decision?
- **Resolution guidance** — what would need to be true for each option to win?

Bad TBD:

> TBD: How to handle notifications.

Good TBD:

> **TBD: Notification channel for shipment updates**
>
> *Question:* Should shipment status updates notify the distributor via email, in-app notification, or both?
>
> *Options:* (a) Email only — simple, works for users who don't check the app daily. (b) In-app only — reduces email volume, requires users to check the app. (c) Both — comprehensive but risks notification fatigue.
>
> *Constraints:* Distributors are not daily app users. Email delivery is already set up via Postmark. In-app notification infrastructure does not exist yet.
>
> *Guidance:* Start with email only (option a). Add in-app notifications as a future enhancement if user feedback indicates demand. The email templates should be designed so they can coexist with in-app notifications later.

### Open Items sections

TBDs live in Open Items sections within each PRD file, not scattered inline. This makes them findable and reviewable. During implementation, Open Items are a checklist: resolve each one before building the feature that depends on it, or explicitly decide to defer it to a later phase.

→ See `spec-driven-development.md` §1 "Conventions within PRD files" for where Open Items fit in the PRD structure.

---

## 6 Maintaining PRD Usefulness

A PRD that's too detailed becomes a burden no one updates. A PRD that's too vague doesn't prevent the rework it's supposed to prevent. The goal is the minimum spec that makes implementation decisions clear.

### The maintainability test

Before writing a spec detail, ask: **"Would I update this if the implementation changed?"**

If the answer is "probably not" — don't write it. That detail will become stale and misleading.

If the answer is "yes, because it affects other parts of the system" — write it and keep it current.

This test naturally calibrates detail level: data models pass (you'd update the spec if a column changed), CSS choices fail (you'd never update the spec because a button color changed).

### Spec detail and project maturity

The right amount of detail changes over a project's life:

- **Early phases** benefit from more detail. The team (you + AI collaborator) is establishing patterns, building shared understanding, and making foundational decisions. Explicit specification prevents misalignment.
- **Later phases** can be lighter. Patterns are established. The data model is built. The AI collaborator has seen the codebase. You can specify "add event reporting, following the same pattern as event creation" instead of spelling out every field and validation.

This isn't laziness — it's efficiency. Detailed specs for Phase 5 written during Phase 0 planning are usually wrong by the time you get there. Sketch later phases; detail them when you're ready to build.

### When the PRD becomes a living doc

→ See `spec-driven-development.md` §5 "Document Lifecycle" for the full framework on planning docs vs. living docs and when to reclassify.

The key signal: if you're updating a PRD file because the system has changed (not because you're building the feature), it has transitioned from a planning document to a living document. Recognize the transition and relocate it.

### The through-line

The PRD is a communication tool between planning-you and building-you. Optimize for that reader. Planning-you is thinking about the system holistically, considering trade-offs, and making decisions. Building-you is focused on the current PR, deep in implementation details, and needs clear answers to specific questions.

Write for building-you: clear decisions, explicit constraints, concrete data model specs, and honest TBDs. Skip the prose that planning-you enjoyed writing but building-you will skip reading.

---

## 7 Brainstorming Prompt Library

Concrete prompts organized by the discovery arc from §2. Copy-paste these into a Claude conversation when starting a new project or feature area. Adapt the bracketed sections to your domain.

### Project kickoff / vision

```text
I'm planning a new project: [project name]. Here's the context:

- Problem: [what problem does this solve?]
- Users: [who will use it?]
- Current process: [how is this handled today?]
- Constraints: [tech stack, timeline, budget, deployment environment]
- Non-goals: [what this project is explicitly NOT trying to do]

Help me develop a clear project vision. I need:
1. A one-paragraph vision statement
2. A list of design principles (3-5) that should guide decisions
3. A clear MVP scope boundary — what's in, what's out

Let's start with the vision statement and refine from there.
```

### Persona discovery

```text
Let's define the user personas for [project name].

Here's what I know about the users:
- [User type 1]: [what you know about them — role, tech comfort, frequency of use]
- [User type 2]: [same]

For each persona, I need:
1. A name and one-sentence description
2. Their primary tasks (what they need to accomplish)
3. Their constraints (technical skill, device, connectivity, language)
4. What success looks like from their perspective

Push back if you think I'm missing a persona, or if two personas should be merged.
```

### Feature area mapping

```text
Based on the vision and personas we've defined, let's map out the feature areas for [project name].

For each feature area, I need:
1. A descriptive name (this will become a PRD file name)
2. A one-sentence summary of what it covers
3. Which persona(s) it serves
4. Whether it's MVP (MUST), important (SHOULD), or nice-to-have (MAY)

Group related functionality together. I'd rather have 6-8 well-scoped feature areas than 15 narrow ones. Flag any features that seem to span multiple areas — those are candidates for their own file.
```

### Data model design

```text
Let's design the data model for [project name / feature area].

Here's what we know from the feature areas:
- [Entity 1]: [what it represents, key attributes you've identified]
- [Entity 2]: [same]

For each entity, I need:
1. Name and purpose
2. Key attributes with types (not every column — the important ones)
3. Relationships to other entities (belongs_to, has_many, etc.)
4. Required fields vs. optional
5. Any uniqueness or validation constraints

I care especially about:
- Relationships between entities — get these right first
- Fields that affect authorization or lifecycle logic
- Anything that constrains future flexibility

Don't worry about: timestamps, IDs, or standard Rails conventions — we'll inherit those.
```

### Status lifecycles and workflows

```text
Let's map out the lifecycle for [entity name].

This entity needs to move through states as part of [describe the workflow].

For the lifecycle, I need:
1. All possible statuses
2. The transitions: from → to, and who/what triggers each transition
3. What happens at each transition (side effects: notifications, related record creation, etc.)
4. Terminal states — which statuses are "done"?
5. Can a record move backward? Under what circumstances?

Also consider:
- What's the initial status when a record is created?
- Are there any transitions that only admins can trigger?
- What happens if something goes wrong mid-lifecycle?
```

### Edge cases and error scenarios

```text
Let's stress-test the design for [feature area / entity].

Walk me through these scenarios:
1. What happens when [common error case]?
2. What if a user tries to [action they shouldn't be able to do]?
3. What if [external dependency] is unavailable?
4. What happens to [related records] when [parent record] is [deleted/cancelled/archived]?
5. Are there race conditions? (e.g., two users acting on the same record simultaneously)

For each scenario, I need:
- What should the system do?
- What should the user see?
- Is this an MVP concern or can we defer it?

Be aggressive about finding cases I haven't considered.
```

### Phase planning and MVP scoping

```text
Let's organize [project name] into implementation phases.

Here are the feature areas we've defined:
- [List feature areas with MUST/SHOULD/MAY tags]

I need:
1. A phase ordering that respects dependencies (can't build workflows before the data model)
2. Each phase should produce a working, deployable system — no half-built features
3. Phase 0 is always foundation (scaffolding, CI, auth)
4. For each phase: which feature areas are included and roughly how many PRs of work

Constraints:
- Keep phases to 5-15 PRs of work each
- The system should be usable (even if limited) after Phase 1
- Don't detail phases beyond Phase 2-3 — we'll refine later phases after building the early ones

Challenge my MVP boundary if you think I'm including too much or too little.
```

### Refining a specific feature area

```text
Let's go deeper on [feature area]. Here's what we have so far:
[paste the current feature area summary]

I want to develop this into a full PRD section. Walk me through:
1. The complete user flow — step by step, what does the user do?
2. What data is captured at each step?
3. Validation rules — what makes a submission valid?
4. Authorization — who can see/do what?
5. What are the open questions we should mark as TBDs?

Keep the MVP filter active — tag anything that's not strictly necessary for launch as SHOULD or MAY.
```

### Wrapping up a brainstorming session

```text
Let's review what we've covered and identify gaps.

Summarize:
1. What decisions we've made (organized by feature area)
2. What TBDs remain — with enough context that we can resolve them later
3. What parked items we haven't returned to
4. What's ready to write up as a PRD section vs. what needs another round of discussion

Is there anything about the data model or core lifecycle that still feels unresolved? Those are the blockers — everything else can be refined during implementation.
```

---

## Appendix: From Brainstorming to PRD Files

The brainstorming output is raw material. Translating it into PRD files is a separate step.

1. **Run `/bootstrap-prd`** to scaffold the directory structure from templates.
2. **Start with `01-overview.md`** — vision, personas, design principles, tech stack. This is mostly consolidating brainstorming output.
3. **Write the data model file** — this is the hardest one and the most important to get right. All other files reference it.
4. **Write feature area files** in dependency order. Each file should be understandable on its own with cross-references to the data model and related features.
5. **Build the ROADMAP** — translate feature areas into phases, phases into checkboxes.
6. **Populate the README** — file index with "consult when..." guidance.

Don't try to produce perfect PRD files in one pass. Write a first draft, read it as if you're the developer who will implement it, and revise for clarity. The maintainability test from §6 applies: if a detail wouldn't survive its first contact with implementation, leave it out.

→ See `~/.claude/templates/prd/` for the structural templates that this process produces.
