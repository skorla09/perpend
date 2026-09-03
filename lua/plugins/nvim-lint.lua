return {
	"mfussenegger/nvim-lint",

	event = { "BufReadPost", "BufNewFile" },

	keys = require("keymaps.code.nvim-lint"),

	config = function()
		local lint = require("lint")
		local config = require("config.nvim-lint")

		lint.linters_by_ft = config.linters_by_ft

		local group = vim.api.nvim_create_augroup("nvim-lint", { clear = true })

		local function lint_buffer()
			pcall(lint.try_lint)
		end

		vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
			group = group,
			callback = lint_buffer,
		})
	end,
}
