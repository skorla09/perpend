return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,

		config = function()
			local ts = require("nvim-treesitter")
			local parsers = require("config.treesitter")
			ts.setup()
			ts.install(parsers)
		end,
	},
}
