local vim = vim

vim.cmd("let g:python3_host_prog = '/usr/bin/env python3'")
vim.cmd("set guicursor=n-v-c-i:block")

-- The below options are taken from:
-- https://github.com/sxyazi/dotfiles/blob/main/nvim/lua/core.lua
vim.o.number = true
vim.opt.cursorline = true

vim.o.wrap = true 
vim.opt.linebreak = true
vim.opt.showbreak = "↳"
vim.opt.whichwrap = "h,l,<,>"

vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.virtualedit = "block"

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true
vim.opt.hlsearch = true 

vim.opt.tabstop = 2

vim.opt.shiftwidth = 2
vim.opt.smartindent = true

vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

vim.opt.winblend = 0
vim.opt.pumblend = 0
vim.opt.pumheight = 15

vim.opt.showmode = false
vim.opt.showcmd = false
vim.opt.laststatus = 3

vim.opt.ruler = false
vim.opt.signcolumn = "yes"

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

vim.opt.clipboard = 'unnamedplus'
-- {'n', 'v'} = vim modes
-- <C-c> = Ctrl + C
vim.keymap.set({'n', 'v'}, '<C-c>', '"+y', { noremap = true })
vim.keymap.set({'n', 'v'}, '<C-v>', '"+p', { noremap = true })
vim.keymap.set('i', '<C-v>', '<C-r>+', { noremap = true })

vim.pack.add({
  -- RULE: don't use unnecessary plugins.
  -- TO DO: pin packages to specific versions
  -- and figure out how updating works.

  -- Dependencies
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lua/plenary.nvim",

  -- Bottom bar (shows mode, git branch etc)
  "https://github.com/nvim-lualine/lualine.nvim",

  -- Top bar (with file name and save status)
  "https://github.com/akinsho/bufferline.nvim",

  -- For finding files and file contents
  "https://github.com/nvim-telescope/telescope.nvim",

  -- Highlights indents and code block structure
  "https://github.com/lukas-reineke/indent-blankline.nvim",

  -- Colour scheme
  "https://github.com/ellisonleao/gruvbox.nvim",

  -- Displays written RGB/HEX colours
  "https://github.com/brenoprata10/nvim-highlight-colors",

  -- Self-explanatory 
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",

  -- For configuring LSPs
  "https://github.com/neovim/nvim-lspconfig",

  -- Nodejs extension host 
  "https://github.com/neoclide/coc.nvim",
})

vim.lsp.enable("lua_ls", "pyright", "ts_ls", "clangd", "qmlls")

vim.lsp.config("clangd", {
  -- Doesn't work (TO FIX)
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto","hpp"},
})

local builtin = require('telescope.builtin')
-- Example of use: ":Telescope find_files" (exit with ":q")
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.opt.termguicolors = true
require("gruvbox").setup({
  --[[
  palette_overrides = {
    bright_green = "#990000",
  },
  --]]
  transparent_mode = true,
})
vim.o.background = "dark" -- "dark"/"light"
vim.cmd([[colorscheme gruvbox]])

require('bufferline').setup()
require('render-markdown').setup({})
require("ibl").setup()
require('nvim-highlight-colors').setup({})

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
