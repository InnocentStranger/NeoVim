return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local telescope = require("telescope")
			local builtin = require("telescope.builtin")
			-- local themes = require('telescope.themes')
			local actions = require("telescope.actions")
			local action_state = require("telescope.actions.state")

			telescope.load_extension("fzf")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						},
						n = {
							["<C-p>"] = require("telescope.actions.layout").toggle_preview,
						},
					},
					preview = {
						hide_on_startup = true, -- Optional: start with preview hidden
					},
				},
				pickers = {
					find_files = {
						hidden = true,
					},
				},
			})

			local function wrap_picker(fn)
				return function(opts)
					opts = vim.tbl_deep_extend("force", {
						layout_config = {
							width = 0.6,
							height = 0.4,
						},
						border = true,
						previewer = false,
						winblend = 10, -- transparency
					}, opts or {})
					fn(require("telescope.themes").get_dropdown(opts))
				end
			end

			local keymap = vim.keymap
			keymap.set("n", "<leader>ff", wrap_picker(builtin.find_files), { desc = "Telescope find files" })
			keymap.set("n", "<leader>fg", wrap_picker(builtin.live_grep), { desc = "Telescope live grep" })
			keymap.set("n", "<leader>fb", wrap_picker(builtin.buffers), { desc = "Telescope buffers" })
			-- keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
		end,
	},
}
