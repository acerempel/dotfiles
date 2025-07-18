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

require('mini.deps').setup()
local plugin = MiniDeps.add

plugin('jaredgorski/Mies.vim')
plugin('Saghen/blink.cmp')
plugin('tyru/capture.vim')
plugin('gmr458/cold.nvim')
plugin('rhysd/committia.vim')
plugin('ms-jpq/coq_nvim')
plugin('sindrets/diffview.nvim')
plugin('aerosol/dumbotron.vim')
plugin('amedoeyes/eyes.nvim')
plugin('lewis6991/gitsigns.nvim')
plugin('MagicDuck/grug-far.nvim')
plugin('NMAC427/guess-indent.nvim')
plugin('tzachar/highlight-undo.nvim')
plugin('cohama/lexima.vim')
plugin('echasnovski/mini.nvim')
plugin('miikanissi/modus-themes.nvim')
plugin('NeogitOrg/neogit')
plugin('hrsh7th/nvim-cmp')
plugin('catgoose/nvim-colorizer.lua')
plugin('martineausimon/nvim-lilypond-suite')
plugin('neovim/nvim-lspconfig')
plugin('dstein64/nvim-scrollview')
plugin('nvim-treesitter/nvim-treesitter')
plugin('e-q/okcolors.nvim')
plugin('axvr/photon.vim')
plugin('nvim-lua/plenary.nvim')
plugin('stevearc/quicker.nvim')
plugin('mrcjkb/rustaceanvim')
plugin('nvim-telescope/telescope-frecency.nvim')
plugin('natecraddock/telescope-zf-native.nvim')
plugin('nvim-telescope/telescope.nvim')
plugin('sdothum/vim-colors-duochrome')
plugin('lifepillar/vim-colortemplate')
plugin('romainl/vim-cool')
plugin('justinmk/vim-dirvish')
plugin('kkga/vim-envy')
plugin('rbong/vim-flog')
plugin('tpope/vim-fugitive')
plugin('andymass/vim-matchup')
plugin('romainl/vim-qf')
plugin('lambdalisue/vim-readablefold')
plugin('tpope/vim-repeat')
plugin('tpope/vim-rhubarb')
plugin('justinmk/vim-sneak')
plugin('tpope/vim-surround')
plugin('cideM/yui')
plugin('vim-scripts/zenesque.vim')

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
require('colorizer').setup()
require('grug-far').setup()
require('quicker').setup()

local blink = require('blink.cmp')
local capabilities = blink.get_lsp_capabilities()
require('lspconfig').pyright.setup { capabilities=capabilities }
ts= require ('lspconfig').ts_ls
ts.cmd = {'bunx', 'typescript-language-server', '--stdio'}
vim.lsp.config('ts_ls', ts)
vim.lsp.enable('ts_ls')

--[[
blink.setup {
	enabled = function ()
		return vim.bo.buftype ~= 'prompt'
	end,
	completion = {
		trigger = {
			show_on_keyword = false,
		}
	},
	keymap = {
		preset = 'none',

		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-e>'] = { 'hide', 'fallback' },
		['<CR>'] = { 'accept', 'fallback' },

		['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
		['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },

		['<Up>'] = { 'select_prev', 'fallback' },
		['<Down>'] = { 'select_next', 'fallback' },
		['<C-p>'] = { 'select_prev', 'fallback' },
		['<C-n>'] = { 'select_next', 'fallback' },

		['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
		['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

		['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
	}
}

vim.g.coq_settings = {
	xdg = true,
	keymap = {
		recommended = false,
	},
}
]]
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
