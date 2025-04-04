# https://github.com/zap-zsh/zap | https://www.zapzsh.com

[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh" ] && source "${XDG_DATA_HOME:-$HOME/.local/share}/zap/zap.zsh"

plug "zsh-users/zsh-autosuggestions"
plug "zap-zsh/supercharge"
plug "zsh-users/zsh-syntax-highlighting"
plug "zap-zsh/exa"
# plug "romkatv/powerlevel10k"
plug "zsh-users/zsh-history-substring-search"

# https://starship.rs
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(starship init zsh)"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# https://asdf-vm.com
. $HOME/.asdf/asdf.sh
fpath=(${ASDF_DIR}/completions $fpath)

# OP_PLUGINS="$XDG_CONFIG_HOME/op"
#
# if [ -d "$OP_PLUGINS" ]; then
#   # https://developer.1password.com/docs/cli
#   . $XDG_CONFIG_HOME/op/plugins.sh
# else
#   echo "Directory does not exist: $OP_PLUGINS. Please reference https://developer.1password.com/docs/cli for installation instructions."
# fi

# https://zsh-abbr.olets.dev
. $HOMEBREW_PREFIX/share/zsh-abbr/zsh-abbr.zsh

# https://github.com/junegunn/fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# https://github.com/ajeetdsouza/zoxide
eval "$(zoxide init zsh)"

# https://github.com/zsh-users/zsh-history-substring-search
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
HISTORY_SUBSTRING_SEARCH_FUZZY=1

unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND
unset HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# https://gist.github.com/elijahmanor/b279553c0132bfad7eae23e34ceb593b

alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-chad="NVIM_APPNAME=NvChad nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "kickstart" "LazyVim" "NvChad" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}
