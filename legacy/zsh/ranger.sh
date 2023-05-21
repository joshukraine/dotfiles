# https://github.com/patrickdeyoreo/dotfiles/blob/master/profile.d/ranger.sh
# Prevent ranger from reading default rc.conf if user-defined rc.conf exists

if test -d "${XDG_CONFIG_HOME:-"${HOME-}/.config"}/ranger"; then
  RANGER_LOAD_DEFAULT_RC='FALSE'
else
  RANGER_LOAD_DEFAULT_RC='TRUE'
fi

export RANGER_LOAD_DEFAULT_RC
