# My Dotfiles

These are the dotfiles I use on my primary machine running Mac OS X, currently 10.10 Yosemite. While there are a few things that are specific to OS X, most of it should be pretty standard for any UNIX-based system.

In addition to the dotfiles themselves, I've also included general instructions (primarily for my own reference) regarding the setup of a new machine. Much of the initial software is installed via [thoughtbot's Laptop script](https://github.com/thoughtbot/laptop).

**For dotfile setup on a Ubuntu box, clone the [`linux`](https://github.com/joshukraine/dotfiles/tree/linux) branch of this repo:**

	git clone -b linux https://github.com/joshukraine/dotfiles.git ~/.dotfiles

### My System

* OS X (10.10)
* `zsh` ([`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh))
* [`rbenv`](https://github.com/sstephenson/rbenv)
* `vim`
* `tmux`

### Assumptions

The dotfiles assume that you have a couple of things installed, namely:

* `rbenv`
* `oh-my-zsh`
* various `vim` plugins installed with Vundle

If you don't want to use those, you'll need to remove or comment out the relevant lines in the various rc files. Otherwise, you'll get some errors.

### Notable Changes

This iteration of my dotfiles brings a few notable changes from last time.

* Powerline has been replaced by [vim-airline](https://github.com/bling/vim-airline). This avoids a lot of the headache of installing python.
* Due to changes in the `.vimrc`, `vim` no longer requires any `.tmp` or `swap` directories to be created.
* I've added a `.railsrc` file to help with common setup flags I like to use when generating new rails apps.
* All of the custom `zsh` code that was once stored in its own directory has now been moved in the `.zshrc` file. This keeps things a little less fragmented and in my opinion makes it easier to understand what's going on.
* Many of the latest changes have been influenced by the newly released book, [Pro Vim](http://www.amazon.com/Pro-Vim-Mark-McDonnell/dp/1484202511), which I also highly recommend!


### Initial Setup

1) Provision your machine with [thoughtbot's Laptop script](https://github.com/thoughtbot/laptop).

    # Download, review, execute
    curl --remote-name https://raw.githubusercontent.com/thoughtbot/laptop/master/mac
	less mac
	bash mac 2>&1 | tee ~/laptop.log


2) Install [`oh-my-zsh`](https://github.com/robbyrussell/oh-my-zsh).

    curl -L http://install.ohmyz.sh | sh

3) Close and reopen terminal to complete `oh-my-zsh` install.

### Install Dotfiles

1) Clone this repo.

    git clone https://github.com/joshukraine/dotfiles.git ~/.dotfiles

2) Symlink the rc files.

    ln -nfs ~/.dotfiles/gemrc ~/.gemrc
    ln -nfs ~/.dotfiles/gitignore ~/.gitignore_global
    ln -nfs ~/.dotfiles/gitconfig ~/.gitconfig
    ln -nfs ~/.dotfiles/tmux.conf ~/.tmux.conf
    ln -nfs ~/.dotfiles/railsrc ~/.railsrc
    ln -nfs ~/.dotfiles/vimrc ~/.vimrc
    ln -nfs ~/.dotfiles/zshrc ~/.zshrc
    source ~/.zshrc


### Install Vundle for `vim`

1) Set up the `~/.vim/bundle` directory needed by the [Vundle](https://github.com/gmarik/Vundle.vim) plugin manager.

    git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

2) Install `vim` plugins with [Vundle](https://github.com/gmarik/Vundle.vim).

    vim +PluginInstall +qall

### Extras

In case you're not me, you'll want to add your own name and email to `~/.dotfiles/gitconfig`.

	git config --global user.name "John Doe"
	git config --global user.email johndoe@example.com

I prefer Homebrew's `git`.

    brew install git

I use [`tmuxinator`](https://github.com/tmuxinator/tmuxinator) for quickly setting up `tmux` environments.

    gem install tmuxinator

I use the [solarized](https://github.com/altercation/solarized) color scheme (dark) for terminal and `vim`.

I use the [Inconsolata font](http://www.levien.com/type/myfonts/inconsolata.html), which you can get optimized for Powerline here: https://github.com/Lokaltog/powerline-fonts. This is also helpful for vim-airline, since it uses some of Powerlines custom symbols.


### Some of my favorite dotfile repos

* [Pro Vim](https://github.com/Integralist/ProVim)
* [Ryan Bates](https://github.com/ryanb/dotfiles)
* [thoughtbot](https://github.com/thoughtbot/dotfiles)
* [Ben Orenstein](https://github.com/r00k/dotfiles)
* [Joshua Clayton](https://github.com/joshuaclayton/dotfiles)
* [Drew Neil](https://github.com/nelstrom/dotfiles)
* [Chris Toomey](https://github.com/christoomey/dotfiles)
