#!/usr/bin/env bash

################################################################################
# install
#
# This script symlinks the dotfiles into place in the home directory.
################################################################################

dotfiles_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] $fmt\\n" "$@"
}

set -e # Terminate script if anything exits with a non-zero value

CONFIG_DIR=$XDG_CONFIG_HOME
DOTFILES_DIR=$HOME/dotfiles

files=(
"asdfrc"
"default-gems"
"default-npm-packages"
"gemrc"
"gitconfig"
"gitignore_global"
"gitmessage"
"gitsh_completions"
"hushlogin"
"npmrc"
"pryrc"
"rubocop.yml"
"svgo.yml"
"tmux.conf"
"tool-versions"
"zshrc"
)

dotfiles_echo "Installing dotfiles..."

for file in "${files[@]}"; do
  if [ -f "$HOME"/."$file" ]; then
    dotfiles_echo ".$file already present. Backing up..."
    cp "$HOME"/."$file" "$HOME"/."${file}"_backup
    rm -f "$HOME"/."$file"
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$file to $HOME/.$file..."
  ln -nfs "$DOTFILES_DIR"/"$file" "$HOME"/."$file"
done

dotfiles_echo "-> Linking $DOTFILES_DIR/Brewfile to $HOME/Brewfile..."
ln -nfs "$DOTFILES_DIR"/Brewfile "$HOME"/Brewfile

dotfiles_echo "Setting up Neovim..."

dotfiles_echo "-> Linking $DOTFILES_DIR/nvim to $CONFIG_DIR/nvim..."
ln -nfs "$DOTFILES_DIR"/nvim "$CONFIG_DIR"/nvim

dotfiles_echo "-> Linking $DOTFILES_DIR/ranger to $CONFIG_DIR/ranger..."
ln -nfs "$DOTFILES_DIR"/ranger "$CONFIG_DIR"/ranger

dotfiles_echo "Dotfiles installation complete!"

dotfiles_echo "Post-install recommendations:"
dotfiles_echo "- Complete Brew Bundle installation with 'brew bundle install'"
dotfiles_echo "- The first time you launch Neovim, plugins will be installed automatically."
dotfiles_echo "- After launching Neovim, run :checkhealth and resolve any errors/warnings."
