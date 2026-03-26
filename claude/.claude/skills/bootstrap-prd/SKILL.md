---
name: bootstrap-prd
description: Set up PRD-driven development infrastructure for a new project, including directory structure, templates, and roadmap.
disable-model-invocation: true
---

# Bootstrap PRD Command

Set up PRD-driven development infrastructure for a new project. This command handles two workflows: **PRD-first** (PRD files already exist, scaffold the project around them) and **scaffold-first** (no PRD yet, create template files to be filled in). The command detects which situation applies and adapts.

## Your task

Work through the steps below in order. Each step has a hard stop — do not proceed past a CHECKPOINT without explicit user approval.

---

### Step 1: Detect existing PRD files

Check whether `docs/prd/` exists and contains any `.md` files.

**If PRD files exist** → enter **PRD-first** mode:

- Read all `.md` files in `docs/prd/` to understand the project
- Extract: project name, description, tech stack, personas, and any quick-start commands mentioned
- Skip to Step 3 (no need to gather information the PRD already contains)

**If no PRD files exist** → enter **scaffold-first** mode:

- Proceed to Step 2 to gather project information

---

### Step 2: Gather project information (scaffold-first mode only)

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
| Static (no build) | Open `index.html` or use a local server | *(none)* | *(none)* |
| Generic | `<!-- TODO: start command -->` | `<!-- TODO: test command -->` | `<!-- TODO: lint command -->` |

---

### Step 3: Read templates

Read the template files that may be needed:

- `~/.claude/docs/prd-workflow/templates/CLAUDE.md`
- `~/.claude/docs/prd-workflow/templates/prd/README.md`
- `~/.claude/docs/prd-workflow/templates/prd/ROADMAP.md`
- `~/.claude/docs/prd-workflow/templates/prd/CHANGELOG.md`
- `~/.claude/docs/prd-workflow/templates/prd/01-overview.md`

In PRD-first mode, only `CLAUDE.md` is typically needed — the PRD files already exist.

---

### Step 4: Check for existing files and determine what needs to be created

Check which of the following already exist in the project:

- `CLAUDE.md` (repo root)
- `docs/prd/README.md`
- `docs/prd/ROADMAP.md`
- `docs/prd/CHANGELOG.md`
- `docs/prd/01-overview.md`
- `.git/` directory (is this already a git repo?)

Build a list of files to create (those that don't already exist) and files to skip (those that do).

---

### Step 5: Present the plan

**CHECKPOINT 1**: Present a summary and wait for explicit approval before writing any files.

**In PRD-first mode**, the summary should include:

- **Mode**: PRD-first (existing PRD files detected)
- **Project**: Name and one-line description (extracted from the PRD)
- **PRD files found**: List the existing files in `docs/prd/`
- **Files to create**: Typically just `CLAUDE.md` — list with full paths
- **What gets customized in CLAUDE.md**: Project name, description, tech stack, quick-start commands (all extracted from the PRD)
- **What stays as TODO**: Any CLAUDE.md sections that can't be inferred from the PRD (guardrails, linter specifics, etc.)
- **Git setup**: Whether `git init` is needed, whether to create a GitHub repo
- **Conflicts**: Any files that already exist where creation was expected

**In scaffold-first mode**, the summary should include:

- **Mode**: Scaffold-first (creating template PRD files)
- **Project**: Name and one-line description
- **Files to create** (full paths):
  - `CLAUDE.md`
  - `docs/prd/README.md`
  - `docs/prd/ROADMAP.md`
  - `docs/prd/CHANGELOG.md`
  - `docs/prd/01-overview.md`
- **What gets customized**: Project name, description, tech stack table, personas, quick-start commands
- **What stays as TODO**: Guardrails, terminology, linter/test details — marked with `<!-- TODO: ... -->` comments
- **Conflicts**: Any existing files detected

Do not create any files until the user approves.

---

### Step 6: Create files

After approval, create each file:

**In PRD-first mode:**

1. **Create `CLAUDE.md`** from the template, populated with information extracted from the existing PRD files (project name, description, tech stack, quick-start commands, key file references)
2. **Initialize git** if `.git/` doesn't exist: `git init`
3. **Create GitHub repo** if the user approved it in the checkpoint: `gh repo create <repo-name> --public --source=. --push` (or `--private` based on user preference)
4. **Skip PRD files** — they already exist

**In scaffold-first mode:**

1. **Create all PRD template files** by copying templates and applying substitutions:
   - Replace `[Project Name]` with the actual project name in all files
   - Fill in gathered details: description paragraph, tech stack table rows, persona sections, quick-start commands
   - Leave unfillable placeholders as `<!-- TODO: ... -->` comments
2. **Create `docs/prd/` directory** as needed
3. **Create `CLAUDE.md`** from template with gathered details
4. **Initialize git** if `.git/` doesn't exist: `git init`
5. **Skip any files** the user chose not to overwrite in the checkpoint

---

### Step 7: Report

**CHECKPOINT 2**: Present a summary of what was created and what remains.

**In PRD-first mode:**

- **Files created**: List each file with its path
- **Remaining TODOs**: List the `<!-- TODO: ... -->` placeholders left in `CLAUDE.md`
- **Suggested next steps**:
  1. Review and fill in architectural guardrails in `CLAUDE.md`
  2. If GitHub repo was created: verify it's accessible and Pages is configured (if applicable)
  3. Set up GitHub labels if using the issue tracker (see `~/.claude/docs/label-taxonomy.md`)
  4. Begin Phase 0 of the ROADMAP

**In scaffold-first mode:**

- **Files created**: List each file with its path
- **Remaining TODOs**: List the `<!-- TODO: ... -->` placeholders left in each file
- **Suggested next steps**:
  1. Fill in architectural guardrails in `CLAUDE.md`
  2. Add project-specific phases to `docs/prd/ROADMAP.md`
  3. Set up GitHub labels (see `~/.claude/docs/label-taxonomy.md`)
  4. Commit the scaffolded files via `/commit`

---

## Important

- **This command creates project files only.** It does not write application code or call any external APIs beyond `git` and `gh`.
- **Both checkpoints are hard stops.** Do not proceed without explicit approval.
- **Shared docs are NOT copied.** `~/.claude/docs/label-taxonomy.md` remains a global reference — it should not be duplicated into individual projects.
- **If a context window clear is needed**, it is safe to do so after Step 7 — the files exist on disk and will survive the clear.
