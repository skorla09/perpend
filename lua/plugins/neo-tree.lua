return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	lazy = false,
	keys = require("keymaps.explorer.neo-tree"),
	-- No opts on purpose: upstream defaults are used, so there is no config
	-- file to wire (N-006).
}
