local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("UserAutocmds", { clear = true })

-- Restore the cursor to the last known position when reopening a file.
autocmd("BufReadPost", {
	group = group,
	pattern = "*",
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Highlight yanked text briefly.
autocmd("TextYankPost", {
	group = group,
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 150 })
	end,
})

-- Treesitter highlighting is a consumer of the parser subsystem (ADR-003).
-- Neovim core does not enable it for every filetype, so Perpend starts it
-- explicitly. `pcall` keeps filetypes without an installed parser quiet.
autocmd("FileType", {
	group = group,
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start, 0)
	end,
})
