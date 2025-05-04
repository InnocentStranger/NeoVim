return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({})

		mason_lspconfig.setup({
			ensure_installed = {
				"clangd",
				"lua_ls",
				"rust_analyzer",
				"ts_ls",
				"jdtls",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})
	end,
}
