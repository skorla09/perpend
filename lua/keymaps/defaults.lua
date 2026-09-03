local map = vim.keymap.set

-- Leader (<Space> by default)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Navegacion entre ventanas
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Limpiar resaltado de busqueda
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clean search results" })

-- Guardar archivo facil
map("n", "<leader>w", ":w<CR>", { desc = "Save File" })
map("n", "<leader>q", ":q<CR>", { desc = "Close Window" })
map("n", "<leader>x", ":x<CR>", { desc = "Save and Close" })
