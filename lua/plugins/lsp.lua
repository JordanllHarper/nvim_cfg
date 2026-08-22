return {
	-- LSP Configuration & Plugins
	{
		enabled = true,
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "j-hui/fidget.nvim", opts = {} },
		},
	},
}
