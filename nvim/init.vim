" Settings {{{
" https://github.com/christoomey/vim-tmux-navigator/issues/72
set shell=/bin/bash\ -i

" Force vim to use older regex engine.
" https://stackoverflow.com/a/16920294/655204
set re=1

" set cmdheight=2

" No backup files
set nobackup

" No write backup
set nowritebackup

" No swap file
set noswapfile

" Show incomplete commands
set showcmd

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
set list listchars=tab:»·,trail:·,nbsp:+

" UTF encoding
set encoding=utf-8

" Use system clipboard
" http://stackoverflow.com/questions/8134647/copy-and-paste-in-vim-via-keyboard-between-different-mac-terminals
set clipboard+=unnamed

" don't give |ins-completion-menu| messages.
set shortmess+=c

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

set grepprg=rg

let g:grep_cmd_opts = '--line-numbers --noheading --ignore-dir=log --ignore-dir=tmp'

set inccommand=nosplit

set updatetime=300

" set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
"       \,a:blinkwait0-blinkoff400-blinkon250-Cursor/lCursor
"       \,sm:block-blinkwait0-blinkoff150-blinkon175

" Need this when using material colorscheme
" if (has("termguicolors"))
"   set termguicolors
" endif

" Keep focus split wide, others narrow.
set winwidth=90
set winminwidth=5

" Keep focus split at max height, others minimal.
set winheight=1
set winminheight=1
" The line below maximzes the window height on enter. Unfortunately it also
" maximizes the height of some floating windows. Disabling for now.
" autocmd WinEnter * wincmd _

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
  autocmd Bufread,BufNewFile *.asciidoc,*.adoc,*.asc,*.ad set filetype=asciidoctor
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

" automatically rebalance windows on vim resize
augroup window_resize
  autocmd!
  autocmd VimResized * :wincmd =
augroup END
" }}}

" Mappings {{{
let mapleader = "\<Space>"

" Misc
map <leader>r :source $XDG_CONFIG_HOME/nvim/init.vim<CR>
map <leader>q :q<CR>
map <leader>w :w<CR>
map <leader>x :x<CR>
map <leader>ra :%s/
map <leader>p :set paste<CR>""p:set nopaste<CR> " Fix indentation on paste
map <leader>h :nohl<CR> " Clear highlights
map <leader>s :%s/\s\+$//e<CR> " Manually clear trailing whitespace
inoremap <C-[> <Esc>:w<CR> " Return to normal mode faster + write file
inoremap jj <C-c> " jj to switch back to normal mode
nnoremap <leader>4 <c-^> " Switch between the last two files
nnoremap <leader>5 :bnext<CR>
nnoremap <leader>6 :bprev<CR>
map <C-t> <esc>:tabnew<CR> " Open a new tab with Ctrl+T

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

" Maximize the height of the current window.
nnoremap <leader>0 :wincmd _<cr>

" Write files as sudo
cmap w!! w !sudo tee >/dev/null %
" }}}

" Plugins {{{
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | exe 'source' stdpath('config') . '/init.vim'
endif
unlet autoload_plug_path

call plug#begin(stdpath('data') . '/plugged')

" General
Plug 'godlygeek/tabular'                " Vim script for text filtering and alignment           | https://github.com/godlygeek/tabular
Plug 'tomtom/tcomment_vim'              " An extensible & universal comment vim-plugin          | https://github.com/tomtom/tcomment_vim
Plug 'vim-scripts/BufOnly.vim'          " Delete all the buffers except current/named buffer    | https://github.com/vim-scripts/BufOnly.vim
Plug 'jlanzarotta/bufexplorer'          " Open/close/navigate vim's buffers                     | https://github.com/jlanzarotta/bufexplorer
Plug 'majutsushi/tagbar'                " A class outline viewer for vim                        | https://github.com/majutsushi/tagbar
Plug 'ntpeters/vim-better-whitespace'   " Better whitespace highlighting for                    | https://github.com/ntpeters/vim-better-whitespace
Plug 'machakann/vim-highlightedyank'    " Make the yanked region apparent!                      | https://github.com/machakann/vim-highlightedyank
Plug 'diepm/vim-rest-console'           " A REST console for Vim.                               | https://github.com/diepm/vim-rest-console
Plug 'rhysd/git-messenger.vim'          " Reveal the commit messages under the cursor           | https://github.com/rhysd/git-messenger.vim
Plug 'terryma/vim-multiple-cursors'     " True Sublime Text style multiple selections for Vim   | https://github.com/terryma/vim-multiple-cursors
Plug 'airblade/vim-gitgutter'           " A Vim plugin which shows a git diff in the gutter     | https://github.com/airblade/vim-gitgutter
Plug 'webdevel/tabulous'                " Vim plugin for setting the tabline                    | https://github.com/webdevel/tabulous
Plug 'jiangmiao/auto-pairs'             " insert or delete brackets, parens, quotes in pair     | https://github.com/jiangmiao/auto-pairs

" Code Completion
Plug 'neoclide/coc.nvim',
      \ {'branch': 'release'}           " Intellisense engine for vim8 & neovim                 | https://github.com/neoclide/coc.nvim
" Plug 'honza/vim-snippets'               " Snippets files for various programming languages      | https://github.com/honza/vim-snippets
Plug 'joshukraine/vue-vscode-snippets', { 'branch': 'js/concat-snippets' }

" Ruby-specific
Plug 'vim-ruby/vim-ruby'                " Vim/Ruby Configuration Files                          | https://github.com/vim-ruby/vim-ruby
Plug 'kana/vim-textobj-user'            " Create your own text objects                          | https://github.com/kana/vim-textobj-user
Plug 'nelstrom/vim-textobj-rubyblock'   " A custom text object for selecting ruby blocks        | https://github.com/nelstrom/vim-textobj-rubyblock

" Searching and Navigation
Plug 'ctrlpvim/ctrlp.vim'               " Active fork of kien/ctrlp.vim—Fuzzy file finder       | https://github.com/ctrlpvim/ctrlp.vim
Plug 'scrooloose/nerdtree'              " A tree explorer plugin for vim                        | https://github.com/scrooloose/nerdtree
Plug 'Xuyuanp/nerdtree-git-plugin'      " A plugin of NERDTree showing git status               | https://github.com/Xuyuanp/nerdtree-git-plugin
Plug 'brooth/far.vim'                   " Find And Replace Vim plugin                           | https://github.com/brooth/far.vim
Plug 'christoomey/vim-tmux-navigator'   " Seamless navigation between tmux panes and vim splits | https://github.com/christoomey/vim-tmux-navigator
Plug 'easymotion/vim-easymotion'        " Vim motions on speed!                                 | https://github.com/easymotion/vim-easymotion
Plug 'ryanoasis/vim-devicons'           " Adds file type icons to Vim                           | https://github.com/ryanoasis/vim-devicons

" Colors and Syntax Highlighting
Plug 'altercation/vim-colors-solarized' " Precision colorscheme for the vim text editor         | https://github.com/altercation/vim-colors-solarized
" Plug 'kaicataldo/material.vim'          " Vim/Neovim Material color scheme                      | https://github.com/kaicataldo/material.vim
Plug 'hail2u/vim-css3-syntax'           " CSS3 syntax                                           | https://github.com/hail2u/vim-css3-syntax
Plug 'cakebaker/scss-syntax.vim'        " Vim syntax file for scss (Sassy CSS)                  | https://github.com/cakebaker/scss-syntax.vim
Plug 'pangloss/vim-javascript',
      \ { 'for': ['javascript', 'vue']
      \}                                " Javascript indentation and syntax support in Vim.     | https://github.com/pangloss/vim-javascript
Plug 'posva/vim-vue'                    " Syntax Highlight for Vue.js components                | https://github.com/posva/vim-vue
Plug 'elzr/vim-json'                    " A better JSON for Vim                                 | https://github.com/elzr/vim-json
Plug 'digitaltoad/vim-pug'              " Vim syntax highlighting for Pug templates             | https://github.com/digitaltoad/vim-pug
Plug 'habamax/vim-asciidoctor'          " Asciidoctor plugin for Vim                            | https://github.com/habamax/vim-asciidoctor
Plug 'dag/vim-fish'                     " Vim support for editing fish scripts                  | https://github.com/dag/vim-fish
Plug 'cespare/vim-toml'                 " Vim syntax for TOML                                   | https://github.com/cespare/vim-toml
Plug 'leafgarland/typescript-vim'       " Typescript syntax files for Vim                       | https://github.com/leafgarland/typescript-vim

" Tim Pope
Plug 'tpope/vim-endwise'                " Add 'end' keyword when needed                         | https://github.com/tpope/vim-endwise
Plug 'tpope/vim-surround'               " Quoting/parenthesizing made simple                    | https://github.com/tpope/vim-surround
Plug 'tpope/vim-rails'                  " Ruby on Rails power tools                             | https://github.com/tpope/vim-rails
Plug 'tpope/vim-obsession'              " Continuously updated session files                    | https://github.com/tpope/vim-obsession
Plug 'tpope/vim-fugitive'               " Tim Pope's Git wrapper                                | https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-repeat'                 " Enable repeating supported plugin maps with '.'       | https://github.com/tpope/vim-repeat
Plug 'tpope/vim-sensible'               " Defaults everyone can agree on                        | https://github.com/tpope/vim-sensible

" Testing & Tmux
Plug 'janko/vim-test'                   " Run your tests at the speed of thought                | https://github.com/janko/vim-test
Plug 'christoomey/vim-tmux-runner'      " Command runner for sending commands from vim to tmux. | https://github.com/christoomey/vim-tmux-runner

call plug#end()

" Plugin-specifc Mappings & Settings

" Far.vim
let g:far#source = 'agnvim'
let g:far#file_mask_favorites = ['%', '**/*.*', '**/*.html', '**/*.haml', '**/*.js', '**/*.css', '**/*.scss', '**/*.rb']

" NERDTree
nmap <silent> <F3> :NERDTreeToggle<CR>
map <leader>\ :NERDTreeToggle<CR>
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.png$', '\.jpg$', '\.gif$', '\.mp3$', '\.ogg$', '\.mp4$',
                  \ '\.avi$','.webm$','.mkv$','\.pdf$', '\.zip$', '\.tar.gz$',
                  \ 'node_modules$', '\.rar$']
let NERDTreeMinimalUI = 1
let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''

let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "*",
    \ "Staged"    : "+",
    \ "Untracked" : "?",
    \ "Renamed"   : "»",
    \ "Unmerged"  : "ǁ",
    \ "Deleted"   : "✘",
    \ "Dirty"     : "*",
    \ "Clean"     : "",
    \ "Ignored"   : "☒",
    \ "Unknown"   : "??"
    \ }

" Vim DevIcons
exe 'source' stdpath('config') . '/extras/devicons.vim'

" GitGutter
nnoremap <F6> :GitGutterToggle<CR>
nnoremap <F7> :GitGutterLineHighlightsToggle<CR>
let g:gitgutter_terminal_reports_focus=0
let g:gitgutter_preview_win_floating = 0

nmap ]g <Plug>(GitGutterNextHunk)
nmap [g <Plug>(GitGutterPrevHunk)

" GitGutter default mapping reference
" https://github.com/airblade/vim-gitgutter#getting-started
" <leader>hp - Preview hunk
" <leader>hs - Stage hunk
" <leader>hu - Undo hunk

" GitMessenger
nmap <Leader>m <Plug>(git-messenger)

" Tcomment
map <leader>/ :TComment<CR>

" Bufexplorer
let g:bufExplorerDisableDefaultKeyMapping=1
nnoremap <silent> <F4> :BufExplorer<CR>

" Obsession
map <leader>ob :Obsession<CR>

" vim-test
nmap <silent> t<C-n> :TestNearest<CR>
nmap <silent> t<C-f> :TestFile<CR>
nmap <silent> t<C-s> :TestSuite<CR>
nmap <silent> t<C-l> :TestLast<CR>
nmap <silent> t<C-g> :TestVisit<CR>
let test#strategy = 'vtr'

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
map <leader>t :CtrlP<CR>
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

" Key mappings for dragvisuals.vim
exe 'source' stdpath('config') . '/extras/dragvisuals.vim'

vmap  <expr>  <LEFT>   DVB_Drag('left')
vmap  <expr>  <RIGHT>  DVB_Drag('right')
vmap  <expr>  <DOWN>   DVB_Drag('down')
vmap  <expr>  <UP>     DVB_Drag('up')
vmap  <expr>  D        DVB_Duplicate()

" Remove any introduced trailing whitespace after moving...
let g:DVB_TrimWS = 1

" Tagbar
nmap <F8> :TagbarToggle<CR>

" Tabulous
let tabulousLabelModifiedStr = '[+] '
let tabulousCloseStr = ''
let tabulousLabelNameOptions = ':t'

" Vim REST Console (VRC)
let g:vrc_curl_opts = {
  \ '-L': '',
  \ '-i': '',
\}

" Coc
" https://github.com/neoclide/coc.nvim

" Global extension names to install when they aren't installed
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-eslint',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-marketplace',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-stylelintplus',
  \ 'coc-tailwindcss',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-yaml',
  \ ]

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

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

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

" Comment highlighting for jsonc
autocmd FileType json syntax match Comment +\/\/.\+$+

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

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

highlight CocErrorSign ctermfg=160 ctermbg=0
highlight CocWarningSign ctermfg=178 ctermbg=0
highlight CocInfoSign ctermfg=33 ctermbg=0
highlight CocHintSign ctermfg=226 ctermbg=0

highlight TabLine     ctermfg=11 ctermbg=0 cterm=reverse
highlight TabLineFill ctermfg=11 ctermbg=0 cterm=reverse
highlight TabLineSel  ctermfg=15 ctermbg=4 cterm=NONE

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
set statusline+=%#PmenuSel#%{coc#status()}%{get(b:,'coc_current_function','')}
set statusline+=%<
set statusline+=\ %#StatusLine#
set statusline+=\ %f
set statusline+=%m
set statusline+=\ %#CursorLine#
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\[%{&fileformat}\]
set statusline+=\ %#StatusLine#
set statusline+=\ %P
set statusline+=\ %l:%c
set statusline+=\ %{ObsessionStatus('●','','■')}
set statusline+=\ %h
set statusline+=%r
" }}}

" Local {{{
if filereadable(glob("$HOME/.vimrc.local"))
  source $HOME/.vimrc.local
endif
" }}}

" vim: fdm=marker fen
