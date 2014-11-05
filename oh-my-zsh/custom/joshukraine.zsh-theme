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
    # echo "%{$fg[white]%}[ruby-$(_current_ruby)]%{$reset_color%}"
    echo "ruby $(_current_ruby)"
  fi
}

local user='%{$fg[green]%}%n@%m%{$fg[white]%}:%{$reset_color%}'
local pwd='%{$fg[blue]%}%~%{$reset_color%}'
local git='%{$fg[white]%}$(git_prompt_info)%{$reset_color%}'

PROMPT="${user}${pwd} ${git} $ "
RPROMPT='$(_rprompt)'

ZSH_THEME_GIT_PROMPT_PREFIX="["
ZSH_THEME_GIT_PROMPT_SUFFIX="]"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}●%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}●%{$fg[white]%}"
