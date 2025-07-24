# Shell Abbreviations Reference

This document provides a comprehensive reference for all shell abbreviations available in both Fish and Zsh shells. Abbreviations are automatically generated from the single source of truth: `shared/abbreviations.yaml`.

## Overview

- **Total abbreviations**: 289 (288 in Fish, 289 in Zsh)
- **Categories**: 24
- **Source file**: `shared/abbreviations.yaml`
- **Generated files**:
  - Fish: `fish/.config/fish/abbreviations.fish`
  - Zsh: `zsh/.config/zsh-abbr/abbreviations.zsh`

## Usage

Abbreviations expand automatically when you press space or enter. For example:

- Type `gst` + space → expands to `git status`
- Type `ll` + space → expands to `eza -la`

## Managing Abbreviations

### Regeneration

To update abbreviations after modifying `shared/abbreviations.yaml`:

```bash
# Regenerate all abbreviation files and documentation
~/dotfiles/shared/generate-all-abbr.sh

# Or use the function (available in both shells)
reload-abbr
```

### Shell Differences

- **Fish**: Uses native abbreviations (`abbr` command)
- **Zsh**: Uses `zsh-abbr` plugin to provide Fish-like behavior
- Most abbreviations work identically in both shells
- Some shell-specific abbreviations exist (e.g., `src` for Zsh only)

## Abbreviation Categories

### unix

Basic system utilities with enhanced options:

| Abbr | Command | Description |
|------|---------|-------------|
| `c` | `clear` | c |
| `cv` | `command -v` | cv |
| `df` | `df -h` | df |
| `du` | `du -h` | du |
| `dud` | `du -d 1 -h` | dud |
| `duf` | `du -sh *` | duf |
| `mkdir` | `mkdir -pv` | mkdir |
| `mv` | `mv -iv` | mv |

### shell

Shell-specific operations:

| Abbr | Command | Description |
|------|---------|-------------|
| `src` | `source $HOME/.zshrc` | src |

### system

System information and management:

| Abbr | Command | Description |
|------|---------|-------------|
| `fast` | `fastfetch` | fast |

### claude code

AI assistant shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `cl` | `claude` | cl |
| `clsp` | `claude --dangerously-skip-permissions` | clsp |
| `clh` | `claude --help` | clh |
| `clv` | `claude --version` | clv |
| `clr` | `claude --resume` | clr |
| `clc` | `claude --continue` | clc |
| `clp` | `claude --print` | clp |
| `clcp` | `claude --continue --print` | clcp |
| `clup` | `claude update` | clup |
| `clmcp` | `claude mcp` | clmcp |

### homebrew

Homebrew shortcuts with common options:

| Abbr | Command | Description |
|------|---------|-------------|
| `brc` | `brew cleanup` | brc |
| `brb` | `brew bundle` | brb |
| `brd` | `brew doctor` | brd |
| `brg` | `brew upgrade` | brg |
| `bri` | `brew info` | bri |
| `brl` | `brew list -1` | brl |
| `brlf` | `brew list  fzf` | brlf |
| `bro` | `brew outdated` | bro |
| `brs` | `brew search` | brs |
| `bru` | `brew update` | bru |
| `bs0` | `brew services stop` | bs0 |
| `bs1` | `brew services start` | bs1 |
| `bsc` | `brew services cleanup` | bsc |
| `bsl` | `brew services list` | bsl |
| `bsr` | `brew services restart` | bsr |
| `bsv` | `brew services` | bsv |

### config dirs

Quick access to common directories:

| Abbr | Command | Description |
|------|---------|-------------|
| `cdot` | `cd $DOTFILES` | cdot |
| `cdxc` | `cd $XDG_CONFIG_HOME` | cdxc |
| `cdfi` | `cd $XDG_CONFIG_HOME/fish` | cdfi |
| `cdnv` | `cd $XDG_CONFIG_HOME/nvim` | cdnv |
| `cdxd` | `cd $XDG_DATA_HOME` | cdxd |
| `cdxa` | `cd $XDG_CACHE_HOME` | cdxa |
| `cdxs` | `cd $XDG_STATE_HOME` | cdxs |
| `cdlb` | `cd $HOME/.local/bin` | cdlb |
| `cdbn` | `cd $HOME/.bin` | cdbn |

### navigation

Enhanced directory navigation:

| Abbr | Command | Description |
|------|---------|-------------|
| `..` | `cd ..` | .. |
| `...` | `cd ../../` | ... |
| `....` | `cd ../../../` | .... |
| `.....` | `cd ../../../../` | ..... |
| `-` | `cd -` | - |

### tree

Enhanced directory listing with `eza`:

| Abbr | Command | Description |
|------|---------|-------------|
| `tree` | `ll --tree --level=2` | tree |
| `t2` | `ll --tree --level=2` | t2 |
| `t2a` | `ll --tree --level=2 -a` | t2a |
| `t3` | `ll --tree --level=3` | t3 |
| `t3a` | `ll --tree --level=3 -a` | t3a |
| `t4` | `ll --tree --level=4` | t4 |
| `t4a` | `ll --tree --level=4 -a` | t4a |

### dev tools

Programming and development utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `gg` | `lazygit` | gg |
| `hm` | `hivemind` | hm |

### markdown

markdown utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `mdl` | `markdownlint-cli2 --config ~/.markdownlint.yaml` | mdl |
| `mdlf` | `markdownlint-cli2 --config ~/.markdownlint.yaml --fix` | mdlf |
| `mdla` | `markdownlint-cli2 --config ~/.markdownlint.yaml '**/*.md'` | mdla |
| `mdlaf` | `markdownlint-cli2 --config ~/.markdownlint.yaml --fix '**/*.md'` | mdlaf |

### local servers

local servers utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `hts` | `http-server` | hts |
| `lvs` | `live-server` | lvs |

### neovim

neovim utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `nv` | `nvim` | nv |
| `vi` | `nvim` | vi |
| `vi0` | `nvim -u NONE` | vi0 |
| `vir` | `nvim -R` | vir |
| `vv` | `nvim --version  less` | vv |

### git

Comprehensive git workflow shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `ga` | `git add` | ga |
| `gaa` | `git add --all` | gaa |
| `gap` | `git add --patch` | gap |
| `gb` | `git branch` | gb |
| `gba` | `git branch --all` | gba |
| `gbm` | `git branch -m` | gbm |
| `gbr` | `git branch --remote` | gbr |
| `gca` | `git commit --amend` | gca |
| `gcl` | `git clone` | gcl |
| `gcm` | `git cm` | gcm |
| `gco` | `git checkout` | gco |
| `gcob` | `git checkout -b` | gcob |
| `gcp` | `git cherry-pick` | gcp |
| `gd` | `git diff` | gd |
| `gdc` | `git diff --cached` | gdc |
| `gdt` | `git difftool` | gdt |
| `gf` | `git fetch` | gf |
| `gfa` | `git fetch --all` | gfa |
| `gfp` | `git fetch --prune` | gfp |
| `gfu` | `git fetch upstream` | gfu |
| `gl` | `git l` | gl |
| `glg` | `git lg` | glg |
| `gll` | `git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold white)— %an%C(reset)%C(bold yellow)%d%C(reset)' --abbrev-commit` | gll |
| `gp` | `git push` | gp |
| `gpl` | `git pull` | gpl |
| `gps` | `git push` | gps |
| `gpsf` | `git push --force-with-lease` | gpsf |
| `gpst` | `git push --tags` | gpst |
| `gpub` | `git publish` | gpub |
| `gpuo` | `git push -u origin` | gpuo |
| `gra` | `git remote add` | gra |
| `grb` | `git rebase` | grb |
| `grba` | `git rebase --abort` | grba |
| `grbc` | `git rebase --continue` | grbc |
| `grbi` | `git rebase -i` | grbi |
| `gre` | `git reset` | gre |
| `grso` | `git remote set-url origin` | grso |
| `grsu` | `git remote set-url` | grsu |
| `grup` | `git remote add upstream` | grup |
| `gs` | `git status` | gs |
| `gsh` | `git show` | gsh |
| `gss` | `git stash` | gss |
| `gssa` | `git stash apply` | gssa |
| `gssd` | `git stash drop` | gssd |
| `gssl` | `git stash list` | gssl |
| `gssp` | `git stash pop` | gssp |
| `gsss` | `git stash save` | gsss |
| `gst` | `git status` | gst |
| `gsts` | `git status --short` | gsts |
| `gt` | `git tag` | gt |

### docker

Container management shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `dc` | `docker compose` | dc |
| `dcu` | `docker compose up` | dcu |
| `dcud` | `docker compose up -d` | dcud |
| `dcb` | `docker compose up --build` | dcb |
| `dcbd` | `docker compose up --build -d` | dcbd |
| `dcd` | `docker compose down` | dcd |
| `dcdv` | `docker compose down -v` | dcdv |
| `dce` | `docker compose exec` | dce |
| `dcr` | `docker compose restart` | dcr |
| `dl` | `docker logs` | dl |
| `dim` | `docker images` | dim |
| `dnet` | `docker network` | dnet |
| `dps` | `docker ps` | dps |
| `dpsa` | `docker ps -a` | dpsa |
| `dsp` | `docker system prune --all` | dsp |
| `d` | `docker` | d |
| `db` | `docker build` | db |
| `dcl` | `docker compose logs` | dcl |
| `dclf` | `docker compose logs -f` | dclf |
| `dcps` | `docker compose ps` | dcps |
| `dcpull` | `docker compose pull` | dcpull |
| `dcrm` | `docker compose rm` | dcrm |
| `dcstart` | `docker compose start` | dcstart |
| `dcstop` | `docker compose stop` | dcstop |
| `de` | `docker exec` | de |
| `dei` | `docker exec -i` | dei |
| `deit` | `docker exec -it` | deit |
| `dexec` | `docker exec` | dexec |
| `dpu` | `docker pull` | dpu |
| `drm` | `docker rm` | drm |
| `drmi` | `docker rmi` | drmi |
| `drun` | `docker run` | drun |
| `dst` | `docker start` | dst |
| `dstp` | `docker stop` | dstp |

### rails

Ruby on Rails shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `RED` | `RAILS_ENV=development` | RED |
| `REP` | `RAILS_ENV=production` | REP |
| `RET` | `RAILS_ENV=test` | RET |
| `bbi` | `bin/bundle install` | bbi |
| `bbo` | `bin/bundle outdated` | bbo |
| `bbu` | `bin/bundle update` | bbu |
| `bd` | `bin/dev` | bd |
| `cred` | `bin/rails credentials:edit --environment` | cred |
| `crsp` | `env COVERAGE=true bin/rspec .` | crsp |
| `ocr` | `overmind connect rails` | ocr |
| `om` | `overmind start` | om |
| `psp` | `bin/rake parallel:spec` | psp |
| `r` | `bin/rails` | r |
| `rc` | `bin/rails console` | rc |
| `rcop` | `rubocop` | rcop |
| `rdb` | `bin/rails dbconsole` | rdb |
| `rdbc` | `bin/rails db:create` | rdbc |
| `rdbd` | `bin/rails db:drop` | rdbd |
| `rdm` | `bin/rails db:migrate` | rdm |
| `rdms` | `bin/rails db:migrate:status` | rdms |
| `rdr` | `bin/rails db:rollback` | rdr |
| `rdr2` | `bin/rails db:rollback STEP=2` | rdr2 |
| `rdr3` | `bin/rails db:rollback STEP=3` | rdr3 |
| `rdbs` | `bin/rails db:seed` | rdbs |
| `rg` | `bin/rails generate` | rg |
| `rgc` | `bin/rails generate controller` | rgc |
| `rgm` | `bin/rails generate migration` | rgm |
| `rgs` | `bin/rails generate stimulus` | rgs |
| `rr` | `bin/rails routes` | rr |
| `rrc` | `bin/rails routes controller` | rrc |
| `rrg` | `bin/rails routes  grep` | rrg |
| `rs` | `bin/rails server` | rs |
| `rsp` | `bin/rspec .` | rsp |
| `rtp` | `bin/rails db:test:prepare` | rtp |

### ruby

ruby utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `b` | `bundle` | b |
| `be` | `bundle exec` | be |
| `ber` | `bundle exec rspec` | ber |
| `beri` | `bundle exec rspec --init` | beri |
| `bes` | `bundle exec standardrb` | bes |
| `besf` | `bundle exec standardrb --fix` | besf |
| `gel` | `gem cleanup` | gel |
| `gemv` | `gem environment` | gemv |
| `gins` | `gem install` | gins |
| `gli` | `gem list` | gli |
| `gout` | `gem outdated` | gout |
| `guns` | `gem uninstall` | guns |
| `gup` | `gem update` | gup |
| `gus` | `gem update --system` | gus |

### npm

JavaScript development tools:

| Abbr | Command | Description |
|------|---------|-------------|
| `nb` | `npm build` | nb |
| `ncl` | `npm clean` | ncl |
| `nd` | `npm run dev` | nd |
| `ndv` | `npm develop` | ndv |
| `ni` | `npm install` | ni |
| `nid` | `npm install -D` | nid |
| `nig` | `npm install -g` | nig |
| `nit` | `npm init` | nit |
| `ns` | `npm serve` | ns |
| `nst` | `npm start` | nst |
| `nt` | `npm test` | nt |

### asdf

asdf utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `ail` | `asdf install lua` | ail |
| `ain` | `asdf install nodejs` | ain |
| `ainl` | `asdf install nodejs latest` | ainl |
| `aip` | `asdf install python` | aip |
| `air` | `asdf install ruby` | air |
| `airl` | `asdf install ruby latest` | airl |
| `ala` | `asdf list all` | ala |
| `ali` | `asdf list` | ali |
| `aui` | `asdf install` | aui |
| `agl` | `asdf global` | agl |
| `all` | `asdf local` | all |
| `acl` | `asdf current` | acl |
| `aun` | `asdf uninstall` | aun |
| `ares` | `asdf reshim` | ares |
| `aup` | `asdf update` | aup |
| `aupp` | `asdf update --all && asdf plugin update --all` | aupp |

### tmux

Terminal multiplexer shortcuts:

| Abbr | Command | Description |
|------|---------|-------------|
| `tl` | `tmux ls` | tl |
| `tlw` | `tmux list-windows` | tlw |

### tmuxinator

tmuxinator utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `mux` | `tmuxinator` | mux |
| `ms` | `tmuxinator start` | ms |
| `msb1` | `tmuxinator start bfo1` | msb1 |
| `msb2` | `tmuxinator start bfo2` | msb2 |
| `msbc` | `tmuxinator start bf_curriculum` | msbc |
| `msc` | `tmuxinator start comix_distro` | msc |
| `msd` | `tmuxinator start dot` | msd |
| `mse` | `tmuxinator start euroteamoutreach` | mse |
| `msl` | `tmuxinator start laptop` | msl |
| `msm` | `tmuxinator start mux` | msm |
| `mso` | `tmuxinator start ofreport` | mso |

### yarn

yarn utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `y` | `yarn` | y |
| `ya` | `yarn add` | ya |
| `yad` | `yarn add --dev` | yad |
| `yag` | `yarn add --global` | yag |
| `yap` | `yarn add --peer` | yap |
| `yarn-upgrade` | `yarn upgrade-interactive --latest` | yarn-upgrade |
| `yb` | `yarn build` | yb |
| `ycc` | `yarn cache clean` | ycc |
| `yd` | `yarn dev` | yd |
| `yga` | `yarn global add` | yga |
| `ygl` | `yarn global list` | ygl |
| `ygr` | `yarn global remove` | ygr |
| `ygu` | `yarn global upgrade` | ygu |
| `yh` | `yarn help` | yh |
| `yi` | `yarn install` | yi |
| `yic` | `yarn install --check-files` | yic |
| `yif` | `yarn install --frozen-lockfile` | yif |
| `yin` | `yarn init` | yin |
| `yln` | `yarn link` | yln |
| `yls` | `yarn list` | yls |
| `yout` | `yarn outdated` | yout |
| `yp` | `yarn pack` | yp |
| `ypub` | `yarn publish` | ypub |
| `yr` | `yarn run` | yr |
| `yre` | `yarn remove` | yre |
| `ys` | `yarn serve` | ys |
| `yst` | `yarn start` | yst |
| `yt` | `yarn test` | yt |
| `ytc` | `yarn test --coverage` | ytc |
| `yuc` | `yarn global upgrade && yarn cache clean` | yuc |
| `yui` | `yarn upgrade-interactive` | yui |
| `yuil` | `yarn upgrade-interactive --latest` | yuil |
| `yup` | `yarn upgrade` | yup |
| `yv` | `yarn version` | yv |
| `yw` | `yarn workspace` | yw |
| `yws` | `yarn workspaces` | yws |

### postgresql

postgresql utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `startpost` | `pg_ctl -D /opt/homebrew/var/postgres start` | startpost |
| `stoppost` | `pg_ctl -D /opt/homebrew/var/postgres stop` | stoppost |
| `statpost` | `pg_ctl -D /opt/homebrew/var/postgres status` | statpost |
| `psq` | `psql -U postgres` | psq |

### finder

finder utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `haf` | `defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder` | haf |
| `saf` | `defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder` | saf |

### middleman

middleman utilities:

| Abbr | Command | Description |
|------|---------|-------------|
| `mm` | `bundle exec middleman` | mm |
| `mmb` | `bundle exec middleman build` | mmb |
| `mmbc` | `bundle exec middleman build --clean` | mmbc |
| `mmc` | `bundle exec middleman console` | mmc |
| `mms` | `bundle exec middleman server` | mms |

## Cross-Shell Compatibility

### Fish-Only Features

- Native abbreviation expansion
- Better completion integration

### Zsh-Only Features

- `src` abbreviation for reloading configuration
- Integration with Oh My Zsh plugins

### Shared Features

- All abbreviations work identically
- Same expansion behavior
- Consistent command structure

## Customization

### Adding New Abbreviations

1. Edit `shared/abbreviations.yaml`
2. Add to appropriate category
3. Run `reload-abbr` to regenerate files
4. Reload your shell configuration

### Example Addition

```yaml
# In shared/abbreviations.yaml
git:
  gnew: "git checkout -b"  # New branch shortcut
```

### Category Guidelines

- **unix**: Basic UNIX commands and utilities
- **git**: Git version control operations
- **dev_tools**: Development and programming tools
- **navigation**: Directory and file navigation
- **system**: System administration and information

## Related Documentation

- [Function Documentation](functions/README.md) - Shell function reference
- [Git Functions](functions/git-functions.md) - Smart git operations
- [Development Tools](functions/development.md) - Development utilities
- [Tmux Functions](functions/tmux.md) - Terminal multiplexer management

---

*This file is automatically generated from `shared/abbreviations.yaml`. Do not edit directly.*
*Last generated: Thu Jul 24 17:22:44 EEST 2025*
