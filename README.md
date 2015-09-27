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
* Install [xkbswitch](https://github.com/joshukraine/xkbswitch-macosx) for displaying current language input source in tmux status bar.
* Install Ukrainian spell-check dictionaries.
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
* Add personal data to `~/.gitconfig.local` and `~/.zshrc.local`.
* Set up desired OS X keyboard shortcuts (see list below)


### Setting up iTerm 2

Thanks to a [great blog post](http://stratus3d.com/blog/2015/02/28/sync-iterm2-profile-with-dotfiles-repository/) by Trevor Brown, I learned that you can quickly set up iTerm 2 by exporting your profile. Here are the steps.

1. Open iTerm 2.
2. Select iTerm 2 > Preferences.
3. Under the General tab, check the box labeled "Load preferences from a custom folder or URL:"
4. Press "Browse" and point it to `~/dotfiles/iterm2/com.googlecode.iterm2.plist`.
5. Restart iTerm 2.


### OS X Keyboard Shortcuts

These are my (current) primary OS X keyboard shortcuts:

* Alfred: &#8984;Space
* Spotlight search: &#8984;&#8679;Space
* Switch input source: &#8963;&#8679;Space
* Fantastical: &#8997;&#8984;Space
* Things: &#8963;Space
* iTerm hotkey window: &#8997;Space


### How to personalize these dotfiles for your own use.

No one else's dotfiles will ever be a perfect match for you. That said, if your needs are close enough to mine, you might benefit from using the same shell scripts and overall structure, and just swapping out the particulars with your own. Here's my recommended approach to doing that:

1) Fork this repo and clone your new fork to your local machine.

2) Review [`setup-mac.sh`](https://github.com/joshukraine/dotfiles/blob/master/setup-mac.sh) and determine which sections you want to use.

* Section 1: Laptop is awesome, but [check what it does](https://github.com/joshukraine/laptop) before installing.
* Section 2: Use `oh-my-zsh`? Prefer to use bash instead?
* Section 3: The dotfiles. Update the `git clone...` URL to point to your fork.
* Section 4: Install Ukrainian dictionaries?
* Section 5: Install fixed-width fonts?
* Section 6: Use Vundle? If you prefer a different plugin manager, you can add the code for that in a file called `install/<my-plugin-manager>.sh` and then update the `source` path in this section.
* Section 7: Check the list of [Homebrew](http://brew.sh/) formulae in `install/brew.sh`. Add or remove packages to suite your needs.
* Section 8: Check the list of [Cask](http://caskroom.io/) apps in `install/brew-cask.sh`. Add or remove apps to suite your needs.
* Section 9: Review general OS X settings in `osx/defaults.sh` and adjust as needed. `osx/dock.sh` ensures that the dock contains only the apps you select. Adjust as desired. (NOTE: `dock.sh` depends on the `dockutil` package installed by Homebrew in `brew.sh`.)

3) Customize the dotfiles themselves with your own prefs. Add or remove dotfiles as desired. Since the files will later be symlinked into place, there is no need to add the leading dot to the filenames. (e.g. use `vimrc`, not `.vimrc`)

4) Update `symlink_dotfiles.sh` to match your dotfiles. Find the following line of code (around line 18)...

	files="gemrc gitignore_global gitconfig hushlogin tmux.conf vimrc zshrc"

...and make sure all your files (and *only* those files) are listed.

5) Create `~/.gitconfig.local` and `~/.zshrc.local` and add in your personal information. These files are sourced in `~/.gitconfig` and `~/.zshrc` respectively.

6) Update the README with your own info, instructions/reminders so you don't forget what you did, and especially the correct install URL:

	curl --remote-name https://raw.githubusercontent.com/<your-github-username>/dotfiles/master/setup-mac.sh && sh setup-mac.sh 2>&1 | tee ~/setup.log

7) Run the script on your machine and wait for the first error. :) Then fix, commit, push, and repeat.


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
