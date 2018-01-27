
# What I've learned about slow performance in Vim

*January 27, 2018*

I started [this PR](https://github.com/joshukraine/dotfiles/pull/12) because Vim had gotten very slow and laggy. The problem seemed particularly painful when editing Ruby files. For example, when trying to move down by holding the "j" key, the downward motion would continue for a second or two after I'd released the key, causing me to far overshoot my target.

There were many other performance issues beyond scrolling. Sometimes even just simply typing in insert mode was noticeably slow. I knew things were getting serious when I found myself watching tutorial videos for Microsoft Visual Studio Code.

Happily, I've found a path back to a speedy and responsive Vim. Here's what I've learned.

### Plugins

Initially I thought that perhaps I had too many plugins installed, or that maybe one or more of them were causing me pain. I began by commenting out almost all of them, and then slowly adding them back in.

The only one that really seemed to make a difference was vim-rails by tpope. However, the improvement was only slight, and I suspected that the reason was connected to syntax highlighting. (I noticed that my Ruby and Rspec syntax had much nicer highlighting with vim-rails, and I thought perhaps the extra overhead was a contributor to my issue.)

In the end, I do not think any of my plugins were causing significant lag. I've now reenabled them all.

### Key Repeat Settings

At some point, I noticed that if I slowed down the key repeat speed in my macOS System Preferences, this seemed to help the scrolling lag. It appeared that Vim (or maybe the terminal?) just couldn't handle registering and displaying the key strokes fast enough.

While this did help to reduce overshooting as I described above, it did not resolve the overall slow performance I was experiencing in Vim.

### cursorline and cursorcolumn

When googling for Vim performance issues, a commonly suggested remedy is to disable the `cursorline` and `cursorcolumn` settings. The rationale is that these force Vim to redraw the screen during movement and so create lag.

I tried this, and I did see minor improvement. But as with my plugin experiments, it did not resolve the issue completely. Moreover, I like these settings and it seems a shame to turn them off.

In the end, these proved not to be the problem and I now have both of these settings on.

### relativenumber

Another commonly suggested remedy for improving vim scrolling speed is to turn off `relativenumber`. If I was hesitant to disable `cursorline` and `cursorcolumn`, I all but refuse to live without `relativenumber`. I don't want to have to do math in my head every time I need to jump to a new line. I want `relativenumber` to tell me how far to go, and then I jump there.

For testing purposes, I did try disabling it. It helped some, but the major problems remained.

In the end, `relativenumber` proved not to be the problem and it remains proudly enabled in my `.vimrc` file.

### foldmethod

Over a year ago I dealt with a Ruby/Vim performance issue and discovered that my `foldmethod` setting was the cause. I had turned on `foldmethod=syntax` for Ruby files, and this really slowed things down.

This is a commonly proposed fix for Vim performance issues, but in my case I had already addressed this. My current setting for all files is `foldmethod=marker`. This does not seem to have any negative impact on performance, and I like it because it allows me to better organize long config files, like my `.vimrc`.

### autocmd

One issue I came across that was new to me was that of [so-called "autocmd spam"](https://stackoverflow.com/a/19031285/655204). I confess this is something I still do not fully understand, but I gained enough from my research to know that autocmd's can compound on top of each other over time, causing slow-down's in performance.

The recommendation in [*Learn Vimscript the Hard Way*](http://learnvimscriptthehardway.stevelosh.com/chapters/14.html#exercises) is to always contain autocmd's in groups. This is something I've implemented in my `.vimrc`. While I think it is a good thing to do, it did not solve my primary performance issue.

### re=1, or The Stunning Conclusion

After trying everything mentioned above, I finally came across the solution that brought me back from the brink. Astoundingly, this one setting resolved my Vim/Ruby issues and increased speed *dramatically*. Ladies and gentlemen, I give you...

    set re=1

What is this, you ask? From the Vim documentation[^1]:

> Vim includes two regexp engines:
> 1. An old, backtracking engine that supports everything.
> 2. A new, NFA engine that works much faster on some patterns, possibly slower on some patterns.

In short, Vim's newer "NFA" engine performs much more slowly in Ruby files. Fortunately, Vim allows us to choose which engine to use. Again from Vim's documentation[^2]:

> The possible values are:
>   0	automatic selection
>   1	old engine
>   2	NFA engine

So by specifying `set re=1` we are forcing Vim to fall back to the older regex engine. At least for editing Ruby files, this makes a profound difference in performance. In particular, scrolling is very snappy. I can set my macOS key repeat settings all the way up, and Vim keeps up just fine!

### Reference

* https://andrewbrookins.com/tech/slow-scrolling-in-vim-and-macvim-on-os-x-increase-key-repeat-settings/
* http://eduncan911.com/software/fix-slow-scrolling-in-vim-and-neovim.html
* https://stackoverflow.com/questions/19030290/syntax-highlighting-causes-terrible-lag-in-vim
* https://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting/16920294#16920294
* http://learnvimscriptthehardway.stevelosh.com/chapters/12.html
* http://learnvimscriptthehardway.stevelosh.com/chapters/14.html
* https://vi.stackexchange.com/a/10496/15827
* https://github.com/vim/vim/issues/282

[^1]: `:h two-engines`
[^2]: `:h 'regexpengine'`
