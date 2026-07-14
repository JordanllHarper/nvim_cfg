return {
    "tadmccorkle/markdown.nvim",
    ft = "markdown",
    opts = {},
    {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
            latex = { enabled = false },
            completions = { blink = { enabled = true } },
            code = { enabled = false },
            file_types = { "markdown", "Avante" },

        },
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        }
    },
}
