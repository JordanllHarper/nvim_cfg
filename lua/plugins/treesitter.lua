return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        branch = "main",
        config = function(_, opts)
            require 'nvim-treesitter'.setup(opts)
            require 'nvim-treesitter'.install({
                'c', 'c_sharp', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
                'bash'
            })
        end,
    },
    {
        dependencies = { 'nvim-treesitter' },
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = "main",
        opts = {
            textobjects = {
                select = {
                    lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                },
            },
        },
        config = function(_, opts)
            require 'nvim-treesitter-textobjects'.setup(opts)
            local set_select = function(movement, to)
                local select = require "nvim-treesitter-textobjects.select"
                vim.keymap.set({ "x", "o" }, movement, function()
                    select.select_textobject(to, "textobjects")
                end)
            end

            set_select("af", "@function.outer")
            set_select("if", "@function.inner")
            set_select("ac", "@class.outer")
            set_select("ic", "@class.outer")
            set_select("aa", "@parameter.outer")
            set_select("ia", "@parameter.inner")

            local set_move_next_start = function(movement, to)
                local move = require 'nvim-treesitter-textobjects.move'
                vim.keymap.set("n", movement,
                    function()
                        move.goto_next_start(to, "textobjects")
                    end)
            end
            set_move_next_start("]m", "@function.outer")
            set_move_next_start("]]", "@class.outer")

            local set_move_next_end = function(movement, to)
                local move = require 'nvim-treesitter-textobjects.move'
                vim.keymap.set("n", movement,
                    function()
                        move.goto_next_end(to, "textobjects")
                    end)
            end

            set_move_next_end("]M", "@function.outer")
            set_move_next_end("][", "@class.outer")

            local set_move_prev_start = function(movement, to)
                local move = require 'nvim-treesitter-textobjects.move'
                vim.keymap.set("n", movement,
                    function()
                        move.goto_previous_start(to, "textobjects")
                    end)
            end

            set_move_prev_start("[m", "@function.outer")
            set_move_prev_start("[[", "@class.outer")

            local set_move_prev_end = function(movement, to)
                local move = require 'nvim-treesitter-textobjects.move'
                vim.keymap.set("n", movement,
                    function()
                        move.goto_previous_end(to, "textobjects")
                    end)
            end

            set_move_prev_end("[M", "@function.outer")
            set_move_prev_end("[]", "@class.outer")

            local swap = require 'nvim-treesitter-textobjects.swap'
            vim.keymap.set("n", "<leader>a",
                function()
                    swap.swap_next("@parameter.inner", "textobjects")
                end,
                { desc = "Swap next [a]rgument" }
            )

            vim.keymap.set("n", "<leader>A",
                function()
                    swap.swap_previous("@parameter.inner", "textobjects")
                end,
                { desc = "Swap prev [A]rgument" }
            )
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        config = function()
            require 'utils'.leader_nmap(
                "C",
                require 'treesitter-context'.toggle,
                "toggle [C]ontext"
            )
        end
    }
}
