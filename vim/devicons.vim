" https://github.com/tiagofumo/vim-nerdtree-syntax-highlight#configuration

" Color Definitions
let s:brown       = '905532'
let s:aqua        = '3AFFDB'
let s:blue        = '689FB6'
let s:darkBlue    = '44788E'
let s:purple      = '834F79'
let s:lightPurple = '834F79'
let s:red         = 'AE403F'
let s:beige       = 'F5C06F'
let s:yellow      = 'F09F17'
let s:orange      = 'D4843E'
let s:darkOrange  = 'F16529'
let s:pink        = 'CB6F6F'
let s:salmon      = 'EE6E73'
let s:green       = '8FAA54'
let s:lightGreen  = '31B53E'
let s:white       = 'FFFFFF'
let s:rspec_red   = 'FE405F'
let s:git_orange  = 'F54D27'

" Color Configs
let g:NERDTreeExtensionHighlightColor = {}
let g:NERDTreeExtensionHighlightColor['haml'] = s:red

let g:NERDTreePatternMatchHighlightColor = {}
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red
let g:NERDTreePatternMatchHighlightColor['gitignore.*'] = s:git_orange
let g:NERDTreePatternMatchHighlightColor['gitconfig.*'] = s:git_orange
let g:NERDTreePatternMatchHighlightColor['gitmodules'] = s:git_orange
let g:NERDTreePatternMatchHighlightColor['gitmessage'] = s:git_orange
let g:NERDTreePatternMatchHighlightColor['Gemfile.*'] = s:red
let g:NERDTreePatternMatchHighlightColor['Rakefile'] = s:red
let g:NERDTreePatternMatchHighlightColor['Guardfile'] = s:red
let g:NERDTreePatternMatchHighlightColor['.*\.scss\.erb$'] = s:pink
let g:NERDTreePatternMatchHighlightColor['.*\.js\.erb$'] = s:beige
let g:NERDTreePatternMatchHighlightColor['.*\.html\.erb$'] = s:red
let g:NERDTreePatternMatchHighlightColor['vimrc$'] = s:green

" Filetypes
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['css'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['html'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['haml'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vim'] = ''

let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitignore.*'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitconfig.*'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmodules'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['gitmessage'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Gemfile.*'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Rakefile'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['Guardfile'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['vimrc$'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.scss\.erb$'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.js\.erb$'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*\.html\.erb$'] = ''

