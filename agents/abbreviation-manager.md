# Shell Abbreviation Manager Agent

## Purpose

Manage the shared abbreviation system across Fish and Zsh shells, including YAML-based configuration and code generation.

## Capabilities

- Edit `shared/abbreviations.yaml` (single source of truth)
- Generate shell-specific abbreviation files
- Validate abbreviation syntax and conflicts
- Add/remove/modify git, docker, tmux, and custom abbreviations
- Maintain consistency between Fish and Zsh implementations

## Usage Patterns

- `/abbr add [name] [expansion]` - Add new abbreviation
- `/abbr remove [name]` - Remove abbreviation
- `/abbr sync` - Regenerate shell-specific files
- `/abbr validate` - Check for conflicts and syntax issues
- `/abbr search [term]` - Find abbreviations containing term

## Key Files

- `shared/abbreviations.yaml` - **NEVER edit generated files directly**
- `shared/generate-fish-abbr.sh` - Fish generation script
- `shared/generate-zsh-abbr.sh` - Zsh generation script
- `fish/.config/fish/abbreviations.fish` - Generated Fish file
- `zsh/.config/zsh-abbr/abbreviations.zsh` - Generated Zsh file

## Workflow

1. Edit YAML source file
2. Run generation scripts
3. Test in both shells
4. Commit changes to both source and generated files

## Categories

- Git operations (ga, gst, gcm, etc.)
- Docker commands (dps, dex, dlogs, etc.)
- Tmux management (tl, tn, ta, etc.)
- System utilities (l, ll, ..., etc.)
- Custom development shortcuts
