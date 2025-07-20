# My Dotfiles for macOS

![dotfiles screenshot][screenshot]

## 🤩 Highlights

- [Neovim][neovim] editor configured with [LazyVim][lazyvim]💤
- [Starship][starship] prompt (or [Powerlevel10K][p10k])
- Shell support for both [Zsh][zsh] and [Fish][fish] with 95% functional parity via shared configuration
- Flexible, terminal-based dev environment with [ghostty][ghostty] 👻 + [Tmux][tmux]!
- Fast, idempotent setup with [GNU Stow][gnu-stow]
- New Mac bootstrap based on thoughtbot’s [Laptop][laptop]
- Support for both Apple Silicon and Intel Macs

## 🗂️ Table of Contents

- [Quick Setup](#%EF%B8%8F-quick-setup)
- [Prerequisites](#-prerequisites)
- [New Mac Bootstrap](#-new-mac-bootstrap)
- [Zsh or Fish?](#zsh-or-fish)
- [About Neovim Distributions](#about-neovim-distributions)
- [My Favorite Programming Fonts](#my-favorite-programming-fonts)
- [Nerd Fonts and Icons](#nerd-fonts-and-icons)
- [A Note about Vim performance and Ruby files](#a-note-about-vim-performance-and-ruby-files)
- [Identifying Sources of Slow Startup Times (Zsh)](#identifying-sources-of-slow-startup-times-zsh)
- [Awesome Neovim Dotfiles, Distros, and Starters](#awesome-neovim-dotfiles-distros-and-starters)
- [Some of my favorite dotfile repos](#some-of-my-favorite-dotfile-repos)
- [Helpful web resources on dotfiles, et al.](#helpful-web-resources-on-dotfiles-et-al)
- [License](#license)

## ⚡️ Quick Setup

Make sure macOS is up to date and you have installed the [required software](#-prerequisites).

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

- [Git][git]
- [Homebrew][homebrew] (including [coreutils][coreutils])
- [asdf][asdf]
- [Ruby][ruby]
- [Node.js][nodejs]
- [Zsh][zsh] and/or [Fish][fish]
- [Neovim][neovim]
- [Starship][starship]
- `yq` (for regenerating abbreviations from shared YAML source)

All of the above and more are installed with my fork of [Laptop][joshuas-laptop].

## 🌟 New Mac Bootstrap

This is what I would do if I bought a new Mac computer today. The steps below assume you have already completed the basics:

- Log in to iCloud
- Check for software updates
- [Install Xcode Command Line Tools][install-clt]

### 💻 1. Run my fork of thoughtbot’s Laptop

&#9657; **[github.com/joshukraine/laptop][joshuas-laptop]**

Download the `mac` script:

```sh
curl --remote-name https://raw.githubusercontent.com/joshukraine/laptop/main/mac
```

Download `.local.laptop` for additional customizations:

```sh
curl --remote-name https://raw.githubusercontent.com/joshukraine/dotfiles/master/laptop/.laptop.local
```

Review both scripts before proceeding:

```sh
less mac
```

```sh
less .laptop.local
```

Execute the `mac` script:

```sh
sh mac 2>&1 | tee ~/laptop.log
```

I’ve made the following changes to my fork of Laptop:

- Install asdf via git instead of Homebrew
- Comment out Heroku-related code
- Comment out unused Homebrew taps and formulae

It is worth noting that the Laptop script (`mac`) is idempotent and can be safely run multiple times to ensure a consistent baseline configuration.

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

### ⚡️ 4. Install Zap

[Zap][zap] describes itself as a _“minimal zsh plugin manager that does what you expect.”_

&#9657; **[zapzsh.com][zap]**

> [!IMPORTANT]
> After copying/pasting the install command for Zap, be sure to add the `--keep` flag to prevent Zap from replacing you existing `.zshrc` file.

### 🍺 5. Install remaining Homebrew packages

Review the included `Brewfile` and make desired adjustments.

```sh
less ~/Brewfile
```

Install the bundle.

```sh
brew bundle install
```

### 🛠️ 6. Complete post-install tasks

- [ ] Launch LazyVim (`nvim`) and run [`:checkhealth`][checkhealth]. Resolve errors and warnings. Plugins should install automatically on first launch.
- [ ] Add personal data as needed to `*.local` files such as `~/.gitconfig.local`, `~/.laptop.local`, `~/dotfiles/local/config.fish.local`.
- [ ] Set up [1Password CLI][1p-cli-start] for managing secrets.
- [ ] Set up [1Password SSH key management][1p-cli-ssh].
- [ ] If using Fish, customize your setup by running the `fish_config` command.
- [ ] If using Zsh, edit `.zshrc` and `plugins.zsh` to select either [Starship][starship] or [Powerlevel10K][p10k] as your prompt.
- [ ] If using Tmux, install Tmux plugins with `<prefix> + I` (<https://github.com/tmux-plugins/tpm>)

## Zsh or Fish?

Having used both Zsh and Fish for several years, I’ve decided to keep my configs for both. One thing I particularly love about Fish is the concept of [abbreviations over aliases](https://www.sean.sh/log/when-an-alias-should-actually-be-an-abbr/). Happily, there is now [zsh-abbr][zsh-abbr] which brings this functionality to Zsh.

&#9657; **[Fish abbr docs](https://fishshell.com/docs/current/cmds/abbr.html)**

My Zsh and Fish configs have 95% functional parity via shared configuration:

- Same prompt (Starship)
- Identical abbreviations (196+) generated from single YAML source
- Shared environment variables
- Smart git functions with automatic branch detection

<details>
  <summary><strong>Zsh Setup Instructions</strong></summary>
Zsh is now the default shell on macOS. However, it’s helpful to add an entry enabling the Homebrew version of Zsh (`$HOMEBREW_PREFIX/bin/zsh`) instead of the default (`/bin/zsh`) version.

Ensure that you have Zsh from Homebrew. (`which zsh`) If not:

```sh
brew install zsh
```

Add Zsh (Homebrew version) to `/etc/shells`:

```sh
echo $HOMEBREW_PREFIX/bin/zsh | sudo tee -a /etc/shells
```

Set it as your default shell:

```sh
chsh -s $(which zsh)
```

Install [Zap][zap]. (Required for functional parity with Fish)

Restart your terminal.

</details>

<details>
  <summary><strong>Fish Setup Instructions</strong></summary>
Install Fish from Homebrew:

```sh
 brew install fish
```

Add Fish to `/etc/shells`:

```sh
echo $HOMEBREW_PREFIX/bin/fish | sudo tee -a /etc/shells
```

Set it as your default shell:

```sh
chsh -s $(which fish)
```

Restart your terminal. This will create the `~/.config` and `~/.local` directories if they don’t already exist.

</details>

## About Neovim Distributions

**TL;DR:** Just install [LazyVim][lazyvim]💤

📺 [Zero to IDE with LazyVim][zero-to-ide-lazyvim-video]

Back in the day if you wanted to use Vim (and later Neovim) you had to code a ton of configuration on your own. With Vim we got Vimscript 🤢, but then came Neovim which brought us Lua 🤩. I went from ye olde crunchy `.vimrc` to the more adventurous `init.vim` to the blessed path of `init.lua`. 😇

Meanwhile, there were the VS Code boys across the fence, bragging about their fancy icons, shiny tabs, and the oh-so-cool LSP. I confess, I even tried VS Code for a bit. That didn't last long. 😬

But Neovim has caught up. And wow have they. caught. up. Not only do we have native LSP support in Neovim (have had for a while now — v0.5), but we are solidly in the era of pre-baked Neovim distributions that are really challenging the notion of Vim/Neovim as austere, command-line editors. (I will say that I think we owe a lot to VS Code for raising the bar here. But I'm still glad I'm with Neovim. 😉)

If you want a quick primer on Neovim distros, **check out the YouTube video below**. I started with [LunarVim][lunar-vim] (my first entry into distro-land) and now I'm with [LazyVim][lazyvim] and the [Folke gang][folke]. Bottom line: you can still config [Neovim from scratch][neovim-from-scratch] if you want to, but you can get a HUGE head-start by just grabbing a distro and tweaking it to your needs.

📺 [I tried Neovim Distributions so you don't have to][i-tried-neovim-distros-video]

Boy, when I reminisce about the days of writing PHP for Internet Explorer in BBEdit...

## My Favorite Programming Fonts

Over the years, I’ve branched out to explore a variety of mono-spaced fonts, both free and premium. Here is a list of my favorites.

### Free Fonts

_Included in my `Brewfile` and installed by default via [Homebrew Cask Fonts][homebrew-cask-fonts]_

- [Cascadia Code][cascadia-code]
- [Fira Code][fira-code]
- [Hack][hack]
- [JetBrains Mono][jetbrains-mono]
- [Monaspace Argon][monaspace]
- [Monaspace Neon][monaspace]
- [Symbols Nerd Font Mono][symbols-nerd-font-mono] (for icons only)

### Premium Fonts

_You have to give people money if you want these._ 🤑

- [Operator Mono][operator-mono]
- [MonoLisa][monolisa]
- [Comic Code][comic-code]

### Ligatures

I first discovered ligatures through [Fira Code][fira-code], which IMHO is probably the king of programming fonts. After using Fira Code, it’s hard to go back to a sans-ligature typeface. Therefore all the fonts I’ve included in my fave’s list _do_ include ligatures, although some have more than others.

> [!NOTE]
> Operator Mono does not include ligatures but [can be easily patched][operator-mono-lig] to add them.

## Nerd Fonts and Icons

Back in the day, I started using the [VimDevicons][devicons] plugin so I could have fancy file-type icons in Vim. (Remember NERDTree?) In order for this to work, one had to install patched “Nerd-font” versions of whatever programming font one wanted to use. For example:

```sh
# Original font
$ brew install --cask font-fira-code

# Patched variant
$ brew install --cask font-fira-code-nerd-font
```

Patching fonts with icons still works fine of course, and is, I think, pretty widely used. However, during my exploration of kitty, I discovered that [there is a different (better?) approach](https://sw.kovidgoyal.net/kitty/faq/#kitty-is-not-able-to-use-my-favorite-font) to icon fonts. It turns out, you don't need a patched version of your chosen mono-spaced font. You can get most if not all the icons you need and use them alongside _any_ font by just installing the `Symbols Nerd Font Mono` font.

Leveraging this approach depends on your terminal. In iTerm2, for example, you need to check “Use a different font for non-ASCII text” in the Preferences panel. Then select `Symbols Nerd Font Mono` font under “Non-ASCII font”. (see screenshot below)

![iterm2-font-settings][iterm2-font-settings]

kitty does things a little differently. If you install a patched font, it will mostly work. Mostly. But the “kitty way” can be broken down in three steps:

1. Install a normal, un-patched mono-spaced font, such as `Cascadia Code`
1. Install a dedicated icon font, such as `Symbols Nerd Font Mono`
1. Create a set of Unicode symbol maps[^2] to tell kitty which font to use for which icons (symbols)

More work up front, maybe, but less guesswork in the long-term once you understand what's going on. And if you're using my dotfiles, you have it easy. **All the fonts you need are installed in `Brewfile`, and I have a set of Unicode symbol maps ready to go.** 😎

> [!NOTE]
> To learn more about Nerd fonts in terminals, as well as Unicode symbol maps and all the rest, be sure to check out [Effective Nerd Fonts in Multiple Terminals](https://youtu.be/mQdB_kHyZn8?si=1mY6_oXEE8hr8lAp&t=289) by [Elijah Manor](https://www.youtube.com/@ElijahManor)

### 🧪 Nerd Font Smoke Test

If you want to check whether icons and ligatures are working properly, try running the included `nerd-font-smoke-test.sh` script from the root of the `dotfiles` folder like so:

```sh
bash nerd-font-smoke-test.sh
```

If your terminal is configured correctly, the output of the test should look like this:

![smoke-test-output][smoke-test-output]

Again, thank you, Elijah Manor!

### Useful Font Links

- [Nerd Fonts][nerd-fonts]
- [Nerd Font Cheat Sheet][nerd-font-cheat-sheet]
- [Programming Fonts - Test Drive][programming-fonts]
- [Homebrew Cask Fonts][homebrew-cask-fonts]

## A Note about Vim performance and Ruby files

Once upon a time, I almost left Vim due to some crippling performance issues. These issues were particularly painful when editing Ruby files. I documented what I learned here:

&#9657; [What I’ve learned about slow performance in Vim](https://gist.github.com/joshukraine/3bfff4e9b553624b09789bc02cdd0ce6)

## Identifying Sources of Slow Startup Times (Zsh)

The `.zshrc` script can be profiled by touching the file `~/.zshrc.profiler` and starting a new login shell. To see the top 20 lines that are taking the most time use the `zshrc_profiler_view`. `zshrc_profiler` parameters are number of lines to show (20) and path to profiler log file (`$TMPDIR/zshrc_profiler.${PID}log`).

## Awesome Neovim Dotfiles, Distros, and Starters

- <https://github.com/LazyVim/lazyvim>
- <https://github.com/LunarVim/LunarVim>
- <https://github.com/NvChad/NvChad>
- <https://github.com/LunarVim/Launch.nvim>
- <https://github.com/folke/dot>
- <https://github.com/nvim-lua/kickstart.nvim>
- <https://github.com/ThePrimeagen/init.lua>
- <https://github.com/elijahmanor/dotfiles>
- <https://github.com/cpow/cpow-dotfiles>
- <https://github.com/josean-dev/dev-environment-files>
- <https://github.com/glepnir/nvim>
- <https://github.com/numToStr/dotfiles>
- <https://github.com/jdhao/nvim-config>
- <https://github.com/brainfucksec/neovim-lua>
- <https://github.com/disrupted/dotfiles>
- <https://github.com/topics/neovim-dotfiles>
- <https://github.com/topics/neovim-config>

## Some of my favorite dotfile repos

- Pro Vim (<https://github.com/Integralist/ProVim>)
- Trevor Brown (<https://github.com/Stratus3D/dotfiles>)
- Chris Toomey (<https://github.com/christoomey/dotfiles>)
- thoughtbot (<https://github.com/thoughtbot/dotfiles>)
- Lars Kappert (<https://github.com/webpro/dotfiles>)
- Ryan Bates (<https://github.com/ryanb/dotfiles>)
- Ben Orenstein (<https://github.com/r00k/dotfiles>)
- Joshua Clayton (<https://github.com/joshuaclayton/dotfiles>)
- Drew Neil (<https://github.com/nelstrom/dotfiles>)
- Kevin Suttle (<https://github.com/kevinSuttle/OSXDefaults>)
- Carlos Becker (<https://github.com/caarlos0/dotfiles>)
- Zach Holman (<https://github.com/holman/dotfiles/>)
- Mathias Bynens (<https://github.com/mathiasbynens/dotfiles/>)
- Paul Irish (<https://github.com/paulirish/dotfiles>)

## Helpful web resources on dotfiles, et al

- <http://dotfiles.github.io/>
- <https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789>
- <http://code.tutsplus.com/tutorials/setting-up-a-mac-dev-machine-from-zero-to-hero-with-dotfiles--net-35449>
- <https://github.com/webpro/awesome-dotfiles>
- <http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/>
- <http://carlosbecker.com/posts/first-steps-with-mac-os-x-as-a-developer/>
- <https://mattstauffer.co/blog/setting-up-a-new-os-x-development-machine-part-1-core-files-and-custom-shell>

## License

Copyright &copy; 2014–2025 Joshua Steele. [MIT License][license]


[^2]: <https://sw.kovidgoyal.net/kitty/conf/#opt-kitty.symbol_map>

[1p-cli-ssh]: https://developer.1password.com/docs/ssh
[1p-cli-start]: https://developer.1password.com/docs/cli/get-started
[asdf]: https://asdf-vm.com/
[cascadia-code]: https://github.com/microsoft/cascadia-code
[checkhealth]: https://neovim.io/doc/user/pi_health.html#:checkhealth
[comic-code]: https://tosche.net/fonts/comic-code
[coreutils]: https://formulae.brew.sh/formula/coreutils
[devicons]: https://github.com/ryanoasis/vim-devicons
[fira-code]: https://github.com/tonsky/FiraCode
[fish]: http://fishshell.com/
[folke]: https://github.com/folke
[ghostty]: https://ghostty.org/
[git]: https://git-scm.com/
[gnu-stow]: https://www.gnu.org/software/stow/
[hack]: https://sourcefoundry.org/hack
[homebrew-cask-fonts]: https://github.com/Homebrew/homebrew-cask-fonts
[homebrew]: http://brew.sh
[i-tried-neovim-distros-video]: https://youtu.be/bbHtl0Pxzj8
[install-clt]: https://www.freecodecamp.org/news/install-xcode-command-line-tools/
[iterm2-font-settings]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1700122897/screenshots/iterm2-config_xqevqo.png
[jetbrains-mono]: https://www.jetbrains.com/lp/mono/
[joshuas-laptop]: https://github.com/joshukraine/laptop
[laptop]: https://github.com/thoughtbot/laptop
[lazyvim]: https://www.lazyvim.org/
[license]: https://github.com/joshukraine/dotfiles/blob/master/LICENSE
[lunar-vim]: https://www.lunarvim.org/
[monaspace]: https://monaspace.githubnext.com
[monolisa]: https://www.monolisa.dev/
[neovim-from-scratch]: https://youtu.be/J9yqSdvAKXY
[neovim]: https://neovim.io/
[nerd-font-cheat-sheet]: https://www.nerdfonts.com/cheat-sheet
[nerd-fonts]: https://www.nerdfonts.com/
[nodejs]: https://nodejs.org/
[operator-mono-lig]: https://github.com/kiliman/operator-mono-lig
[operator-mono]: https://www.typography.com/fonts/operator/styles/operatormonoscreensmart
[p10k]: https://github.com/romkatv/powerlevel10k
[programming-fonts]: https://app.programmingfonts.org/
[ruby]: https://www.ruby-lang.org/en
[screenshot]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1700154289/screenshots/dotfiles-nov-2023_gx2wrw.png
[smoke-test-output]: https://res.cloudinary.com/dnkvsijzu/image/upload/v1700085278/screenshots/smoke-test_tddntp.png
[starship]: https://starship.rs/
[symbols-nerd-font-mono]: https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/NerdFontsSymbolsOnly.zip
[tmux]: https://github.com/tmux/tmux/wiki
[zap]: https://www.zapzsh.com/
[zero-to-ide-lazyvim-video]: https://youtu.be/N93cTbtLCIM
[zsh-abbr]: https://zsh-abbr.olets.dev/
[zsh]: https://zsh.sourceforge.io/
