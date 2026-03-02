-- My NVIM init :)
-- Based on kickstart.nvim by https://github.com/tjdevries (go check him out!)
-- Notes for me to remember
-- <C> = Ctrl
-- <CR> = Enter/Return
-- <A> = Alt/Option

local map = require("utils").map
local leader_nmap = require("utils").leader_nmap

map({ "n", "v" }, "<Space>", "<Nop>")
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

require "options"
require "commands"
require "keymaps"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup {
  defaults = {
    lazy = true,
    dev = {
      path = "~/projects",
    },
    rocks = {
      enabled = false,
    },
    checker = {
      enabled = true,
    },
    profiling = {
      loading = true,
      require = true,
    },
    performance = {
      enabled = true,
    },
  },
  { import = "plugins" },
  { import = "themes" },
}

require 'lsp'.setup_servers()
require "autocommands"

vim.cmd([[colorscheme vague]])
leader_nmap("ln", "<Cmd>Lazy<CR>", "[l]azy [n]vim")
leader_nmap("lr", ":Lazy reload", "[l]azy [r]eload")
-- vim: ts=2 sts=2 sw=2 et
