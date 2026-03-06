# README Refresh Command

Audit and update the project README, or bootstrap one if it doesn't exist. The README is a living document — it evolves with the code and should always reflect the current state of the project.

## Command Options

- `--bootstrap`: Force bootstrap mode even if a README exists (useful to start fresh)

## Your task

### Step 0: Detect mode

- If `README.md` exists at the project root **and `--bootstrap` was not passed**: enter **Refresh mode** (Step 1).
- If `README.md` does not exist **or `--bootstrap` was passed**: enter **Bootstrap mode** (Step 5).

---

## Refresh Mode

### Step 1: Scan the project

Gather facts from the codebase. Do not rely on the README's current claims — verify independently.

**Tech stack and versions:**

- Ruby version: `.ruby-version`, `Gemfile.lock` (`RUBY VERSION` section), `.tool-versions`
- Rails version: `Gemfile.lock` (search for `rails (`)
- Node version: `.node-version`, `.nvmrc`, `.tool-versions`, `package.json` (`engines`)
- Database: `config/database.yml`, `Gemfile.lock` (pg, mysql2, sqlite3)
- Key framework gems/packages: Devise, Turbo, Stimulus, Tailwind, Solid Queue, etc. — scan `Gemfile` or `package.json` for notable dependencies

**Services and infrastructure:**

- Hosting: `fly.toml` (Fly.io), `netlify.toml`, `Procfile`, `render.yaml`, `app.json` (Heroku), `Dockerfile`, `docker-compose.yml`
- Storage: look for Active Storage config, S3/Tigris credentials in `config/storage.yml`
- Email: `config/environments/production.rb` (SMTP settings, `action_mailer` config), initializers for Postmark/SendGrid/etc.
- Background jobs: `config/application.rb` or initializers (Solid Queue, Sidekiq, etc.)
- Search: Elasticsearch, Meilisearch, etc.

**Available commands:**

- `bin/` directory: list executable scripts (`bin/rails`, `bin/dev`, `bin/ci`, `bin/setup`, etc.)
- `Procfile.dev` or `Procfile`: processes defined for local development
- `Makefile` or `Taskfile`: custom task definitions
- `package.json` scripts section

**Configuration requirements:**

- `.env.example` or `.env.template`: expected environment variables
- `config/credentials.yml.enc` or `config/master.key`: credentials setup
- `config/database.yml`: database setup requirements

**CI/CD:**

- `.github/workflows/`: GitHub Actions workflows
- `.circleci/`, `.travis.yml`, `Jenkinsfile`: other CI configs

### Step 2: Compare against the README

Read the current `README.md` and compare each claim against the facts gathered in Step 1. Build a findings report with three categories:

1. **Outdated** — the README states something that is no longer accurate (e.g., "Rails 7.1" when `Gemfile.lock` shows Rails 8.0, or mentions a service that has been removed).
2. **Missing** — something exists in the project that the README doesn't mention and reasonably should (e.g., a `bin/dev` script for local development, a background job processor, a CI workflow).
3. **Stale references** — commands, URLs, or setup steps that no longer work or point to things that don't exist.

Do **not** flag:

- Prose descriptions of what the app does (subjective — leave to the human).
- Stylistic preferences (heading structure, badge choices, etc.).
- Items that are genuinely optional to document.

### Step 3: Present findings

**CHECKPOINT**: Present the findings report to the user. Format:

```text
README Refresh — Findings
==========================

Outdated (N items):
  ✗ Ruby version: README says 3.3.0, project uses 4.0.1
  ✗ Rails version: README says 7.1, Gemfile.lock shows 8.0.1
  ✗ References Redis for caching, but project uses Solid Cache

Missing (N items):
  + bin/dev script not documented (starts Procfile.dev with foreman)
  + Postmark configured for transactional email — not mentioned
  + GitHub Actions CI workflow exists — not documented

Stale references (N items):
  ⚠ Setup step 3 references `rake db:seed` — project uses `bin/rails db:seed`
  ⚠ Link to API docs points to a 404

No issues found: (list any sections that are current and accurate)
```

Ask: **"Want me to apply the mechanical fixes? I'll update versions, add missing sections, and remove stale references. I won't rewrite prose descriptions."**

### Step 4: Apply fixes

For each confirmed finding:

- **Outdated versions/facts**: Update to the verified value from Step 1.
- **Missing sections**: Add a concise section with the verified information. Match the existing README's style and heading level conventions.
- **Stale references**: Fix or remove. If a command changed, update it. If a link is dead and no replacement is obvious, comment it out with a note.

After applying changes:

- Show a diff summary of what was changed.
- Do **not** commit automatically — let the user review and commit when ready (or suggest using `/commit`).

---

## Bootstrap Mode

### Step 5: Scan the project

Run the same scan as Step 1 to gather project facts.

### Step 6: Detect project type and generate README

Based on the scan results, generate a README with these sections (omit any that don't apply):

1. **Project name and description** — use the repo name as a heading. Add a one-line placeholder: `<!-- TODO: Add project description -->`. Do not invent a description.
2. **Tech stack** — list detected language, framework, database, and key dependencies with verified versions.
3. **Prerequisites** — what needs to be installed before setup (Ruby, Node, PostgreSQL, etc.) with version requirements.
4. **Setup** — step-by-step local development setup based on what exists: `bin/setup`, `bundle install`, `bin/rails db:prepare`, `.env` configuration, etc. Only include steps that the project actually needs.
5. **Development** — how to run the app locally (`bin/dev`, `bin/rails server`, etc.), how to run tests, how to run the linter.
6. **Deployment** — if hosting config is detected (fly.toml, netlify.toml, etc.), document the deployment target and any relevant commands.
7. **Services** — external services the app depends on (email provider, object storage, background jobs, etc.).
8. **Documentation** — if a `docs/` directory exists, mention it and list key documents (PRD, domain model, etc.).

### Step 7: Present and write

**CHECKPOINT**: Present the generated README to the user for review.

Write the file to `README.md` at the project root. Do **not** commit — let the user review and commit when ready.

---

## Important

- This command inspects and reports. It does not refactor code, change configuration, or install dependencies.
- Prose and subjective descriptions are the human's domain. The command handles mechanical, verifiable facts.
- The command is framework-aware but not framework-specific. The scan in Step 1 covers Rails, Node, Python, Go, Rust, and Hugo projects. For unrecognized stacks, fall back to checking common files (`Makefile`, `Dockerfile`, `docker-compose.yml`, `README.md`).
- When in doubt about whether something belongs in the README, include it in the findings report and let the user decide.
- If the project has a `CLAUDE.md`, read it for additional context about conventions, but do not document `CLAUDE.md` itself in the README (it is tooling-specific, not project documentation).

## Lifecycle Context

This is a **living-document maintenance** command (→ See `spec-driven-development.md` §5 "Document Lifecycle"). The README is never frozen — it evolves with the code.

| Project Stage | README Refresh Focus                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| Greenfield    | Bootstrap mode. Generate initial README as setup docs solidify.               |
| MVP complete  | Full refresh. The README likely drifted during rapid development.             |
| Mature        | Light periodic refresh. Versions and dependencies are the main drift vectors. |

**Suggested cadence:** Run after phase boundaries, after `/update-deps`, or whenever the project feels like it has accumulated untracked changes. A good rule of thumb: if you'd be embarrassed for a new contributor to read the README, it's time.
