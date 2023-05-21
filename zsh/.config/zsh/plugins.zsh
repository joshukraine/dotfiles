# https://github.com/zap-zsh/zap | https://www.zapzsh.org

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/exa"

# https://starship.rs
eval "$(starship init zsh)"

# https://asdf-vm.com
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

# https://developer.1password.com/docs/cli
. $XDG_CONFIG_HOME/op/plugins.sh

# https://zsh-abbr.olets.dev
. $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
