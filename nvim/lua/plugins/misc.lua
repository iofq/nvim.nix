return {
  {
    'iofq/dart.nvim',
    lazy = false,
    priority = 1001,
    config = true,
  },
  {
    'windwp/nvim-autopairs',
    event = 'VeryLazy',
    config = true,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    branch = 'main',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        config = true,
      },
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 5,
          min_window_height = 50,
        },
      },
    },
  },
  {
    'jinh0/eyeliner.nvim',
    event = 'VeryLazy',
    config = true,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'VeryLazy',
    opts = {
      completions = {
        blink = { enabled = true },
      },
    },
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    opts = {
      use_icons = false,
      enhanced_diff_hl = true,
      default_args = {
        DiffviewOpen = { '--imply-local' },
      },
      view = {
        merge_tool = {
          layout = 'diff4_mixed',
          disable_diagnostics = true,
        },
      },
      keymaps = {
        view = {
          { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
        },
        file_panel = {
          { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
        },
        file_history_panel = {
          { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
        },
      },
    },
    keys = {
      { '<leader>nb', vim.cmd.DiffviewOpen, desc = 'diffview open' },
      {
        '<leader>nh',
        '<cmd>DiffviewFileHistory %<cr>',
        mode = { 'n', 'v' },
        desc = 'diffview history',
      },
      {
        '<leader>nH',
        '<cmd>DiffviewFileHistory<cr>',
        mode = { 'n', 'v' },
        desc = 'diffview history',
      },
    },
  },
  {
    'ThePrimeagen/refactoring.nvim',
    event = 'VeryLazy',
    config = true,
    keys = {
      { '<leader>rv', '<cmd>Refactor inline_var<cr>dd', mode = { 'n', 'x' } },
      {
        '<leader>rr',
        function()
          require('refactoring').select_refactor { prefer_ex_cmd = true }
        end,
        mode = { 'n', 'x' },
      },
    },
  },
  {
    'stevearc/quicker.nvim',
    event = 'VeryLazy',
    opts = {
      follow = {
        enabled = true,
      },
    },
    keys = {
      {
        '<leader>qf',
        function()
          require('quicker').toggle { max_height = 20 }
        end,
        desc = 'Toggle qflist',
      },
      {
        '<leader>qr',
        function()
          require('quicker').refresh()
        end,
        desc = 'Refresh qflist',
      },
      {
        '<leader>q>',
        function()
          require('quicker').expand { before = 2, after = 2, add_to_existing = true }
        end,
        desc = 'Expand quickfix context',
      },
      {
        '<leader>q<',
        function()
          require('quicker').collapse()
        end,
        desc = 'Collapse quickfix context',
      },
    },
  },
}
