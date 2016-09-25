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

" Ignore case in search if term(s) are lowercase
set ignorecase

" Search with case sensitivity if term(s) are upper or mixed case
set smartcase

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
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

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
set splitright

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

set fillchars+=vert:\|

" Vertical line at 80 characters
set textwidth=80
set colorcolumn=+1

" Keep focus split large, others minimal
set winwidth=90
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
Plugin 'scrooloose/syntastic'             " Syntax checking hacks for vim                         | https://github.com/scrooloose/syntastic

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

" Tim Pope
Plugin 'tpope/vim-endwise'                " Add 'end' keyword when needed                         | https://github.com/tpope/vim-endwise
Plugin 'tpope/vim-surround'               " Quoting/parenthesizing made simple                    | https://github.com/tpope/vim-surround
Plugin 'tpope/vim-rails'                  " Ruby on Rails power tools                             | https://github.com/tpope/vim-rails
Plugin 'tpope/vim-obsession'              " Continuously updated session files                    | https://github.com/tpope/vim-obsession
Plugin 'tpope/vim-rake'                   " Extended funtionality for rails.vim                   | https://github.com/tpope/vim-rake
Plugin 'tpope/vim-bundler'                " Vim goodies for Bundler, rails.vim, rake.vim          | https://github.com/tpope/vim-bundler
Plugin 'tpope/vim-fugitive'               " Tim Pope's Git wrapper                                | https://github.com/tpope/vim-fugitive
Plugin 'tpope/vim-haml'                   " Vim runtime files for Haml, Sass, and SCSS            | https://github.com/tpope/vim-haml

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
Plugin 'jiangmiao/auto-pairs'             " Insert or delete brackets, parens, quotes in pair.    | https://github.com/jiangmiao/auto-pairs

" All of your Plugins must be added before the following line
call vundle#end()                         " required
filetype plugin indent on                 " required

" }}}

" General Mappings {{{

let mapleader = "\<Space>"

" Misc
map <leader>ev :tabe ~/.vimrc<CR>
map <leader>r :source ~/.vimrc<CR>:AirlineRefresh<CR>
map <leader>q :q<CR>
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>ra :%s/
map <leader>p :set paste<CR>o<esc>"*]p:set nopaste<CR> " Fix indentation on paste
map <leader>i mmgg=G`m<CR> " For indenting code
map <leader>h :nohl<CR> " Clear highlights
map <leader>s :%s/\s\+$//e<CR> " Manually clear trailing whitespace
inoremap <C-[> <Esc>:w<CR> " Return to normal mode faster + write file
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <leader><leader> <c-^> " Switch between the last two files
map <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T
map Q <Nop> " Disable Ex mode
map K <Nop> " Disable K looking stuff up

" Delete all lines beginning with '#' regardless of leading space.
map <leader>d :g/^\s*#.*/d<CR>:nohl<CR>

" Run 'git blame' on a selection of code
vmap <leader>gb :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" zoom a vim pane like in tmux
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
" zoom back out
nnoremap <leader>= :wincmd =<cr>

" Force vim to use 'very magic' mode for regex searches
nnoremap / /\v

" }}}

" Plugin-specific Mappings and Settings {{{

" NERDTree
nmap <silent> <F3> :NERDTreeToggle<CR>
map <leader>\ :NERDTreeToggle<CR>
let g:NERDTreeWinSize=25
let NERDTreeShowHidden=1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" Toggle GitGutter
nnoremap <F4> :GitGutterToggle<CR>

" Tcomment
map <leader>/ :TComment<CR>

" Bufexplorer - unmapping defaults because they cause delay for <leader>b
map <leader>b :ToggleBufExplorer<CR>

" Obsession
map <leader>ob :Obsession<CR>

" vim-rspec
map <leader>f :call RunCurrentSpecFile()<CR>
map <leader>n :call RunNearestSpec()<CR>
map <leader>l :call RunLastSpec()<CR>
map <leader>a :call RunAllSpecs()<CR>
let g:rspec_command = 'VtrSendCommandToRunner! clear; bin/rspec {spec}'

" vim-tmux-runner
let g:VtrPercentage = 20
let g:VtrUseVtrMaps = 1
nnoremap <leader>sd :VtrSendCtrlD<cr>
nmap <leader>fs :VtrFlushCommand<cr>:VtrSendCommandToRunner<cr>
nmap <leader>osp :VtrOpenRunner {'orientation': 'h', 'percentage': 20, 'cmd': '' }<cr>
nmap <leader>orc :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'rc'}<cr>
nmap <leader>opr :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'pry'}<cr>

" CtrlP
map <leader>t <C-p>
map <leader>y :CtrlPBuffer<CR>
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 15

" CtrlP -> override <C-o> to provide options for how to open files
let g:ctrlp_arg_map = 1

" CtrlP -> files matched are ignored when expanding wildcards
set wildignore+=*/.git/*,*.tmp/*,*/.hg/*,*/.svn/*.,*/.DS_Store

" CtrlP -> directories to ignore when fuzzy finding
let g:ctrlp_custom_ignore = '\v[\/]((build|node_modules)|\.(git|sass-cache))$'

" Custom rails.vim commands
command! Rroutes :e config/routes.rb
command! RTroutes :tabe config/routes.rb
command! RSroutes :sp config/routes.rb
command! RVroutes :vs config/routes.rb
command! Rfactories :e spec/factories.rb
command! RTfactories :tabe spec/factories.rb
command! RSfactories :sp spec/factories.rb
command! RVfactories :vs spec/factories.rb

" Syntastic
let g:syntastic_scss_checkers = ['scss_lint']
let g:syntastic_haml_checkers = ['haml_lint']
let g:syntastic_javascript_checkers = ['eslint']

" Key mappings for dragvisuals.vim
runtime bundle/dragvisuals/plugins/dragvisuals.vim

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

" }}}

" Commands {{{

" specify syntax highlighting for specific files
autocmd Bufread,BufNewFile *.spv set filetype=php
autocmd Bufread,BufNewFile *Brewfile set filetype=ruby
autocmd Bufread,BufNewFile aliases,functions,prompt,tmux,oh-my-zsh set filetype=zsh
autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal lbr
au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" file formats
autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd Filetype sh,markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0 " http://vim.wikia.com/wiki/Word_wrap_without_line_breaks
autocmd FileType sh,cucumber,ruby,yaml,html,xml,zsh,vim,css,scss,javascript,gitconfig setlocal shiftwidth=2 tabstop=2 expandtab

" autoindent with two spaces, always expand tabs
autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
autocmd FileType ruby,eruby,yaml setlocal path+=lib

" Enable spellchecking for Markdown
autocmd FileType markdown setlocal spell

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e

" Fold settings
autocmd BufRead * setlocal foldmethod=marker
autocmd BufRead * normal zM
" autocmd BufRead *.rb setlocal foldmethod=syntax
" autocmd BufRead *.rb normal zR
" set foldnestmax=3

" Close vim if only nerdtree window is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Change colourscheme when diffing
fun! SetDiffColors()
  highlight DiffAdd    cterm=bold ctermfg=white ctermbg=DarkGreen
  highlight DiffDelete cterm=bold ctermfg=white ctermbg=DarkGrey
  highlight DiffChange cterm=bold ctermfg=white ctermbg=DarkBlue
  highlight DiffText   cterm=bold ctermfg=white ctermbg=DarkRed
endfun
autocmd FilterWritePre * call SetDiffColors()

" Unmap GitGutter leaders that I don't use. This avoids delays for other leaders.
autocmd VimEnter * nunmap <leader>hp
autocmd VimEnter * nunmap <leader>hr
autocmd VimEnter * nunmap <leader>hs

" Unmap Bufexplorer leaders that I don't use. This avoids delays for other leaders.
autocmd VimEnter * nunmap <leader>bs
autocmd VimEnter * nunmap <leader>bv

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" }}}

" Airline (status line) {{{
" https://github.com/bling/vim-airline

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_powerline_fonts=1

let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
let g:airline_symbols.crypt = '🔒'

let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''

" For more intricate customizations, you can replace the predefined sections
" with the usual statusline syntax.
"
" Note: If you define any section variables it will replace the default values
" entirely.  If you want to disable only certain parts of a section you can try
" using variables defined in the |airline-configuration| or |airline-extensions|
" section.
" >
"   variable names                default contents
"   ----------------------------------------------------------------------------
"   let g:airline_section_a       (mode, crypt, paste, iminsert)
"   let g:airline_section_b       (hunks, branch)
"   let g:airline_section_c       (bufferline or filename)
"   let g:airline_section_gutter  (readonly, csv)
"   let g:airline_section_x       (tagbar, filetype, virtualenv)
"   let g:airline_section_y       (fileencoding, fileformat)
"   let g:airline_section_z       (percentage, line number, column number)
"   let g:airline_section_error   (ycm_error_count, syntastic, eclim)
"   let g:airline_section_warning (ycm_warning_count, whitespace)

  " here is an example of how you could replace the branch indicator with
  " the current working directory, followed by the filename.
  " let g:airline_section_b = '%{getcwd()}'
  " let g:airline_section_c = '%t%m'

let g:airline#extensions#default#section_truncate_width = {
    \ 'y': 100,
    \ }

let g:airline#extensions#default#layout = [
    \ [ 'a', 'b', 'c' ],
    \ [ 'x', 'y', 'z', 'error', 'warning' ]
    \ ]

" airline branch settings
" let g:airline#extensions#branch#enabled = 1
" let g:airline#extensions#branch#displayed_head_limit = 10

  " default value leaves the name unmodifed
  " let g:airline#extensions#branch#format = 0

  " to only show the tail, e.g. a branch 'feature/foo' becomes 'foo', use
  " let g:airline#extensions#branch#format = 1

  " to truncate all path sections but the last one, e.g. a branch
  " 'foo/bar/baz' becomes 'f/b/baz', use
  " let g:airline#extensions#branch#format = 2

" airline hunk settings

" enable/disable showing a summary of changed hunks under source control
" let g:airline#extensions#hunks#enabled = 1

" enable/disable showing only non-zero hunks
let g:airline#extensions#hunks#non_zero_only = 1

" set hunk count symbols
" let g:airline#extensions#hunks#hunk_symbols = ['+', '~', '-']

" }}}

" Colorscheme {{{

" set background=light " light theme
set background=dark " dark theme
colorscheme solarized

highlight clear IncSearch
highlight IncSearch term=reverse cterm=reverse ctermfg=7 ctermbg=0 guifg=Black guibg=Yellow
highlight VertSplit ctermbg=NONE guibg=NONE
" }}}

" Include local settings {{{
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
" }}}
