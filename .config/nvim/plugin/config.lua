all = {'', 'i'}
function map(modes, lhs, rhs, opts)
	vim.keymap.set(modes, lhs, rhs, vim.tbl_extend('keep', opts or {}, {silent = true}))
end
map(all, '<C-q>', '<cmd>qa<cr>')
map(all, '<C-s>', '<cmd>w<cr>')

nxo = {'n', 'x', 'o'}
map(nxo, 'j', 'gj')
map(nxo, 'k', 'gk')
-- Imitate the ADM-3A
map(nxo, '-', ':')
map(nxo, '<cr>', '<c-]>')
map(nxo, "'", "`")
map('n', '<bs>', '<c-^>')

for _, key in ipairs({'f', 'F', 't', 'T'}) do
	map(nxo, key, "<Plug>Sneak_"..key, {remap=true})
end

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

require('highlight-undo').setup()

require('grug-far').setup()

local coq = require('coq')
require('lspconfig').pyright.setup(coq.lsp_ensure_capabilities({}))

vim.g.coq_settings = {
	xdg = true,
	keymap = {
		recommended = false,
	},
}

-- Keybindings
vim.api.nvim_set_keymap('i', '<Esc>', [[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]], { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap('i', '<C-c>', [[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]], { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap('i', '<BS>', [[pumvisible() ? "\<C-e><BS>" : "\<BS>"]], { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap(
	"i",
	"<CR>",
	[[pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]],
	{ expr = true, silent = true, noremap = false }
)
vim.api.nvim_set_keymap('i', '<Tab>', [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true, silent = true, noremap = true })
vim.api.nvim_set_keymap('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<BS>"]], { expr = true, silent = true, noremap = true })

local tel = require('telescope')
tel.setup {}
tel.load_extension('zf-native')
tel.load_extension('frecency')
map(nxo, "<C-p>", function() tel.extensions.frecency.frecency {workspace="CWD"} end)
