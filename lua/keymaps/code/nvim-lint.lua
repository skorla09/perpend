return {
	{
		"<leader>cl",
		function()
			pcall(require("lint").try_lint)
			vim.notify("Lint check complete", vim.log.levels.INFO)
		end,
		desc = "Lint Buffer",
	},
}
