return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp", -- Autocompletion plugin
    "hrsh7th/cmp-nvim-lsp", -- LSP source for nvim-cmp,
    "saadparwaiz1/cmp_luasnip", -- Snippets source for nvim-cmp,
    "L3MON4D3/LuaSnip", -- Snippets plugin
  },
  config = function() 
    
    local lspconfig = require('lspconfig')

    -- When Lsp Client gets attached to buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function(event)
        local opts = {buffer = event.buf}
        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', '<leader>ref', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {})
      end,
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local luasnip = require("luasnip")

    local servers = {
      "lua_ls", "tsserver"
    }

    for _, lsp in ipairs(servers) do 
      lspconfig[lsp].setup{
        -- on_attach = my_custom_on_attach
        capabilities = capabilities
      }
    end


    -- Nvim-cmp needs sources to show suggestions, Sources includes = [language servers, buffers...]
    -- Nvim-cmp doesn't know how to expand a snippet, that's why we need luasnip
    local cmp = require("cmp")
    cmp.setup {
      snippet = {
        expand = function(args) 
          luasnip.lsp_expand(args.body)
        end
      },

      sources = {
        {
          name = 'nvim_lsp'
        },
        {
          name = "buffer"
        },
      },
    }

  end
}
