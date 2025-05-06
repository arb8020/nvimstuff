-- Set leader key to space (near the top)
vim.g.mapleader = " "

local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- Your existing plugins
Plug('catppuccin/nvim', {['as'] = 'catppuccin'})
Plug('akinsho/bufferline.nvim', { ['tag'] = '*' })
Plug('nvim-tree/nvim-web-devicons')  -- Required for file icons
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug('numToStr/Comment.nvim')  -- Add this line for the commenting plugin

-- New plugins for LSP and file finding
Plug('neovim/nvim-lspconfig')           -- LSP configuration
Plug('williamboman/mason.nvim')         -- LSP installer
Plug('williamboman/mason-lspconfig.nvim') -- Mason LSP config
Plug('NeogitOrg/neogit')
Plug('nvim-lua/plenary.nvim')           -- Required for telescope
Plug('nvim-telescope/telescope.nvim')    -- Fuzzy finder

-- Adding GitSigns for git integration
Plug('lewis6991/gitsigns.nvim')

-- do u have games on ur nvim
Plug('ThePrimeagen/vim-be-good')

vim.call('plug#end')

local neogit = require('neogit')
neogit.setup({})

vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true        -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers

-- Folding settings
vim.opt.foldmethod = "indent"

-- Basic bufferline setup
require("bufferline").setup{
    highlights = require("catppuccin.groups.integrations.bufferline").get()
}

-- Enhanced Treesitter setup with folding
require('nvim-treesitter.configs').setup({
    ensure_installed = { 
        "python",
        "lua",
        "vim",
        "javascript",
        "typescript",
        "json",
    },
    highlight = {
        enable = true,
    },
    indent = {
        enable = true
    },
})

-- Indentation settings
vim.opt.expandtab = true      -- Convert tabs to spaces
vim.opt.shiftwidth = 4        -- Number of spaces for each indentation
vim.opt.tabstop = 4           -- Number of spaces for a tab
vim.opt.autoindent = true     -- Copy indent from current line when starting a new line
vim.opt.smartindent = true    -- Smart autoindenting when starting a new line

vim.cmd.colorscheme "catppuccin"

-- Set up Comment.nvim
require('Comment').setup()

-- Set up Mason and LSP
require("mason").setup()
require("mason-lspconfig").setup()

-- LSP configurations
local lspconfig = require('lspconfig')
lspconfig.pyright.setup{}  -- for Python
lspconfig.ts_ls.setup{} -- for JavaScript/TypeScript
lspconfig.lua_ls.setup{}   -- for Lua

local diagnostics_active = false
local function toggle_diagnostics()
    diagnostics_active = not diagnostics_active
    if diagnostics_active then
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
        })
    else
        vim.diagnostic.config({
            virtual_text = false,
            signs = false,
            underline = false,
            update_in_insert = false,
            severity_sort = true,
        })
    end
end

-- Keymaps
vim.keymap.set('n', '<space>e', toggle_diagnostics, { noremap = true })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { noremap = true })

-- -- Comment keymaps using Cmd + / (for macOS)
-- i dont think these work lol
vim.keymap.set('n', '<D-/>', 'gcc', { noremap = true })  -- Comment line in normal mode
vim.keymap.set('v', '<D-/>', 'gc', { noremap = true })   -- Comment selection in visual mode

-- LSP keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})

-- Updated Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = "Find files"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = "Find text"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc = "Find buffers"})

-- Folding keymaps
vim.keymap.set('n', 'zf', 'zf', { noremap = true })  -- Create fold
vim.keymap.set('n', 'za', 'za', { noremap = true })  -- Toggle fold
vim.keymap.set('n', 'zo', 'zo', { noremap = true })  -- Open fold
vim.keymap.set('n', 'zc', 'zc', { noremap = true })  -- Close fold
vim.keymap.set('n', 'zR', 'zR', { noremap = true })  -- Open all folds
vim.keymap.set('n', 'zM', 'zM', { noremap = true })  -- Close all folds

-- Set up GitSigns with minimal config
require('gitsigns').setup({
  -- Just use default settings
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    -- Only the most essential keymaps
    vim.keymap.set('n', ']c', gs.next_hunk, {buffer=bufnr})
    vim.keymap.set('n', '[c', gs.prev_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr})
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr})
  end
})
