"=== VIM SETTINGS ===================================="

set nocompatible

call plug#begin()

Plug 'devsjc/vim-jb'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax

call plug#end()

let g:coc_global_extensions = [
  \ 'coc-kotlin',
  \ 'coc-sh',
  \ 'coc-tsserver', 
  \ ]

unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

syntax enable
filetype plugin indent on
set hlsearch incsearch ignorecase
set number relativenumber
set encoding=UTF-8

if $COLORTERM == 'truecolor'
  set termguicolors
endif

let mapleader="\<space>"
nnoremap <leader>c :botright term<CR>

colorscheme jb

