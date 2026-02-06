local vim = vim
local Plug = vim.fn['plug#']

vim.cmd('let g:python3_host_prog = "/usr/bin/env python3"')
vim.cmd('set guicursor=n-v-c-i:block')
vim.cmd('set number')

vim.call("plug#begin")
Plug("nvim-tree/nvim-web-devicons")
Plug("nvim-lualine/lualine.nvim")

Plug("preservim/nerdtree")
Plug 'nvim-lua/plenary.nvim'
Plug("nvim-telescope/telescope.nvim")
Plug("BurntSushi/ripgrep")
Plug("/sharkdp/fd")

Plug("nvim-treesitter/nvim-treesitter")
Plug("lukas-reineke/indent-blankline.nvim")
Plug("ellisonleao/gruvbox.nvim")

Plug("akinsho/bufferline.nvim")
Plug("brenoprata10/nvim-highlight-colors")
Plug("MeanderingProgrammer/render-markdown.nvim")

Plug("neovim/nvim-lspconfig")
Plug("neoclide/coc.nvim")
vim.call("plug#end")

local async = require("plenary.async")
local builtin = require('telescope.builtin')

--vim.lsp.lua_ls.setup({})
--vim.lsp.pyright.setup({})
--vim.lsp.ts_ls.setup({})

vim.lsp.enable("lua_ls", "pyright", "ts_ls")

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
})

vim.o.background = "dark"
vim.cmd([[colorscheme gruvbox]])

require('lualine').setup {
   options = {
	icons_enabled = true,
	theme = 'auto',
	component_separators = {'', ''},
	section_separators = { left = '', right = '' },
	disabled_filetypes = {
	    statusline = {},
	    winbar = {},
	},
	ignore_focus = {},
	always_divide_middle = true,
	always_show_tabline = true,
	globalstatus = false,
	refresh = {
	    statusline = 100,
	    tabline = 100,
	    winbar = 100,
	    events = {
		'WinEnter',
		'BufEnter',
		'BufWritePost',
		'SessionLoadPost',
		'FileChangedShellPost',
		'VimResized',
		'Filetype',
		'CursorMoved',
		'CursorMovedI',
		'ModeChanged',
	}
	},
   sections = {
	lualine_a = {'mode'},
	lualine_b = {'branch', 'diff'},
	lualine_c = {'diagnostics'},
	lualine_x = {},
	lualine_y = {'filetype'},
	lualine_z = {'location'}
   },
   inactive_sections = {
	lualine_a = {},
	lualine_b = {},
	lualine_c = {'filename'},
	lualine_x = {},
	lualine_y = {'progress'},
	lualine_z = {}
   },
   tabline = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {},
	  lualine_y = {},
	  lualine_z = {}
	},

	inactive_tabline = {
	  lualine_a = {},
	  lualine_b = {},
	  lualine_c = {'filename'},
	  lualine_x = {},
	  lualine_y = {},
	  lualine_z = {}
	},

   winbar = {},
   inactive_winbar = {},
   extensions = {}
   }
}

require('bufferline').setup()
require('render-markdown').setup({})
require("ibl").setup()

vim.opt.termguicolors = true
require('nvim-highlight-colors').setup({})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua", "yaml", "markdown" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})
