return function(bufnr)
	local map = function(mode, lhs, rhs, opts)
		opts = opts or {}
		opts.buffer = bufnr
		vim.keymap.set(mode, lhs, rhs, opts)
	end

	local gs = require("gitsigns")

	map("n", "]h", function() gs.nav_hunk("next") end, { desc = "Next Hunk" })
	map("n", "[h", function() gs.nav_hunk("prev") end, { desc = "Previous Hunk" })
	map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })
	map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
	map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
	map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })
	map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
	map("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Toggle Blame" })
	map("n", "<leader>gd", gs.diffthis, { desc = "Diff This" })
end
