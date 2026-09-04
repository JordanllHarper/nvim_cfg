vim.diagnostic.config(
    {
        signs = true
    }

)
-- Set highlight on search
vim.o.hlsearch = false

vim.o.mousehide = true

-- Highlight cursor line
vim.o.cursorline = true

-- Make line numbers default
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- INDENT
-- Enable break indent
vim.o.breakindent = true
vim.o.autoindent = true
vim.o.smartindent = true

-- Enable scroll off
vim.o.scrolloff = 5

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

vim.opt.termguicolors = true

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.linebreak = true

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.exrc = true

-- disable netrw at the very start
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

vim.opt.inccommand = 'split'


-- Spelling help
vim.opt.spell = false
vim.opt.spelllang = { 'en_us' }

vim.opt.guicursor = 'a:block'
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars = {
    eol = '↴',
    tab = ' '
}

vim.filetype.add('bicep')
