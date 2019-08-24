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

" Don't break long lines in insert mode.
set formatoptions=l

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

" always show signcolumns
set signcolumn=auto

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

" Need this when using material colorscheme
" if (has("termguicolors"))
"   set termguicolors
" endif

" Keep focus split wide, others narrow.
set winwidth=90
set winminwidth=5

" Keep focus split at max height, others minimal.
function! SetWindowHeight()
  set winheight=7
  set winminheight=7
  set winheight=999
endfunction

" Reset window height to avoid session errors.
function! ResetWindowHeight()
  set winminheight=0
  set winheight=1
endfunction

" Requires 'jq' (brew install jq)
function! s:PrettyJSON()
  %!jq .
  set filetype=json
  normal zR
endfunction
command! PrettyJSON :call <sid>PrettyJSON()
" }}}

" Commands {{{

" specify syntax highlighting for specific files
augroup file_types
  autocmd!
  autocmd Bufread,BufNewFile *.spv set filetype=php
  autocmd Bufread,BufNewFile *Brewfile,pryrc set filetype=ruby
  autocmd Bufread,BufNewFile *prettierrc,*stylelintrc,*browserslistrc,*babelrc set filetype=json
  autocmd Bufread,BufNewFile aliases,functions,prompt,tmux,oh-my-zsh,opts set filetype=zsh
  autocmd Bufread,BufNewFile *.md set filetype=markdown " Vim interprets .md as 'modula2' otherwise, see :set filetype?
  autocmd Bufread,BufNewFile gitconfig set filetype=gitconfig
augroup END

" Remove trailing whitespace on save for specified file types.
augroup clear_whitespace
  autocmd!
  au BufWritePre *.rb,*.yml,*.erb,*.haml,*.css,*.scss,*.js,*.coffee,*.vue :%s/\s\+$//e
augroup END

" Fold settings
augroup fold_settings
  autocmd!
  autocmd FileType json setlocal foldmethod=syntax
  autocmd FileType json normal zR
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
Plug 'machakann/vim-highlightedyank'    " Make the yanked region apparent!                      | https://github.com/machakann/vim-highlightedyank
Plug 'diepm/vim-rest-console'           " A REST console for Vim.                               | https://github.com/diepm/vim-rest-console
Plug 'rhysd/git-messenger.vim'          " Reveal the commit messages under the cursor           | https://github.com/rhysd/git-messenger.vim

" Code Completion
Plug 'neoclide/coc.nvim',
      \ {'branch': 'release'}           " Intellisense engine for vim8 & neovim                 | https://github.com/neoclide/coc.nvim
Plug 'mattn/emmet-vim'                  " emmet for vim                                         | https://github.com/mattn/emmet-vim

" Ruby-specific
Plug 'vim-ruby/vim-ruby'                " Vim/Ruby Configuration Files                          | https://github.com/vim-ruby/vim-ruby
Plug 'kana/vim-textobj-user'            " Create your own text objects                          | https://github.com/kana/vim-textobj-user
Plug 'nelstrom/vim-textobj-rubyblock'   " A custom text object for selecting ruby blocks        | https://github.com/nelstrom/vim-textobj-rubyblock

" Searching and Navigation
Plug 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file finder       | https://github.com/ctrlpvim/ctrlp.vim
Plug 'scrooloose/nerdtree'              " A tree explorer plugin for vim                        | https://github.com/scrooloose/nerdtree
Plug 'brooth/far.vim'                   " Find And Replace Vim plugin                           | https://github.com/brooth/far.vim
Plug 'skwp/greplace.vim'                " Global search and replace for VI                      | https://github.com/skwp/greplace.vim
Plug 'mileszs/ack.vim'                  " Vim plugin for the Perl module / CLI script 'ack'     | https://github.com/mileszs/ack.vim
Plug 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
Plug 'joshukraine/dragvisuals'          " Damian Conway's dragvisuals plugin for vim            | https://github.com/joshukraine/dragvisuals
Plug 'easymotion/vim-easymotion'        " Vim motions on speed!                                 | https://github.com/easymotion/vim-easymotion
Plug 'francoiscabrol/ranger.vim'        " Ranger integration in vim and neovim                  | https://github.com/francoiscabrol/ranger.vim
Plug 'rbgrouleff/bclose.vim'            " Dependency of ranger.vim                              | https://github.com/rbgrouleff/bclose.vim

" Colors and Syntax Highlighting
Plug 'altercation/vim-colors-solarized' " Precision colorscheme for the vim text editor         | https://github.com/altercation/vim-colors-solarized
" Plug 'kaicataldo/material.vim'          " Vim/Neovim Material color scheme                      | https://github.com/kaicataldo/material.vim
Plug 'hail2u/vim-css3-syntax'           " CSS3 syntax                                           | https://github.com/hail2u/vim-css3-syntax
Plug 'cakebaker/scss-syntax.vim'        " Vim syntax file for scss (Sassy CSS)                  | https://github.com/cakebaker/scss-syntax.vim
Plug 'pangloss/vim-javascript',
      \ { 'for': ['javascript', 'vue']
      \}                                " Javascript indentation and syntax support in Vim.     | https://github.com/pangloss/vim-javascript
Plug 'posva/vim-vue'                    " Syntax Highlight for Vue.js components                | https://github.com/posva/vim-vue
Plug 'chrisbra/Colorizer'               " A plugin to color colornames and codes                | https://github.com/chrisbra/Colorizer
Plug 'elzr/vim-json'                    " A better JSON for Vim                                 | https://github.com/elzr/vim-json

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
let NERDTreeIgnore=['\.png$', '\.jpg$', '\.gif$', '\.mp3$', '\.ogg$', '\.mp4$',
                  \ '\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$',
                  \ '\.rar$']

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
let g:rspec_command = 'VtrSendCommandToRunner! clear; rspec {spec}'

" vim-tmux-runner
let g:VtrPercentage = 25
let g:VtrUseVtrMaps = 1
nnoremap <leader>sd :VtrSendCtrlD<cr>
nmap <leader>fs :VtrFlushCommand<cr>:VtrSendCommandToRunner<cr>
nmap <leader>v3 :VtrAttachToPane 3<cr>
nmap <leader>v4 :VtrAttachToPane 4<cr>
nmap <leader>osp :VtrOpenRunner {'orientation': 'h', 'percentage': 25, 'cmd': '' }<cr>
nmap <leader>orc :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'rc'}<cr>
nmap <leader>opr :VtrOpenRunner {'orientation': 'h', 'percentage': 40, 'cmd': 'pry'}<cr>

" vim-tmux-runner default mappings
" nnoremap <leader>va :VtrAttachToPane<cr>
" nnoremap <leader>ror :VtrReorientRunner<cr>
" nnoremap <leader>sc :VtrSendCommandToRunner<cr>
" nnoremap <leader>sl :VtrSendLinesToRunner<cr>
" vnoremap <leader>sl :VtrSendLinesToRunner<cr>
" nnoremap <leader>or :VtrOpenRunner<cr>
" nnoremap <leader>kr :VtrKillRunner<cr>
" nnoremap <leader>fr :VtrFocusRunner<cr>
" nnoremap <leader>dr :VtrDetachRunner<cr>
" nnoremap <leader>cr :VtrClearRunner<cr>
" nnoremap <leader>fc :VtrFlushCommand<cr>
" nnoremap <leader>sf :VtrSendFile<cr>

" CtrlP
map <leader>t <C-p>
map <leader>y :CtrlPBuffer<CR>
let g:ctrlp_show_hidden = 1
let g:ctrlp_working_path_mode = 0
let g:ctrlp_max_height = 15

" CtrlP -> override <C-o> to provide options for how to open files
let g:ctrlp_arg_map = 1

" CtrlP -> files matched are ignored when expanding wildcards
set wildignore+=*/.git/*,*.tmp/*,*/.hg/*,*/.svn/*.,*/.DS_Store,*/tmp,*/dist,*/.nuxt

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

let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'css': ['prettier'],
      \ 'vue': ['stylelint', 'prettier', 'eslint'],
      \}

let g:ale_linters = {
      \ 'javascript': ['eslint'],
      \ 'css': ['prettier'],
      \ 'vue': ['stylelint', 'prettier', 'eslint'],
      \}

let g:ale_linter_aliases = {'vue': ['javascript', 'css']}

let g:ale_pattern_options = {
\   '.*\.json$': {'ale_enabled': 0}
\}

" Key mappings for dragvisuals.vim
runtime plugged/dragvisuals/plugins/dragvisuals.vim

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Colorizer
let g:colorizer_auto_filetype='css,html,javascript,vue'

" Vim REST Console (VRC)
let g:vrc_curl_opts = {
  \ '-L': '',
  \ '-i': '',
\}

" Ranger.vim
let g:ranger_map_keys = 0
map <leader>k :Ranger<CR>

" Coc
" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> {c <Plug>(coc-diagnostic-prev)
nmap <silent> }c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-git
" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)
" Stage current chunk
nmap <leader>hs :CocCommand git.chunkStage<CR>
" Undo current chunk
nmap <leader>hu :CocCommand git.chunkUndo<CR>
" Fold unchanged lines of current buffer
nmap <leader>fu :CocCommand git.foldUnchanged<CR>

" }}}

" Appearance {{{

set background=dark
colorscheme solarized
let g:solarized_diffmode="high"
let g:solarized_termtrans = 1 " Use terminal background
" colorscheme material

highlight clear IncSearch
highlight IncSearch term=reverse cterm=reverse ctermfg=7 ctermbg=0 guifg=Black guibg=Yellow
highlight VertSplit ctermbg=NONE guibg=NONE
highlight SignColumn ctermfg=10 ctermbg=0 guifg=Yellow

" Statusline appearance
set statusline=
set statusline^=\ %{get(g:,'coc_git_status','')}%{get(b:,'coc_git_status','')}%{get(b:,'coc_git_blame','')}
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=%#PmenuSel#
set statusline+=%#CursorLine#
set statusline+=%<
set statusline+=\ %f
set statusline+=%m
set statusline+=%=
set statusline+=%#StatusLine#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %P
set statusline+=\ %l:%c
set statusline+=\ 
set statusline+=%{ObsessionStatus('●','❙❙','■')}
set statusline+=\ 
set statusline+=%h%r
" }}}

" Local {{{

if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
" }}}

" vim: fdm=marker fen
