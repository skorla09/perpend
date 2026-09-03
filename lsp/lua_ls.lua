return {
	settings = {
		Lua = {
			diagnostics = {
				-- Recognize the Neovim runtime
				globals = { "vim" },
			},
			workspace = {
				-- Don't prompt about third-party libraries.
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
