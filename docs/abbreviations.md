# Shell Abbreviations Reference

This document provides a comprehensive reference for all shell abbreviations available in both Fish and Zsh shells. Abbreviations are automatically generated from the single source of truth: `shared/abbreviations.yaml`.

## Overview

- **Total abbreviations**: 287 (288 in Fish, 287 in Zsh)
- **Categories**: 23
- **Source file**: `shared/abbreviations.yaml`
- **Generated files**:
  - Fish: `fish/.config/fish/abbreviations.fish`
  - Zsh: `zsh/.config/zsh-abbr/abbreviations.zsh`

## Usage

Abbreviations expand automatically when you press space or enter. For example:

- Type `gst` + space → expands to `git status`
- Type `dcu` + space → expands to `docker compose up`

## Managing Abbreviations

### Regeneration

To update abbreviations after modifying `shared/abbreviations.yaml`:

```bash
reload-abbr
```

The `reload-abbr` function provides:

- Comprehensive error checking and validation
- Regenerates both abbreviations and function documentation
- Built-in help with `reload-abbr --help`
- User-friendly output and guidance

### Shell Differences

- **Fish**: Uses native abbreviations (`abbr` command)
- **Zsh**: Uses `zsh-abbr` plugin to provide Fish-like behavior
- Most abbreviations work identically in both shells
- Some shell-specific abbreviations exist (e.g., `src` for Zsh only)

## Abbreviation Categories

### unix

Basic system utilities with enhanced options:

| Abbr    | Command         | Description                                                  |
| ------- | --------------- | ------------------------------------------------------------ |
| `c`     | `clear`         | Clear terminal screen                                        |
| `cv`    | `command -v`    | Check if command exists and show its path                    |
| `df`    | `df -h`         | Show disk space usage in human-readable format               |
| `du`    | `du -h`         | Show directory sizes in human-readable format                |
| `dud`   | `du -d 1 -h`    | Show directory sizes one level deep                          |
| `duf`   | `du -sh *`      | Show file/folder sizes in current directory                  |
| `cat`   | `bat`           | Enhanced cat with syntax highlighting using bat              |
| `cp`    | `gcp -iv`       | Enhanced copy with progress and interactive prompts          |
| `l`     | `ls -lhF --git` | Long listing format with human-readable sizes and git status |
| `mkdir` | `mkdir -pv`     | Create directories recursively with verbose output           |
| `mv`    | `mv -iv`        | Move files interactively with confirmation                   |

### shell

Shell-specific operations:

| Abbr  | Command               | Description              |
| ----- | --------------------- | ------------------------ |
| `src` | `source $HOME/.zshrc` | Reload Zsh configuration |

### system

System information and management:

| Abbr   | Command     | Description                          |
| ------ | ----------- | ------------------------------------ |
| `fast` | `fastfetch` | Display system information with logo |

### claude code

AI assistant shortcuts:

| Abbr    | Command                                 | Description                             |
| ------- | --------------------------------------- | --------------------------------------- |
| `cl`    | `claude`                                | Start Claude AI assistant               |
| `clsp`  | `claude --dangerously-skip-permissions` | Start Claude without permission checks  |
| `clh`   | `claude --help`                         | Show Claude help information            |
| `clv`   | `claude --version`                      | Show Claude version                     |
| `clr`   | `claude --resume`                       | Resume previous Claude session          |
| `clc`   | `claude --continue`                     | Continue current conversation           |
| `clp`   | `claude --print`                        | Print conversation history              |
| `clcp`  | `claude --continue --print`             | Continue conversation and print history |
| `clup`  | `claude update`                         | Update Claude to latest version         |
| `clmcp` | `claude mcp`                            | Use Claude with MCP protocol            |

### homebrew

Homebrew shortcuts with common options:

| Abbr   | Command                 | Description                                 |
| ------ | ----------------------- | ------------------------------------------- |
| `brc`  | `brew cleanup`          | Remove outdated downloads and clear cache   |
| `brb`  | `brew bundle`           | Install packages from Brewfile              |
| `brd`  | `brew doctor`           | Check system for potential problems         |
| `brg`  | `brew upgrade`          | Upgrade all installed packages              |
| `bri`  | `brew info`             | Show package information                    |
| `brl`  | `brew list -1`          | List installed packages (one per line)      |
| `brlf` | `brew list  fzf`        | Search installed packages with fuzzy finder |
| `bro`  | `brew outdated`         | Show packages with updates available        |
| `brs`  | `brew search`           | Search for packages                         |
| `bru`  | `brew update`           | Update Homebrew and package lists           |
| `bs0`  | `brew services stop`    | Stop Homebrew service                       |
| `bs1`  | `brew services start`   | Start Homebrew service                      |
| `bsc`  | `brew services cleanup` | Remove unused service files                 |
| `bsl`  | `brew services list`    | List all Homebrew services                  |
| `bsr`  | `brew services restart` | Restart Homebrew service                    |
| `bsv`  | `brew services`         | Manage Homebrew services                    |

### config dirs

Quick access to common directories:

| Abbr   | Command                    | Description                            |
| ------ | -------------------------- | -------------------------------------- |
| `cdot` | `cd $DOTFILES`             | Navigate to dotfiles repository        |
| `cdxc` | `cd $XDG_CONFIG_HOME`      | Navigate to XDG config directory       |
| `cdfi` | `cd $XDG_CONFIG_HOME/fish` | Navigate to Fish shell configuration   |
| `cdnv` | `cd $XDG_CONFIG_HOME/nvim` | Navigate to Neovim configuration       |
| `cdxd` | `cd $XDG_DATA_HOME`        | Navigate to XDG data directory         |
| `cdxa` | `cd $XDG_CACHE_HOME`       | Navigate to XDG cache directory        |
| `cdxs` | `cd $XDG_STATE_HOME`       | Navigate to XDG state directory        |
| `cdlb` | `cd $HOME/.local/bin`      | Navigate to local bin directory        |
| `cdbn` | `cd $HOME/.bin`            | Navigate to legacy bin directory       |
| `cdkb` | `cdkb`                     | Navigate to Claude Code Knowledge Base |

### navigation

Enhanced directory navigation:

| Abbr    | Command           | Description                  |
| ------- | ----------------- | ---------------------------- |
| `..`    | `cd ..`           | Go up one directory level    |
| `...`   | `cd ../../`       | Go up two directory levels   |
| `....`  | `cd ../../../`    | Go up three directory levels |
| `.....` | `cd ../../../../` | Go up four directory levels  |
| `-`     | `cd -`            | Go to previous directory     |

### tree

Enhanced directory listing with `eza`:

| Abbr  | Command                  | Description                                      |
| ----- | ------------------------ | ------------------------------------------------ |
| `t2`  | `ll --tree --level=2`    | Show directory tree (2 levels deep)              |
| `t2a` | `ll --tree --level=2 -a` | Show directory tree with hidden files (2 levels) |
| `t3`  | `ll --tree --level=3`    | Show directory tree (3 levels deep)              |
| `t3a` | `ll --tree --level=3 -a` | Show directory tree with hidden files (3 levels) |
| `t4`  | `ll --tree --level=4`    | Show directory tree (4 levels deep)              |
| `t4a` | `ll --tree --level=4 -a` | Show directory tree with hidden files (4 levels) |

### dev tools

Programming and development utilities:

| Abbr | Command    | Description                        |
| ---- | ---------- | ---------------------------------- |
| `gg` | `lazygit`  | Launch interactive git interface   |
| `hm` | `hivemind` | Run Procfile-based process manager |

### markdown

markdown utilities:

| Abbr    | Command                                                           | Description                                                      |
| ------- | ----------------------------------------------------------------- | ---------------------------------------------------------------- |
| `mdl`   | `markdownlint-cli2 --config ~/.markdownlint.yaml "**/*.md"`       | Lint all markdown files in project (recursive)                   |
| `mdlf`  | `markdownlint-cli2 --config ~/.markdownlint.yaml --fix "**/*.md"` | Lint and auto-fix all markdown files in project (recursive)      |
| `mdlc`  | `markdownlint-cli2 --config ~/.markdownlint.yaml "*.md"`          | Lint markdown files in current directory only                    |
| `mdlcf` | `markdownlint-cli2 --config ~/.markdownlint.yaml --fix "*.md"`    | Lint and auto-fix markdown files in current directory only       |
| `mdla`  | `markdownlint-cli2 --config ~/.markdownlint.yaml "**/*.md"`       | Lint all markdown files in project (alias for mdl)               |
| `mdlaf` | `markdownlint-cli2 --config ~/.markdownlint.yaml --fix "**/*.md"` | Lint and auto-fix all markdown files in project (alias for mdlf) |
| `mdv`   | `markdown-validate`                                               | Validate markdown in current directory (detailed)                |
| `mdvf`  | `markdown-validate --fix`                                         | Validate and auto-fix markdown in current directory              |
| `mdvq`  | `markdown-validate --fix --quiet`                                 | Quick markdown validation and fix in current directory           |

### local servers

local servers utilities:

| Abbr  | Command       | Description                               |
| ----- | ------------- | ----------------------------------------- |
| `hts` | `http-server` | Start simple HTTP server for static files |
| `lvs` | `live-server` | Start development server with live reload |

### neovim

neovim utilities:

| Abbr  | Command                | Description                           |
| ----- | ---------------------- | ------------------------------------- |
| `nv`  | `nvim`                 | Open Neovim editor                    |
| `vi`  | `nvim`                 | Open Neovim editor (vi alias)         |
| `vi0` | `nvim -u NONE`         | Open Neovim without any configuration |
| `vir` | `nvim -R`              | Open Neovim in read-only mode         |
| `vv`  | `nvim --version  less` | Show Neovim version information       |

### git

Comprehensive git workflow shortcuts:

| Abbr   | Command                       | Description                               |
| ------ | ----------------------------- | ----------------------------------------- |
| `ga`   | `git add`                     | Stage files for commit                    |
| `gaa`  | `git add --all`               | Stage all changes for commit              |
| `gap`  | `git add --patch`             | Interactively stage changes               |
| `gb`   | `git branch`                  | List or manage branches                   |
| `gba`  | `git branch --all`            | List all branches (local and remote)      |
| `gbm`  | `git branch -m`               | Rename current branch                     |
| `gbr`  | `git branch --remote`         | List remote branches                      |
| `gca`  | `git commit --amend`          | Amend the last commit                     |
| `gcl`  | `git clone`                   | Clone a repository                        |
| `gcm`  | `git cm`                      | Commit with custom template               |
| `gco`  | `git checkout`                | Switch branches or restore files          |
| `gcob` | `git checkout -b`             | Create and switch to new branch           |
| `gcp`  | `git cherry-pick`             | Apply commit from another branch          |
| `gd`   | `git diff`                    | Show changes between commits              |
| `gdc`  | `git diff --cached`           | Show staged changes                       |
| `gdt`  | `git difftool`                | Show changes using external diff tool     |
| `gf`   | `git fetch`                   | Download changes from remote              |
| `gfa`  | `git fetch --all`             | Fetch from all remotes                    |
| `gfp`  | `git fetch --prune`           | Fetch and remove deleted remote branches  |
| `gfu`  | `git fetch upstream`          | Fetch from upstream remote                |
| `gl`   | `git l`                       | Show compact log (custom alias)           |
| `glg`  | `git lg`                      | Show graph log (custom alias)             |
| `gps`  | `git push`                    | Upload changes to remote                  |
| `gpl`  | `git pull`                    | Download and merge changes from remote    |
| `gpsf` | `git push --force-with-lease` | Force push with safety checks             |
| `gpst` | `git push --tags`             | Push tags to remote                       |
| `gpub` | `git publish`                 | Publish branch (custom command)           |
| `gpuo` | `git push -u origin`          | Push and set upstream to origin           |
| `gra`  | `git remote add`              | Add a remote repository                   |
| `grb`  | `git rebase`                  | Reapply commits on top of another base    |
| `grba` | `git rebase --abort`          | Cancel current rebase operation           |
| `grbc` | `git rebase --continue`       | Continue rebase after resolving conflicts |
| `grbi` | `git rebase -i`               | Interactive rebase                        |
| `gre`  | `git reset`                   | Reset current HEAD to specified state     |
| `grso` | `git remote set-url origin`   | Change origin remote URL                  |
| `grsu` | `git remote set-url`          | Change remote URL                         |
| `grup` | `git remote add upstream`     | Add upstream remote                       |
| `grv`  | `git remote -v`               | Show remote repositories with URLs        |
| `gsh`  | `git show`                    | Show various types of objects             |
| `gss`  | `git stash`                   | Temporarily save changes                  |
| `gssa` | `git stash apply`             | Apply stashed changes                     |
| `gssd` | `git stash drop`              | Delete a stash                            |
| `gssl` | `git stash list`              | List all stashes                          |
| `gssp` | `git stash pop`               | Apply and remove stash                    |
| `gsss` | `git stash save`              | Save changes to stash with message        |
| `gst`  | `git status`                  | Show working tree status                  |
| `gsts` | `git status --short`          | Show status in short format               |
| `gt`   | `git tag`                     | Create, list, or verify tags              |

### docker

Container management shortcuts:

| Abbr      | Command                        | Description                            |
| --------- | ------------------------------ | -------------------------------------- |
| `dc`      | `docker compose`               | Manage multi-container applications    |
| `dcu`     | `docker compose up`            | Start Docker Compose services          |
| `dcud`    | `docker compose up -d`         | Start services in background           |
| `dcb`     | `docker compose up --build`    | Build and start services               |
| `dcbd`    | `docker compose up --build -d` | Build and start services in background |
| `dcd`     | `docker compose down`          | Stop and remove containers             |
| `dcdv`    | `docker compose down -v`       | Stop containers and remove volumes     |
| `dce`     | `docker compose exec`          | Execute command in running container   |
| `dcr`     | `docker compose restart`       | Restart Docker Compose services        |
| `dl`      | `docker logs`                  | Show container logs                    |
| `dim`     | `docker images`                | List Docker images                     |
| `dnet`    | `docker network`               | Manage Docker networks                 |
| `dps`     | `docker ps`                    | List running containers                |
| `dpsa`    | `docker ps -a`                 | List all containers                    |
| `dsp`     | `docker system prune --all`    | Remove all unused Docker objects       |
| `d`       | `docker`                       | Docker container management            |
| `db`      | `docker build`                 | Build Docker image                     |
| `dcl`     | `docker compose logs`          | Show logs for services                 |
| `dclf`    | `docker compose logs -f`       | Follow logs for services               |
| `dcps`    | `docker compose ps`            | List containers for project            |
| `dcpull`  | `docker compose pull`          | Pull latest images                     |
| `dcrm`    | `docker compose rm`            | Remove stopped containers              |
| `dcstart` | `docker compose start`         | Start existing containers              |
| `dcstop`  | `docker compose stop`          | Stop running containers                |
| `de`      | `docker exec`                  | Execute command in container           |
| `dei`     | `docker exec -i`               | Execute interactive command            |
| `deit`    | `docker exec -it`              | Execute interactive terminal session   |
| `dpu`     | `docker pull`                  | Download Docker image                  |
| `drm`     | `docker rm`                    | Remove containers                      |
| `drmi`    | `docker rmi`                   | Remove Docker images                   |
| `drun`    | `docker run`                   | Create and start new container         |
| `dst`     | `docker start`                 | Start stopped containers               |
| `dstp`    | `docker stop`                  | Stop running containers                |

### rails

Ruby on Rails shortcuts:

| Abbr   | Command                                    | Description                          |
| ------ | ------------------------------------------ | ------------------------------------ |
| `RED`  | `RAILS_ENV=development`                    | Set Rails environment to development |
| `REP`  | `RAILS_ENV=production`                     | Set Rails environment to production  |
| `RET`  | `RAILS_ENV=test`                           | Set Rails environment to test        |
| `bbi`  | `bin/bundle install`                       | Install Ruby gems                    |
| `bbo`  | `bin/bundle outdated`                      | Show outdated gems                   |
| `bbu`  | `bin/bundle update`                        | Update Ruby gems                     |
| `bd`   | `bin/dev`                                  | Start development server             |
| `cred` | `bin/rails credentials:edit --environment` | Edit Rails credentials               |
| `crsp` | `env COVERAGE=true bin/rspec .`            | Run RSpec with coverage              |
| `ocr`  | `overmind connect rails`                   | Connect to Rails process in Overmind |
| `om`   | `overmind start`                           | Start Overmind process manager       |
| `psp`  | `bin/rake parallel:spec`                   | Run parallel specs                   |
| `r`    | `bin/rails`                                | Rails command runner                 |
| `rc`   | `bin/rails console`                        | Start Rails console                  |
| `rcop` | `rubocop`                                  | Run Ruby code linter                 |
| `rdb`  | `bin/rails dbconsole`                      | Start database console               |
| `rdbc` | `bin/rails db:create`                      | Create database                      |
| `rdbd` | `bin/rails db:drop`                        | Drop database                        |
| `rdm`  | `bin/rails db:migrate`                     | Run database migrations              |
| `rdms` | `bin/rails db:migrate:status`              | Show migration status                |
| `rdr`  | `bin/rails db:rollback`                    | Rollback last migration              |
| `rdr2` | `bin/rails db:rollback STEP=2`             | Rollback 2 migrations                |
| `rdr3` | `bin/rails db:rollback STEP=3`             | Rollback 3 migrations                |
| `rdbs` | `bin/rails db:seed`                        | Seed database with data              |
| `rgen` | `bin/rails generate`                       | Generate Rails code                  |
| `rgc`  | `bin/rails generate controller`            | Generate controller                  |
| `rgm`  | `bin/rails generate migration`             | Generate database migration          |
| `rgs`  | `bin/rails generate stimulus`              | Generate Stimulus controller         |
| `rr`   | `bin/rails routes`                         | Show application routes              |
| `rrc`  | `bin/rails routes controller`              | Show routes for controller           |
| `rrg`  | `bin/rails routes  grep`                   | Search routes                        |
| `rs`   | `bin/rails server`                         | Start Rails server                   |
| `rsp`  | `bin/rspec .`                              | Run RSpec tests                      |
| `rtp`  | `bin/rails db:test:prepare`                | Prepare test database                |

### ruby

ruby utilities:

| Abbr   | Command                        | Description                  |
| ------ | ------------------------------ | ---------------------------- |
| `b`    | `bundle`                       | Bundler gem manager          |
| `be`   | `bundle exec`                  | Execute command with Bundler |
| `ber`  | `bundle exec rspec`            | Run RSpec with Bundler       |
| `beri` | `bundle exec rspec --init`     | Initialize RSpec             |
| `bes`  | `bundle exec standardrb`       | Run StandardRB linter        |
| `besf` | `bundle exec standardrb --fix` | Fix StandardRB issues        |
| `gel`  | `gem cleanup`                  | Remove old gem versions      |
| `gemv` | `gem environment`              | Show gem environment info    |
| `gins` | `gem install`                  | Install gem                  |
| `gli`  | `gem list`                     | List installed gems          |
| `gout` | `gem outdated`                 | Show outdated gems           |
| `guns` | `gem uninstall`                | Uninstall gem                |
| `gup`  | `gem update`                   | Update gems                  |
| `gus`  | `gem update --system`          | Update RubyGems system       |

### npm

JavaScript development tools:

| Abbr  | Command          | Description              |
| ----- | ---------------- | ------------------------ |
| `nb`  | `npm build`      | Build npm project        |
| `ncl` | `npm clean`      | Clean npm cache          |
| `nd`  | `npm run dev`    | Run development server   |
| `ndv` | `npm develop`    | Run development mode     |
| `ni`  | `npm install`    | Install npm dependencies |
| `nid` | `npm install -D` | Install dev dependencies |
| `nig` | `npm install -g` | Install global package   |
| `nit` | `npm init`       | Initialize npm project   |
| `ns`  | `npm serve`      | Serve npm project        |
| `nst` | `npm start`      | Start npm project        |
| `nt`  | `npm test`       | Run npm tests            |

### asdf

asdf utilities:

| Abbr   | Command                      | Description                            |
| ------ | ---------------------------- | -------------------------------------- |
| `ail`  | `asdf install lua`           | Install Lua with ASDF                  |
| `ain`  | `asdf install nodejs`        | Install Node.js with ASDF              |
| `ainl` | `asdf install nodejs latest` | Install latest Node.js                 |
| `aip`  | `asdf install python`        | Install Python with ASDF               |
| `air`  | `asdf install ruby`          | Install Ruby with ASDF                 |
| `airl` | `asdf install ruby latest`   | Install latest Ruby                    |
| `ala`  | `asdf list all`              | List all available versions            |
| `ali`  | `asdf list`                  | List installed versions                |
| `aui`  | `asdf install`               | Install from .tool-versions            |
| `acl`  | `asdf current`               | Show current versions                  |
| `aun`  | `asdf uninstall`             | Uninstall version                      |
| `ares` | `asdf reshim`                | Refresh shims                          |
| `asu`  | `asdf set -u`                | Set global default version for user    |
| `ast`  | `asdf set`                   | Set tool version for current directory |

### tmux

Terminal multiplexer shortcuts:

| Abbr  | Command             | Description        |
| ----- | ------------------- | ------------------ |
| `tl`  | `tmux ls`           | List tmux sessions |
| `tlw` | `tmux list-windows` | List tmux windows  |

### tmuxinator

tmuxinator utilities:

| Abbr   | Command                             | Description                            |
| ------ | ----------------------------------- | -------------------------------------- |
| `mux`  | `tmuxinator`                        | Tmux session manager                   |
| `ms`   | `tmuxinator start`                  | Start tmuxinator session               |
| `msb1` | `tmuxinator start bfo1`             | TODO: Add project-specific description |
| `msb2` | `tmuxinator start bfo2`             | TODO: Add project-specific description |
| `msbc` | `tmuxinator start bfc`              | TODO: Add project-specific description |
| `msc`  | `tmuxinator start comix_distro`     | TODO: Add project-specific description |
| `msd`  | `tmuxinator start dot`              | Start dotfiles tmux session            |
| `mse`  | `tmuxinator start euroteamoutreach` | TODO: Add project-specific description |
| `msl`  | `tmuxinator start laptop`           | Start laptop setup session             |
| `msm`  | `tmuxinator start mux`              | Start mux session                      |
| `mso`  | `tmuxinator start ofreport`         | TODO: Add project-specific description |

### yarn

yarn utilities:

| Abbr           | Command                                   | Description                   |
| -------------- | ----------------------------------------- | ----------------------------- |
| `y`            | `yarn`                                    | Yarn package manager          |
| `ya`           | `yarn add`                                | Add package                   |
| `yad`          | `yarn add --dev`                          | Add dev dependency            |
| `yag`          | `yarn add --global`                       | Add global package            |
| `yap`          | `yarn add --peer`                         | Add peer dependency           |
| `yarn-upgrade` | `yarn upgrade-interactive --latest`       | Interactive upgrade to latest |
| `yb`           | `yarn build`                              | Build project                 |
| `ycc`          | `yarn cache clean`                        | Clean yarn cache              |
| `yd`           | `yarn dev`                                | Start development server      |
| `yga`          | `yarn global add`                         | Add global package            |
| `ygl`          | `yarn global list`                        | List global packages          |
| `ygr`          | `yarn global remove`                      | Remove global package         |
| `ygu`          | `yarn global upgrade`                     | Upgrade global packages       |
| `yh`           | `yarn help`                               | Show yarn help                |
| `yi`           | `yarn install`                            | Install dependencies          |
| `yic`          | `yarn install --check-files`              | Install with file check       |
| `yif`          | `yarn install --frozen-lockfile`          | Install from lockfile         |
| `yin`          | `yarn init`                               | Initialize yarn project       |
| `yln`          | `yarn link`                               | Link package                  |
| `yls`          | `yarn list`                               | List dependencies             |
| `yout`         | `yarn outdated`                           | Show outdated packages        |
| `yp`           | `yarn pack`                               | Create package archive        |
| `ypub`         | `yarn publish`                            | Publish package               |
| `yr`           | `yarn run`                                | Run script                    |
| `yre`          | `yarn remove`                             | Remove package                |
| `ys`           | `yarn serve`                              | Serve project                 |
| `yst`          | `yarn start`                              | Start project                 |
| `yt`           | `yarn test`                               | Run tests                     |
| `ytc`          | `yarn test --coverage`                    | Run tests with coverage       |
| `yuc`          | `yarn global upgrade && yarn cache clean` | Upgrade and clean cache       |
| `yui`          | `yarn upgrade-interactive`                | Interactive upgrade           |
| `yuil`         | `yarn upgrade-interactive --latest`       | Interactive upgrade to latest |
| `yup`          | `yarn upgrade`                            | Upgrade packages              |
| `yv`           | `yarn version`                            | Manage package version        |
| `yw`           | `yarn workspace`                          | Workspace command             |
| `yws`          | `yarn workspaces`                         | Manage workspaces             |

### postgresql

postgresql utilities:

| Abbr  | Command             | Description                                              |
| ----- | ------------------- | -------------------------------------------------------- |
| `psq` | `pgcli -d postgres` | Connect to PostgreSQL using pgcli with postgres database |

### middleman

middleman utilities:

| Abbr   | Command                               | Description                         |
| ------ | ------------------------------------- | ----------------------------------- |
| `mm`   | `bundle exec middleman`               | Run Middleman static site generator |
| `mmb`  | `bundle exec middleman build`         | Build Middleman site                |
| `mmbc` | `bundle exec middleman build --clean` | Clean build Middleman site          |
| `mmc`  | `bundle exec middleman console`       | Start Middleman console             |
| `mms`  | `bundle exec middleman server`        | Start Middleman development server  |

## Cross-Shell Compatibility

### Fish-Only Features

- Native abbreviation expansion
- Better completion integration

### Zsh-Only Features

- `src` abbreviation for reloading configuration
- Integration with Zap plugin manager

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
  gnew:
    command: "git checkout -b"
    description: "Create and checkout new branch"
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

_This file is automatically generated from `shared/abbreviations.yaml`. Do not edit directly._
_Last generated: Mon Aug 4 20:22:56 EEST 2025_
