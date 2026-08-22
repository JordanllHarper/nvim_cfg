local nvim_create_autocmd = vim.api.nvim_create_autocmd
local global_keymaps = {
	["<C-b>"] = "delete_buffer",
	["<C-s>"] = "select_horizontal",
}

return {
	{
		"nvim-telescope/telescope.nvim",
		version = "0.2.2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-fzf-native.nvim",
			"debugloop/telescope-undo.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		opts = {
			defaults = {
				path_display = { "filename_first" },
				winblend = 17,
				layout_strategy = "horizontal",
				layout_config = {
					prompt_position = "bottom",
				},
				mappings = {
					n = global_keymaps,
					i = global_keymaps,
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		},
		config = function(_, opts)
			local themes = require("telescope.themes")
			local builtin = require("telescope.builtin")
			local leader_nmap = require("utils").leader_nmap
			opts.extensions = {
				["ui-select"] = themes.get_cursor({}),
			}

			leader_nmap("?", builtin.oldfiles, "[?] Find recently opened files")
			leader_nmap("<leader>", function()
				builtin.buffers(themes.get_ivy())
			end, "[ ] Find existing buffers")
			leader_nmap("/", function()
				builtin.current_buffer_fuzzy_find(themes.get_dropdown({
					previewer = true,
					winblend = 10,
					layout_config = {
						prompt_position = "top",
					},
				}))
			end, "[/] Fuzzily search in current buffer")
			leader_nmap("sF", function()
				builtin.find_files({ hidden = true })
			end, "[s]earch All [F]iles (including hidden)")
			leader_nmap("sf", builtin.find_files, "[s]earch [f]iles")
			leader_nmap("sh", builtin.help_tags, "[s]earch [h]elp")
			leader_nmap("sH", builtin.search_history, "[s]earch [H]istory")
			leader_nmap("sg", builtin.live_grep, "[s]earch [g]rep")
			leader_nmap("sr", builtin.resume, "[s]earch [r]esume")
			leader_nmap("sR", builtin.registers, "[s]earch [R]egisters")
			leader_nmap("sS", function()
				builtin.spell_suggest(themes.get_cursor({ border = true }))
			end, "[s]earch [S]pelling")
			leader_nmap("sk", builtin.keymaps, "[s]earch [k]eymaps")
			leader_nmap("sw", builtin.grep_string, "[S]earch [w]ord")

			require("telescope").setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("ui-select")

			nvim_create_autocmd("LspAttach", {
				callback = function()
					local ts = require("telescope.builtin")
					leader_nmap("T", function()
						ts.lsp_type_definitions()
					end, "[T]ype Definition")
					leader_nmap("d", function()
						ts.lsp_document_symbols()
					end, "[d]ocument Symbols")
					leader_nmap("ss", function()
						ts.lsp_dynamic_workspace_symbols()
					end, "[s]earch [s]ymbols")
					leader_nmap("gd", function()
						ts.lsp_definitions()
					end, "[g]oto [d]efinition", 0)
					leader_nmap("gr", function()
						ts.lsp_references({ include_declaration = false, include_current_line = false }, 0)
					end, "[g]oto [r]eferences")
					leader_nmap("gI", function()
						ts.lsp_implementations()
					end, "[g]oto [i]mplementation", 0)
					-- Wocument lmao
					-- Workspace
					leader_nmap("w", function()
						ts.lsp_workspace_symbols()
					end, "[w]ocument Symbols")
					leader_nmap("sd", function()
						ts.diagnostics()
					end, "[S]earch [D]iagnostics (current buffer)", 0)
					leader_nmap("sD", function()
						ts.diagnostics()
					end, "[s]earch [d]iagnostics", 0)
				end,
			})
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
		cond = function()
			return vim.fn.executable("make") == 1
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
	},
}
