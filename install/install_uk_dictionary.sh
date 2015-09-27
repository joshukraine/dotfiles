#!/bin/sh

################################################################################
# install_uk_dictionary.sh
#
# This script installs Ukrainian dictionary files which support system-wide
# spell checking for OS X.
#
# Reference:
# * http://apple.stackexchange.com/a/11842/75491
# * http://extensions.services.openoffice.org/en/project/ukrainian-dictionary
################################################################################

set -e # Terminate script if anything exits with a non-zero value
set -u # Prevent unset variables

DOTFILES_DIR=$HOME/dotfiles
DICTIONARY_DIR=$HOME/Library/Spelling

fancy_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\n$fmt\n" "$@"
}

cd $HOME

################################################################################
# Copy dictionary files
################################################################################

cp $DOTFILES_DIR/lib/{hyph_uk_UA.dic,uk_UA.aff,uk_UA.dic} $DICTIONARY_DIR
