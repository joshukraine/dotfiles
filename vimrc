" ========================================================================
" Vundle
" ========================================================================

set nocompatible              " be iMproved, required
filetype off                  " required

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
Plugin 'koron/nyancat-vim'
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

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required



" ========================================================================
" Ruby stuff
" ========================================================================

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



" ========================================================================
" Settings
" ========================================================================

syntax enable
set background=dark
set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set backspace=indent,eol,start    " Intuitive backspacing.
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.
set number                        " Show line numbers.
set ruler                         " Show cursor position.
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set visualbell                    " No beeping.
set tabstop=2                     " Global tab width.
set shiftwidth=2                  " And again, related.
set expandtab                     " Use spaces instead of tabs
set laststatus=2                  " Show the status line all the time
set history=500                   " keep 500 lines of command line history
set autoindent
set tags=./tags;
set encoding=utf-8
set t_Co=256
set fillchars+=vert:\ 
set splitbelow
set splitright
set nowrap
set showmatch
set backupdir=~/.tmp
set directory=~/.tmp              " Don't clutter my dirs up with swp and tmp files
set relativenumber
set list listchars=tab:»·,trail:· " Display extra whitespace
set cursorline                    " highlight current line
set clipboard=unnamed             " use OS clipboard

" Keep focus split large, others minimal
set winwidth=84
set winheight=7
set winminheight=7
set winheight=999



" ========================================================================
" Mappings
" ========================================================================

let mapleader = ","

" General Vim
map <Leader>x :Explore
map <Leader>vi :tabe ~/.vimrc<CR>
map <Leader>src :source ~/.vimrc
map <Leader>w <C-w>
map <Leader>ra :%s/
map <Leader>p :set paste<CR>o<esc>"*]p:set nopaste<cr> " Fix indentation on paste
map <Leader>i mmgg=G`m<CR> " For indenting code

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
map <Leader>vu :RVunittest<CR>
map <Leader>u :Runittest<cr>
map <Leader>rd :!bundle exec rspec % --format documentation<CR>
map <Leader>r :call RunCurrentSpecFile()<CR>
map <Leader>n :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Git
map <Leader>gca :Gcommit -am ""<LEFT>
map <Leader>gc :Gcommit -m ""<LEFT>
map <Leader>gs :Gstatus<CR>

" Tcomment
map <Leader>/ :TComment<CR>

" Edit another file in the same directory as the current file
" uses expression to extract path from current file's path
map <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
map <Leader>s :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
map <Leader>vn :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

map <Leader>h :nohl<cr>
map <C-t> <esc>:tabnew<CR>
map <C-n> :cn<CR>
map <C-p> :cp<CR>

" Return to normal mode faster
imap <C-[> <C-c>

" jj to switch back to normal mode
inoremap jj <C-c>

" Switch between the last two files
nnoremap <Leader><Leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" Disable Ex mode
map Q <Nop>

" Disable K looking stuff up
map K <Nop>

" Add new lines without leaving normal mode
nmap <Leader>O O<Esc>
nmap <CR> o<Esc>

" When loading text files, wrap them and don't split up words.
au BufNewFile,BufRead *.txt setlocal lbr
au BufNewFile,BufRead *.txt setlocal nolist " Don't display whitespace

" Remove trailing whitespace on save for ruby files.
au BufWritePre *.rb :%s/\s\+$//e


" ========================================================================
" Color
" ========================================================================

colorscheme solarized



" ========================================================================
" Powerline
" ========================================================================

let g:Powerline_symbols = 'unicode'
python from powerline.vim import setup as powerline_setup
python powerline_setup()
python del powerline_setup
