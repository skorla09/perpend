local map = vim.keymap.set

map("n", "[d", vim.diagnostic.goto_prev, {
	desc = "Previous Diagnostic",
})

map("n", "]d", vim.diagnostic.goto_next, {
	desc = "Next Diagnostic",
})

map("n", "<leader>df", vim.diagnostic.open_float, {
	desc = "Line Diagnostics",
})

map("n", "<leader>dl", vim.diagnostic.setloclist, {
	desc = "Diagnostics List",
})
