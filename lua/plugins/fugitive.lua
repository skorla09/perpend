return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G", "Gwrite", "Gread", "Gdiffsplit" },
	-- lazy = false,
	-- keys = {
	-- 	{
	-- 		"<leader>gS",
	-- 		"<cmd>Git<CR>",
	-- 		desc = "Git Status",
	-- 	},
	-- },
	keys = require("keymaps.git.fugitive"),
}
