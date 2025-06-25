set background=light
set termguicolors
colorscheme envy
set mouse=a
set undofile
set virtualedit=block,onemore
set autowriteall
set splitbelow splitright
set gdefault ignorecase smartcase
set tabstop=4 softtabstop=4 shiftwidth=4
set title
set showcmd
set scrolloff=2 sidescrolloff=4
if has('nvim-0.10')
	set smoothscroll completeopt+=popup
endif
set diffopt+=context:3,vertical,indent-heuristic,algorithm:histogram,linematch:60
set completeopt-=preview
set clipboard=unnamed
set signcolumn=yes
set wrap linebreak breakindent breakindentopt+=list:-1 showbreak=➥\ 
set list listchars=tab:┆\ ,trail:⋅,nbsp:␣,extends:≫,precedes:≪
let &statusline = ' %<%f%( %h%)%( [%R%M]%)%=%( %{get(b:, ''gitsigns_head'', '''')} %{get(b:, ''gitsigns_status'', '''')}%)%=%l∕%L:%-3c %P '

nmap _ <Plug>(dirvish_up)
nmap <c-w>_ <Plug>(dirvish_vsplit_up)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		\ | wincmd p | diffthis
endif

augroup vimStartup
	au!
	" When editing a file, always jump to the last known cursor position.
	" Don't do it when the position is invalid, when inside an event handler
	" (happens when dropping a file on gvim) and for a commit message (it's
	" likely a different one than last time).
	autocmd BufReadPost *
		\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
		\ |   exe "normal! g`\""
		\ | endif
augroup END

augroup yankhl
	au!
	autocmd TextYankPost * silent! lua vim.highlight.on_yank()
augroup END

let g:sneak#label = 1

let g:mapleader = ' '
let g:maplocalleader = '\'

" Do not load netrw -- I use dirvish instead
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

nmap  <C-a>  <Plug>(dial-increment)
nmap  <C-x>  <Plug>(dial-decrement)
nmap g<C-a> g<Plug>(dial-increment)
nmap g<C-x> g<Plug>(dial-decrement)
vmap  <C-a>  <Plug>(dial-increment)
vmap  <C-x>  <Plug>(dial-decrement)
vmap g<C-a> g<Plug>(dial-increment)
vmap g<C-x> g<Plug>(dial-decrement)

let g:colortemplate_toolbar = 0
