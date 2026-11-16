return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		dependencies = {
			"nvim-lua/plenary.nvim",
			-- Optional native sorter, left disabled on purpose: it needs a C
			-- toolchain (make + cc) at install time, which conflicts with the
			-- portable install workflow. Enabling it requires the `build`
			-- field plus a guarded `load_extension("fzf")` call (research
			-- note N-023).
			-- { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},

		opts = require("config.telescope"),

		keys = require("keymaps.find.telescope"),
	},
}
