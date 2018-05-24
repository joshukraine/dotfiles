# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

These are the dotfiles I use on my Macs, currently running [macOS High Sierra (10.13)][high-sierra]. They are geared primarily towards [Ruby][ruby]/[Rails][rails] and [Node.js][nodejs] web development using Zsh (via [Oh-My-Zsh][oh-my-zsh]), [Vim][vim]/[Neovim][neovim], and [Tmux][tmux]. Also included are my [iTerm2][iterm2] and [Terminal.app][terminal] profiles.

## Mac Bootstrap Script

This repo previously contained my entire provisioning solution for a new machine running a fresh install of macOS. I've now extracted the provisioning functionality into its own repository. Check it out:

&#9657; **Provision a new Mac with [Mac Bootstrap][mac-bootstrap].**

NOTE: Mac Bootstrap automatically clones and installs this dotfiles repo.

## Prerequisites

The dotfiles assume you are running macOS with the following software pre-installed:

* [Oh-My-Zsh][oh-my-zsh]
* [Homebrew][homebrew]
* [Vim][vim] and [Neovim][neovim]
* [Git][git]
* [Tmux][tmux]
* [Ruby][ruby]
* [Node.js][nodejs]
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
* Add personal data to `~/.gitconfig.local`, `~/.vimrc.local`, and `~/.zshrc.local`.
* Complete [Brew Bundle][brew-bundle] with `brew bundle install`
* After opening Neovim, run [`:checkhealth`][checkhealth] and resolve errors/warnings.

## Setting up iTerm2

Thanks to a [great blog post][blog-post] by Trevor Brown, I learned that you can quickly set up iTerm2 by exporting your profile. Here are the steps.

1. Open iTerm2.
1. Select iTerm2 > Preferences.
1. Under the General tab, check the box labeled "Load preferences from a custom folder or URL:"
1. Press "Browse" and point it to `~/dotfiles/iterm2/com.googlecode.iterm2.plist`.
1. Restart iTerm2.

## Setting up Terminal.app

Getting set up after a fresh install is simple.

1. Open Terminal.app.
1. Select Terminal > Preferences. (But really you'll just press &#8984;, right? So much faster.)
1. Select the Profiles tab.
1. Click the gear icon and select Import...
1. Select `~/dotfiles/terminal/<desired-profile>.terminal` and click Open.
1. Click the Default button to keep using this profile in new Terminal windows.

## A Note about Vim performance and Ruby files

I recently discovered a resolution to some significant performance issues I had been experiencing running Vim on macOS. These issues were particularly painful when editing Ruby files. I've documented what I learned here:

&#9657; [What I've learned about slow performance in Vim](vim-performance.md)

## Vim vs. Neovim

I'm currently trying out Neovim, and so far things are working nicely. For now I have things set up so I can run either Vim or Neovim interchangeably. This is accomplished by telling Neovim's config file (`~/.config/nvim/init.vim`) to source the standard Vim config file (`~/.vimrc`).

**More info:**

* https://neovim.io/doc/user/nvim.html#nvim-from-vim
* https://neovim.io/doc/user/vim_diff.html#vim-differences

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

Copyright &copy; 2018 Joshua Steele. [MIT License][license]

[asdf]: https://github.com/asdf-vm/asdf
[blog-post]: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[checkhealth]: https://neovim.io/doc/user/pi_health.html#:checkhealth
[git]: https://git-scm.com/
[high-sierra]: https://www.apple.com/macos/high-sierra/
[homebrew]: http://brew.sh
[iterm2]: https://www.iterm2.com/
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[mac-bootstrap]: http://jsua.co/macos
[neovim]: https://neovim.io/
[nodejs]: https://nodejs.org/
[oh-my-zsh]: https://github.com/robbyrussell/oh-my-zsh
[rails]: https://rubyonrails.org/
[ruby]: https://www.ruby-lang.org/en
[screenshot]: https://s3.amazonaws.com/images.jsua.co/dotfiles-05-24-2018.png
[terminal]: https://en.wikipedia.org/wiki/Terminal_(macOS)
[tmux]: https://github.com/tmux/tmux/wiki
[vim]: http://www.vim.org/
