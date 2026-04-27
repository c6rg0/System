local vim = vim

vim.cmd("let g:python3_host_prog = '/usr/bin/env python3'")
vim.cmd("set guicursor=n-v-c-i:block")
vim.o.number = true
vim.o.relativenumber = false 
vim.o.wrap = true 
--vim.o.winborder = "rounded" 

vim.pack.add({
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/sindrets/diffview.nvim",

  "https://github.com/preservim/nerdtree",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/BurntSushi/ripgrep",
  "https://github.com/sharkdp/fd",

  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/lukas-reineke/indent-blankline.nvim",
  "https://github.com/ellisonleao/gruvbox.nvim",

  "https://github.com/akinsho/bufferline.nvim",
  "https://github.com/brenoprata10/nvim-highlight-colors",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/neoclide/coc.nvim",

})

local async = require("plenary.async")
local builtin = require('telescope.builtin')

vim.lsp.enable("lua_ls", "pyright", "ts_ls", "clangd")

require("gruvbox").setup({
  terminal_colors = true, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = false,
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
    section_separators = { left = '', right = '' },
    component_separators = { left = '', right = ''},
    ignore_focus = {},
    always_divide_middle = false,
    always_show_tabline = true,
    globalstatus = true,
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
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch", "diff"},
    lualine_c = {"diagnostics"},
    lualine_x = {},
    lualine_y = {"filetype"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {'filetype'},
    lualine_z = {'location'}
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
}

require('bufferline').setup()
require('render-markdown').setup({})
require("ibl").setup()

vim.opt.termguicolors = true
require('nvim-highlight-colors').setup({})

vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.expandtab = true
vim.g.diagnostics_active = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix", "lua", "yaml", "markdown", "html", "ejs"},
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})
