filetype plugin indent on

if has("syntax")
  syntax on
endif

set encoding=utf-8
set fileencoding=utf-8
set nocompatible
"filetype off
set wrap
set number

inoremap jj <ESC>
inoremap """ """"""<left><left><left>
inoremap "" ""
inoremap " ""<left>
inoremap '' ''
inoremap ' ''<left>
inoremap () ()
inoremap ( ()<left>
inoremap [] []
inoremap [ []<left>
inoremap {} {}
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O
set tabstop=4
set shiftwidth=4
set scrolloff=5
set backspace=indent,eol,start
set showmode
set showcmd

