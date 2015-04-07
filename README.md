# My Dotfiles

These are the dotfiles and general preferences I use on my primary machine running Mac OS X, currently 10.10 Yosemite. The `setup-mac.sh` script is very specific to OS X.

**Running Linux? Check out my [linux branch](https://github.com/joshukraine/dotfiles/tree/linux).**

### Prerequisites

Make sure your software is up to date:

	sudo softwareupdate -i -a

Install Apple's command line tools:

	xcode-select --install

Reboot, check for additional updates, then reinstall, reboot if needed.

	sudo softwareupdate -l
	sudo softwareupdate -i -a

### Installation

To install with a one-liner, run this:

```sh
curl --remote-name https://raw.githubusercontent.com/joshukraine/dotfiles/master/setup-mac.sh && sh setup-mac.sh 2>&1 | tee ~/setup.log
```

Want to read through the script first?
```sh
curl --remote-name https://raw.githubusercontent.com/joshukraine/dotfiles/master/setup-mac.sh
less setup-mac.sh
sh setup-mac.sh 2>&1 | tee ~/setup.log
```

WARNING: This script will ask for your admin password multiple times. You'll need to babysit it for a while. :)

### What does it do?

When you invoke `setup-mac.sh`, this is what it does in a nutshell:

* Check for command line tools to be installed. The script will exit if they aren't found.
* Install [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh).
* Run my fork of thoughtbot's [Laptop script](https://github.com/joshukraine/laptop). This is a provisioning script which installs lots of goodies like Homebrew, rbenv, postgres, etc.
* Set up some basic directories in `$HOME`.
* Symlink dotfiles to `$HOME`.
* Install several fixed-width fonts.
* Install Vundle and plugins for vim.
* Install various packages via [Homebrew](http://brew.sh/).
* Install OS X software via [Cask](http://caskroom.io/).
* Set a variety of OS X defaults.
* Customize the OS X dock.

### Post-install Tasks

After running `setup-mac.sh` there are still a few things that need to be done.

* Restart your machine in order for some changes to take effect.
* Install software from Mac App Store.
* Set up iTerm 2 profile (see details below).

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
* Lars Kappert (https://github.com/webpro/dotfiles)
* Ryan Bates (https://github.com/ryanb/dotfiles)
* thoughtbot (https://github.com/thoughtbot/dotfiles)
* Ben Orenstein (https://github.com/r00k/dotfiles)
* Joshua Clayton (https://github.com/joshuaclayton/dotfiles)
* Drew Neil (https://github.com/nelstrom/dotfiles)
* Chris Toomey (https://github.com/christoomey/dotfiles)
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
* http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles/
