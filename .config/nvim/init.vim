set background=light
colorscheme mies
set mouse=a
set undofile
set virtualedit=block,onemore
set autowrite
set splitbelow splitright
set gdefault
set tabstop=4 softtabstop=4 shiftwidth=4
set title
set showcmd
set scrolloff=2 sidescrolloff=4
set diffopt+=context:3,vertical,indent-heuristic,algorithm:histogram
set completeopt-=preview
set clipboard=unnamed
set wrap linebreak breakindent breakindentopt+=list:-1 showbreak=➥\ 
set list listchars=tab:┆\ ,trail:⋅,nbsp:␣,extends:≫,precedes:≪
let &statusline = ' %<%f%( %h%)%( [%R%M]%)%=%( %{get(b:, ''gitsigns_head'', '''')} %{get(b:, ''gitsigns_status'', '''')}%)%=%l∕%L:%-3c %P '

" Imitate the ADM-3A
noremap <silent> - :
noremap <silent> ' @
noremap <silent> @ "
noremap <silent> '- @:
noremap <silent> " `
nnoremap <silent> <BS> <C-^>

noremap <silent> <CR> <C-]>
noremap <silent> Q q
noremap <silent> q <C-w>q
noremap <silent> X <cmd>w<CR>
noremap <silent> j gj
noremap <silent> k gk
sunmap j
sunmap k
sunmap Q
sunmap q
sunmap X
sunmap <CR>

map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T
sunmap f
sunmap F
sunmap t
sunmap T

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

" Do not load netrw -- I use dirvish instead
let g:loaded_netrw       = 1
let g:loaded_netrwPlugin = 1

lua <<ENDLUA
require('guess-indent').setup()

require('gitsigns').setup {
	attach_to_untracked = false,
	on_attach = function()
		vim.wo.signcolumn = 'yes'
		local default_modes = {'n', 'x', 'o'}
		local default_opts = {noremap = true, silent = true}
		function map_local(lhs, rhs, opts, modes)
			local opts = vim.tbl_extend('keep', opts or {}, default_opts)
			local modes = modes or default_modes
			for _, mode in ipairs(modes) do
				vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, opts)
			end
		end
		map_local(']c', "&diff ? ']c' : '<cmd>Gitsigns next_hunk<cr>'", {expr = true})
		map_local('[c', "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<cr>'", {expr = true})
		map_local('<Leader>cs', ':Gitsigns stage_hunk<cr>')
		map_local('<Leader>cr', ':Gitsigns reset_hunk<cr>')
		map_local('<Leader>cp', '<cmd>Gitsigns preview_hunk<cr>')
		map_local('<Leader>ac', '<cmd>Gitsigns select_hunk<cr>')
	end,
}

-- require('highlight-undo').setup()
ENDLUA
