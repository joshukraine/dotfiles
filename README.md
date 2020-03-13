# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

These are the dotfiles I use on my Mac computers, currently running [macOS Catalina (10.15)][catalina]. They are geared primarily towards web development with [Rails][rails], [React][react], and [Vue][vue]. I use a terminal-based development environment built on [Fish][fish], [Tmux][tmux], and [Neovim][neovim]. Also included are my [iTerm2][iterm2] and [Terminal.app][terminal] profiles.

## Mac Bootstrap Script

Need to provision a new Mac from scratch? My Mac Bootstrap script installs and configures the software, dotfiles, and general preferences I use for web development.

&#9657; **Provision a new Mac with [Mac Bootstrap][mac-bootstrap].**

NOTE: Mac Bootstrap automatically clones and installs this dotfiles repo.

## Prerequisites

The dotfiles assume you are running macOS with the following software pre-installed:

* [Git][git]
* [Homebrew][homebrew]
* [Ruby][ruby]
* [Node.js][nodejs]
* [Fish][fish] or [Zsh][zsh]
* [Oh My Fish][oh-my-fish] or [Oh-My-Zsh][oh-my-zsh]
* [Neovim][neovim]
* [Tmux][tmux]
* [asdf][asdf]
* [Starship][starship]

All of the above and more are included in [Mac Bootstrap][mac-bootstrap]

## Installation

The install script will try to detect your default shell using `$SHELL` and provide the appropriate setup. Supported options are Fish and Zsh.

1. Setup your shell. (See Fish/Zsh instructions below.)

1. Install the dotfiles.

```sh
$ git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
$ sh ~/dotfiles/install.sh
```

## Fish or Zsh?

I have used Zsh for years and really liked it. Recently I've switched to Fish, and am loving that too! I've kept both of my configs intact in my dotfiles. Running the install script will link configs for both Fish and Zsh shells. After completing the installation, switch to the shell you want to use.

### Zsh Setup

1. Install zsh: `$ brew install zsh`
1. Set it as your default shell: `$ chsh -s $(which zsh)`
1. Install [Oh My Zsh][oh-my-zsh].
1. Restart your computer.

### Fish Setup

1. Install Fish: `$ brew install fish`
1. Add Fish to `/etc/shells`: `$ echo /usr/local/bin/fish | sudo tee -a /etc/shells`
1. Set it as your default shell: `$ chsh -s /usr/local/bin/fish`
1. Install [Oh My Fish][oh-my-fish]

## Post-install Tasks

After running `install.sh` there are still a couple of things that need to be done.

* Set up iTerm2 or Terminal.app profile (see details below).
* Add personal data to `~/.gitconfig.local`, `~/.vimrc.local`, `~/.fish.local`, and `~/.zshrc.local` as needed.
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

UPDATE: After "trying" Neovim for nearly two years, I'm ready to make the switch permanent. Instead of linking to my `.vimrc` as described below, I've now moved all my configs over to `~/.config/nvim/init.vim`.

---

I'm currently trying out Neovim, and so far things are working nicely. For now I have things set up so I can run either Vim or Neovim interchangeably. This is accomplished by telling Neovim's config file (`~/.config/nvim/init.vim`) to source the standard Vim config file (`~/.vimrc`).

**More info:**

* https://neovim.io/doc/user/nvim.html#nvim-from-vim
* https://neovim.io/doc/user/vim_diff.html#vim-differences

## Identifying Sources of Slow Startup Times

The `.zshrc` script can be profiled by touching the file `~/.zshrc.profiler` and starting a new login shell. To see the top 20 lines that are taking the most time use the `zshrc_profiler_view`. `zshrc_profiler` parameters are number of lines to show (20) and path to profiler log file (`$TMPDIR/zshrc_profiler.${PID}log`).

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

Copyright &copy; 2020 Joshua Steele. [MIT License][license]

[asdf]: https://github.com/asdf-vm/asdf
[blog-post]: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[catalina]: https://www.apple.com/macos/catalina/
[checkhealth]: https://neovim.io/doc/user/pi_health.html#:checkhealth
[fish]: http://fishshell.com/
[git]: https://git-scm.com/
[homebrew]: http://brew.sh
[iterm2]: https://www.iterm2.com/
[javascript]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[mac-bootstrap]: http://jsua.co/macos
[neovim]: https://neovim.io/
[nodejs]: https://nodejs.org/
[oh-my-fish]: https://github.com/oh-my-fish/oh-my-fish
[oh-my-zsh]: https://github.com/ohmyzsh/ohmyzsh
[rails]: https://rubyonrails.org/
[react]: https://reactjs.org/
[ruby]: https://www.ruby-lang.org/en
[screenshot]: https://res.cloudinary.com/dnkvsijzu/image/upload/c_scale,f_auto,q_auto:best,w_1500/v1575408538/screenshots/dotfiles-dec-2019_bbfbfr.png
[starship]: https://starship.rs/
[terminal]: https://en.wikipedia.org/wiki/Terminal_(macOS)
[tmux]: https://github.com/tmux/tmux/wiki
[vim]: http://www.vim.org/
[vue]: https://vuejs.org/
[zsh]: https://www.zsh.org/
