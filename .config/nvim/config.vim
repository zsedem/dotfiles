syntax on
filetype on
set breakindent
set breakindentopt=sbr
set colorcolumn=120
set cursorline
set expandtab
set foldmethod=indent
set foldlevel=99
set history=1000
set ignorecase
set incsearch
set list
set listchars=tab:▸▸,trail:·
set number
set ruler
set shiftwidth=4
set showbreak=↪\ 
set showmode
set smartcase
set smartcase
set softtabstop=4
set timeout
set timeoutlen=400
set title
set tw=120
set wildignore+=*\\tmp\\*,*.hi,*.swp,*.swo,*.o,*.zip,.git,.cabal-sandbox,node_modules,.stack-work

" NeoMake
autocmd BufWritePost * Neomake

" Workaround a problem with gitgutter async
let g:gitgutter_async = 0
