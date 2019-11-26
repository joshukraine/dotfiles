" https://github.com/ryanoasis/vim-devicons/wiki/Extra-Configuration

" https://github.com/ryanoasis/vim-devicons/pull/135
let g:WebDevIconsOS = 'Darwin'

if exists("g:loaded_webdevicons")
  call webdevicons#refresh()
endif

" Custom Icons
" https://www.nerdfonts.com/cheat-sheet
let s:css3  = ''
let s:git   = ''
let s:haml  = ''
let s:html5 = ''
let s:js    = ''
let s:md    = ''
let s:ruby  = ''
let s:sass  = ''
let s:vim   = ''
let s:gulp   = ''

" Filetypes
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css']  = s:css3
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = s:html5
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['haml'] = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim']  = s:vim
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']  = s:md
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['js']  = s:js

let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitignore.*']    = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitconfig.*']    = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmodules']     = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmessage']     = s:git
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Gemfile.*']      = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Rakefile']       = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Guardfile']      = s:ruby
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['vimrc$']         = s:vim
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.scss\.erb$'] = s:sass
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.js\.erb$']   = s:js
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.html\.erb$'] = s:haml
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gulpfile.js']    = s:gulp

autocmd filetype nerdtree highlight html_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight haml_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight git_icon ctermbg=none ctermfg=166 guifg=#ffa500
autocmd filetype nerdtree highlight ruby_icon ctermbg=none ctermfg=160 guifg=#d70000
autocmd filetype nerdtree highlight css_icon ctermbg=none ctermfg=32 guifg=#ffa500
autocmd filetype nerdtree highlight yml_icon ctermbg=none ctermfg=195 guifg=#d7ffff
autocmd filetype nerdtree highlight md_icon ctermbg=none ctermfg=31 guifg=#0087af
autocmd filetype nerdtree highlight js_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight json_icon ctermbg=none ctermfg=178 guifg=#d7af00
autocmd filetype nerdtree highlight vue_icon ctermbg=none ctermfg=29 guifg=#00875f
autocmd filetype nerdtree highlight scss_icon ctermbg=none ctermfg=205 guifg=#ff5faf
autocmd filetype nerdtree highlight vim_icon ctermbg=none ctermfg=28 guifg=#008700
autocmd filetype nerdtree highlight gulpfile_icon ctermbg=none ctermfg=124 guifg=#af0000
autocmd filetype nerdtree highlight sh_icon ctermbg=none ctermfg=97 guifg=#875faf
autocmd filetype nerdtree highlight license_icon ctermbg=none ctermfg=195 guifg=#d7ffff

autocmd filetype nerdtree syn match html_icon ## containedin=NERDTreeFile,html
autocmd filetype nerdtree syn match haml_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match git_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match ruby_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match css_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match yml_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match md_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match js_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match json_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match vue_icon #﵂# containedin=NERDTreeFile
autocmd filetype nerdtree syn match scss_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match vim_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match gulpfile_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match sh_icon ## containedin=NERDTreeFile
autocmd filetype nerdtree syn match license_icon ## containedin=NERDTreeFile
