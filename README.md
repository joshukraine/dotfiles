# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

These are the dotfiles I use on my Macs, currently running [macOS High Sierra (10.13)][high-sierra]. They are geared primarily towards Ruby-based web development using Zsh (via [Oh-My-Zsh][oh-my-zsh]), Vim, and Tmux. Also included are my [iTerm2][iterm2] and [Terminal.app][terminal] profiles.

## Mac Bootstrap Script

This repo previously contained my entire provisioning solution for a new machine running a fresh install of macOS. I've now extracted the provisioning functionality into its own repository. Check it out:

&#9657; **Provision a new Mac with [Mac Bootstrap][mac-bootstrap].**

NOTE: Mac Bootstrap automatically clones and installs this dotfiles repo.

## Prerequisites

The dotfiles assume you are running macOS with the following software preinstalled:

* [Oh-My-Zsh][oh-my-zsh]
* [Homebrew][homebrew]
* [Vim][vim]
* [Git][git]
* [Tmux][tmux]
* [Ruby][ruby]
* [asdf][asdf]

All of the above and more are included in [Mac Bootstrap][mac-bootstrap]

## Installation

```sh
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
. ~/dotfiles/install.sh
```

## Post-install Tasks

After running `install.sh` there are still a couple of things that need to be done.

* Set up iTerm2 or Terminal.app profile (see details below).
* Add personal data to `~/.gitconfig.local` and `~/.zshrc.local`.
* Complete [Brew Bundle][brew-bundle] with `brew bundle install`

## Setting up iTerm2

Thanks to a [great blog post][blog-post] by Trevor Brown, I learned that you can quickly set up iTerm2 by exporting your profile. Here are the steps.

1. Open iTerm2.
1. Select iTerm2 > Preferences.
1. Under the General tab, check the box labeled "Load preferences from a custom folder or URL:"
1. Press "Browse" and point it to `~/dotfiles/iterm2/com.googlecode.iterm2.plist`.
1. Restart iTerm2.

## Setting up Terminal.app

These days I've switched over to using Terminal.app instead of iTerm2. In my mind, there is no question that iTerm2 has a far richer set of features and is overall easier to use and configure. That being said, it has gotten really slow. Slow enough, in fact, that it was affecting my work. For now, I'm using Terminal.app. There are a few rough edges, but the in-console experience is blazing fast and in the end, that's what matters most to me.

Getting set up after a fresh install is simple.

1. Open Terminal.app.
1. Select Terminal > Preferences. (But really you'll just press &#8984;, right? So much faster.)
1. Select the Profiles tab.
1. Click the gear icon and select Import...
1. Select `~/dotfiles/terminal/<desired-profile>.terminal` and click Open.
1. Click the Default button to keep using this profile in new Terminal windows.

## Some of my favorite dotfile repos

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

## Helpful web resources on dotfiles, et al.

* http://dotfiles.github.io/
* https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789
* http://code.tutsplus.com/tutorials/setting-up-a-mac-dev-machine-from-zero-to-hero-with-dotfiles--net-35449
* https://github.com/webpro/awesome-dotfiles
* http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
* http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/
* https://mattstauffer.co/blog/setting-up-a-new-os-x-development-machine-part-1-core-files-and-custom-shell

## License

Copyright &copy; 2017 Joshua Steele. [MIT License][license]

[screenshot]: https://s3.amazonaws.com/images.jsua.co/dotfiles-screenshot.png
[mac-bootstrap]: http://jsua.co/macos
[high-sierra]: https://www.apple.com/macos/high-sierra/
[iterm2]: https://www.iterm2.com/
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[homebrew]: http://brew.sh
[vim]: http://www.vim.org/
[git]: https://git-scm.com/
[tmux]: http://tmux.github.io/
[ruby]: https://www.ruby-lang.org/en
[asdf]: https://github.com/asdf-vm/asdf
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[blog-post]: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[terminal]: https://en.wikipedia.org/wiki/Terminal_(macOS)
