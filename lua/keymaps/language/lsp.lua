local map = vim.keymap.set

-- Neovim 0.12 provides the `gr` LSP prefix and `K` hover by default:
--   gra = code action, gri = implementation, grn = rename,
--   grr = references, grt = type definition, grx = codelens.
-- Perpend does not override those mappings. Defining a custom `K` would
-- suppress Neovim's buffer-local hover mapping.
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

-- Explicit aliases for discoverability. They do not shadow Neovim defaults.
map("n", "<leader>lr", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Code action" })
