local servers = {
	"lua_ls",
	"ts_ls",
	"html",
	"cssls",
}

for _, server in ipairs(servers) do
	pcall(vim.lsp.enable, server)
end
