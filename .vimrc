set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'

call vundle#end()

filetype plugin indent on
set colorcolumn=120
syntax on

set nobackup
set nowritebackup
set noswapfile
set noundofile

" easy tab navigation
map <C-k> <ESC>ddkkp
map <C-j> <ESC>ddp
map <C-t> <ESC>:tabnew
map <C-l> <ESC>:tabn<CR>
map <C-h> <ESC>:tabp<CR>

" split pane navigation
nmap <silent> <a-k> :wincmd k<CR>
nmap <silent> <a-j> :wincmd j<CR>
nmap <silent> <a-h> :wincmd h<CR>
nmap <silent> <a-l> :wincmd l<CR>

" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b = '%{strftime("%c")}'


" git-gutter
hi clear SignColumn
