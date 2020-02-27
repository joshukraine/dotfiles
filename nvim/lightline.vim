function! LightlineRelativepath()
  let relativepath = expand('%:f') !=# '' ? expand('%:f') : '[No Name]'
  let modified = &modified ? ' +' : ''
  return relativepath . modified
endfunction

function! LightlineFileformat()
  return winwidth(0) > 95 ? &fileformat : ''
endfunction

function! LightlineFiletype()
  return winwidth(0) > 95 ? (&filetype !=# '' ? &filetype : 'no ft') : ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 95 ? &fileencoding : ''
endfunction

function! LightlineObsession()
  return '%{ObsessionStatus("●", "", "■")}'
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

let g:lightline = {
    \   'colorscheme': 'solarized',
    \   'component': { 'lineinfo': '⭡ %3l:%-2v' },
    \ }

let g:lightline.component_function = {
    \  'relativepath': 'LightlineRelativepath',
    \  'fileformat': 'LightlineFileformat',
    \  'fileencoding': 'LightlineFileencoding',
    \  'readonly': 'LightlineReadonly',
    \  'cocstatus': 'coc#status',
    \  'currentfunction': 'CocCurrentFunction'
    \ }

let g:lightline.component_expand = {
    \  'obsession': 'LightlineObsession',
    \ }

let g:lightline.active = {
    \  'left': [ ['mode', 'paste'], ['relativepath', 'cocstatus', 'currentfunction', 'readonly'] ],
    \  'right': [ ['lineinfo'], ['percent'], ['filetype', 'fileencoding', 'fileformat', 'obsession'] ]
    \ }

let g:lightline.inactive = {
    \ 'left': [ [ 'relativepath'] ],
    \ 'right': [ [ 'lineinfo' ] ],
    \ }

let g:lightline.tabline = {
    \  'left': [ ['tabs'] ],
    \  'right': []
    \ }
