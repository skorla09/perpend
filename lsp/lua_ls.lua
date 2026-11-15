return {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				-- Recognize the Neovim runtime
				globals = { "vim" },
			},
			workspace = {
				-- Index the Neovim runtime so `vim.*` resolves and completes.
				library = vim.api.nvim_get_runtime_file("", true),
				-- Don't prompt about third-party libraries.
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
