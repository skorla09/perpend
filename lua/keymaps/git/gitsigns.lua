return function(bufnr)
	local map = function(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	local gs = require("gitsigns")

	map("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next hunk" })
	map("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Previous hunk" })
	map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
	map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
	map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
	map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
	map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
	map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle blame" })
	map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" })
end
