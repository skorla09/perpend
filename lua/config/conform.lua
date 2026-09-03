---@type conform.setupOpts
local prettier_formatters = {
	"prettierd",
	"prettier",
	stop_after_first = true,
}

return {
	formatters_by_ft = {
		lua = {
			"stylua",
		},

		javascript = prettier_formatters,
		javascriptreact = prettier_formatters,

		typescript = prettier_formatters,
		typescriptreact = prettier_formatters,

		html = prettier_formatters,
		css = prettier_formatters,

		json = prettier_formatters,
		yaml = prettier_formatters,

		markdown = prettier_formatters,
	},

	default_format_opts = {
		lsp_format = "fallback",
	},

	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},

	notify_no_formatters = true,
	notify_on_error = true,
}
