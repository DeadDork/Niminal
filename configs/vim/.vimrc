filetype plugin on
set grepprg=grep\ -nH\ $*
filetype indent on
let g:tex_flavor='latex'
"
" Turn on syntax
syntax on
"
" Turn on spelling highlighting for English
"set spell

nmap <C-S> :set spell spelllang=en_us
nmap <C-S><C-S> :set invspell
"
" Sets the tab and shift space to only 4 spaces
set tabstop=4
set shiftwidth=4
"
" Sets the list options (makes nested code TONS more legible)
set list
set lcs=tab:│·,extends:>,precedes:<,nbsp:&
"
" The following sets the colors.
" REVISION 2-24-2012: can't get 256 colors to work right in urxvt, so
" turning off 256 colors in vim.
set t_Co=256
colors phd
"
" This turns on cursorcolumn & cursorline
set cursorline
set cursorcolumn
"
" Set line number
set nu
nmap <C-N> :set nu
nmap <C-N><C-N> :set invnumber
"
" GUI config
set guioptions=a
"
" Let's vim open .docx, xlsx, etc.
au BufReadCmd *.docx,*.xlsx,*.pptx call zip#Browse(expand("<amatch>"))
au BufReadCmd *.odt,*.ott,*.ods,*.ots,*.odp,*.otp,*.odg,*.otg call zip#Browse(expand("<amatch>"))

" Necessary for r-plugin
set nocompatible
syntax enable
let vimrplugin_screenplugin = 1
