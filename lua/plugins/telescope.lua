local actions = require 'telescope.actions'
local global_keymaps = {
    ['<C-b>'] = actions.delete_buffer,
    ['<C-s>'] = actions.select_horizontal
}
return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            "debugloop/telescope-undo.nvim",
            'nvim-telescope/telescope-ui-select.nvim',
        },
        opts = {
            defaults = {
                winblend = 17,
                layout_strategy = 'horizontal',
                layout_config = {
                    prompt_position = 'bottom',
                },
                mappings = {
                    n = global_keymaps,
                    i = global_keymaps,
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor {}
                },
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = 'smart_case',
                },
            }
        },
        config = function(_, opts)
            local themes = require 'telescope.themes'
            local builtin = require 'telescope.builtin'
            local leader_nmap = require 'utils'.leader_nmap

            local set = leader_nmap
            set('?', builtin.oldfiles, '[?] Find recently opened files')
            set('<leader>', function() builtin.buffers(themes.get_ivy()) end, '[ ] Find existing buffers')
            set('/', function()
                builtin.current_buffer_fuzzy_find(themes.get_dropdown {
                    previewer = true,
                    winblend = 10,
                    layout_config = {
                        prompt_position = "top",
                    }
                })
            end, '[/] Fuzzily search in current buffer')
            set('sF', function() builtin.find_files { hidden = true, } end, '[s]earch All [F]iles (including hidden)')
            set('sf', builtin.find_files, '[s]earch [f]iles')
            set("sh", builtin.help_tags, "[s]earch [h]elp")
            set("sH", builtin.search_history, "[s]earch [H]istory")
            set("sg", builtin.live_grep, "[s]earch [g]rep")
            set("sr", builtin.resume, "[s]earch [r]esume")
            set("sR", builtin.registers, "[s]earch [R]egisters")
            set("sS", function() builtin.spell_suggest(themes.get_cursor { border = true }) end,
                "[s]earch [S]pelling")
            set("sk", builtin.keymaps, "[s]earch [k]eymaps")
            set("sw", builtin.grep_string, "[S]earch [w]ord")

            require 'telescope'.setup(opts)
            require 'telescope'.load_extension 'fzf'
            require 'telescope'.load_extension 'ui-select'
        end,
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
            return vim.fn.executable 'make' == 1
        end,
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
    }

}
