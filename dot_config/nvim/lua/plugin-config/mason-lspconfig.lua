local nvim_lsp = require("lspconfig")

require("mason-lspconfig").setup_handlers({
	function(server_name)
		local opts = {}
		if server_name == "sumneko_lua" then
			opts.settings = {
				Lua = {
					diagnostics = { globals = { "vim" } },
				},
			}
		end
		nvim_lsp[server_name].setup(opts)
	end,
})
