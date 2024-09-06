return {
  {
    'rcarriga/nvim-dap-ui',
    event = 'VeryLazy',
    dependencies = {
      'nvim-neotest/nvim-nio',
    },
  },
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
    },
    config = function()
      local d = require('dap')
      local w = require('dap.ui.widgets')
      local ui = require('dapui')
      require('dap-go').setup()
      ui.setup()

      local scopes = nil
      vim.keymap.set('n', '<leader>za', function()
        ui.toggle()
      end, { desc = 'toggle dapui' })
      vim.keymap.set('n', '<leader>zz', function()
        d.continue()
      end, { desc = 'start debugger' })
      vim.keymap.set('n', '<leader>zn', function()
        d.step_over()
      end, { desc = 'step over' })
      vim.keymap.set('n', '<leader>zi', function()
        d.step_into()
      end, { desc = 'step into' })
      vim.keymap.set('n', '<leader>zo', function()
        d.step_out()
      end, { desc = 'step out' })
      vim.keymap.set('n', '<leader>zx', function()
        d.toggle_breakpoint()
      end, { desc = 'toggle_breakpoint' })
      vim.keymap.set('n', '<leader>zr', function()
        d.run_last()
      end, { desc = 'run prev' })
      vim.keymap.set({ 'n', 'v' }, '<leader>zh', function()
        ui.eval()
      end, { desc = 'hover' })
      vim.keymap.set({ 'n', 'v' }, '<leader>zp', function()
        require('dap.ui.widgets').preview()
      end, { desc = 'preview' })
      vim.keymap.set('n', '<leader>zf', function()
        local widgets = require('dap.ui.widgets')
        widgets.centered_float(widgets.frames)
      end, { desc = 'view frames' })
    end,
  },
}
