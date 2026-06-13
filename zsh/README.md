# Zsh Configuration

Zsh is the primary shell, configured with [zsh-abbr](https://zsh-abbr.olets.dev) for abbreviations, [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) for history-based completions, and [Starship](https://starship.rs) for the prompt.

## Key Files

| File                                 | Purpose                                                          |
| ------------------------------------ | ---------------------------------------------------------------- |
| `.zshrc`                             | Main shell config — history settings, plugin loading, path setup |
| `.config/zsh-abbr/abbreviations.zsh` | All abbreviations (managed by zsh-abbr)                          |
| `.config/zsh/plugins.zsh`            | Plugin declarations (loaded by Zap)                              |
| `.config/zsh/*.sh`                   | Topic-specific config (docker, aliases, etc.)                    |

## History Cleanup

zsh-autosuggestions shows "shadow text" completions sourced from `~/.zsh_history`. Erroneous commands that make it into history will keep appearing as suggestions. Here's how to remove them.

### Remove a Single Command

```bash
# 1. Find the entry (shows line numbers)
LC_ALL=C grep -n 'tll' ~/.zsh_history

# 2. Back up the history file
cp ~/.zsh_history ~/.zsh_history.bak

# 3. Delete the line (replace 6432 with the actual line number)
LC_ALL=C sed -i '' '6432d' ~/.zsh_history

# 4. Reload history in your current session
fc -R
```

Run `fc -R` in every open terminal to pick up the change.

### Remove All Occurrences of a Command

Use this when a command appears multiple times in history.

```bash
cp ~/.zsh_history ~/.zsh_history.bak

# Remove all exact matches of "tll"
LC_ALL=C grep -v '^: [0-9]*:[0-9]*;tll$' ~/.zsh_history > ~/.zsh_history.tmp \
  && mv ~/.zsh_history.tmp ~/.zsh_history

fc -R
```

### Batch Remove Multiple Commands

```bash
cp ~/.zsh_history ~/.zsh_history.bak

BAD_CMDS=("tll" "gti status" "brwe install")

for cmd in "${BAD_CMDS[@]}"; do
  LC_ALL=C grep -v "^: [0-9]*:[0-9]*;${cmd}$" ~/.zsh_history > ~/.zsh_history.tmp \
    && mv ~/.zsh_history.tmp ~/.zsh_history
done

fc -R
```

### Prevent a Command From Being Saved

Deleting an entry is reactive — the typo returns the next time you fat-finger it. To stop a specific command from ever entering history, set `HISTORY_IGNORE` to a pattern that matches it; zsh checks the pattern when writing history and drops anything that matches.

Keep this in `~/.zshrc.local` (sourced by `.zshrc`) rather than the tracked `.zshrc`, so your personal typo list stays out of the shared config:

```bash
# ~/.zshrc.local — never save these exact commands to history
HISTORY_IGNORE="(cc|tll)"
```

The pattern must match the **entire** command line, so `(cc|tll)` blocks only bare `cc` and `tll` — related commands like `cc-rails` or `tldr` are still saved. Extend it with alternation, e.g. `HISTORY_IGNORE="(cc|tll|gti *)"` (the trailing `*` is needed to also match a command's arguments).

### Tips

- **Always back up first** — `cp ~/.zsh_history ~/.zsh_history.bak`
- **`LC_ALL=C` matters** — the history file can contain non-ASCII bytes (pasted output, accented input). Under a UTF-8 locale `grep`/`sed` may mishandle those bytes and silently skip matches; the `LC_ALL=C` prefix forces reliable byte-wise matching.
- **Reloading the current session** — `fc -R` re-reads the file, but under `SHARE_HISTORY` it _appends_ rather than replaces, so a command already typed in the live session lingers as a suggestion. The surest fix is a fresh shell: `exec zsh` (or open a new terminal).
- **Close other terminals** or reload each one after editing, otherwise an exiting shell may write the old entries back
- **Preview before deleting** — use `LC_ALL=C grep -n` to see matches and confirm they're what you expect
- **Partial matches** — drop the `^` and `$` anchors in the grep pattern to match commands that _contain_ the string (be careful not to remove legitimate entries)
- **Restore from backup** — if something goes wrong: `cp ~/.zsh_history.bak ~/.zsh_history && fc -R`
