" Settings {{{

" Switch syntax highlighting on, when the terminal has colors
syntax on

" Use vim, not vi api
set nocompatible

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Command history
set history=500

" Always show cursor
set ruler

" Show incomplete commands
set showcmd

" Incremental searching (search as you type)
set incsearch

" Highlight search matches
set hlsearch

" Ignore case in search
set smartcase

" Make sure any searches /searchPhrase doesn't need the \c escape character
set ignorecase

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not
" currently loaded in a window.
" If you try and quit Vim while there are hidden buffers, you will raise an
" error:
" E162: No write since last change for buffer “a.txt”
set hidden

" Turn word wrap off
set nowrap

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Convert tabs to spaces, all file types
" set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=4

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=4

" Turn on line numbers AND use relative number
set number
set relativenumber

" Highlight tailing whitespace
set list listchars=tab:»·,trail:·

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

" Hide the toolbar
set guioptions-=T

" UTF encoding
set encoding=utf-8

" Autoload files that have changed outside of vim
set autoread

" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
set clipboard+=unnamed

" Don't show intro
set shortmess+=I

" Better splits (new windows appear below and to the right)
set splitbelow
" set splitright

" Highlight the current line and column
set cursorline
set cursorcolumn

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Display the mode you're in.
set showmode

" Complete files like a shell.
set wildmode=list:longest

" Show 3 lines of context around the cursor.
set scrolloff=3

" Set the terminal's title
set title

set autoindent

set tags=./tags;

set t_Co=256

set fillchars+=vert:\ 

" Vertical line at 80 characters
set textwidth=80
set colorcolumn=+1

" Keep focus split large, others minimal
set winwidth=84
set winheight=7
set winminheight=7
set winheight=999

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3

" Enable built-in matchit plugin
runtime macros/matchit.vim

set grepprg=ag

let g:grep_cmd_opts = '--line-numbers --noheading'

" }}}


" Plugins {{{

filetype off " required by Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Vundle itself
Plugin 'gmarik/Vundle.vim'                " https://github.com/gmarik/Vundle.vim

" Ruby-specific
Plugin 'vim-ruby/vim-ruby'                " https://github.com/vim-ruby/vim-ruby
Plugin 'kana/vim-textobj-user'            " https://github.com/kana/vim-textobj-user
Plugin 'nelstrom/vim-textobj-rubyblock'   " https://github.com/nelstrom/vim-textobj-rubyblock
Plugin 'scrooloose/syntastic'             " https://github.com/scrooloose/syntastic

" Searching and Navigation
Plugin 'scrooloose/nerdtree'              " https://github.com/scrooloose/nerdtree
Plugin 'skwp/greplace.vim'                " https://github.com/skwp/greplace.vim
Plugin 'rking/ag.vim'                     " https://github.com/rking/ag.vim
Plugin 'christoomey/vim-tmux-navigator'   " https://github.com/christoomey/vim-tmux-navigator
Plugin 'ctrlpvim/ctrlp.vim'               " https://github.com/ctrlpvim/ctrlp.vim

" Look and Feel
Plugin 'altercation/vim-colors-solarized' " https://github.com/altercation/vim-colors-solarized
Plugin 'bling/vim-airline'                " https://github.com/bling/vim-airline

" Tim Pope
Plugin 'tpope/vim-fugitive'               " https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-git'                    " https://github.com/tpope/vim-git
Plugin 'tpope/vim-endwise'                " https://github.com/tpope/vim-endwise
Plugin 'tpope/vim-surround'               " https://github.com/tpope/vim-surround
Plugin 'tpope/vim-rails'                  " https://github.com/tpope/vim-rails
Plugin 'tpope/vim-ragtag'                 " https://github.com/tpope/vim-ragtag
Plugin 'tpope/vim-obsession'              " https://github.com/tpope/vim-obsession

" Related to testing & tmux
Plugin 'benmills/vimux'                   " https://github.com/benmills/vimux
Plugin 'jgdavey/tslime.vim'               " https://github.com/jgdavey/tslime.vim
Plugin 'thoughtbot/vim-rspec'             " https://github.com/thoughtbot/vim-rspec
Plugin 'skalnik/vim-vroom'                " https://github.com/skalnik/vim-vroom

" Related to vim-snipmate
Plugin 'MarcWeber/vim-addon-mw-utils'     " https://github.com/MarcWeber/vim-addon-mw-utils
Plugin 'tomtom/tlib_vim'                  " https://github.com/tomtom/tlib_vim
Plugin 'garbas/vim-snipmate'              " https://github.com/garbas/vim-snipmate
Plugin 'honza/vim-snippets'               " https://github.com/honza/vim-snippets

" Other
Plugin 'kchmck/vim-coffee-script'         " https://github.com/kchmck/vim-coffee-script
Plugin 'tomtom/tcomment_vim'              " https://github.com/tomtom/tcomment_vim
Plugin 'bronson/vim-trailing-whitespace'  " https://github.com/bronson/vim-trailing-whitespace
Plugin 'ervandew/supertab'                " https://github.com/ervandew/supertab
Plugin 'danro/rename.vim'                 " https://github.com/danro/rename.vim
Plugin 'duff/vim-scratch'                 " https://github.com/duff/vim-scratch
Plugin 'godlygeek/tabular'                " https://github.com/godlygeek/tabular

" All of your Plugins must be added before the following line
call vundle#end()                         " required
filetype plugin indent on                 " required

" }}}


" General Mappings {{{

let mapleader = " "

" Misc
" map <leader>x :Explore
map <leader>ev :tabe ~/.vimrc<CR>
map <leader>q :source ~/.vimrc<CR>:AirlineRefresh<CR>
map <leader>s :w<CR>
map <leader>ra :%s/
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<CR> " Fix indentation on paste
map <leader>i mmgg=G`m<CR> " For indenting code
map <leader>h :nohl<CR> " Clear highlights
imap <C-[> <C-c> " Return to normal mode faster
map <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <leader><leader> <c-^> " Switch between the last two files
map Q <Nop> " Disable Ex mode
map K <Nop> " Disable K looking stuff up
nmap <leader>O O<Esc> " Add new line ABOVE without leaving normal mode
nmap <CR> o<Esc>k " Add new line BELOW without leaving normal mode

" Run 'git blame' on a selection of code
vmap <leader>b :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
map <leader>- :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <leader>vn :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

" Reminders :)
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" }}}


" Plugin-specific Mappings and Settings {{{

" NERDTree
map <leader>\ :NERDTreeToggle<CR>

" Tcomment
map <leader>/ :TComment<CR>

" Obsession
map <leader>ob :Obsession<CR>

" vim-rspec
map <leader>f :call RunCurrentSpecFile()<CR>
map <leader>r :call RunNearestSpec()<CR>
map <leader>l :call RunLastSpec()<CR>
map <leader>a :call RunAllSpecs()<CR>
let g:rspec_command = 'call VimuxRunCommand("clear; spring rspec {spec}")'
" let g:rspec_command = 'call VimuxRunCommand("clear; rspec {spec}")'

" vroom.vim (alternative plugin to vim-rspec)
" map <leader>r :VroomRunNearestTest<CR>
" map <leader>f :VroomRunTestFile<CR>
" map <leader>l :VroomRunLastTest<CR>
" let g:vroom_use_vimux = 1
" let g:vroom_use_colors = 1
" let g:vroom_use_bundle_exec = 0
" let g:vroom_map_keys = 0
" let g:vroom_clear_screen = 0

" Vimux
" Prompt for a command to run map
map <leader>vp :VimuxPromptCommand<CR>

" Inspect runner pane map
map <leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand. If a pane is closed manually,
" the vim-rspec commands will no longer cause a new pane to open. Calling
" :VimuxCloseRunner() will 'reset' Vimux, after which the vim-rspec commands
" will pop open a new pane as they did initially.
map <leader>vq :VimuxCloseRunner<CR>

" Zoom the tmux runner page
map <leader>vz :VimuxZoomRunner<CR>

" Set the size of the vimux window.
let g:VimuxHeight = "30"

" CtrlP
map <leader>t <C-p>
map <leader>y :CtrlPBuffer<CR>
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 15

" CtrlP -> override <C-o> to provide options for how to open files
let g:ctrlp_arg_map = 1

" CtrlP -> files matched are ignored when expanding wildcards
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*.,*/.DS_Store

" CtrlP -> directories to ignore when fuzzy finding
let g:ctrlp_custom_ignore = '\v[\/]((node_modules)|\.(git|svn|grunt|sass-cache))$'

" Custom rails.vim commands
command! Rroutes :e config/routes.rb
command! RTroutes :tabe config/routes.rb
command! RSroutes :sp config/routes.rb
command! RVroutes :vs config/routes.rb
command! Rfactories :e spec/factories.rb
command! RTfactories :tabe spec/factories.rb
command! RSfactories :sp spec/factories.rb
command! RVfactories :vs spec/factories.rb

" vim-scratch
map <C-s> :Sscratch<CR>

" }}}


" Commands {{{

" specify syntax highlighting for specific files
autocmd Bufread,BufNewFile *.spv set filetype=php
autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal lbr
au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" file formats
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,html,zsh,vim,css,scss setlocal shiftwidth=2 tabstop=2 expandtab

" autoindent with two spaces, always expand tabs
autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
autocmd FileType ruby,eruby,yaml setlocal path+=lib

" Enable spellchecking for Markdown
autocmd FileType markdown setlocal spell

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e

" Close all folds when opening a new buffer
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM

" Close vim if only nerdtree window is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColors()

" }}}


" Airline (status line) {{{
" https://github.com/bling/vim-airline

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = 'Ln'
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''

" }}}


" Colorscheme {{{

" Light theme
" set background=light
" colorscheme solarized

" Dark theme
set background=dark
colorscheme solarized
" }}}
