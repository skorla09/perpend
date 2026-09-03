vim.diagnostic.config({
	underline = true,
	virtual_text = false,
	signs = true,
	severity_sort = true,
	update_in_insert = false,

	float = {
		border = "rounded",
		source = "if_many",
	},
})
