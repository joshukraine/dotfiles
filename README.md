# My Dotfiles for OS X

These are the dotfiles I use on my MacBook Pro running OS X El Capitan. They are geared primarily for Ruby on Rails development using zsh, vim, and tmux. Also included is my iTerm 2 profile.


### Mac Bootstrap Script

This repo previously contained my entire provisioning solution for a new machine running a fresh install of OS X. I've now extracted the provisioning functionality into its own repository. Check it out:

&#9657; **Provision a new Mac with [Mac Bootstrap](https://github.com/joshukraine/mac-bootstrap).**

NOTE: Mac Bootstrap automatically clones and installs this dotfiles repo.


### Prerequisites

The dotfiles assume you are running OS X (10.10 or higher) with the following software preinstalled:

* [Git](https://git-scm.com/)
* [Vim](http://www.vim.org/)
* [Tmux](http://tmux.github.io/)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [Ruby](https://www.ruby-lang.org/en/)
* [rbenv](https://github.com/sstephenson/rbenv)

All of the above and more are included in [Mac Bootstrap](https://github.com/joshukraine/mac-bootstrap).

### Installation

```sh
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
source ~/dotfiles/install.sh
```


### Post-install Tasks

After running `install.sh` there are still a couple of things that need to be done.

* Set up iTerm 2 profile (see details below).
* Add personal data to `~/.gitconfig.local` and `~/.zshrc.local`.


### Setting up iTerm 2

Thanks to a [great blog post](http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/) by Trevor Brown, I learned that you can quickly set up iTerm 2 by exporting your profile. Here are the steps.

1. Open iTerm 2.
2. Select iTerm 2 > Preferences.
3. Under the General tab, check the box labeled "Load preferences from a custom folder or URL:"
4. Press "Browse" and point it to `~/dotfiles/iterm2/com.googlecode.iterm2.plist`.
5. Restart iTerm 2.


### Some of my favorite dotfile repos

* Pro Vim (https://github.com/Integralist/ProVim)
* Trevor Brown (https://github.com/Stratus3D/dotfiles)
* Chris Toomey (https://github.com/christoomey/dotfiles)
* thoughtbot (https://github.com/thoughtbot/dotfiles)
* Lars Kappert (https://github.com/webpro/dotfiles)
* Ryan Bates (https://github.com/ryanb/dotfiles)
* Ben Orenstein (https://github.com/r00k/dotfiles)
* Joshua Clayton (https://github.com/joshuaclayton/dotfiles)
* Drew Neil (https://github.com/nelstrom/dotfiles)
* Kevin Suttle (https://github.com/kevinSuttle/OSXDefaults)
* Carlos Becker (https://github.com/caarlos0/dotfiles)
* Zach Holman (https://github.com/holman/dotfiles/)
* Mathias Bynens (https://github.com/mathiasbynens/dotfiles/)
* Paul Irish (https://github.com/paulirish/dotfiles)


### Helpful web resources on dotfiles, et al.

* http://dotfiles.github.io/
* https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
* http://code.tutsplus.com/tutorials/setting-up-a-mac-dev-machine-from-zero-to-hero-with-dotfiles--net-35449
* https://github.com/webpro/awesome-dotfiles
* http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
* http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/
* https://mattstauffer.co/blog/setting-up-a-new-os-x-development-machine-part-1-core-files-and-custom-shell
