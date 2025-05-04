return {
  "rcarriga/nvim-dap-ui",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup()

    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.keymap.set('n', '<Leader>db', function() dap.toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>dc', function() dap.continue() end)

    -- c & rust dap
    dap.adapters.lldb = {
      type = 'executable',
      command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
      name = 'lldb'
    }

    dap.configurations.c = {
      {
        name = 'Launch',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
      },
    }

  end
}
