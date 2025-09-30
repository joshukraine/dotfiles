typeset -A ZSH_HIGHLIGHT_REGEXP
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main regexp)

# ZSH_HIGHLIGHT_STYLES[builtin]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[function]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[command]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[alias]='fg=#97FEA4'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#79A070'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#79A070'
# ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#F0776D'
# ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#F0776D'
# ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#FB649F'
# ZSH_HIGHLIGHT_STYLES[redirection]='fg=white'
# ZSH_HIGHLIGHT_STYLES[default]='fg=#7EBDB3'
# ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#F0776D'

# Only set regexp highlighting if abbreviation variables are available
if [[ -n "${ABBR_REGULAR_USER_ABBREVIATIONS:-}" ]]; then
    ZSH_HIGHLIGHT_REGEXP=('^[[:blank:][:space:]]*('${(j:|:)${(Qk)ABBR_REGULAR_USER_ABBREVIATIONS}}')$' fg=blue)
fi
if [[ -n "${ABBR_GLOBAL_USER_ABBREVIATIONS:-}" ]]; then
    ZSH_HIGHLIGHT_REGEXP+=('[[:<:]]('${(j:|:)${(Qk)ABBR_GLOBAL_USER_ABBREVIATIONS}}')$' fg=magenta)
fi
