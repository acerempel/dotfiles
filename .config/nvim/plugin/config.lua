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

-- colorschemes
plugin('aerosol/dumbotron.vim')
plugin('amedoeyes/eyes.nvim')
plugin('jaredgorski/Mies.vim')
plugin('gmr458/cold.nvim')
plugin('miikanissi/modus-themes.nvim')
plugin('e-q/okcolors.nvim')
plugin('axvr/photon.vim')
plugin('sdothum/vim-colors-duochrome')
plugin('kkga/vim-envy')
plugin('cideM/yui')
plugin('vim-scripts/zenesque.vim')

-- others
plugin('tyru/capture.vim')
plugin('rhysd/committia.vim')
plugin('sindrets/diffview.nvim')
plugin('lewis6991/gitsigns.nvim')
-- plugin('MagicDuck/grug-far.nvim')
plugin('NMAC427/guess-indent.nvim')
plugin('tzachar/highlight-undo.nvim')
plugin('cohama/lexima.vim')
plugin('echasnovski/mini.nvim')
plugin('NeogitOrg/neogit')
plugin('hrsh7th/nvim-cmp')
plugin('catgoose/nvim-colorizer.lua')
plugin('martineausimon/nvim-lilypond-suite')
plugin('neovim/nvim-lspconfig')
plugin('dstein64/nvim-scrollview')
plugin('nvim-treesitter/nvim-treesitter')
plugin('nvim-lua/plenary.nvim')
plugin('stevearc/quicker.nvim')
plugin('mrcjkb/rustaceanvim')
plugin('nvim-telescope/telescope-frecency.nvim')
plugin('natecraddock/telescope-zf-native.nvim')
plugin('nvim-telescope/telescope.nvim')
plugin('lifepillar/vim-colortemplate')
plugin('romainl/vim-cool')
plugin('justinmk/vim-dirvish')
plugin('rbong/vim-flog')
plugin('tpope/vim-fugitive')
plugin('andymass/vim-matchup')
plugin('romainl/vim-qf')
plugin('lambdalisue/vim-readablefold')
plugin('tpope/vim-repeat')
plugin('tpope/vim-rhubarb')
plugin('justinmk/vim-sneak')
plugin('tpope/vim-surround')
plugin {
  source = "L3MON4D3/LuaSnip",
  checkout = 'v2.4.0',
  hooks = {
    post_checkout = function (path)
      vim.uv.spawn("make", {
        args ={ "install_jsregexp"},
        cwd = path,
      }, function (code, signal)
        if code == 0 then vim.notify("make install_jsregexp succeeded!!") else vim.notify("make install_jsregexp failed with code " .. code " and signal " .. signal) end
      end)
    end
  }
}
plugin { source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
    },
}

MiniDeps.now(function() vim.cmd('colorscheme modus') end)

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
-- require('grug-far').setup()
require('quicker').setup()

MiniDeps.later(function ()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  local py = {
    capabilities=capabilities,
    cmd = { "pyright-langserver", "--stdio", "--verbose" },
    settings = {
      python = {
        pythonPath = ".venv/bin/python",
      }
    }
  }
  vim.lsp.config('pyright', py)
  vim.lsp.enable('pyright')
  vim.lsp.config('ruff', {
    init_options = {
      settings = {
        showSyntaxErrors = false,
      }
    }
  })
  vim.lsp.enable('ruff')
  ts= require ('lspconfig').ts_ls
  ts.capabilities = capabilities
  vim.lsp.config('ts_ls', ts)
  vim.lsp.enable('ts_ls')
end)

--[=[
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
]=]

vim.g.cmp_enabled = true

MiniDeps.later(
	function()
      -- ensure dependencies exist
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local lspkind_loaded, lspkind = pcall(require, "lspkind")

      -- border opts
      local border_opts = {
        winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      }
      local cmp_config_window = (
        vim.g.lsp_round_borders_enabled and cmp.config.window.bordered(border_opts)
      ) or cmp.config.window

      -- helper
      local function has_words_before()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
      end

      cmp.setup {
        enabled = function() -- disable in certain cases on dap.
          local is_prompt = vim.bo.buftype == "prompt"
          local is_dap_prompt = false
              and vim.tbl_contains(
                { "dap-repl", "dapui_watches", "dapui_hover" }, vim.bo.filetype)
          if is_prompt and not is_dap_prompt then
            return false
          else
            return vim.g.cmp_enabled
          end
        end,
        preselect = cmp.PreselectMode.None,
        --[[formatting = {
          fields = { "kind", "abbr", "menu" },
          format = nil,
        },]]
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        duplicates = {
          nvim_lsp = 1,
          lazydev = 1,
          luasnip = 1,
          cmp_tabnine = 1,
          buffer = 1,
          path = 1,
        },
        confirm_opts = {
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        },
        window = {
          completion = cmp_config_window,
          documentation = cmp_config_window,
        },
        mapping = {
          ["<PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 8,
          },
          ["<C-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<C-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageUp>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<S-PageDown>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
            count = 16,
          },
          ["<Up>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<Down>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
          },
          ["<C-p>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-n>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-k>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-j>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
          },
          ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
          ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<C-y>"] = cmp.config.disable,
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          -- Note: Priority decides the order items appear.
          { name = "nvim_lsp", priority = 1000 },
          { name = "lazydev",  priority = 850 },
          { name = "luasnip",  priority = 750 },
          { name = "copilot",  priority = 600 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        },
      }
    end
)

MiniDeps.later(function ()
	local tel = require('telescope')
	tel.setup {}
	tel.load_extension('zf-native')
	tel.load_extension('frecency')
	map(nxo, "<C-p>", function() require('telescope').extensions.frecency.frecency {workspace="CWD"} end)
end)
