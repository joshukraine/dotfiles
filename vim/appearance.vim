" set background=light " light theme
set background=dark " dark theme
let g:solarized_diffmode="high"
colorscheme solarized


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

" Always show statusline
set laststatus=2

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
set statusline+=%m%h%r
