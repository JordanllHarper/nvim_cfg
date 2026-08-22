return {
    "akinsho/flutter-tools.nvim",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        settings = {
            renameFilesWithClasses = "always",
        },
        fvm = true,
        lsp = {
            on_attach = require("lsp").on_attach,
            color = {
                enabled = true,
            },
        },
        widget_guides = {
            enabled = true,
        },
    },

    config = function(_, opts)
        local flutter_tools = require 'flutter-tools'
        local cmd = require "flutter-tools.commands"
        local log = require 'flutter-tools.log'
        local lsp = require 'flutter-tools.lsp'
        local telescope = require 'telescope'

        local set = function(motion, f, desc)
            vim.keymap.set("n", motion, f, { desc = desc })
        end

        set("<leader>Frl", cmd.reload, "[F]lutter [r]e[l]oad")
        set("<leader>Frs", cmd.restart, "[F]lutter [r]e[s]tart")
        set("<leader>Fs", cmd.run, "[F]lutter [s]tart")
        set("<leader>Fq", cmd.quit, "[F]lutter [q]uit")
        set("<leader>Fe", cmd.reload, "[F]lutter [e]mulators")
        set("<leader>Fc", log.clear, "[F]lutter [c]lear")
        set("<leader>Fl", log.toggle, "[F]lutter toggle [l]og")
        set("<leader>FL", lsp.restart, "[F]lutter restart [L]sp")

        flutter_tools.setup(opts)
        telescope.load_extension("flutter")
    end,
}
