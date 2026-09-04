local M = {
    color_column_value = nil
}
local create_user_command = vim.api.nvim_create_user_command

create_user_command(
    "ToggleColorColumn",
    function()
        if M.color_column_value then
            M.color_column_value = nil
        else
            M.color_column_value = "80"
        end

        vim.cmd(("set colorcolumn=%s"):format(colorColumnValue or ""))
    end,
    { desc = "Toggle Color Column" }
)

return M
