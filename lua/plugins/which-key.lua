return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = function()
			return require("config.which-key")
		end,
		keys = require("keymaps.which-key"),
	},
}
