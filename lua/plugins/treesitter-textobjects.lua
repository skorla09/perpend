return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",

		init = function()
			-- Disable the plugin's default mappings.
			-- Perpend defines all keymaps explicitly.
			vim.g.no_plugin_maps = true
		end,

		config = function()
			require("nvim-treesitter-textobjects").setup({

				select = {
					lookahead = true,
				},

				move = {
					set_jumps = true,
				},
			})
			require("keymaps.language.textobjects")
		end,
	},
}
