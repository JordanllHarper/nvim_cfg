local map = vim.keymap.set
local nmap = require("utils").nmap
local leader_nmap = require("utils").leader_nmap
local leader_nmap_cmd = require("utils").leader_nmap_cmd

-- Quickfix
leader_nmap("qo", "<Cmd>copen<CR>", "[Q]uickfix [O]pen")
leader_nmap("qc", "<Cmd>cclose<CR>", "[Q]uickfix [C]lose")
nmap("]q", "<Cmd>cnext<CR>", "Next [Q]uickfix")
nmap("[q", "<Cmd>cprev<CR>", "Previous [Q]uickfix")

-- Terminal
map("t", "<C-q>", "<C-\\><C-n>", { silent = true, desc = "[Q]uit terminal mode" })

-- lua files
leader_nmap("S", function()
    vim.cmd("luafile %")
    vim.notify("Sourced current Lua file", vim.log.levels.INFO, {})
end, "[S]ource luafile")

-- Lsp
leader_nmap("Li", "<Cmd>LspInfo<CR>", "[L]sp [I]nfo")
leader_nmap("Lr", "<Cmd>lsp restart<CR>", "[L]sp [R]estart")
leader_nmap("Ls", "<Cmd>LspStart<CR>", "[s]tart")

-- buffers
leader_nmap("]", function()
    vim.cmd("bnext")
end, "Next buffer")
leader_nmap("[", function()
    vim.cmd("bprevious")
end, "Previous buffer")

leader_nmap("b", function()
    vim.cmd("bdelete")
end, "Delete buffer")

leader_nmap("B", function()
    vim.cmd("bdelete!")
end, "Delete buffer (override)")


-- tabs
leader_nmap("n", function()
    vim.cmd("tabnew")
end, "[n]ew tab")
leader_nmap(">", function()
    vim.cmd("tabnext")
end, "Next tab")
leader_nmap("<", function()
    vim.cmd("tabprevious")
end, "Previous tab")

leader_nmap("x", function()
    vim.cmd("tabclose")
end, "Delete tab")

leader_nmap("X", function()
    vim.cmd("x!")
end, "Delete tab (override)")

leader_nmap_cmd("|", "ToggleColorColumn", "Toggle Color Column [ | ]")
