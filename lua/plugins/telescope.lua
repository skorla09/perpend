return {
	{
		"nvim-telescope/telescope.nvim",
		version = "*",
		-- The dashboard actions run ex-commands (`:Telescope find_files`, ...),
		-- and the command only exists once the plugin loads. This stub makes
		-- lazy.nvim load Telescope on first use without touching startup.
		cmd = "Telescope",
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
