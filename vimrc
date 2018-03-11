" Settings {{{

" Force vim to use older regex engine.
" https://stackoverflow.com/a/16920294/655204
set re=1

" Use vim, not vi api
set nocompatible

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Show incomplete commands
set showcmd

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

" Conceal Markdown characters
set conceallevel=2

" Convert tabs to spaces, all file types
set expandtab

" Set tab size in spaces (this is for manual indenting)
set tabstop=2

" The number of spaces inserted for a tab (used for auto indenting)
set shiftwidth=2

" Turn on line numbers AND use relative number
set number
set relativenumber

" Highlight tabs and trailing whitespace
set list listchars=tab:»·,trail:·

" Hide the toolbar
set guioptions-=T

" UTF encoding
set encoding=utf-8

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

" redraw only when we need to (i.e. don't redraw when executing a macro)
set lazyredraw

" Indicates a fast terminal connection
set ttyfast

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

set tags=./tags;

set fillchars+=vert:\|

" Vertical line at 80 characters
set textwidth=80
set colorcolumn=+1

" Start diff mode with vertical splits
set diffopt=vertical

" Set built-in file system explorer to use layout similar to the NERDTree plugin
let g:netrw_liststyle=3

" Enable built-in matchit plugin
runtime macros/matchit.vim

set grepprg=ag

let g:grep_cmd_opts = '--line-numbers --noheading --ignore-dir=log --ignore-dir=tmp'

if has('nvim')
  set inccommand=nosplit

  set updatetime=100

  set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
        \,a:blinkwait0-blinkoff400-blinkon250-Cursor/lCursor
        \,sm:block-blinkwait0-blinkoff150-blinkon175
endif

" Keep focus split wide, others narrow.
set winwidth=90
set winminwidth=5

" Keep focus split at max height, others minimal.
function! SetWindowHeight()
  set winheight=5
  set winminheight=5
  set winheight=999
endfunction

" Reset window height to avoid session errors.
function! ResetWindowHeight()
  set winminheight=0
  set winheight=1
endfunction
" }}}

" Commands {{{

" specify syntax highlighting for specific files
augroup file_types
  autocmd!
  autocmd Bufread,BufNewFile *.spv set filetype=php
  autocmd Bufread,BufNewFile *Brewfile set filetype=ruby
  autocmd Bufread,BufNewFile aliases,functions,prompt,tmux,oh-my-zsh set filetype=zsh
  autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?
  autocmd Bufread,BufNewFile gitconfig set filetype=gitconfig
augroup END

" Remove trailing whitespace on save for specified file types.
augroup clear_whitespace
  autocmd!
  au BufWritePre *.rb,*.yml,*.erb,*.haml,*.css,*.scss,*.js,*.coffee :%s/\s\+$//e
augroup END

" Fold settings
augroup fold_settings
  autocmd!
  autocmd BufRead * setlocal foldmethod=marker
  autocmd BufRead * normal zM
  " autocmd FileType ruby setlocal foldmethod=manual
  " autocmd BufRead *.rb setlocal foldmethod=syntax
  " autocmd BufRead *.rb normal zR
  " set foldnestmax=3
augroup END

" Close vim if only nerdtree window is left
augroup nerdtree_settings
  autocmd!
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
augroup END

" Unmap various plugin-related commands I don't use.
augroup unmappings
  autocmd!
  " Unmap Bufexplorer leaders that I don't use. This avoids delays for other leaders.
  autocmd VimEnter * nunmap <leader>bs
  autocmd VimEnter * nunmap <leader>bv
augroup END

" automatically rebalance windows on vim resize
augroup window_resize
  autocmd!
  autocmd VimResized * :wincmd =
augroup END

" Reset window sizes to avoid errors on session load.
augroup set_window_height
  autocmd!
  autocmd VimLeavePre * :call ResetWindowHeight()
  autocmd VimEnter * :call SetWindowHeight()
augroup END
" }}}

" Mappings {{{

let mapleader = "\<Space>"

" Misc
map <leader>ev :tabe ~/.vimrc<CR>
map <leader>ew :windo edit!<CR>
map <leader>eb :bufdo edit!<CR>
map <leader>r :source ~/.vimrc<CR>
map <leader>q :q<CR>
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>ra :%s/
map <leader>p :set paste<CR>""p:set nopaste<CR> " Fix indentation on paste
map <leader>i mmgg=G`m<CR> " For indenting code
map <leader>h :nohl<CR> " Clear highlights
map <leader>0 :call SetWindowHeight()<CR>
map <leader>s :%s/\s\+$//e<CR> " Manually clear trailing whitespace
inoremap <C-[> <Esc>:w<CR> " Return to normal mode faster + write file
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <leader>4 <c-^> " Switch between the last two files
map <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T
map Q <Nop> " Disable Ex mode
map K <Nop> " Disable K looking stuff up

" Expand active file directory
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Delete all lines beginning with '#' regardless of leading space.
map <leader>d :g/^\s*#.*/d<CR>:nohl<CR>

" Run 'git blame' on a selection of code
vmap <leader>gb :<C-U>!git blame <C-R>=expand("%:p") <CR> \| sed -n <C-R>=line("'<") <CR>,<C-R>=line("'>") <CR>p <CR>

" zoom a vim pane like in tmux
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
" zoom back out
nnoremap <leader>= :wincmd =<cr>

" Write files as sudo
cmap w!! w !sudo tee >/dev/null %
" }}}

" Plugins {{{

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $HOME/.vimrc
endif

call plug#begin('~/.vim/plugged')

" General
Plug 'godlygeek/tabular'                " Vim script for text filtering and alignment           | https://github.com/godlygeek/tabular
Plug 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin          | https://github.com/tomtom/tcomment_vim
Plug 'vim-scripts/BufOnly.vim'          " Delete all the buffers except current/named buffer    | https://github.com/vim-scripts/BufOnly.vim
Plug 'jlanzarotta/bufexplorer'          " Open/close/navigate vim's buffers                     | https://github.com/jlanzarotta/bufexplorer
Plug 'majutsushi/tagbar'                " A class outline viewer for vim                        | https://github.com/majutsushi/tagbar
Plug 'w0rp/ale'                         " Asynchronous Lint Engine                              | https://github.com/w0rp/ale
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting for                    | https://github.com/ntpeters/vim-better-whitespace
Plug 'jiangmiao/auto-pairs'             " Insert or delete brackets, parens, quotes in pair.    | https://github.com/jiangmiao/auto-pairs
Plug 'airblade/vim-gitgutter'           " Shows a git diff in the 'gutter'                      | https://github.com/airblade/vim-gitgutter
Plug 'machakann/vim-highlightedyank'    " Make the yanked region apparent!                      | https://github.com/machakann/vim-highlightedyank

" Code Completion
if has('nvim')
  Plug 'roxma/nvim-completion-manager'  " Async Completion Framework for Neovim                 | https://github.com/roxma/nvim-completion-manager
  Plug 'roxma/ncm-rct-complete'         " Required for Ruby completion                          | https://github.com/roxma/ncm-rct-complete
  Plug 'roxma/nvim-cm-tern',
    \ {'do': 'npm install'}             " Javascript completion for nvim-completion-manager.    | https://github.com/roxma/nvim-cm-tern
endif
Plug 'SirVer/ultisnips'                 " The ultimate snippet solution for Vim                 | https://github.com/sirver/UltiSnips

" Ruby-specific
Plug 'vim-ruby/vim-ruby'                " Vim/Ruby Configuration Files                          | https://github.com/vim-ruby/vim-ruby
Plug 'kana/vim-textobj-user'            " Create your own text objects                          | https://github.com/kana/vim-textobj-user
Plug 'nelstrom/vim-textobj-rubyblock'   " A custom text object for selecting ruby blocks        | https://github.com/nelstrom/vim-textobj-rubyblock

" Searching and Navigation
Plug 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file finder       | https://github.com/ctrlpvim/ctrlp.vim
Plug 'scrooloose/nerdtree'              " A tree explorer plugin for vim                        | https://github.com/scrooloose/nerdtree
Plug 'brooth/far.vim'                   " Find And Replace Vim plugin                           | https://github.com/brooth/far.vim
Plug 'mileszs/ack.vim'                  " Vim plugin for the Perl module / CLI script 'ack'     | https://github.com/mileszs/ack.vim
Plug 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
Plug 'joshukraine/dragvisuals'          " Damian Conway's dragvisuals plugin for vim            | https://github.com/joshukraine/dragvisuals
Plug 'easymotion/vim-easymotion'        " Vim motions on speed!                                 | https://github.com/easymotion/vim-easymotion

" Colors and Syntax Highlighting
Plug 'altercation/vim-colors-solarized' " Precision colorscheme for the vim text editor         | https://github.com/altercation/vim-colors-solarized
Plug 'kchmck/vim-coffee-script'         " CoffeeScript support for vim                          | https://github.com/kchmck/vim-coffee-script
Plug 'Glench/Vim-Jinja2-Syntax'         " An up-to-date jinja2 syntax file                      | https://github.com/Glench/Vim-Jinja2-Syntax
Plug 'hail2u/vim-css3-syntax'           " CSS3 syntax                                           | https://github.com/hail2u/vim-css3-syntax
Plug 'cakebaker/scss-syntax.vim'        " Vim syntax file for scss (Sassy CSS)                  | https://github.com/cakebaker/scss-syntax.vim

" Tim Pope
Plug 'tpope/vim-endwise'                " Add 'end' keyword when needed                         | https://github.com/tpope/vim-endwise
Plug 'tpope/vim-surround'               " Quoting/parenthesizing made simple                    | https://github.com/tpope/vim-surround
Plug 'tpope/vim-rails'                  " Ruby on Rails power tools                             | https://github.com/tpope/vim-rails
Plug 'tpope/vim-obsession'              " Continuously updated session files                    | https://github.com/tpope/vim-obsession
Plug 'tpope/vim-fugitive'               " Tim Pope's Git wrapper                                | https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-repeat'                 " Enable repeating supported plugin maps with '.'       | https://github.com/tpope/vim-repeat
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on                        | https://github.com/tpope/vim-sensible

" Testing & Tmux
Plug 'thoughtbot/vim-rspec'             " Run Rspec specs from Vim                              | https://github.com/thoughtbot/vim-rspec
Plug 'christoomey/vim-tmux-runner'      " Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner

call plug#end()

" Plugin-specifc Mappings & Settings

" nvim-completion-manager
if has('nvim')
  inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
  inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
endif

" UltiSnips
let g:UltiSnipsEditSplit = 'horizontal'
let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'

" Far.vim
let g:far#source = 'agnvim'
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.haml', '**/*.js', '**/*.css', '**/*.scss', '**/*.rb']

" ack.vim
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" NERDTree
nmap <silent> <F3> :NERDTreeToggle<CR>
map <leader>\ :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" GitGutter
nnoremap <F6> :GitGutterToggle<CR>
nnoremap <F7> :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_terminal_reports_focus=0

" GitGutter default mapping reference
" https://github.com/airblade/vim-gitgutter#getting-started
" <leader>hp - Preview hunk
" <leader>hs - Stage hunk
" <leader>hu - Undo hunk

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
set wildignore+=*/.git/*,*.tmp/*,*/.hg/*,*/.svn/*.,*/.DS_Store,*/tmp

" CtrlP -> directories to ignore when fuzzy finding
let g:ctrlp_custom_ignore = '\v[\/]((build|node_modules)|\.(git|sass-cache))$'

" Custom rails.vim commands
" command! Rroutes :e config/routes.rb
" command! RTroutes :tabe config/routes.rb
" command! RSroutes :sp config/routes.rb
" command! RVroutes :vs config/routes.rb
" command! Rfactories :e spec/factories.rb
" command! RTfactories :tabe spec/factories.rb
" command! RSfactories :sp spec/factories.rb
" command! RVfactories :vs spec/factories.rb

" ALE | https://github.com/w0rp/ale#1-supported-languages-and-tools
let g:ale_completion_enabled = 1
let g:ale_sign_error = '⌦'
let g:ale_sign_warning = '∙∙'

" Key mappings for dragvisuals.vim
runtime bundle/dragvisuals/plugins/dragvisuals.vim

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

" Tagbar
nmap <F8> :TagbarToggle<CR>
" }}}

" Appearance {{{

set background=dark
colorscheme solarized
let g:solarized_diffmode="high"
let g:solarized_termtrans = 1 " Use terminal background

highlight clear IncSearch
highlight IncSearch term=reverse cterm=reverse ctermfg=7 ctermbg=0 guifg=Black guibg=Yellow
highlight VertSplit ctermbg=NONE guibg=NONE

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

" Statusline appearance
set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=%<
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#CursorColumn#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %P
set statusline+=\ %l:%c
set statusline+=\ 
set statusline+=%{ObsessionStatus('●','❙❙','■')}
set statusline+=\ 
set statusline+=%m%h%r
" }}}

" Local {{{

if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
" }}}
