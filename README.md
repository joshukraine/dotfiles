# My Dotfiles

These days everyone publishes their dotfiles. For this I am grateful since I've learned quite a bit by combing through the dotfiles of others. I've tried to gather the things that I find useful while at the same time keeping my own dotfiles as simple as possible.

These dotfiles are mainly intended for my personal use; I've made no attempt to ensure that they are compatible with other systems. Feel free to take what you like and customize it for your own use.

### My System

* OS X (10.9)
* rbenv
* Vim
* tmux
* zsh (oh my zsh)

### Make sure you have these first

* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [rbenv](https://github.com/sstephenson/rbenv)
* Ruby (via rbenv)
* [Homebrew](http://brew.sh/)
* Vim (via Homebrew)
* tmux (via Homebrew)

Or you can get all of the above and more by running [thoughtbot's laptop script](https://github.com/thoughtbot/laptop).

### Setup Instructions

Clone this repo.

    git clone https://github.com/joshukraine/dotfiles.git ~/.dotfiles

Symlink the rc files. (Yes, someday when I grow up I'll put this in a Rake task.)

    ln -nfs ~/.dotfiles/gemrc ~/.gemrc
    ln -nfs ~/.dotfiles/gitignore ~/.gitignore_global
    ln -nfs ~/.dotfiles/gitignore ~/.gitconfig gitconfig
    ln -nfs ~/.dotfiles/gvimrc ~/.gvimrc
    ln -nfs ~/.dotfiles/tmux.conf ~/.tmux.conf
    ln -nfs ~/.dotfiles/vim ~/.vim
    ln -nfs ~/.dotfiles/vimrc ~/.vimrc
    ln -nfs ~/.dotfiles/zshrc ~/.zshrc

Set up the `~/.vim/bundle` directory needed by the [Vundle](https://github.com/gmarik/Vundle.vim) plugin manager.

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

Restart your terminal or `source ~/.zshrc`

Launch `vim` and run `:PluginInstall`

### Notes
* I use Powerline which is a cool but rather fickle status bar for `vim`. You'll need to either [install Powerline](https://powerline.readthedocs.org/en/latest/overview.html#installation) (good luck!) or comment out the relevant lines in the `.vimrc`.
* I also use the [solarized](https://github.com/altercation/solarized) color scheme for terminal and vim.

### Some of my favorite dotfile repos

* [Ryan Bates](https://github.com/ryanb/dotfiles)
* [thoughtbot](https://github.com/thoughtbot/dotfiles)
* [Ben Orenstein](https://github.com/r00k/dotfiles)
* [Joshua Clayton](https://github.com/joshuaclayton/dotfiles)
* [Drew Neil](https://github.com/nelstrom/dotfiles)
* [Chris Toomey](https://github.com/christoomey/dotfiles)
