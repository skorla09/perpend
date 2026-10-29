return {
	preset = "modern",
	delay = 200,
	icons = {
		mappings = true,
	},
	-- Only declare groups that currently contain mappings. Empty groups are
	-- added when the corresponding feature is implemented.
	spec = {
		{ "<leader>g", group = "Git" },
		{ "<leader>l", group = "Language" },
		{ "<leader>f", group = "Find" },
		{ "<leader>c", group = "Code" },
		{ "<leader>u", group = "UI" },
	},
}
