local map = vim.keymap.set

map("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
map("n", "gr", vim.lsp.buf.references, { desc = "References" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Implementation" })
map("n", "gt", vim.lsp.buf.type_definition, { desc = "Type Definition" })

map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename" })
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
