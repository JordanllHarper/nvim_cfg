local cmd = require("utils").custom_buf_user_command
local batchMap = require("utils").batch_map
local set = vim.keymap.set
local del = vim.keymap.del

local M = {}

local capabilities = require("blink-cmp").get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.setup_servers = function()
    vim.lsp.config("*", {
        capabilities = capabilities,
        root_markers = { ".git" },
    })

    ---@type table<string | table<string, vim.lsp.Config>>
    local global_servers = {
        { "bicep",        { cmd = { 'bicep-ls' }, } },
        { "lemminx" },
        { "lua_ls",       { settings = { Lua = { diagnostics = { globals = { "vim" } } } } } },
        { "bashls" },
        { "gopls" },
        { "ruby_lsp" },
        { "pyright" },
        { "ocamllsp" },
        { "ts_ls" },
        { "emmet-ls" },
        { "rust-analyzer" },
        { "denols" },
        -- {
        --     "html",
        --     { cmd = { "vscode-html-language-server", "--stdio", "-allow-env" } },
        -- },
        -- {
        --     "cssls",
        --     { cmd = { "vscode-css-language-server", "--stdio", "-allow-env" } }
        -- },
        { "phpactor" },
        { "svelte" },
        -- { "roslyn" }
        -- {
        --     "clangd",
        --     ---@type vim.lsp.Config
        --     {
        --         cmd = {
        --             "clangd",
        --             "--offset-encoding=utf-16",
        --             "--background-index",
        --             "--clang-tidy",
        --             "--log=verbose",
        --         },
        --     }
        -- }
    }
    -- vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { "vim" } } } } })
    -- vim.lsp.enable("lua_ls")

    for _, server in ipairs(global_servers) do
        local serverName = server[1]
        local configuration = server[2]
        if configuration then
            vim.lsp.config(serverName, configuration)
        else
            vim.lsp.config(serverName, {})
        end
        vim.lsp.enable(serverName)
    end
end

---Configures the lsp keymaps
---@param bufnr number
local function configure_lsp(bufnr)
    local buf_leader_nmap = function(keys, func, desc)
        set("n", "<leader>" .. keys, func, { buffer = bufnr, desc = desc })
    end

    buf_leader_nmap("LS", "LspStop", "[S]top")

    local lspbuf = vim.lsp.buf

    local mappings = {
        { "Q",  vim.lsp.codelens.run,   "[Q]ode lense" },
        -- Document
        {
            "h",
            function()
                lspbuf.hover({ border = "single" })
            end,
            "[h]over",
        },
        {
            "k",
            function()
                lspbuf.signature_help({ border = "single" })
            end,
            "Signature [k]elp (help)",
        },
        { "rn", lspbuf.rename,          "[r]e[n]ame" },
        -- Code actions
        { "c",  lspbuf.code_action,     "[c]ode action" },
        -- Hints
        { "Lt", "<Cmd>ToggleHints<CR>", "[L]sp [T]oggle hints" },
    }

    batchMap(mappings, buf_leader_nmap)

    set({ "i", "s", "v" }, "<C-k>", lspbuf.signature_help, { desc = "Signature Help", buffer = bufnr })
    cmd(bufnr, "ToggleHints", function(_)
        require("lsp-attach.toggle_virt_text").toggle()
    end, "Toggle Virtual Text in Buffer")
end

---Configures the default keymaps for diagnostics
---@param bufnr number
local function configure_diagnostic(bufnr)
    vim.diagnostic.config({
        severity_sort = true,
    })
    local buf_nmap = function(keys, func, desc)
        set("n", keys, func, { buffer = bufnr, desc = desc })
    end
    local buf_leader_nmap = function(keys, func, desc)
        set("n", "<leader>" .. keys, func, { buffer = bufnr, desc = desc })
    end
    local diagnostic = vim.diagnostic
    local function diagnostic_jump(count)
        diagnostic.jump({ count = count, severity = { min = vim.diagnostic.severity.WARN } })
    end
    buf_nmap("[d", function()
        diagnostic_jump(-1)
    end, "Go to previous diagnostic message")
    buf_nmap("]d", function()
        diagnostic_jump(1)
    end, "Go to next diagnostic message")
    buf_leader_nmap("e", diagnostic.open_float, "[e]rror float")
end

-- Deletes the default keybindings
local function delete_defaults()
    local bufdel = function(mode, lhs)
        pcall(function()
            del(mode, lhs)
        end)
    end
    bufdel("n", "grn")
    bufdel("n", "gra")
    bufdel("n", "grr")
    bufdel("n", "gri")
    bufdel("n", "grt")
    bufdel("n", "grx")
    bufdel("i", "<C-S>")
end

M.on_attach = function(_, bufnr)
    delete_defaults()
    configure_lsp(bufnr)
    configure_diagnostic(bufnr)
end

return M
