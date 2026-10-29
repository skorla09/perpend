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

-- LSP Progress notifications
autocmd("LspProgress", {
	group = group,
	pattern = "*",
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if not client then
			return
		end

		local progress = ev.data.progress
		if not progress then
			return
		end

		local message = progress.message or ""
		local percentage = progress.percentage or 0
		local title = progress.title or "LSP"

		if percentage > 0 then
			vim.notify(
				string.format("%s: %s (%d%%)", title, message, percentage),
				vim.log.levels.INFO,
				{ title = "LSP Progress" }
			)
		else
			vim.notify(
				string.format("%s: %s", title, message),
				vim.log.levels.INFO,
				{ title = "LSP Progress" }
			)
		end
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
