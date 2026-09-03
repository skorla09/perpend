return {
	{
		"neovim/nvim-lspconfig",
		lazy = false,

		config = function()
			require("config.lsp")
		end,
	},
}
