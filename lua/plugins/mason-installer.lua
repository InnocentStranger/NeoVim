return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		require("mason-tool-installer").setup({
			ensure_installed = {
				-- formatters
				"black",
				"isort",
				"prettier",
				"stylua",
				"google-java-format",
				"clang-format",

				-- linters
				"eslint_d",
				"pylint",
				"cpplint",
			},
			auto_update = false,
			run_on_start = true,
		})
	end,
}
