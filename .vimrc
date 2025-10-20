"=== VIM SETTINGS ===================================="

set nocompatible

call plug#begin()

Plug 'devsjc/vim-jb'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'airblade/vim-gitgutter'     " Git plus/minus on left

call plug#end()

let g:coc_global_extensions = [
  \ 'coc-kotlin',
  \ 'coc-sh',
  \ 'coc-tsserver', 
  \ 'coc-pyright',
  \ 'coc-spell-checker',
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

nnoremap <leader>c :botright term<CR>

colorscheme jb

