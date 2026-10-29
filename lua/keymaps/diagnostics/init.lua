local map = vim.keymap.set

map("n", "[d", vim.diagnostic.goto_prev, {
	desc = "Previous diagnostic",
})

map("n", "]d", vim.diagnostic.goto_next, {
	desc = "Next diagnostic",
})

map("n", "<leader>df", vim.diagnostic.open_float, {
	desc = "Line diagnostics",
})

map("n", "<leader>dl", vim.diagnostic.setloclist, {
	desc = "Diagnostics list",
})
