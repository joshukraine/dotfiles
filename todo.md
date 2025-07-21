# Dotfiles Improvement Plan

## Analysis Summary

**Fish vs Zsh Parity**: ~85-90% achieved  
**Analysis Date**: 2025-01-20  
**Priority**: High-impact improvements for maintainability and consistency

---

## Phase 1: Quick Wins (High Impact, Low Risk)

### 1. Remove Outdated iTerm2 Configuration ✅
- [x] Remove `/Users/joshukraine/dotfiles/iterm/` directory
- [x] Remove iTerm2 setup from `setup.sh` (lines 159-166)
- [x] Update `CLAUDE.md` to remove iTerm2 references
- [ ] Update README.md to remove iTerm2 font settings (if any)

### 2. Fix Deprecated Package References ✅
- [x] ~~Update Zsh exa plugin reference to eza~~ **REVERTED**: Plugin name stays "exa" (uses eza under hood)
- [x] Update comments to clarify exa plugin uses eza under the hood
- [x] Fix Homebrew cask tap warning: `brew untap homebrew/cask`

### 3. Update Git Branch References ✅  
- [x] ~~Fix Git aliases in `git/.gitconfig`~~ **REVERTED**: Hardcoding "main" breaks master repos
- [x] ~~Update Zsh abbreviations~~ **REVERTED**: Need smart branch detection instead  
- [x] ~~Update Fish abbreviations~~ **REVERTED**: Need smart branch detection instead
- [x] **PLAN**: Add smart git branch functions to Phase 2

### 4. Clean Up LazyVim Configuration ✅
- [x] Remove disabled `gruvbox.lua` (line 3: `if true then return {} end`)
- [x] Remove disabled `extend-neo-tree.lua` (line 3)
- [x] Remove disabled `extend-mini-files.lua` (line 3)
- [x] Update `vim.loop` to `vim.uv` in utility functions
- [x] Clean up extensive comments in `extend-blink.lua`

### 5. Remove Commented Dead Code ✅
- [x] Clean up commented powerlevel10k plugin in `zsh/.config/zsh/plugins.zsh` (line 9)
- [x] Remove commented 1Password CLI setup (lines 23-30)
- [x] Clean up commented autocmd in `nvim/lua/config/autocmds.lua` (lines 38-67)

---

## Phase 2: Major Improvements (Medium Impact, Medium Risk)

### 1. Create Shared Configuration Framework ✅
- [x] Create `shared/environment.sh` - Common environment variables (Zsh)
- [x] Create `shared/environment.fish` - Common environment variables (Fish)
- [x] Update Fish and Zsh configs to use shared environment files
- [x] Create `shared/abbreviations.yaml` - Single source for all abbreviations (196 abbrs!)
- [x] Build generators for Fish and Zsh specific configs
- [x] Generate shell-specific abbreviation files with proper headers
- [x] **ISSUE FOUND**: Missing abbreviations from original configs need restoration
- [ ] Create `shared/functions/` directory (lower priority - functions already mostly consolidated)

### 1a. Restore Missing Abbreviations ✅
**Priority: HIGH** - Several important abbreviations were lost during YAML conversion

**Missing Categories:**
- Shell-specific: `src` (Zsh reload)
- Development tools: `gg` (lazygit), `hm` (hivemind), `fast` (fastfetch)
- Rails shortcuts: `r` (bin/rails), `rc` (bin/rails console)  
- NPM: `ni` (install), `ns` (serve), `nt` (test)
- Git: `gs` (git status)

**Conflicts to resolve:**
- `ys`: Current=`yarn start` vs Original=`yarn serve` 

**Implementation Tasks:**
- [x] Add missing abbreviations to YAML file
- [x] Resolve `ys` conflict (kept `ys` = start, added `yserve` = serve)
- [x] Regenerate Fish/Zsh abbreviation files
- [x] Test abbreviations work in both shells
- [x] Update documentation if needed

**Results:**
- Fish: 207 abbreviations (excludes shell-specific `src`)
- Zsh: 208 abbreviations (includes `src` for sourcing .zshrc)
- All missing abbreviations restored successfully

### 2. Create Smart Git Branch Functions ❌
- [ ] Implement `gpum` function that detects default branch and pushes to it
- [ ] Implement `grbm` function that detects default branch and rebases against it  
- [ ] Implement `com` function that detects and checks out default branch
- [ ] Use logic: `git symbolic-ref refs/remotes/origin/HEAD` or `git remote show origin`
- [ ] Add fallback logic and error handling
- [ ] Implement in both Fish and Zsh with identical functionality

### 3. Improve Fish/Zsh Parity ❌
- [ ] Add missing editor functions to Zsh (`ed`, `efl`, `et`, `ev`, `evl`)
- [ ] Implement `fkill` function in Zsh (fuzzy kill with fzf)
- [ ] Add path manipulation functions to Zsh (`addpaths`, `removepath`)
- [ ] Align tmuxinator project abbreviations between shells
- [ ] Ensure ls/eza commands work identically

### 4. Function Consolidation ❌
- [ ] Consolidate duplicate Git functions (`g`, `gcom`, `gbrm`)
- [ ] Merge development utilities (`aua`, `bubo`, `copy`)
- [ ] Unify navigation/path functions

### 5. Setup Script Improvements ❌
- [ ] Extract conflict detection into separate function
- [ ] Add dry-run capability
- [ ] Improve error handling and rollback
- [ ] Add validation for required tools

### 6. Configuration Organization ❌
- [ ] Organize Fish functions into logical directories (git/, development/, system/)
- [ ] Split large Zsh functions.zsh into modules
- [ ] Consolidate colorscheme configurations in Neovim

---

## Phase 3: Long-term Improvements (Future Enhancements)

### 1. Automation & Testing ❌
- [ ] Add automated testing for shell functions
- [ ] Create configuration validation scripts
- [ ] Implement CI/CD for dotfiles

### 2. Documentation ❌
- [ ] Document individual functions
- [ ] Add setup script usage examples
- [ ] Create troubleshooting guide

### 3. Maintenance Tools ❌
- [ ] Automated abbreviation conflict detection
- [ ] Configuration drift monitoring
- [ ] Dependency update automation

---

## Current Issues Identified

### Fish vs Zsh Parity Gaps
- **Missing in Zsh**: Editor functions, fkill, path manipulation, eza wrappers
- **Different implementations**: Functions vs aliases for same functionality

### Outdated Code Locations
- `iterm/` - Complete obsolete directory
- `zsh/.config/zsh/plugins.zsh` - Commented out configurations
- `zsh/.p10k.zsh` - Legacy version manager configs
- `bash/.bashrc` - Commented ASDF configuration

### Package Issues
- Zsh references deprecated `exa` instead of `eza`
- Git configs use `master` instead of `main`
- Unnecessary Homebrew cask tap

### LazyVim Issues
- Multiple disabled configuration files
- Outdated API usage (`vim.loop` vs `vim.uv`)
- Extensive commented code sections
- Inconsistent file naming (`extend-*` prefix)

---

## Progress Tracking

**Phase 1 Completion**: 5/5 ✅  
**Phase 2 Completion**: 2/7 ⚠️ (Shared config + Missing abbreviations)  
**Phase 3 Completion**: 0/3 ❌  

**Overall Progress**: 47% (7/15 major sections)

---

*Last Updated: 2025-01-20*