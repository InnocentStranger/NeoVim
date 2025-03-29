return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local telescope = require('telescope')
      local themes = require('telescope.themes')
      local builtin = require('telescope.builtin')

      -- Setup Telescope with the dropdown theme as default
      telescope.setup {
        pickers = {
          -- You can further customize specific pickers here if needed
          -- find_files = {
          --   theme = "dropdown",
          -- },

          find_files = {
            theme = "dropdown",
            layout_strategy = "vertical",
            layout_config = {
              preview_cutoff = 0,
              width = 0.8,
              height = 0.8,
              prompt_position = "top",
            }
          },

          live_grep = {
            theme = "dropdown",
            layout_strategy = "vertical",
            layout_config = {
              preview_cutoff = 0,
              width = 0.8,
              height = 0.8,
              prompt_position = "top",
            }
          }

        },
        extensions = {
          -- Extension configurations can go here
        },
      }

      -- Load the ui-select extension
      telescope.load_extension('ui-select')

      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      -- vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      -- vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      --require("telescope").setup ({
      --extensions = {
        --["ui-select"] = {
          --require("telescope.themes").get_dropdown {
          --}
        --}
      --}
      --})
      --require("telescope").load_extension("ui-select")
    end
  }
}
