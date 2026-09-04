local colorColumnValue = nil
local M = {}
local create_user_command = vim.api.nvim_create_user_command

create_user_command(
    "ToggleColorColumn",
    function()
        if colorColumnValue then
            colorColumnValue = nil
        else
            colorColumnValue = "80"
        end

        vim.cmd(("set colorcolumn=%s"):format(colorColumnValue or ""))
    end,
    { desc = "Toggle Color Column" }
)

create_user_command(
    "ToggleFormat",
    function()
        require 'formatting'.toggle()
        print("Formatting enabled:", M.formattingEnabled)
    end,
    { desc = "Toggle Formatting" }
)

return M
