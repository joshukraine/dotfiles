#!/bin/sh

################################################################################
# install
#
# This script symlinks dotfiles into place in the home and config directories
################################################################################

dotfiles_echo() {
  local fmt="$1"; shift

  # shellcheck disable=SC2059
  printf "\\n[DOTFILES] $fmt\\n" "$@"
}

set -e # Terminate script if anything exits with a non-zero value

DOTFILES_DIR=$HOME/dotfiles

home_files=(
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
)

config_dirs=(
"nvim"
"omf"
"ranger"
)

if [ -z "$XDG_CONFIG_HOME" ]; then
  if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
  fi
  CONFIG_DIR=$HOME/.config
else
  CONFIG_DIR=$XDG_CONFIG_HOME
fi

dotfiles_echo "Setting up your shell configs..."

if [ "$(basename "$SHELL")" = "fish" ]; then
  if [ -d "$CONFIG_DIR"/omf ]; then
  dotfiles_echo "Fish shell detected"
    cp -r "$CONFIG_DIR"/omf "$CONFIG_DIR"/omf_backup
    rm -rf "$CONFIG_DIR"/omf
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/omf to $CONFIG_DIR/omf..."
  ln -nfs "$DOTFILES_DIR"/omf "$CONFIG_DIR"/omf

elif [ "$(basename "$SHELL")" = "zsh" ]; then
  dotfiles_echo "Zsh detected"
  if [ -f "$HOME"/.zshrc ]; then
    dotfiles_echo ".zshrc already present. Backing up..."
    cp "$HOME"/.zshrc "$HOME"/.zshrc_backup
    rm -f "$HOME"/.zshrc
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/zshrc to $HOME/.zshrc..."
  ln -nfs "$DOTFILES_DIR"/zshrc "$HOME"/.zshrc

else
  dotfiles_echo "Sorry, it looks like your default shell is set to $SHELL,
  which is not supported. Please install Zsh or Fish and try again."
  exit 1
fi

dotfiles_echo "Installing dotfiles..."

for item in "${home_files[@]}"; do
  if [ -f "$HOME"/."$item" ]; then
    dotfiles_echo ".$item already present. Backing up..."
    cp "$HOME"/."$item" "$HOME"/."${item}"_backup
    rm -f "$HOME"/."$item"
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$item to $HOME/.$item..."
  ln -nfs "$DOTFILES_DIR"/"$item" "$HOME"/."$item"
done

if [ -f "$HOME"/Brewfile ]; then
  dotfiles_echo "Brewfile already present. Backing up..."
  cp "$HOME"/Brewfile "$HOME"/Brewfile_backup
  rm -f "$HOME"/Brewfile
fi
dotfiles_echo "-> Linking $DOTFILES_DIR/Brewfile to $HOME/Brewfile..."
ln -nfs "$DOTFILES_DIR"/Brewfile "$HOME"/Brewfile

for item in "${config_dirs[@]}"; do
  if [ -d "$CONFIG_DIR"/"$item" ]; then
    dotfiles_echo "$item already present. Backing up..."
    cp -r "$CONFIG_DIR"/"$item" "$CONFIG_DIR"/"${item}"_backup
    rm -rf "$CONFIG_DIR"/"$item"
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$item to $CONFIG_DIR/$item..."
  ln -nfs "$DOTFILES_DIR"/"$item" "$CONFIG_DIR"/"$item"
done

dotfiles_echo "-> Linking $DOTFILES_DIR/starship.toml to $CONFIG_DIR/starship.toml..."
ln -nfs "$DOTFILES_DIR"/starship.toml "$CONFIG_DIR"/starship.toml

dotfiles_echo "Dotfiles installation complete!"

dotfiles_echo "Post-install recommendations:"
dotfiles_echo "- Complete Brew Bundle installation with 'brew bundle install'"
dotfiles_echo "- The first time you launch Neovim, plugins will be installed automatically."
dotfiles_echo "- After launching Neovim, run :checkhealth and resolve any errors/warnings."
