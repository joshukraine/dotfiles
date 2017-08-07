filetype off " required by Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle itself
Plugin 'VundleVim/Vundle.vim'             " Vundle, the plug-in manager for Vim                   | https://github.com/VundleVim/Vundle.vim.git

" General Vim
Plugin 'godlygeek/tabular'                " Vim script for text filtering and alignment           | https://github.com/godlygeek/tabular
Plugin 'ervandew/supertab'                " Use <Tab> for all your insert completion needs        | https://github.com/ervandew/supertab
Plugin 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin          | https://github.com/tomtom/tcomment_vim
Plugin 'vim-scripts/BufOnly.vim'          " Delete all the buffers except current/named buffer    | https://github.com/vim-scripts/BufOnly.vim
Plugin 'jlanzarotta/bufexplorer'          " Open/close/navigate vim's buffers                     | https://github.com/jlanzarotta/bufexplorer

" Ruby-specific
Plugin 'vim-ruby/vim-ruby'                " Vim/Ruby Configuration Files                          | https://github.com/vim-ruby/vim-ruby
Plugin 'kana/vim-textobj-user'            " Create your own text objects                          | https://github.com/kana/vim-textobj-user
Plugin 'nelstrom/vim-textobj-rubyblock'   " A custom text object for selecting ruby blocks        | https://github.com/nelstrom/vim-textobj-rubyblock
Plugin 'vim-syntastic/syntastic'          " Syntax checking hacks for vim                         | https://github.com/vim-syntastic/syntastic

" Searching and Navigation
Plugin 'scrooloose/nerdtree'              " A tree explorer plugin for vim                        | https://github.com/scrooloose/nerdtree
Plugin 'skwp/greplace.vim'                " Global search and replace for vi                      | https://github.com/skwp/greplace.vim
Plugin 'rking/ag.vim'                     " Vim plugin for the_silver_searcher                    | https://github.com/rking/ag.vim
Plugin 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
Plugin 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file finder       | https://github.com/ctrlpvim/ctrlp.vim
Plugin 'joshukraine/dragvisuals'          " Damian Conway's dragvisuals plugin for vim            | https://github.com/joshukraine/dragvisuals

" Look and Feel
Plugin 'altercation/vim-colors-solarized' " Precision colorscheme for the vim text editor         | https://github.com/altercation/vim-colors-solarized
Plugin 'vim-airline/vim-airline'          " Status/tabline for vim                                | https://github.com/vim-airline/vim-airline
Plugin 'vim-airline/vim-airline-themes'   " A collection of themes for vim-airline                | https://github.com/vim-airline/vim-airline-themes
Plugin 'plasticboy/vim-markdown'          " Syntax highlighting and more for markdown             | https://github.com/plasticboy/vim-markdown

" Tim Pope
Plugin 'tpope/vim-endwise'                " Add 'end' keyword when needed                         | https://github.com/tpope/vim-endwise
Plugin 'tpope/vim-surround'               " Quoting/parenthesizing made simple                    | https://github.com/tpope/vim-surround
Plugin 'tpope/vim-rails'                  " Ruby on Rails power tools                             | https://github.com/tpope/vim-rails
Plugin 'tpope/vim-obsession'              " Continuously updated session files                    | https://github.com/tpope/vim-obsession
Plugin 'tpope/vim-rake'                   " Extended funtionality for rails.vim                   | https://github.com/tpope/vim-rake
Plugin 'tpope/vim-bundler'                " Vim goodies for Bundler, rails.vim, rake.vim          | https://github.com/tpope/vim-bundler
Plugin 'tpope/vim-fugitive'               " Tim Pope's Git wrapper                                | https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-haml'                   " Vim runtime files for Haml, Sass, and SCSS            | https://github.com/tpope/vim-haml
Plugin 'tpope/vim-repeat'                 " Enable repeating supported plugin maps with '.'       | https://github.com/tpope/vim-repeat

" Related to testing & tmux
Plugin 'thoughtbot/vim-rspec'             " Run Rspec specs from Vim                              | https://github.com/thoughtbot/vim-rspec
Plugin 'christoomey/vim-tmux-runner'      " Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner

" Related to vim-snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'     " [vim-snipmate dependency]                             | https://github.com/MarcWeber/vim-addon-mw-utils
Plugin 'tomtom/tlib_vim'                  " [vim-snipmate dependency]                             | https://github.com/tomtom/tlib_vim
Plugin 'garbas/vim-snipmate'              " Textmate-style snippet behavior for vim               | https://github.com/garbas/vim-snipmate
Plugin 'joshukraine/vim-snippets'         " My customized vim-snippets                            | https://github.com/joshukraine/vim-snippets

" Other
Plugin 'christoomey/vim-conflicted'       " Easy git merge conflict resolution in Vim             | https://github.com/christoomey/vim-conflicted
Plugin 'kchmck/vim-coffee-script'         " CoffeeScript support for vim                          | https://github.com/kchmck/vim-coffee-script
Plugin 'bronson/vim-trailing-whitespace'  " Highlights trailing whitespace in red                 | https://github.com/bronson/vim-trailing-whitespace
Plugin 'airblade/vim-gitgutter'           " Shows a git diff in the 'gutter'                      | https://github.com/airblade/vim-gitgutter
Plugin 'mattn/webapi-vim'                 " Allow vim to interface with web APIs                  | https://github.com/mattn/webapi-vim
Plugin 'Glench/Vim-Jinja2-Syntax'         " An up-to-date jinja2 syntax file                      | https://github.com/Glench/Vim-Jinja2-Syntax
Plugin 'slim-template/vim-slim'           " Slim syntax highlighting                              | https://github.com/slim-template/vim-slim
Plugin 'jiangmiao/auto-pairs'             " Insert or delete brackets, parens, quotes in pair.    | https://github.com/jiangmiao/auto-pairs
Plugin 'lifepillar/vim-cheat40'           " A Vim cheat sheet that makes sense, inside Vim!       | https://github.com/lifepillar/vim-cheat40

" All of your Plugins must be added before the following line
call vundle#end()                         " required
filetype plugin indent on                 " required
