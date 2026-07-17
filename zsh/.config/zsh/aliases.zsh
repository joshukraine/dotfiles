# General

# Always use Neovim as EDITOR
alias vim='nvim'

# History with timestamps
# Override default history command to show timestamps using fc (fix command)
# -l: list format, -i: ISO timestamp format
alias history='fc -li 1'

# ls > eza
# Other aliases (ll, la, tree) handled by the exa plugin (uses eza under the hood).
# https://github.com/zap-zsh/exa
# Override the plugin's `ls`: upstream uses a bare `--icons`, whose optional value
# swallows a following path (`ls /tmp` -> error). Bare already defaults to auto, so
# pinning `=auto` is behaviour-identical. Sourced after plugins.zsh, and zsh resolves
# aliases at use time, so this fixes ll/la/tree too.
alias ls='eza --group-directories-first --icons=auto'

# Middleman
alias mma='bundle exec middleman article'


# Mac App Store (https://github.com/argon/mas)
alias masi='mas install'
alias masl='mas list'
alias maso='mas outdated'
alias mass='mas search'
alias masu='mas upgrade'

# Finder
# You can also toggle hidden files from the Finder GUI with Cmd + Shift + .
alias o='open . &'

# Neovim
# https://github.com/richin13/asdf-neovim
alias update-nvim-stable='asdf uninstall neovim stable && asdf install neovim stable'
alias update-nvim-nightly='asdf uninstall neovim nightly && asdf install neovim nightly'
# alias update-nvim-master='asdf uninstall neovim ref:master && asdf install neovim ref:master'

# https://github.com/nickjj/docker-rails-example/blob/main/run
alias run='./run'
