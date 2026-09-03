local builtin = require("telescope.builtin")
return {
	{
		"<leader>ff",
		function()
			builtin.find_files()
		end,
		desc = "Find Files",
	},
	{
		"<leader>fr",
		function()
			builtin.oldfiles()
		end,
		desc = "Recent Files",
	},
	{
		"<leader>fg",
		function()
			builtin.live_grep()
		end,
		desc = "Search Workspace",
	},
	{
		"<leader>fb",
		function()
			builtin.buffers()
		end,
		desc = "Find Buffers",
	},
	{
		"<leader>fc",
		function()
			builtin.commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>fh",
		function()
			builtin.help_tags()
		end,
		desc = "Help",
	},
	{
		"<leader>fk",
		function()
			builtin.keymaps()
		end,
		desc = "Keymaps",
	},
}
