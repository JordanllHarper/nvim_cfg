return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern",
        spec = {
            { "<leader>g", group = "[g]it..." },
            { "<leader>R", group = "[R]un..." },
            { "<leader>l", group = "[l]azy..." },
            { "<leader>L", group = "[L]sp..." },
            { "<leader>q", group = "[q]uickfix.." },
            { "<leader>r", group = "[r]ename..." },
            { "<leader>s", group = "[s]earch..." },
        },
    },
}
