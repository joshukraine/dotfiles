#!/usr/bin/env bash

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

dotfiles_backup() {
  if ! command -v gcp >/dev/null || ! command -v gdate >/dev/null; then
    dotfiles_echo "GNU cp and date commands are required. Please install via Homebrew coreutils: brew install coreutils"
    exit 1
  elif [ -d "$1" ]; then
    mv -v "$1" "${1}_bak_$(gdate +"%Y%m%d%3N")"
  else
    gcp -f --backup=numbered "$1" "$1"
  fi
}

set -e # Terminate script if anything exits with a non-zero value

FISH_DIR="${HOME}/.config/fish"
DOTFILES_DIR=$HOME/dotfiles

if [ -z "$XDG_CONFIG_HOME" ]; then
  if [ ! -d "$HOME/.config" ]; then
    mkdir "$HOME/.config"
  fi
  CONFIG_DIR=$HOME/.config
else
  CONFIG_DIR=$XDG_CONFIG_HOME
fi

if [ ! -d "${HOME}/.config/fish" ]; then
  mkdir "${HOME}/.config/fish"
fi

fish_files=(
"config.fish"
"abbreviations.fish"
)

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
"zshrc"
)

config_dirs=(
"nvim"
"ranger"
)

dotfiles_echo "Installing dotfiles..."

for item in "${home_files[@]}"; do
  if [ -e "$HOME"/."$item" ]; then
    dotfiles_echo ".${item} exists."
    if [ -L "$HOME"/."$item" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "$HOME"/."$item"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${HOME}/.${item}"
    fi
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$item to $HOME/.$item..."
  ln -nfs "$DOTFILES_DIR"/"$item" "$HOME"/."$item"
done

if [ -e "$HOME"/Brewfile ]; then
  dotfiles_echo "Brewfile exists."
  if [ -L "$HOME"/Brewfile ]; then
    dotfiles_echo "Symbolic link detected. Removing..."
    rm -v "$HOME"/Brewfile
  else
    dotfiles_echo "Backing up..."
    dotfiles_backup "${HOME}/Brewfile"
  fi
fi
dotfiles_echo "-> Linking $DOTFILES_DIR/Brewfile to $HOME/Brewfile..."
ln -nfs "$DOTFILES_DIR"/Brewfile "$HOME"/Brewfile

for item in "${config_dirs[@]}"; do
  if [ -d "$CONFIG_DIR"/"$item" ]; then
    dotfiles_echo "Directory ${item} exists."
    if [ -L "$CONFIG_DIR"/"$item" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "$CONFIG_DIR"/"$item"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${CONFIG_DIR}/${item}"
    fi
  fi
  dotfiles_echo "-> Linking $DOTFILES_DIR/$item to $CONFIG_DIR/$item..."
  ln -nfs "$DOTFILES_DIR"/"$item" "$CONFIG_DIR"/"$item"
done

for item in "${fish_files[@]}"; do
  if [ -e "${FISH_DIR}/${item}" ]; then
    dotfiles_echo "${item} exists."
    if [ -L "${FISH_DIR}/${item}" ]; then
      dotfiles_echo "Symbolic link detected. Removing..."
      rm -v "${FISH_DIR}/${item}"
    else
      dotfiles_echo "Backing up..."
      dotfiles_backup "${FISH_DIR}/${item}"
    fi
  fi
  dotfiles_echo "-> Linking ${DOTFILES_DIR}/fish/${item} to ${FISH_DIR}/${item}..."
  ln -nfs "${DOTFILES_DIR}/fish/${item}" "${FISH_DIR}/${item}"
done

if [ -d "${FISH_DIR}"/functions ]; then
  dotfiles_echo "Directory ${item} exists."
  if [ -L "${FISH_DIR}"/functions ]; then
    dotfiles_echo "Symbolic link detected. Removing..."
    rm -v "${FISH_DIR}"/functions
  else
    dotfiles_echo "Backing up..."
    dotfiles_backup "${FISH_DIR}/${item}"
  fi
fi
dotfiles_echo "-> Linking ${DOTFILES_DIR}/fish/functions to ${FISH_DIR}/functions..."
ln -nfs "${DOTFILES_DIR}/fish/functions" "${FISH_DIR}/functions"

if [ -e "$CONFIG_DIR"/starship.toml ]; then
  dotfiles_echo "starship.toml exists."
  if [ -L "$CONFIG_DIR"/starship.toml ]; then
    dotfiles_echo "Symbolic link detected. Removing..."
    rm -v "$CONFIG_DIR"/starship.toml
  else
    dotfiles_echo "Backing up..."
    dotfiles_backup "${CONFIG_DIR}/starship.toml"
  fi
fi
dotfiles_echo "-> Linking $DOTFILES_DIR/starship.toml to $CONFIG_DIR/starship.toml..."
ln -nfs "$DOTFILES_DIR"/starship.toml "$CONFIG_DIR"/starship.toml

dotfiles_echo "-> Installing vim-plug plugins..."
nvim --headless +PlugInstall +qall

dotfiles_echo "-> Installing custom terminfo entries..."
tic -x "$DOTFILES_DIR"/terminfo/tmux-256color.terminfo
tic -x "$DOTFILES_DIR"/terminfo/xterm-256color-italic.terminfo

dotfiles_echo "Dotfiles installation complete!"

dotfiles_echo "Post-install recommendations:"
dotfiles_echo "- Complete Brew Bundle installation with 'brew bundle install'"
dotfiles_echo "- After launching Neovim, run :checkhealth and resolve any errors/warnings."
