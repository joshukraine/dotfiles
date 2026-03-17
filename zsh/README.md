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
grep -n 'tll' ~/.zsh_history

# 2. Back up the history file
cp ~/.zsh_history ~/.zsh_history.bak

# 3. Delete the line (replace 6432 with the actual line number)
sed -i '' '6432d' ~/.zsh_history

# 4. Reload history in your current session
fc -R
```

Run `fc -R` in every open terminal to pick up the change.

### Remove All Occurrences of a Command

Use this when a command appears multiple times in history.

```bash
cp ~/.zsh_history ~/.zsh_history.bak

# Remove all exact matches of "tll"
grep -v '^: [0-9]*:[0-9]*;tll$' ~/.zsh_history > ~/.zsh_history.tmp \
  && mv ~/.zsh_history.tmp ~/.zsh_history

fc -R
```

### Batch Remove Multiple Commands

```bash
cp ~/.zsh_history ~/.zsh_history.bak

BAD_CMDS=("tll" "gti status" "brwe install")

for cmd in "${BAD_CMDS[@]}"; do
  grep -v "^: [0-9]*:[0-9]*;${cmd}$" ~/.zsh_history > ~/.zsh_history.tmp \
    && mv ~/.zsh_history.tmp ~/.zsh_history
done

fc -R
```

### Tips

- **Always back up first** — `cp ~/.zsh_history ~/.zsh_history.bak`
- **Close other terminals** or run `fc -R` in each one after editing, otherwise an exiting shell may write the old entries back
- **Preview before deleting** — use `grep -n` to see matches and confirm they're what you expect
- **Partial matches** — drop the `^` and `$` anchors in the grep pattern to match commands that _contain_ the string (be careful not to remove legitimate entries)
- **Restore from backup** — if something goes wrong: `cp ~/.zsh_history.bak ~/.zsh_history && fc -R`
