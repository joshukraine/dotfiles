" Settings {{{
" Switch syntax highlighting on, when the terminal has colors
syntax on
" syntax enable

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

" A buffer is marked as ‘hidden’ if it has unsaved changes, and it is not currently loaded in a window
" if you try and quit Vim while there are hidden buffers, you will raise an error:
" E162: No write since last change for buffer “a.txt”
set hidden

" Turn word wrap off
set nowrap

" Allow backspace to delete end of line, indent and start of line characters
set backspace=indent,eol,start

" Convert tabs to spaces
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

" Turn on line numbers AND use relative number
set number
set relativenumber

" Highlight tailing whitespace
set list listchars=tab:\ \ ,trail:·

" Get rid of the delay when pressing O (for example)
" http://stackoverflow.com/questions/2158516/vim-delay-before-o-opens-a-new-line
set timeout timeoutlen=1000 ttimeoutlen=100

" Always show status bar
set laststatus=2

" Set the status line to something useful
set statusline=%f\ %=L:%l/%L\ %c\ (%p%%)

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

" Highlight the current line
set cursorline

" Ensure Vim doesn't beep at you every time you make a mistype
set visualbell

" Visual autocomplete for command menu (e.g. :e ~/path/to/file)
set wildmenu

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" highlight a matching [{()}] when cursor is placed on start/end character
set showmatch

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3


" LEGACY SETTINGS
set showmode                      " Display the mode you're in.
set wildmode=list:longest         " Complete files like a shell.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set autoindent
set tags=./tags;
set t_Co=256
set fillchars+=vert:\ 
" set backupdir=~/.tmp
" set directory=~/.tmp              " Don't clutter my dirs up with swp and tmp files
" set list listchars=tab:»·,trail:· " Display extra whitespace
" set clipboard=unnamed             " use OS clipboard

" Make it obvious where 80 characters is
set textwidth=80
set colorcolumn=+1

" Keep focus split large, others minimal
set winwidth=84
set winheight=7
set winminheight=7
set winheight=999
" }}}


" Plugins {{{
filetype off                  " required by Vundle

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-git'
Plugin 'tpope/vim-bundler'
Plugin 'tpope/vim-rake'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-ragtag'
Plugin 'tpope/vim-unimpaired'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tomtom/tcomment_vim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'wincent/Command-T'
Plugin 'thoughtbot/vim-rspec'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'jgdavey/tslime.vim'
Plugin 'ervandew/supertab'
Plugin 'altercation/vim-colors-solarized'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
Plugin 'mileszs/ack.vim'
Plugin 'bufexplorer.zip'
Plugin 'greplace.vim'
Plugin 'Rename'
Plugin 'bling/vim-airline'
Plugin 'scrooloose/nerdtree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Airline (status line)
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_symbols.linenr = 'Ln'

let g:airline_powerline_fonts=1
" let g:airline_theme='powerlineish'
let g:airline_left_sep=''
let g:airline_right_sep=''

" Close vim if only nerdtree window is left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Theme
set background=dark
colorscheme solarized
" }}}


" Ruby {{{
augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
  autocmd FileType ruby,eruby,yaml setlocal path+=lib
  autocmd BufRead,BufNewFile *.md set filetype=markdown

  " Enable spellchecking for Markdown
  autocmd FileType markdown setlocal spell

  " Automatically wrap at 80 characters for Markdown
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80

augroup END

" Enable built-in matchit plugin
runtime macros/matchit.vim

let g:rspec_runner = "os_x_iterm"
let g:rspec_command = 'call Send_to_Tmux("rspec {spec}\n")'
" }}}


" Mappings {{{
let mapleader = ","

" General Vim
map <Leader>x :Explore
map <Leader>vi :tabe ~/.vimrc<cr>
map <Leader>src :source ~/.vimrc<cr>:AirlineRefresh<cr>
map <Leader>w <C-w>
map <Leader>ra :%s/
map <Leader>p :set paste<cr>o<esc>"*]p:set nopaste<cr> " Fix indentation on paste
map <Leader>i mmgg=G`m<cr> " For indenting code

" Rails
map <Leader>vm :RVmodel<cr>
map <Leader>vv :RVview<cr>
map <Leader>vc :RVcontroller<cr>
map <Leader>vh :RVhelper
map <Leader>sm :RSmodel
map <Leader>sv :RSview
map <Leader>sc :RScontroller
map <Leader>sh :RShelper
map <Leader>vf :RVfunctional<cr>

" Rspec
map <Leader>su :RSunittest
map <Leader>vu :RVunittest<cr>
map <Leader>u :Runittest<cr>
map <Leader>rd :!bundle exec rspec % --format documentation<cr>
map <Leader>r :call RunCurrentSpecFile()<cr>
map <Leader>n :call RunNearestSpec()<cr>
map <Leader>l :call RunLastSpec()<cr>
map <Leader>a :call RunAllSpecs()<cr>

" Git
map <Leader>gca :Gcommit -am ""<LEFT>
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>gs :Gstatus<cr>

" Searching the file system
map <C-n> :NERDTreeToggle<cr>

" Tcomment
map <Leader>/ :TComment<cr>


" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<cr>
map <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<cr>
map <Leader>vn :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<cr>
map <C-t> <esc>:tabnew<cr>

map <Leader>h :nohl<cr>
map <Leader>cn :cn<cr>
map <Leader>cp :cp<cr>

" Return to normal mode faster
imap <C-[> <C-c>

" jj to switch back to normal mode
inoremap jj <C-c>

" Switch between the last two files
nnoremap <Leader><Leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<cr>
nnoremap <Right> :echoe "Use l"<cr>
nnoremap <Up> :echoe "Use k"<cr>
nnoremap <Down> :echoe "Use j"<cr>

" Disable Ex mode
map Q <Nop>

" Disable K looking stuff up
map K <Nop>

" Add new lines without leaving normal mode
nmap <Leader>O O<Esc>
nmap <cr> o<Esc>

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal lbr
au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e
" }}}


" Powerline {{{
" let g:Powerline_symbols = 'unicode'
" python from powerline.vim import setup as powerline_setup
" python powerline_setup()
" python del powerline_setup
" }}}
