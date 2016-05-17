imap jj <ESC>

nmap <expr><Tab>   pumvisible() ? "\<C-n>" : ">>"
nmap <expr><S-Tab> pumvisible() ? "\<C-p>" : "<<"
vmap <expr><Tab>   pumvisible() ? "\<C-n>" : ">"
vmap <expr><S-Tab> pumvisible() ? "\<C-p>" : "<"

imap <expr><C-j>   pumvisible() ? "\<C-n>" : "\<C-j>"
imap <expr><C-k>   pumvisible() ? "\<C-p>" : "\<C-k>"
imap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
imap <expr><S-Tab>   pumvisible() ? "\<C-p>" : "\<S-Tab>"
imap <silent><expr><CR> pumvisible() ? deoplete#mappings#close_popup() : "\<CR>"

nmap <C-p> :GitFiles<CR>

nmap jww :w<CR>
nmap jwq :wq<CR>
nmap jqq :q<CR>

nmap : q:i
" Disables:
" Disable the right side of the keyboard
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
inoremap  <PageDown> <NOP>
inoremap  <PageUp> <NOP>
inoremap  <Home> <NOP>
inoremap  <End> <NOP>
inoremap  <Delete> <NOP>
inoremap  <Insert> <NOP>
noremap  <Up>     <NOP>
noremap  <Down>   <NOP>
noremap  <Left>   <NOP>
noremap  <Right>  <NOP>
noremap  <PageDown> <NOP>
noremap  <PageUp> <NOP>
noremap  <Home> <NOP>
noremap  <End> <NOP>
noremap  <Delete> <NOP>
noremap  <Insert> <NOP>
