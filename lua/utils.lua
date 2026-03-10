local M = {}

---Alias for vim.keymap.set. Sets defaults: silent and noremap
---@param mode string | table
---@param lhs string
---@param rhs function | string
---@param desc string?
---@param buf number? Defaults to all buffers
function M.map(mode, lhs, rhs, desc, buf)
    vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, noremap = true, buffer = buf })
end

---Calls M.map but specifies the mode to be normal.
---@param lhs string
---@param rhs function | string
---@param desc string?
---@param buf number?
function M.nmap(lhs, rhs, desc, buf)
    M.map("n", lhs, rhs, desc, buf)
end

---Calls M.map but specifies the mode to be insert.
---@param lhs string
---@param rhs function | string
---@param desc string?
function M.imap(lhs, rhs, desc)
    M.map("i", lhs, rhs, desc)
end

---Calls M.map and specifies using the '<leader>' prefix for the keymap.
---@param mode string | table
---@param lhs string
---@param rhs function | string
---@param desc string?
function M.leader_map(mode, lhs, rhs, desc)
    M.map(mode, ("<leader>%s"):format(lhs), rhs, desc)
end

---Calls M.map, specifies using the '<leader>' prefix for the keymap and uses normal mode.
---@param lhs string
---@param rhs function | string
---@param desc string?
---@param buf number?
function M.leader_nmap(lhs, rhs, desc, buf)
    M.nmap(("<leader>%s"):format(lhs), rhs, desc, buf)
end

---Creates a user command for the given buffer.
---@param bufnr number
---@param name string
---@param command string | function
---@param desc string?
function M.custom_buf_user_command(bufnr, name, command, desc)
    vim.api.nvim_buf_create_user_command(bufnr, name, command, { desc = desc })
end

---Creates a global user command.
---@param name string
---@param command string | function
---@param desc string?
function M.custom_user_command(name, command, desc)
    vim.api.nvim_create_user_command(name, command, { desc = desc })
end

function M.map_command(mode, lhs, rhs, desc)
    M.map(mode, lhs, ("<Cmd>%s<CR>"):format(rhs), desc)
end

---@param lhs string
---@param rhs string | function
---@param desc string
function M.leader_nmap_cmd(lhs, rhs, desc)
    M.leader_nmap(lhs, ("<Cmd>%s<CR>"):format(rhs), desc)
end

---Creates a bunch of mappings from an array of mappings.
---@param mappings table
---@param mapping_function function
function M.batch_map(mappings, mapping_function)
    for _, value in ipairs(mappings) do mapping_function(value[1], value[2], value[3]) end
end

return M
