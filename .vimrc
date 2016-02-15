filetype off
set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'tpope/vim-fugitive'
Plugin 'kien/ctrlp.vim'
Plugin 'bitc/vim-hdevtools'

call vundle#end()

filetype plugin on
filetype plugin indent on
set colorcolumn=120
syntax on

set number
set nobackup
set nowritebackup
set noswapfile
set noundofile
set list
set listchars=tab:▸·,trail:·
" File save/exit
imap <C-x> <ESC>:q<CR>
nmap <C-x> :q<CR>

" Line moving
nmap <C-j> ddp
nmap <C-k> ddkkp
imap <C-j> <ESC>ddpi
imap <C-k> <ESC>ddkkpi

" easy tab navigation
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

" multiline-editing
let g:multi_cursor_exit_from_visual_mode = 0
let g:multi_cursor_exit_from_insert_mode = 0
let g:multi_cursor_use_default_mapping = 0

let g:multi_cursor_next_key='<C-d>'
let g:multi_cursor_prev_key='<C-S-d>'
let g:multi_cursor_skip_key='<C-k>'
let g:multi_cursor_quit_key='<Esc>'

" git rebase magic
function RebaseActionToggle()
   let line = getline(".")
   let result = matchstr(line, "^\\a")
   let transitions = {'p': 'fixup', 's': 'pick', 'e': 'squash', 'f': 'edit'}
   execute "normal! ^cw" . transitions[result]
endfunction

autocmd FileType gitrebase noremap <Cr> :call RebaseActionToggle()<Cr>

" Commenting blocks of code.
autocmd FileType c,cpp,java,scala let b:comment_leader = '// '
autocmd FileType sh,ruby,python   let b:comment_leader = '# '
autocmd FileType conf,fstab       let b:comment_leader = '# '
autocmd FileType tex              let b:comment_leader = '% '
autocmd FileType mail             let b:comment_leader = '> '
autocmd FileType vim              let b:comment_leader = '" '
autocmd FileType haskell          let b:comment_leader = '-- '
noremap <silent> ,cc :<C-B>silent <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:nohlsearch<CR>
noremap <silent> ,cu :<C-B>silent <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:nohlsearch<CR>

