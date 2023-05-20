# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

## 🤩 Highlights

- [Neovim][neovim] editor configured with [LunarVim][lunar-vim] IDE layer
- [Starship][starship] prompt
- Shell support for both [Zsh][zsh] and [Fish][fish] with 90% functional parity
- Flexible, terminal-based dev environment with [Tmux][tmux]
- Fast, idempotent setup with [GNU Stow][gnu-stow]
- New Mac bootstrap based on thoughtbot’s [Laptop][laptop]
- Support for both Apple Silicon and Intel Macs

## 🗂️ Table of Contents

- [Quick Setup](#%EF%B8%8F-quick-setup)
- [Prerequisites](#-prerequisites)
- [New Mac Bootstrap](#-new-mac-bootstrap)
- [Zsh or Fish?](#zsh-or-fish)
  - [Zsh Setup](#zsh-setup)
  - [Fish Setup](#fish-setup)
- [Setting up iTerm2](#setting-up-iterm2)
- [My Favorite Programming Fonts](#my-favorite-programming-fonts)
- [A Note about Vim performance and Ruby files](#a-note-about-vim-performance-and-ruby-files)
- [Identifying Sources of Slow Startup Times (Zsh)](#identifying-sources-of-slow-startup-times)
- [Some of my favorite dotfile repos](#some-of-my-favorite-dotfile-repos)
- [Helpful web resources on dotfiles, et al.](#helpful-web-resources-on-dotfiles-et-al)
- [License](#license)

## ⚡️ Quick Setup

Make sure macOS is up to date and you have installed the [required software](#prerequisites).

Clone this repo.

```sh
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
```

Read the setup script.

```sh
less ~/dotfiles/setup.sh
```

Run the setup script.

```sh
bash ~/dotfiles/setup.sh
```

## ✅ Prerequisites

The dotfiles assume you are running macOS with (at minimum) the following software pre-installed:

* [Git][git]
* [Homebrew][homebrew] (including [coreutils][coreutils])
* [asdf][asdf]
* [Ruby][ruby]
* [Node.js][nodejs]
* [Zsh][zsh] and/or [Fish][fish]
* [Neovim][neovim]
* [Tmux][tmux]
* [Starship][starship]

All of the above and more are included installed with my fork of [Laptop][joshuas-laptop].

## 🌟 New Mac Bootstrap

This is what I would do if I bought a new Mac computer today. The steps below assume you have already completed the basics like checking for software updates and logging in to iCloud.

### 💻 1. Run my fork of thoughtbot’s Laptop

It is worth noting that the Laptop script is idempotent and can be safely run multiple times to ensure a consistent baseline configuration.

&#9657; **[github.com/joshukraine/laptop][joshuas-laptop]**

I’ve made the following changes to my fork of Laptop:

- Remove Heroku-related code
- Customize Homebrew bundle
- Install asdf via git instead of Homebrew

### ⚠️ 2. Check for Stow conflicts

The dotfiles `setup.sh` script uses [GNU Stow][gnu-stow] to symlink all the config files to your `$HOME` directory. If you already have an identically-named file/directory in `$HOME` (e.g. `~/.zshrc` leftover from installing Laptop), this will cause a conflict, and Stow will (rightly) abort with an error.

The setup script will try to detect and backup these files ahead of Stow, but it’s still a good idea to check your `$HOME` directory as well as `$HOME/.config` and `$HOME/.local/bin`.

### 📍 3. Clone and setup the dotfiles

Clone

```sh
git clone https://github.com/joshukraine/dotfiles.git ~/dotfiles
```

Read
```sh
less ~/dotfiles/setup.sh
```

Setup

```sh
bash ~/dotfiles/setup.sh
```

If you do encounter Stow conflicts, resolve these and run setup again. The script is idempotent, so you can run it multiple times safely.

### 🌙 4. Install LunarVim

[LunarVim][lunar-vim] describes itself as *“An IDE layer for Neovim with sane defaults.”* I’ve used it for some time now and found it to be delightful. It’s pretty stable and has made configuring Neovim much simpler.

&#9657; **[lunarvim.org/docs/installation][install-lunar-vim]**

### ⚡️ 5. Install Zap

[Zap][zap] describes itself as a *“minimal zsh plugin manager that does what you expect.”*

&#9657; **[zapzsh.org][zap]**

After copying/pasting the install command for Zap, be sure to add the `--keep` flag to prevent Zap from replacing you existing `.zshrc` file.

### 🍺 6. Install remaining Homebrew packages

Review the included `Brewfile` and make desired adjustments.

```sh
less ~/Brewfile
```

Install the bundle.

```sh
brew bundle install
```

### 🛠️ 7. Complete post-install tasks

- [ ] Set up iTerm2 preferences. (see details below)
- [ ] Launch LunarVim (`lvim`) and run [`:checkhealth`][checkhealth]. Resolve errors and warnings.
- [ ] Set up [1Password CLI][1p-cli-start] for managing secrets.
- [ ] Set up [1Password SSH key management][1p-cli-ssh].
- [ ] Add personal data as needed to `*.local` files such as `~/.gitconfig.local`, `~/.laptop.local`, `~/dotfiles/local/config.fish.local`.
- [ ] If using Fish, customize your setup by running the `fish_config` command.

## Zsh or Fish?

Having used both Zsh and Fish for several years, I’ve decided to keep my configs for both. One thing I particularly love about Fish is the concept of [abbreviations over aliases](https://www.sean.sh/log/when-an-alias-should-actually-be-an-abbr/). Happily, there is now [zsh-abbr][zsh-abbr] which brings this functionality to Zsh.

&#9657; **[Fish abbr docs](https://fishshell.com/docs/current/cmds/abbr.html)**

My Zsh and Fish configs mostly have functional parity:

- Same prompt (Starship)
- Same essential abbreviations and functions

### Zsh Setup

Zsh is now the default shell on macOS. However, it’s helpful to add an entry enabling the Homebrew version of Zsh (`$HOMEBREW_PREFIX/bin/zsh`) instead of the default (`/bin/zsh`) version.

1. Install Zsh from Homebrew: `$ brew install zsh`
1. Add Zsh (Homebrew version) to `/etc/shells`: `$ echo $HOMEBREW_PREFIX/bin/zsh | sudo tee -a /etc/shells`
1. Set it as your default shell: `$ chsh -s $(which zsh)`
1. Install [Zap][zap]. (Required for functional parity with Fish)
1. Restart your computer.

### Fish Setup

1. Install Fish: `$ brew install fish`
1. Add Fish to `/etc/shells`: `$ echo $HOMEBREW_PREFIX/bin/fish | sudo tee -a /etc/shells`
1. Set it as your default shell: `$ chsh -s $(which fish)`
1. Restart your terminal emulator. This will create the `~/.config` and `~/.local` directories if they don’t already exist.

## Setting up iTerm2

Thanks to a [great blog post][blog-post] by Trevor Brown, I learned that you can quickly set up iTerm2 by exporting your profile. Here are the steps.

1. Open iTerm2.
1. Select iTerm2 > Settings. (&#8984;,)
1. Under the General tab, select “Preferences”.
1. Check the box labeled “Load preferences from a custom folder or URL:”
1. Press “Browse” and navigate to `~/dotfiles/iterm/com.googlecode.iterm2.plist`.
1. Press “Open”.
1. Restart iTerm2.

## My Favorite Programming Fonts

Over the years, I’ve branched out to explore a variety of mono-spaced fonts, both free and premium. Here is a list of my favorites.

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
- [Comic Code][comic-code]

### Ligatures

I first discovered ligatures through [Fira Code][fira-code], which IMO is probably the king of programming fonts. After using Fira Code, it’s hard to go back to a sans-ligature typeface. Therefore all† the fonts I’ve included in my fave’s list *do* include ligatures, although some have more than others.

† *Operator Mono does not include ligatures but [can be easily patched][operator-mono-lig] to add them.*

### Nerd Font Variants

I use [Devicons][devicons] in my editor, and these require patched fonts in order to display properly. For most free fonts, there are pre-patched [Nerd Font][nerd-fonts-downloads] variants that include the various glyphs and icons.

[Homebrew Cask Fonts][homebrew-cask-fonts] includes both original and Nerd Font variants. For example:

```sh
# Original font
$ brew install --cask font-fira-code

# Patched variant
$ brew install --cask font-fira-code-nerd-font
```

If using a font that does not have a patched variant (e.g. MonoLisa) iTerm2 has an option to use an alternate font for non-ASCII characters.

![iterm2-font-settings][iterm2-font-settings]

### Useful Font Links

- [Nerd Font Downloads][nerd-fonts-downloads]
- [Programming Fonts - Test Drive][programming-fonts]
- [Homebrew Cask Fonts][homebrew-cask-fonts]

## A Note about Vim performance and Ruby files

I recently discovered a resolution to some significant performance issues I had been experiencing running Vim on macOS. These issues were particularly painful when editing Ruby files. I’ve documented what I learned here:

&#9657; [What I’ve learned about slow performance in Vim](https://gist.github.com/joshukraine/3bfff4e9b553624b09789bc02cdd0ce6)

## Identifying Sources of Slow Startup Times (Zsh)

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

Copyright &copy; 2014–2023 Joshua Steele. [MIT License][license]

[1p-cli-ssh]: https://developer.1password.com/docs/ssh
[1p-cli-start]: https://developer.1password.com/docs/cli/get-started
[asdf]: https://asdf-vm.com/
[blog-post]: http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/
[brew-bundle]: https://github.com/Homebrew/homebrew-bundle
[cascadia-code]: https://github.com/microsoft/cascadia-code
[checkhealth]: https://neovim.io/doc/user/pi_health.html#:checkhealth
[comic-code]: https://tosche.net/fonts/comic-code
[coreutils]: https://formulae.brew.sh/formula/coreutils
[dank-mono]: https://philpl.gumroad.com/l/dank-mono
[devicons]: https://github.com/ryanoasis/vim-devicons
[fira-code]: https://github.com/tonsky/FiraCode
[fish]: http://fishshell.com/
[git]: https://git-scm.com/
[gnu-stow]: https://www.gnu.org/software/stow/
[gruvbox]: https://github.com/morhetz/gruvbox
[homebrew-cask-fonts]: https://github.com/Homebrew/homebrew-cask-fonts
[homebrew]: http://brew.sh
[install-lunar-vim]: https://www.lunarvim.org/docs/installation
[iosevka]: https://typeof.net/Iosevka/
[iterm2-colorschemes]: https://github.com/mbadolato/iTerm2-Color-Schemes
[iterm2-font-settings]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1587816605/screenshots/iterm2-font-settings_k7upta.png
[iterm2]: https://www.iterm2.com/
[jetbrains-mono]: https://www.jetbrains.com/lp/mono/
[joshuas-laptop]: https://github.com/joshukraine/laptop
[laptop]: https://github.com/thoughtbot/laptop
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[lunar-vim]: https://www.lunarvim.org/
[monolisa]: https://www.monolisa.dev/
[neovim]: https://neovim.io/
[nerd-fonts-downloads]: https://www.nerdfonts.com/font-downloads
[nodejs]: https://nodejs.org/
[operator-mono-lig]: https://github.com/kiliman/operator-mono-lig
[operator-mono]: https://www.typography.com/fonts/operator/styles/operatormonoscreensmart
[programming-fonts]: https://app.programmingfonts.org/
[rails]: https://rubyonrails.org/
[ruby]: https://www.ruby-lang.org/en
[screenshot]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1584547844/screenshots/dotfiles-mar-2020_a5p5do.png
[starship]: https://starship.rs/
[tmux]: https://github.com/tmux/tmux/wiki
[victor-mono]: https://rubjo.github.io/victor-mono/
[vue]: https://vuejs.org/
[zap]: https://www.zapzsh.org/
[zsh-abbr]: https://zsh-abbr.olets.dev/
[zsh]: https://zsh.sourceforge.io/
