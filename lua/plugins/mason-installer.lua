return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatters
				"black",
				"isort",
				"prettierd",
				"stylua",
				"google-java-format",
				"clang-format",

				-- linters
				"eslint_d",
				"pylint",
				"cpplint",

				-- lsp
				"clangd",
				"lua_ls",
				"rust_analyzer",
				"ts_ls",
				"jdtls",
			},
			auto_update = false,
			run_on_start = true,
		})
	end,
}
