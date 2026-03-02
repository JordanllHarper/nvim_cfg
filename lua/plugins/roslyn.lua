local lsp = require "lsp"
local on_attach = lsp.on_attach

return {
    "seblyng/roslyn.nvim",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    config = function()
        vim.lsp.config("roslyn", {
            on_attach = on_attach,
            cmd = { "roslyn-language-server", "--stdio" },
            settings = {
                ["csharp|inlay_hints"] = {
                    csharp_enable_inlay_hints_for_implicit_object_creation = true,
                    csharp_enable_inlay_hints_for_implicit_variable_types = true,
                },
                ["csharp|code_lens"] = { dotnet_enable_references_code_lens = true },
            }
        })
        vim.lsp.enable("roslyn")
    end

}
