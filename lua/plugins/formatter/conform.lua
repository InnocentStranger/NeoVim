return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				kotlin = { "ktfmt" },
				css = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				graphql = { "prettierd" },
				java = { "google-java-format" },
				c = { "clang-format" },
				cpp = { "clang-format" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			format_on_save = function(bufnr)
				if vim.g.conform_disable then
					return
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				}
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>fmt", function()
			if not vim.g.conform_disable then
				conform.format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			else
				vim.notify("Conform formatting is currently disabled.", vim.log.levels.WARN)
			end
		end, { desc = "Format file or range (in visual mode)" })

		-- Commands to enable/disable conform formatting
		vim.api.nvim_create_user_command("ConformEnable", function()
			vim.g.conform_disable = false
			vim.notify("Conform formatting enabled", vim.log.levels.INFO)
		end, {})

		vim.api.nvim_create_user_command("ConformDisable", function()
			vim.g.conform_disable = true
			vim.notify("Conform formatting disabled", vim.log.levels.INFO)
		end, {})
	end,
}
