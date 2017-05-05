source $HOME/dotfiles/vim/settings.vim
source $HOME/dotfiles/vim/plugins.vim
source $HOME/dotfiles/vim/mappings.vim
source $HOME/dotfiles/vim/appearance.vim
source $HOME/dotfiles/vim/commands.vim

" Include local settings
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
