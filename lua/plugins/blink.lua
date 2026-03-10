return {
    {
        'saghen/blink.cmp',
        dependencies = "L3MON4D3/LuaSnip",
        version = '1.*',
        opts = {
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    }
                }
            },
            snippets = {
                preset = 'luasnip',
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
            },
            keymap = {
                preset = 'default',
                ['<C-a>'] = { 'show' },
                ['<Tab>'] = {},
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            sources = {
                default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },
            signature = { enabled = true }
        },
    },
    {
        'saghen/blink.indent',
        config = function()
            local indent = require 'blink.indent'
            indent.enable(false) -- turn off by default
            require 'utils'.leader_nmap("I", function()
                indent.enable(not indent.is_enabled())
            end, "Toggle [I]ndent")
        end
    },
}
