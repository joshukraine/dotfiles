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
