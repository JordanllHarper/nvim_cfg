local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
local nvim_create_autocmd = vim.api.nvim_create_autocmd

---@diagnostic disable-next-line: param-type-mismatch
nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.hl.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

nvim_create_autocmd('BufEnter', {
    pattern = "*.md",
    callback = function()
        vim.opt.spell = true
    end
})

nvim_create_autocmd('BufLeave', {
    pattern = "*.md",
    callback = function()
        vim.opt.spell = false
    end
})

nvim_create_autocmd('LspAttach', {
    callback = function(event)
        local buf = event.buf
        require('lsp').on_attach(_, buf)
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "html",
    callback = function()
        vim.bo.expandtab = true
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
        vim.bo.softtabstop = 2
    end,
})
