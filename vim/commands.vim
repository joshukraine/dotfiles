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
autocmd FileType sh,cucumber,ruby,yaml,html,xml,zsh,vim,css,scss,javascript,json,gitconfig setlocal shiftwidth=2 tabstop=2 expandtab

" autoindent with two spaces, always expand tabs
autocmd FileType ruby,eruby,yaml setlocal ai sw=2 sts=2 et
autocmd FileType ruby,eruby,yaml setlocal path+=lib

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
