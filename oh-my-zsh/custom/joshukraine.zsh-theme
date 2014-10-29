_current_ruby() {
  if [[ -n $rvm_path ]]; then
    $rvm_path/bin/rvm-prompt
  fi

  if [[ -n $(rbenv version) ]]; then
    rbenv version-name
  fi
}

_rprompt() {
  if [ $COLUMNS -gt 80 ]; then
    echo "%{$fg[white]%}[ruby-$(_current_ruby)]%{$reset_color%}"
  fi
}

local user='%{$fg[green]%}%n@%m%{$reset_color%}:'
local pwd='%~'
local git='%{$fg[blue]%}$(git_prompt_info)%{$reset_color%}'

PROMPT="${user}${pwd}${git} $ "
RPROMPT='$(_rprompt)'

ZSH_THEME_GIT_PROMPT_PREFIX="[git:"
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""
