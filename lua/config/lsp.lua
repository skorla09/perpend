local servers = {
	"lua_ls",
	"vtsls",
	"html",
	"cssls",
}

for _, server in ipairs(servers) do
	pcall(vim.lsp.enable, server)
end
