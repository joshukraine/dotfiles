# My Dotfiles

These days everyone publishes their dotfiles. For this I am grateful since I've learned quite a bit by combing through the dotfiles of others. I've tried to gather the things that I find useful while at the same time keeping my own dotfiles as simple as possible.

These dotfiles are mainly intended for my personal use; I've made no attempt to ensure that they are compatible with other systems. Granted, the following instructions are a bit more involved that just dotfiles. It's more like "How to set up your whole Mac from scratch". Feel free to take what you like and customize it for your own use.

### My System

* OS X (10.9)
* zsh (oh my zsh)
* rbenv
* Vim
* tmux

### Setup Instructions (OS X only)

Install [Homebrew](http://brew.sh/).

    ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"

Install [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh).

    curl -L http://install.ohmyz.sh | sh

Close and reopen terminal to complete `oh-my-zsh` install.

Clone this repo.

    git clone https://github.com/joshukraine/dotfiles.git ~/.dotfiles

Symlink the rc files. (Yes, someday when I grow up I'll put this in a Rake task.)

    ln -nfs ~/.dotfiles/gemrc ~/.gemrc
    ln -nfs ~/.dotfiles/gitignore ~/.gitignore_global
    ln -nfs ~/.dotfiles/gitconfig ~/.gitconfig
    ln -nfs ~/.dotfiles/gvimrc ~/.gvimrc
    ln -nfs ~/.dotfiles/tmux.conf ~/.tmux.conf
    ln -nfs ~/.dotfiles/vim ~/.vim
    ln -nfs ~/.dotfiles/vimrc ~/.vimrc
    ln -nfs ~/.dotfiles/zshrc ~/.zshrc
    source ~/.zshrc

If you plan to use [Powerline](https://powerline.readthedocs.org/en/latest/overview.html#installation), install `python` and THEN `vim`. Order is important. (For more detailed instructions on Powerline, see [How to install Powerline on OS X](https://gist.github.com/joshukraine/2c0078b9eba270382d58).)

    brew install python
    brew install vim --env-std --override-system-vim

Provision your machine with [thoughtbot's laptop script](https://github.com/thoughtbot/laptop). ([see requirements](https://github.com/thoughtbot/laptop#requirements))

    bash <(curl -s https://raw.githubusercontent.com/thoughtbot/laptop/master/mac) 2>&1 | tee ~/laptop.log
Set up the `~/.vim/bundle` directory needed by the [Vundle](https://github.com/gmarik/Vundle.vim) plugin manager.

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    
Set up a `~/.tmp` directory (needed by `vim`)

    mkdir ~/.tmp

Install and configure Powerline: [How to install Powerline on OS X](https://gist.github.com/joshukraine/2c0078b9eba270382d58)

Install `vim` plugins with [Vundle](https://github.com/gmarik/Vundle.vim).

    vim +PluginInstall +qall

### Extras

I prefer Homebrew's `git`.

    brew install git
    
I use [`tmuxinator`](https://github.com/tmuxinator/tmuxinator) for quickly setting up `tmux` environments.

    gem install tmuxinator
    
I use the [solarized](https://github.com/altercation/solarized) color scheme (dark) for terminal and `vim`.

I use the [Inconsolata font](http://www.levien.com/type/myfonts/inconsolata.html), which you can get optimized for Powerline here: https://github.com/Lokaltog/powerline-fonts

### Notes

* In case you're not me, you'll want to add your own name and email to `~/.dotfiles/gitconfig`.
* If you don't want to use Powerline, simply comment out the relevant lines in the vimrc file.

### Some of my favorite dotfile repos

* [Ryan Bates](https://github.com/ryanb/dotfiles)
* [thoughtbot](https://github.com/thoughtbot/dotfiles)
* [Ben Orenstein](https://github.com/r00k/dotfiles)
* [Joshua Clayton](https://github.com/joshuaclayton/dotfiles)
* [Drew Neil](https://github.com/nelstrom/dotfiles)
* [Chris Toomey](https://github.com/christoomey/dotfiles)
