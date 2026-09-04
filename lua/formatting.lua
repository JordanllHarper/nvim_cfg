local create_user_command = vim.api.nvim_create_user_command

local M = {
    formatting_enabled = true
}

create_user_command(
    "ToggleFormat",
    function()
        M.toggle()
        if M.formatting_enabled then
            print("Formatting *enabled*")
        else
            print("Formatting *disabled*")
        end
    end,
    { desc = "Toggle Formatting" }
)

function M.toggle()
    M.formatting_enabled = not M.formatting_enabled
end

return M
