---
name: ruby-gc
description: Audit asdf-installed Ruby versions against project pins and remove unreferenced ones. Dry-run by default.
disable-model-invocation: true
argument-hint: "[--apply]"
---

# Ruby GC

Garbage-collect asdf-installed Ruby versions that nothing on the system references.

**Dry-run by default.** Without `--apply`, this is a read-only report and you must not uninstall anything.

## Arguments

- `$ARGUMENTS` — pass `--apply` to enable the uninstall step. Absent that flag, stop after the report.
- `--apply` enables deletion; it does **not** authorize it. You still show the full table and get an explicit yes first.

## Safety rules

These are non-negotiable. The cost of a wrong delete is a broken app plus a slow rebuild; the cost of a wrong keep is a few hundred MB.

1. **Never delete the global version** — the one in `~/.tool-versions`.
2. **Never delete a version that has any pin on disk**, wherever that pin lives.
3. **Never delete without showing the table and getting an explicit confirmation** in the same session.
4. **If the scan errors, or returns implausibly few pins, STOP and report.** A truncated scan is indistinguishable from "nothing uses this" — it produces a confident delete list that breaks real apps. This has happened; treat a thin result as a bug in the scan, not a licence to delete. "Implausibly few" is measured against the July 2026 baseline in "Calibration" below — check it every run, before classifying anything.
5. **Uninstall one version at a time**, reporting each result before the next.

## Your task

### 1. Inventory what's installed

```bash
asdf list ruby
du -sh ~/.asdf/installs/ruby/*
```

### 2. Read the global pin

```bash
cat ~/.tool-versions
```

This is a symlink into `~/dotfiles/asdf/.tool-versions` (the real dotfiles). Note that `~/code/my_repos/dotfiles/` and `~/dotfiles.bak/` are **stale clones** carrying outdated pins — ignore them as authorities on the global version, though their pins still count under rule 2 until the user cleans them up.

### 3. Scan for pins — FULL DEPTH

```bash
find ~ -type f \( -name .tool-versions -o -name .ruby-version \) \
  -not -path '*/node_modules/*' -not -path '*/.git/*' \
  -not -path '*/Library/*' -not -path '*/.Trash/*' \
  -not -path '*/vendor/*' -not -path '*/.asdf/*' \
  -not -path '*/.local/share/nvim/*' -not -path '*/.local/share/zap/*' \
  -not -path '*/.local/share/neobean/*' \
  -exec grep -H . {} + 2>/dev/null
```

**Do not add `-maxdepth`.** Projects nest deeper than seems reasonable — `code/active/eto/ComixDistroBase/comix_distro/` is five levels below `~/code`, and a `-maxdepth 4` scan silently misses it while still returning plenty of plausible-looking output.

**Scan all of `~`, not just `~/code`.** Real projects live in `~/Sites/` too — that's where the legacy ETO sites pinning Ruby 2.7.4 are.

The plugin-directory exclusions are deliberate: nvim and zsh plugins vendor their own `.tool-versions` (`bullets.vim` pins ruby 3.1.0, `neotest-rspec` pins 3.1.1, a zap plugin pins 2.5.3). Those are library artifacts, not projects, and shouldn't hold an install hostage.

### 3b. Scan Gemfiles too — they are live pins

`~/dotfiles/asdf/.asdfrc` sets `legacy_version_file = yes`, and asdf-ruby's `bin/list-legacy-filenames` echoes `.ruby-version Gemfile`. So a `Gemfile` **is** a version pin on this system, exactly like a `.ruby-version`. Verify both facts each run rather than trusting this note — if `legacy_version_file` is ever turned off, Gemfiles stop counting.

```bash
find ~ -type f -name Gemfile \
  -not -path '*/node_modules/*' -not -path '*/.git/*' \
  -not -path '*/Library/*' -not -path '*/.Trash/*' \
  -not -path '*/vendor/*' -not -path '*/.asdf/*' \
  -not -path '*/.local/share/*' \
  -exec grep -HE '^\s*ruby\s' {} + 2>/dev/null
```

### 3c. Calibration — is this scan plausible?

Rule 4 is only enforceable against a known-good baseline. Measured 2026-07-17, immediately after a cleanup run:

| Signal | Baseline | Treat as a broken scan if... |
|---|---|---|
| `.ruby-version` + `.tool-versions` files found | 58 | fewer than ~40 |
| `.tool-versions` carrying a ruby line | 21 | fewer than ~14 |
| Gemfiles with any `ruby` line | 113 | fewer than ~80 |
| Gemfiles with an **exact** ruby pin | 10 | zero |

Counts drift as projects come and go, so treat them as an order-of-magnitude check, not an assertion — a 20% wobble is normal, a 60% drop is a bug. The **landmark checks below are the real test**, because they fail loudly rather than plausibly:

- The scan MUST reach `~/Sites/` — 13 ruby pins live there, including the legacy ETO sites on 2.7.4. Zero hits under `~/Sites` means the scan never left `~/code`.
- The scan MUST reach `~/code/active/eto/ComixDistroBase/comix_distro/`. Missing it means a depth limit crept in.
- The deepest real pin sits **9 levels** below `~` (`~/code/active/eto/ETOWebReboot/legacy/*/.tool-versions`). Any `-maxdepth` silently truncates this.

Note the Gemfile ratio: **113 files carry a `ruby` line but only 10 are real pins.** That gap is the ~100 prag-studio Gemfiles pinning `ruby '>= 3.0.0'`. If exact pins ever approach the total, the parse is wrongly counting range specifiers — that inflates the keep list and makes the skill useless rather than dangerous. Both failure directions are worth catching.

### 4. Parse the pins carefully

Five formats, all present on this system:

| File | Example contents | Extract |
|---|---|---|
| `.ruby-version` | `ruby-4.0.6` | strip the `ruby-` prefix → `4.0.6` |
| `.ruby-version` | `3.1.2` | use as-is |
| `.tool-versions` | `ruby 3.1.2` | the ruby line only — the file also carries nodejs, python, lua, neovim |
| `Gemfile` | `ruby "3.1.2"` | → `3.1.2` — a real pin |
| `Gemfile` | `ruby '>= 3.0.0'` or `ruby file: ".ruby-version"` | **not a pin** — ignore |

A `.tool-versions` line may list multiple fallback versions (`python 3.12.4 2.7.18`); if a ruby line ever does, every version listed counts as pinned.

Only an **exact** Gemfile version pins anything. `parse-legacy-file`'s sed pipeline ends with `/^[^0-9]/d`, which drops any result not starting with a digit — so `>= 3.0.0` yields nothing, and `file: ".ruby-version"` defers to the `.ruby-version` already scanned in step 3. This matters: ~100 prag-studio Gemfiles say `ruby '>= 3.0.0'`, and counting them would wrongly pin versions nothing uses. Mirror the plugin's real behavior; don't invent stricter or looser rules.

### 5. Classify each installed version

- **Global** → keep, always.
- **Has ≥1 pin** → keep. Record which paths, so the report can show its reasons.
- **Zero pins** → delete candidate.

Sort delete candidates into two tiers, and present them separately:

- **Unreferenced** — no pin anywhere. Safe.
- **Judgment** — pinned only by archived clones (`~/code/archives/`), throwaway sandboxes (`~/code/rails/`, `~/code/fly/`), other people's dotfiles (`~/code/nathan/`, `~/code/kelsie/`), or stale dotfile copies. Technically pinned, plausibly disposable — the user decides, per version, every run. Never fold these into the safe tier.

### 6. Report

Show a table: version, size, keep/delete, and the concrete reason (a pin path, or "no pins found"). Include the total reclaimable.

Also report **pins referencing versions that aren't installed** (e.g. 3.3.4 has pins but no install). It means those projects are already broken, and it's a useful signal that a pin doesn't prove a project is alive.

State the known gaps every run, so the user can calibrate:

- Only `~` is scanned — anything on an external volume is invisible.
- Pins are read from `.ruby-version`, `.tool-versions`, and `Gemfile`. A project selecting its Ruby some other way (a wrapper script, a Docker image, direnv) would not show up.

**CHECKPOINT: stop here unless `--apply` was passed. Report and end.**

### 7. Uninstall (only with `--apply` + explicit confirmation)

Confirm the exact list with the user, then per version:

```bash
asdf uninstall ruby <version>
```

Report each result. Afterwards, re-run `asdf list ruby` and `du -sh ~/.asdf/installs/ruby` to show the new state and actual space reclaimed.

## Relationship to `/create-bump`

`/create-bump` is a **project-local skill** in the asdf working repo (`~/code/active/asdf/.claude/skills/create-bump/`), not part of dotfiles — it won't appear in this repo.

It uninstalls only the single MRI version it installed for testing — safe, because it created that version minutes earlier and nothing can be pinned to it yet. It must **not** call this skill or do fleet-wide cleanup; a routine ruby-build bump should never be able to delete an app's Ruby. Run `/ruby-gc` deliberately, on its own.

That constraint is enforced where it binds — in `/create-bump`'s own step 8, since a skill can only follow rules written in the file it reads. The note here is orientation, not enforcement. If `/create-bump` is ever rewritten, re-check that its step 8 still carries the no-fleet-cleanup rule.
