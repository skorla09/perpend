return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		opts = {},

		keys = require("keymaps.find.telescope"),

		-- config = function()
		-- 	require("telescope").setup(require("config.telescope"))
		-- 	require("telescope").load_extension("fzf")
		-- end,
	},
}
