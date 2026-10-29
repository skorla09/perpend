-- Telescope is lazy-loaded, so its modules must be required inside the
-- callbacks. Requiring them while lazy.nvim evaluates this table would load
-- Telescope at startup and can cause a module-loading loop.
return {
	{
		"<leader>ff",
		function()
			require("telescope.builtin").find_files()
		end,
		desc = "Find files",
	},
	{
		"<leader>fr",
		function()
			require("telescope.builtin").oldfiles()
		end,
		desc = "Recent files",
	},
	{
		"<leader>fg",
		function()
			require("telescope.builtin").live_grep()
		end,
		desc = "Search workspace",
	},
	{
		"<leader>fb",
		function()
			require("telescope.builtin").buffers()
		end,
		desc = "Find buffers",
	},
	{
		"<leader>fc",
		function()
			require("telescope.builtin").commands()
		end,
		desc = "Commands",
	},
	{
		"<leader>fh",
		function()
			require("telescope.builtin").help_tags()
		end,
		desc = "Help tags",
	},
	{
		"<leader>fk",
		function()
			require("telescope.builtin").keymaps()
		end,
		desc = "Keymaps",
	},
}
