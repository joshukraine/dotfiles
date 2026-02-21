# Bootstrap PRD Command

Scaffold PRD-driven development infrastructure into a new project using the shared templates. This command creates files and directories but writes no application code.

## Your task

Work through the steps below in order. Each step has a hard stop — do not proceed past a CHECKPOINT without explicit user approval.

---

### Step 1: Gather project information

Ask the user for the following. Skip anything already provided in the conversation context.

- **Project name** (e.g., "Acme Dashboard")
- **One-paragraph description** of what the project does and who it serves
- **Tech stack** — framework, database, frontend approach, linter, test framework
- **Key personas** — 1-3 user types with a sentence each
- **Quick-start commands** — how to start the app, run tests, run the linter

If the user provides a framework name, pre-fill quick-start commands from this lookup table (the user can override):

| Framework | Start | Test | Lint |
| --- | --- | --- | --- |
| Rails | `bin/dev` | `bin/rails test` | `bin/standardrb --fix` |
| Next.js | `npm run dev` | `npm test` | `npm run lint` |
| Hugo | `hugo server -D` | *(none)* | *(none)* |
| Generic | `<!-- TODO: start command -->` | `<!-- TODO: test command -->` | `<!-- TODO: lint command -->` |

### Step 2: Read templates

Read all 5 template files that will be copied into the project:

- `~/.claude/templates/CLAUDE.md`
- `~/.claude/templates/prd/README.md`
- `~/.claude/templates/prd/ROADMAP.md`
- `~/.claude/templates/prd/CHANGELOG.md`
- `~/.claude/templates/prd/01-overview.md`

### Step 3: Check for existing files

Check whether any of the following already exist in the project:

- `CLAUDE.md` (repo root)
- `docs/prd/` directory (any files inside it)

Note any conflicts — these will be presented to the user in the checkpoint.

### Step 4: Present the plan

**CHECKPOINT 1**: Present a summary and wait for explicit approval before writing any files.

The summary should include:

- **Project**: Name and one-line description
- **Files to create** (full paths):
  - `CLAUDE.md`
  - `docs/prd/README.md`
  - `docs/prd/ROADMAP.md`
  - `docs/prd/CHANGELOG.md`
  - `docs/prd/01-overview.md`
- **What gets customized**: Project name, description, tech stack table, personas, quick-start commands
- **What stays as TODO**: Guardrails, terminology, linter/test details — marked with `<!-- TODO: ... -->` comments
- **Conflicts**: Any existing files detected in Step 3 (ask whether to overwrite or skip each one)

Do not create any files until the user approves.

---

### Step 5: Create files

After approval, create each file by copying the template and applying substitutions:

1. **Replace `[Project Name]`** with the actual project name in all files
2. **Fill in gathered details**: description paragraph, tech stack table rows, persona sections, quick-start commands
3. **Leave unfillable placeholders** as `<!-- TODO: ... -->` comments so the user can find and complete them later
4. **Create `docs/prd/` directory** as needed
5. **Skip any files** the user chose not to overwrite in the checkpoint

### Step 6: Report

**CHECKPOINT 2**: Present a summary of what was created and what remains.

- **Files created**: List each file with its path
- **Remaining TODOs**: List the `<!-- TODO: ... -->` placeholders left in each file so the user knows what to fill in
- **Suggested next steps**:
  1. Fill in architectural guardrails in `CLAUDE.md`
  2. Add project-specific phases to `docs/prd/ROADMAP.md`
  3. Set up GitHub labels (see `~/.claude/docs/label-taxonomy.md`)
  4. Commit the scaffolded files via `/commit`

---

## Important

- **This command creates project files only.** It does not write application code, create GitHub issues, or call any external APIs.
- **Both checkpoints are hard stops.** Do not proceed without explicit approval.
- **Shared docs are NOT copied.** `~/.claude/docs/label-taxonomy.md` remains a global reference — it should not be duplicated into individual projects.
- **If a context window clear is needed**, it is safe to do so after Step 6 — the files exist on disk and will survive the clear.
