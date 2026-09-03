local opt = vim.opt

-- Line number
opt.number = true
opt.relativenumber = true

-- Cursor line
opt.cursorline = true

-- Tabulacion y sangria
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Look
opt.termguicolors = true
opt.signcolumn = "yes"
opt.showmode = false -- ya lo muestra lualine u otros

-- Performance
opt.updatetime = 250
opt.timeoutlen = 300

-- Clipbiard
opt.clipboard = "unnamedplus"

-- Swap/backup files
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undo"
opt.undofile = true

-- Splits
opt.splitright = true
opt.splitbelow = true
