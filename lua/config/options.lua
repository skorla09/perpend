local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Cursor line
opt.cursorline = true

-- Tabs and indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false -- Already shown by lualine

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Clipboard
opt.clipboard = "unnamedplus"

-- Swap and backup files
opt.swapfile = false
opt.backup = false

-- Undo history
local undo_dir = vim.fn.stdpath("data") .. "/undo"
vim.fn.mkdir(undo_dir, "p")
opt.undodir = undo_dir
opt.undofile = true

-- Splits
opt.splitright = true
opt.splitbelow = true
