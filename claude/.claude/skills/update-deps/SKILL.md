---
name: update-deps
description: Dependabot-aware dependency updates with security audit, real-CI validation, and a unified PR. Framework-agnostic.
disable-model-invocation: true
---

# Update Dependencies

Update project dependencies safely: reconcile open Dependabot PRs into one unified change, run the project's security audit, validate boot-affecting changes against the real CI environment, and open a single PR — instead of stopping at local commits.

This skill is framework-agnostic. It **detects** the project's package manager, test/lint commands, audit suite, and CI workflow rather than assuming a stack.

## Command Options

- `--dry-run`: Show what would be updated without making changes
- `--major`: Include major version updates (default: minor/patch only)
- `--package <name>`: Update specific package only
- `--skip-tests`: Skip running tests between updates

## Workflow at a glance

```text
Detect → Reconcile Dependabot → Update → Audit → Validate on real CI → Open PR → Verify auto-close
```

Each stage feeds the next. Don't skip the audit or the real-CI validation for boot-affecting changes — those are the two stages that catch what local tests can't.

## Your task

### 1. Detect the environment (do not hardcode)

Detect both the package manager **and** the project's real entry points. The runners below are common defaults, not assumptions — always confirm against what the repo actually uses.

- **Package manager**:
  - `package.json` (npm/yarn/pnpm) — check the lockfile to disambiguate
  - `Gemfile` (bundler)
  - `requirements.txt` / `pyproject.toml` (pip/poetry/uv)
  - `Cargo.toml` (cargo)
  - `go.mod` (go modules)
- **Test/lint/CI entry points** — prefer a single project gate over assumed runners:
  - A wrapper script like `bin/ci`, `bin/test`, `script/test`, or a `Makefile`/`Justfile` target is the **canonical gate** — use it if present.
  - Otherwise detect the real tools: Minitest vs RSpec, StandardRB vs RuboCop, Herb, Biome vs ESLint, Prettier, `tsc`, `mypy`, etc.
  - Detect the **CI workflow** itself: list `.github/workflows/*.yml` and identify the workflow that runs on the default branch and the jobs it contains.
- **Audit suite** (see step 4) — detect, don't assume.

### 2. Reconcile open Dependabot PRs

Before making any changes, find out what Dependabot already has in flight:

```bash
gh pr list --app dependabot --state open --json number,title,headRefName,body
```

- If open Dependabot PRs exist, **fold their bumps into one unified branch** rather than running in parallel and leaving stale PRs behind.
- Land **the exact target versions or newer** for every bump a Dependabot PR covers. Dependabot **auto-closes** a PR once its target versions (or higher) land on the base branch — landing a lower version defeats that and leaves the PR open.
- Note which PRs you expect to be superseded; you'll verify their auto-close in step 7.

### 3. Update incrementally

Keep the safe, category-by-category loop:

- **Security updates first** (always include), then **patch**, then **minor**.
- **Major updates** only with `--major`. Isolate a risky major into **its own commit — or its own PR** — so it can be rolled back cleanly without reverting the safe bumps.
- Run the detected test gate after each category. **If `--skip-tests`**: skip test execution.
- For major bumps, flag **soft-dependency and default-behavior changes** explicitly — a newly pulled-in transitive dependency, a changed default load/eager-load behavior (e.g. Bundler's `require:`), a renamed config key. These are where "the tests pass but boot breaks" lives.
- Stop and report if the gate fails; offer to revert the specific update that caused it.

### 4. Run the security audit

This is the highest-value stage on a dependency PR — not an afterthought. After updates, run the project's detected audit suite and **fold any newly surfaced fix into this PR** (a fresh advisory is in-scope, not a separate task):

| Ecosystem | Audit tools (detect what's present) |
| --------- | ----------------------------------- |
| Ruby | `bundler-audit`; plus `brakeman` and `importmap audit` on Rails |
| Node | `npm audit`, `yarn npm audit`, `pnpm audit` |
| Python | `pip-audit`, `safety` |
| Rust | `cargo audit` |
| Go | `govulncheck` |

If the project's CI gate (e.g. `bin/ci`) already runs these, run that gate rather than invoking each tool separately.

### 5. Validate boot-affecting changes on the real CI

A change that touches the **manifest** (the `Gemfile`, `package.json`, `pyproject.toml` — not just the lockfile) can alter what loads at boot. Local gates **cannot** catch a failure caused by a system library that happens to be installed on the dev machine but missing on one CI job. Validate those changes on the actual CI environment before recommending merge:

```bash
gh workflow run <ci-workflow> --ref <branch>
gh run watch   # or: gh run list --branch <branch>
```

Do this when:

- The manifest changed (new dependency, changed `require:`/load behavior, version constraint change), **and/or**
- A bump pulls in a native/system-backed library (image processing, crypto, database drivers).

Lockfile-only patch bumps with a green local gate generally don't need a dedicated CI run.

### 6. Open a unified PR

Stop-at-commits is not the finish line. Open **one** PR for the reconciled set, following the project's PR conventions — hand off to the `/create-pr` skill (it generates the description, links issues, and updates the ROADMAP). Summarize in the PR body: the bumps grouped by category, the Dependabot PRs this supersedes, any CVE fixed, and the result of the real-CI run.

### 7. Verify Dependabot auto-close (don't race it)

After the PR merges, **expect** Dependabot to auto-close the superseded PRs on its own — verify it did rather than pre-emptively closing them:

```bash
gh pr list --app dependabot --state open
```

- If a superseded PR closed automatically: done.
- **Fallback only:** if a PR is still open after Dependabot's next rebase cycle — the edge where a lower/different version landed and Dependabot just rebases instead of closing (see `dependabot/dependabot-core#13606`) — close it manually with a note. Don't duplicate Dependabot's behavior or race its rebase.

## Design principles

The lessons this workflow encodes, worth keeping in mind when a situation doesn't fit the steps above:

- **"Passes locally, fails on one CI job" is a real failure class.** A local gate can't see a system library that's present on your machine but absent on a specific CI job. Boot-affecting dependency changes need real-CI validation, not just local tests.
- **Don't fight Dependabot.** It already reconciles bumps and auto-closes superseded PRs. The skill's job is to *expect and verify* that behavior, not re-implement it.
- **Security audits are the highest-value step**, not an afterthought. A plain update can ship a live CVE that only the audit catches.

## Package manager commands

### npm/yarn/pnpm

```bash
npm outdated        # check
npm update <pkg>    # update
```

### Ruby (Bundler)

```bash
bundle outdated
bundle update <gem>
```

### Python (pip/poetry)

```bash
pip list --outdated
poetry show --outdated && poetry update <pkg>
```

### Rust (Cargo)

```bash
cargo outdated
cargo update <pkg>
```

### Go

```bash
go list -u -m all
go get -u <pkg>
```

## Update categories

1. **Security updates** (always applied) — packages with known vulnerabilities.
2. **Patch updates** (default) — bug fixes, e.g. `1.2.3 → 1.2.4`.
3. **Minor updates** (default) — backwards-compatible features, e.g. `1.2.3 → 1.3.0`.
4. **Major updates** (only with `--major`) — breaking changes, e.g. `1.2.3 → 2.0.0`. Isolate for clean rollback.

## Commit message format

Use Conventional Commits format from global CLAUDE.md:

```text
chore(deps): update dependencies

Security updates:
- erb: 6.0.1 → 6.0.3 (CVE-2026-41316)

Patch updates:
- rails: 7.1.3 → 7.1.5

Minor updates:
- image_processing: 1.12 → 2.0

Breaking changes:
- image_processing 2.0 requires ruby-vips; added with require: false
  so a missing libvips does not crash boot.
```

## Error handling

- **No package manager detected**: "No supported package manager found"
- **No outdated packages and no open Dependabot PRs**: "All dependencies are up to date"
- **Test or audit failure**: identify the culprit update, offer to revert it
- **Real-CI run fails**: report the failing job; do not recommend merge
- **Lock file conflicts**: guide through resolution

## Integration with global standards

Follow dependency best practices from global CLAUDE.md:

- Pin versions, use lock files for consistent environments
- Test breaking changes thoroughly; document system requirements
- Treat security advisories as in-scope for the dependency PR
