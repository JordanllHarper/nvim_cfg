local cmd                                                          = require("utils").custom_buf_user_command
local batchMap                                                     = require('utils').batch_map
local set                                                          = vim.keymap.set
local del                                                          = vim.keymap.del
local ts                                                           = require 'telescope.builtin'

local M                                                            = {}

local capabilities                                                 = require("blink-cmp").get_lsp_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

M.setup_servers                                                    = function()
    vim.diagnostic.config({
        severity_sort = true,
    })

    vim.lsp.config('*', {
        capabilities = capabilities
    })


    ---@type table<string | table<string, vim.lsp.Config>>
    local global_servers = {
        {
            "bicep",
            {
                cmd = { "dotnet", "C:/tools/bicep-langserver/Bicep.LangServer.dll" }
            }
        },
        "lemminx",
        "lua_ls",
        "bashls",
        "gopls",
        "ruby_lsp",
        "pyright",
        "ocamllsp",

        "rust-analyzer",
        "denols",
        {
            "html",
            { cmd = { "vscode-html-language-server", "--stdio", "-allow-env" } },
        },
        {
            "cssls",
            { cmd = { "vscode-css-language-server", "--stdio", "-allow-env" } }
        },
        "phpactor",
        "svelte",
        {
            "clangd",
            ---@type vim.lsp.Config
            {
                cmd = {
                    "clangd",
                    "--offset-encoding=utf-16",
                    "--background-index",
                    "--clang-tidy",
                    "--log=verbose",
                },
            }
        }
    }

    for _, server in ipairs(global_servers) do
        local serverName = server
        if type(server) == "table" then
            serverName = server[1]
            local configuration = server[2]
            vim.lsp.config[serverName] = configuration
        end

        vim.lsp.enable(serverName)
    end
end

---Configures the lsp keymaps
---@param bufnr number
local function configure_lsp(bufnr)
    local buf_nmap = function(keys, func, desc)
        set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    local buf_leader_nmap = function(keys, func, desc)
        set("n", "<leader>" .. keys, func, { buffer = bufnr, desc = desc })
    end

    buf_leader_nmap("LS", "LspStop", "[S]top")

    local lspbuf = vim.lsp.buf

    local mappings = {
        { "T",  ts.lsp_type_definitions,                                    "[t]ype Definition" },
        { "Q",  vim.lsp.codelens.run,                                       "[Q]ode lense" },
        -- Document
        { "d",  ts.lsp_document_symbols,                                    "[d]ocument Symbols" },
        -- Wocument lmao
        -- Workspace
        { "w",  ts.lsp_workspace_symbols,                                   "[w]ocument Symbols" },
        { "ss", ts.lsp_dynamic_workspace_symbols,                           "[s]earch [s]ymbols" },
        { "h",  function() lspbuf.hover { border = "single" } end,          "[h]over" },
        { "k",  function() lspbuf.signature_help { border = "single" } end, "Signature [H]elp" },
        { "rn", lspbuf.rename,                                              "[r]e[n]ame" },
        -- Code actions
        { "c",  lspbuf.code_action,                                         "[c]ode action" },
        -- Hints
        { "Lt", "<Cmd>ToggleHints<CR>",                                     "[T]oggle hints" },
    }

    batchMap(mappings, buf_leader_nmap)




    -- Treesitter
    buf_nmap("gd", ts.lsp_definitions, "[g]oto [d]efinition")
    buf_nmap("gr", function()
        ts.lsp_references({ include_declaration = false, include_current_line = false })
    end, "[g]oto [r]eferences")
    buf_nmap("gI", ts.lsp_implementations, "[g]oto [i]mplementation")


    set({ "i", "s", "v" }, "<C-k>", lspbuf.signature_help, { desc = "Signature Help", buffer = bufnr })
    cmd(bufnr, "ToggleHints", function(_)
        require("lsp-attach.toggle_virt_text").toggle()
    end, "Toggle Virtual Text in Buffer")
end

---Configures the default keymaps for diagnostics
---@param bufnr number
local function configure_diagnostic(bufnr)
    local buf_nmap = function(keys, func, desc)
        set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    local buf_leader_nmap = function(keys, func, desc)
        set("n", "<leader>" .. keys, func, { buffer = bufnr, desc = desc })
    end

    local diagnostic = vim.diagnostic

    local function diagnostic_jump(count)
        diagnostic.jump {
            count = count,
            severity = { min = vim.diagnostic.severity.WARN }
        }
    end

    buf_nmap("[d", function()
        diagnostic_jump(-1)
    end, "Go to previous diagnostic message")

    buf_nmap("]d", function()
        diagnostic_jump(1)
    end, "Go to next diagnostic message")

    buf_leader_nmap("e", diagnostic.open_float, "Open [E]rror float")

    -- Treesitter
    buf_leader_nmap("sd", function()
        ts.diagnostics()
    end, "[S]earch [D]iagnostics (current buffer)")
    buf_leader_nmap("sD", ts.diagnostics, "[S]earch [D]iagnostics")
end

---Deletes the default keybindings
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
    bufdel("i", "<C-S>")
end

M.on_attach = function(_, bufnr)
    delete_defaults()
    configure_lsp(bufnr)
    configure_diagnostic(bufnr)
end

return M
