local map = vim.keymap.set

-- Leader key (Space)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Clear search highlighting
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlight" })

-- Save and close
map("n", "<leader>w", ":w<CR>", { desc = "Save file" })
map("n", "<leader>q", ":q<CR>", { desc = "Close window" })
map("n", "<leader>x", ":x<CR>", { desc = "Save and close" })
