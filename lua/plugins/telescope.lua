return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", },
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      local telescope = require('telescope')
      -- local themes = require('telescope.themes')
      local builtin = require('telescope.builtin')

      local actions = require("telescope.actions")

      telescope.setup ({
        defaults = {
          mappings = {
            i = {
              ["<C-k>"] = actions.move_selection_previous, -- move to prev result
              ["<C-j>"] = actions.move_selection_next, -- move to next result
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            }
          }
        },
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
      })

      telescope.load_extension("fzf");

      local keymap = vim.keymap
      keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
      keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
      keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
      -- keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })


      -- Load the ui-select extension
      telescope.load_extension('ui-select')

      -- Setup Telescope with the dropdown theme as default
      -- telescope.setup {
      --
      --   },
      --   extensions = {
      --     -- Extension configurations can go here
      --   },
      -- }
      --
      --
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    config = function()
      require("telescope").setup ({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}
