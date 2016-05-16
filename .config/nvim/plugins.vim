set runtimepath^=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim

call dein#begin(expand('~/.cache/nvim/dein'))
call dein#add('Shougo/dein.vim')
call dein#add('Shougo/vimproc.vim', {'build': 'make'})
call dein#add('eagletmt/neco-ghc', {'on_ft': 'haskell'})
call dein#add('Shougo/deoplete.nvim')
call dein#add('Shougo/neco-vim')
call dein#add('Quramy/tsuquyomi')
call dein#add('mhartington/deoplete-typescript', {'on_ft': 'typescript'})
call dein#add('leafgarland/typescript-vim', {'on_ft': 'typescript'})
call dein#add('/home/zsedem/.fzf/')
call dein#add('junegunn/fzf.vim')

call dein#end()

filetype plugin indent on

if dein#check_install()
  call dein#install()
endif

let g:deoplete#enable_at_startup = 1
