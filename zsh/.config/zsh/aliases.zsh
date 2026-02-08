# General

# Always use Neovim as EDITOR
alias vim='nvim'

# History with timestamps
# Override default history command to show timestamps using fc (fix command)
# -l: list format, -i: ISO timestamp format
alias history='fc -li 1'

# ls > eza
# Other aliases handled by exa plugin (uses eza under the hood)
# https://github.com/zap-zsh/exa

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
