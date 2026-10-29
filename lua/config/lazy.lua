-- Node.js host program. Only set it when Node.js is available; `exepath`
-- returns an empty string when it is not found.
local node = vim.fn.exepath("node")
if node ~= "" then
	vim.g.node_host_prog = node
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("config.options")
require("keymaps")
require("config.autocmds")
require("config.diagnostics")

require("lazy").setup("plugins")
