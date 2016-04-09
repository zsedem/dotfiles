filetype off
set nocompatible

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'airblade/vim-gitgutter'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'ervandew/supertab.git'
Plugin 'scrooloose/syntastic.git'
Plugin 'scrooloose/nerdtree.git'
Plugin 'VundleVim/Vundle.vim'
Plugin 'Xuyuanp/nerdtree-git-plugin.git'

call vundle#end()
filetype plugin on
filetype plugin indent on
syntax on

set number
set nowrap
set ruler
set showmode
set tw=120
set smartcase
set smarttab
set smartindent
set autoindent
set softtabstop=4
set shiftwidth=4
set expandtab
set incsearch
set mouse=a
set history=1000
set completeopt=menuone,menu,longest
set wildignore+=*\\tmp\\*,*.swp,*.swo,*.zip,.git,.cabal-sandbox
set wildmode=longest,list,full
set wildmenu
set completeopt+=longest
set t_Co=256
set cmdheight=1
set cursorline
set colorcolumn=120
set nobackup
set nowritebackup
set noswapfile
set list
set listchars=tab:▸▸,trail:·
set showtabline=2
set laststatus=2

" folding method
set foldmethod=indent
set foldlevel=99
" Line moving
nmap <C-j> ddp
nmap <C-k> ddkP
imap <C-j> <ESC>ddpi
imap <C-k> <ESC>ddkPi

" easy buffer navigation
map <C-t> <ESC>:enew<CR>
map <C-l> <ESC>:bnext<CR>
map <C-h> <ESC>:bprev<CR>
" map <C-w> <ESC>:bp <BAR> bd #<CR>

" git-gutter
hi clear SignColumn

" Syntastic
map <Leader>s :SyntasticToggleMode<CR>
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {'mode': 'active', 'passive_filetypes': ['python'] }

" git rebase magic
function! RebaseActionToggle()
   let line = getline(".")
   let result = matchstr(line, "^\\a")
   let transitions = {'p': 'fixup', 's': 'pick', 'e': 'reword', 'f': 'edit', 'r': 'squash'}
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

" Powerline
set rtp+=/usr/lib/python3.5/site-packages/powerline/bindings/vim
" FZF
set rtp+=~/.fzf

function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction
