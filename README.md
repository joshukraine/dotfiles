# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

## 🚧 Under Construction!

I am currently in the process of revamping significant portions of my dotfiles.

### What's Staying the Same

Most of the core features of my dotfiles will not change. For example, I am still using:

- macOS
- Neovim
- Tmux
- Ruby/Node development focus

### What I Plan to Change

- Use [LunarVim](https://www.lunarvim.org/) as my Neovim config
- Switch back to Zsh; drop support for Fish
- Decouple my dotfiles from my Mac Bootstrap script
- Implement GNU Stow (or similar) for managing symlinks

```
$ git clone -b zsh-plus-stow https://github.com/joshukraine/dotfiles.git
$ bash ~/dotfiles/install.sh
```

---

These are the dotfiles I use on my Mac computers, currently running [macOS Catalina (10.15)][catalina]. They are geared primarily towards web development with [Rails][rails], [React][react], and [Vue][vue]. I use a terminal-based development environment built on [Fish][fish], [Tmux][tmux], and [Neovim][neovim]. Also included are my [iTerm2][iterm2] and [Alacritty][alacritty] profiles.

## Table of Contents

- [Mac Bootstrap Script](#mac-bootstrap-script)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Fish or Zsh?](#fish-or-zsh)
  - [Zsh Setup](#zsh-setup)
  - [Fish Setup](#fish-setup)
- [Post-install Tasks](#post-install-tasks)
- [Setting up iTerm2](#setting-up-iterm2)
- [Setting up Alacritty](#setting-up-alacritty)
- [Machine-specific Configs](#machine-specific-configs)
- [Colorschemes](#colorschemes)
  - [1. Colorschemes](#1-colorschemes)
  - [2. Machine-specific Config](#2-machine-specific-config)
  - [3. Terminal Colorschemes](#3-terminal-colorschemes)
  - [4. Tmux Custom Overrides](#4-tmux-custom-overrides)
  - [Useful Colorscheme Links](#useful-colorscheme-links)
- [My Favorite Programming Fonts](#my-favorite-programming-fonts)
  - [Free Fonts](#free-fonts)
  - [Premium Fonts](#premium-fonts)
  - [Ligatures](#ligatures)
  - [Nerd Font Variants](#nerd-font-variants)
  - [Useful Font Links](#useful-font-links)
- [A Note about Vim performance and Ruby files](#a-note-about-vim-performance-and-ruby-files)
- [Vim vs. Neovim](#vim-vs-neovim)
- [Identifying Sources of Slow Startup Times](#identifying-sources-of-slow-startup-times)
- [Some of my favorite dotfile repos](#some-of-my-favorite-dotfile-repos)
- [Helpful web resources on dotfiles, et al.](#helpful-web-resources-on-dotfiles-et-al)
- [License](#license)

## Mac Bootstrap Script

Need to provision a new Mac from scratch? My Mac Bootstrap script installs and configures the software, dotfiles, and general preferences I use for web development.

&#9657; **Provision a new Mac with [Mac Bootstrap][mac-bootstrap].**

NOTE: Mac Bootstrap automatically clones and installs this dotfiles repo.

## Prerequisites

The dotfiles assume you are running macOS with the following software pre-installed:

* [Git][git]
* [Homebrew][homebrew] (including [coreutils][coreutils])
* [Ruby][ruby]
* [Node.js][nodejs]
* [Fish][fish] or [Zsh][zsh]
* [Oh-My-Zsh][oh-my-zsh] (if using zsh)
* [Neovim][neovim]
* [Tmux][tmux]
* [asdf][asdf]
* [Starship][starship]

All of the above and more are included in [Mac Bootstrap][mac-bootstrap]

## Installation

The install script will create the needed directories and symlinks for your setup, adding config files for both Zsh and Fish.

1. Setup your shell. (See Fish/Zsh instructions below.)

1. Run the installation script.

```sh
$ git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
$ bash ~/dotfiles/install.sh
```

## Fish or Zsh?

I have used Zsh for years and really liked it. Recently I've switched to Fish, and am loving that too! I've kept both of my configs intact in my dotfiles. Running the install script will link configs for both Fish and Zsh shells.

### Zsh Setup

1. Install zsh: `$ brew install zsh`
1. Set it as your default shell: `$ chsh -s $(which zsh)`
1. Install [Oh My Zsh][oh-my-zsh].
1. Restart your computer.

### Fish Setup

1. Install Fish: `$ brew install fish`
1. Add Fish to `/etc/shells`: `$ echo /usr/local/bin/fish | sudo tee -a /etc/shells`
1. Set it as your default shell: `$ chsh -s /usr/local/bin/fish`
1. Restart your terminal emulator. This will create the `~/.config` and `~/.local` directories if they don’t already exist.

## Post-install Tasks

After running `install.sh` there are still a couple of things that need to be done.

* Add machine-specific configs as needed. (see Machine-specific Configs below)
* Set up iTerm2 or Alacritty profile (see details below).
* Complete [Brew Bundle][brew-bundle] with `brew bundle install`
* Add personal data to `~/.gitconfig.local`, `~/.vimrc.local`, `~/dotfiles/local/config.fish.local`, and `~/.zshrc.local` as needed.
* After opening Neovim, run [`:checkhealth`][checkhealth] and resolve errors/warnings.
* If using Fish, customize your setup by running the `fish_config` command.

## Setting up iTerm2

Thanks to a [great blog post][blog-post] by Trevor Brown, I learned that you can quickly set up iTerm2 by exporting your profile. Here are the steps.

1. Open iTerm2.
1. Select iTerm2 > Preferences.
1. Under the General tab, check the box labeled "Load preferences from a custom folder or URL:"
1. Press "Browse" and point it to `~/dotfiles/machines/<hostname>/com.googlecode.iterm2.plist`.
1. Restart iTerm2.

## Setting up Alacritty

Getting set up after a fresh install is simple.

1. Tweak preferences in `~/dotfiles/machines/<hostname>/alacritty.yml`.
1. Uncomment Alacritty terminfo lines in  `~/dotfiles/machines/<hostname>/tmux.conf.custom`
1. Run Alacritty!

## Machine-specific Configs

I regularly use two Mac computers: a desktop and laptop. Most of my configs are identical between the two, but there are some some differences. I also occasionally install my dotfiles on other machines (family computer, wife's computer, your computer if I can get to it... 😈)

For this reason, I've introduced a `machines/` folder where I keep configs that are specific to a given computer. Machine-specific configs should be stored in sub-folders of `machines/` and named for the `hostname` of that machine. The overall structure looks like this:

```
machines/
├── joshuas-imac
│   ├── Brewfile -> ../../Brewfile
│   ├── Brewfile.lock.json
│   ├── alacritty.yml
│   ├── colors.fish
│   ├── colorscheme.vim
│   ├── com.googlecode.iterm2.plist
│   ├── starship.toml
│   └── tmux.conf.custom
└── joshuas-mbp15
    ├── Brewfile -> ../../Brewfile
    ├── Brewfile.lock.json
    ├── alacritty.yml
    ├── colors.fish
    ├── colorscheme.vim
    ├── com.googlecode.iterm2.plist
    ├── starship.toml
    └── tmux.conf.custom
```

My current [Homebrew Bundle][brew-bundle] approach depends heavily on the above setup. I have a Fish function (`bb`) which runs a machine-specific `Brewfile` based on the `hostname` of the current computer. (See `fish/functions/bb.fish`)

## Colorschemes

My all-time favorite colorscheme for code-editing is [Solarized Dark][solarized]. That said, there are times when I like to dabble with something new, just to have some variety. In the past it's been painful to switch colorschemes for vim since I also needed to find a suitable profile for iTerm2, make tweaks to tmux.conf, etc. Sometimes the colorschemes were 24-bit only (think `set termguicolors`) and others were more simple (256-color), like the original version of Solarized.

I've now introduced an approach for switching between colorschemes which I hope will be more straightforward. It's still not a one-step operation, but all the colorschemes and their individual settings can be stored simultaneously, and switching between them takes minimal effort.

![One Half Dark Screenshot][one-half-dark-screenshot]

*Example of a React app with the One Half Dark colorscheme*

At the time of this writing, I've incorporated 11 colorschemes, all of which require true color support.

1. [Gruvbox][gruvbox]
1. [Material][material]
1. [Night Owl][night-owl]
1. [Nightfly][nightfly]
1. [Nord Vim][nord]
1. [Oceanic Next][oceanic-next]
1. [One Half Dark][one-half-dark]
1. [Solarized Dark][neo-solarized]
1. [Tender][tender]
1. [Vim One][vim-one]
1. [vim-monokai-tasty][vim-monokai-tasty]

Here's how everything is organized:

#### 1. Colorschemes

The settings for individual colorschemes are stored in separate files. To add a new colorscheme, add a file for it here.

```
nvim/
└── colorschemes
    ├── gruvbox.vim
    ├── material.vim
    ├── night-owl.vim
    ├── nightfly.vim
    ├── nord.vim
    ├── oceanic-next.vim
    ├── onehalfdark.vim
    ├── solarized.vim
    ├── tender.vim
    ├── vim-monokai-tasty.vim
    └── vim-one.vim
```

#### 2. Machine-specific Config

Every machine I manage has a `colorscheme.vim` file in its directory. That file defines in one line which colorscheme should be used. For example:

```
" machines/joshuas-imac/colorscheme.vim

exe 'source' stdpath('config') . '/colorschemes/gruvbox.vim'
```

This theme is then loaded in `nvim/init.vim` with the following line (see the Appearance section):

```
" nvim/init.vim

exe 'source' "$DOTFILES/machines/$HOST_NAME/colorscheme.vim"
```

#### 3. Terminal Colorschemes

Since I use vim in the terminal, I need corresponding iTerm2 or Alacritty colorschemes for every vim colorscheme. My iTerm2 colorschemes are stored in `itermcolors/`, but of course must be added manually to the iTerm profile. Alacritty colorschemes are defined in `~/dotfiles/machines/<hostname>/alacritty.yml`.

Multiple pre-made colorschemes are available online for both iTerm2 and Alacritty:

* [iTerm2 colorschemes][iterm2-colorschemes]
* [Alacritty colorschemes][alacritty-colorschemes]

#### 4. Tmux Custom Overrides

The last tweak is for Tmux. I like to set custom hex color codes for the status bar depending on which colorscheme I'm using. Each machine profile now has its own `tmux.conf.custom` file. In particular, it can be nice to adjust the background of the status bar to better match the current colorscheme.

The main `tmux.conf` file contains all the settings that Tmux needs. However, any setting that is re-declared in `machines/$HOST_NAME/tmux.conf.custom` will override the defaults.

```
# machines/joshuas-imac/tmux.conf.custom

# Gruvbox {{{
setw -g window-status-style fg=$BLACK,bg=$BRIGHT_BLUE
setw -g window-status-current-style fg="#fbf1c7",bg=$BRIGHT_RED
set -g pane-border-style bg=default,fg="#665c54"
set -g status-left "#[fg=$BRIGHT_GREEN][#S] #[fg=$RED]w#I #[fg=$BLUE]p#P"
set -g status-style bg="#3c3836"
# }}}

# Material {{{
# set -g status-style bg="#2c3b41"
# }}}

[...]
```

### Useful Colorscheme Links

- http://vimcolors.com/
- https://www.slant.co/topics/480/~best-vim-color-schemes

## My Favorite Programming Fonts

I've recently branched out to explore some of the different mono-spaced fonts available, both free and premium. Here is a list of my favorites.

### Free Fonts

*Included in my `Brewfile` and installed by default via [Homebrew Cask Fonts][homebrew-cask-fonts]*

- [Fira Code][fira-code]
- [Cascadia Code][cascadia-code]
- [Victor Mono][victor-mono]
- [JetBrains Mono][jetbrains-mono]
- [Iosveka][iosevka]

### Premium Fonts

*You have to give people money if you want these.* 🤑

- [Operator Mono][operator-mono]
- [MonoLisa][monolisa]
- [Dank Mono][dank-mono]

### Ligatures

I first discovered ligatures through [Fira Code][fira-code], which IMO is probably the king of programming fonts. After using Fira Code, it's hard to go back to a sans-ligature typeface. Therefore †all the fonts I've included in my fave's list *do* include ligatures, although some have more than others.

† *Operator Mono does not include ligatures but [can be easily patched][operator-mono-lig] to add them.*

### Nerd Font Variants

I use [Devicons][devicons] in my editor, and these require patched fonts in order to display properly. For most free fonts, there are pre-patched [Nerd Font][nerd-fonts-downloads] variants that include the various glyphs and icons.

[Homebrew Cask Fonts][homebrew-cask-fonts] includes both original and Nerd Font variants. For example:

```sh
# Original font
$ brew cask install font-fira-code

# Patched variant
$ brew cask install font-firacode-nerd-font
```

If using a font that does not have a patched variant (e.g. MonoLisa) iTerm2 has an option to use an alternate font for non-ASCII characters.

![iterm2-font-settings][iterm2-font-settings]

### Useful Font Links

- [Nerd Font Downloads][nerd-fonts-downloads]
- [Programming Fonts - Test Drive][programming-fonts]
- [Homebrew Cask Fonts][homebrew-cask-fonts]

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

Copyright &copy; 2014–2020 Joshua Steele. [MIT License][license]

[alacritty-colorschemes]: https://github.com/alacritty/alacritty/wiki/Color-schemes
[alacritty]: https://github.com/alacritty/alacritty
[asdf]: https://github.com/asdf-vm/asdf
[blog-post]: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[cascadia-code]: https://github.com/microsoft/cascadia-code
[catalina]: https://www.apple.com/macos/catalina/
[checkhealth]: https://neovim.io/doc/user/pi_health.html#:checkhealth
[coreutils]: https://formulae.brew.sh/formula/coreutils
[dank-mono]: https://dank.sh/
[devicons]: https://github.com/ryanoasis/vim-devicons
[fira-code]: https://github.com/tonsky/FiraCode
[fish]: http://fishshell.com/
[git]: https://git-scm.com/
[gruvbox]: https://github.com/morhetz/gruvbox
[homebrew-cask-fonts]: https://github.com/Homebrew/homebrew-cask-fonts
[homebrew]: http://brew.sh
[iosevka]: https://typeof.net/Iosevka/
[iterm2-colorschemes]: https://github.com/mbadolato/iTerm2-Color-Schemes
[iterm2-font-settings]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1587816605/screenshots/iterm2-font-settings_k7upta.png
[iterm2]: https://www.iterm2.com/
[javascript]: https://developer.mozilla.org/en-US/docs/Web/JavaScript
[jetbrains-mono]: https://www.jetbrains.com/lp/mono/
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[mac-bootstrap]: http://jsua.co/macos
[material]: https://github.com/kaicataldo/material.vim
[monolisa]: https://www.monolisa.dev/
[neo-solarized]: https://github.com/icymind/NeoSolarized
[neovim]: https://neovim.io/
[nerd-fonts-downloads]: https://www.nerdfonts.com/font-downloads
[night-owl]: https://github.com/haishanh/night-owl.vim
[nightfly]: https://github.com/bluz71/vim-nightfly-guicolors
[nodejs]: https://nodejs.org/
[nord]: https://github.com/arcticicestudio/nord-vim
[oceanic-next]: https://github.com/mhartington/oceanic-next
[oh-my-zsh]: https://github.com/ohmyzsh/ohmyzsh
[one-half-dark-screenshot]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1587822657/screenshots/one-half-dark-sample_rn5fds.png
[one-half-dark]: https://github.com/sonph/onehalf
[operator-mono-lig]: https://github.com/kiliman/operator-mono-lig
[operator-mono]: https://www.typography.com/fonts/operator/styles/operatormonoscreensmart
[programming-fonts]: https://app.programmingfonts.org/
[rails]: https://rubyonrails.org/
[react]: https://reactjs.org/
[ruby]: https://www.ruby-lang.org/en
[screenshot]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1584547844/screenshots/dotfiles-mar-2020_a5p5do.png
[solarized]: https://github.com/altercation/solarized
[starship]: https://starship.rs/
[tender]: https://github.com/jacoborus/tender.vim
[tmux]: https://github.com/tmux/tmux/wiki
[victor-mono]: https://rubjo.github.io/victor-mono/
[vim-monokai-tasty]: https://github.com/joshukraine/vim-monokai-tasty
[vim-one]: https://github.com/rakr/vim-one
[vim]: http://www.vim.org/
[vue]: https://vuejs.org/
[zsh]: https://www.zsh.org/
