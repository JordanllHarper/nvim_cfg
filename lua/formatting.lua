local M = {
    formatting_enabled = true
}

function M.toggle()
    M.formatting_enabled = not M.formatting_enabled
end

return M
