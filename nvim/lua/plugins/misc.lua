return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'stevearc/oil.nvim',
    opts = {
      watch_for_changes = true,
      columns = {
        'permissions',
        'size',
      },
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ['wq'] = 'actions.close',
      },
    },
    keys = {
      {
        '<leader>nc',
        function()
          require('oil').toggle_float()
        end,
        { noremap = true, silent = true },
      },
    },
  },
  {
    'jinh0/eyeliner.nvim',
    event = 'VeryLazy',
    init = function()
      vim.api.nvim_set_hl(0, 'EyelinerPrimary', { underline = true })
      vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true, bold = true })
    end,
  },
  { 'tiagovla/scope.nvim',                       event = 'VeryLazy', config = true },
  { 'MeanderingProgrammer/render-markdown.nvim', event = 'VeryLazy', config = true },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    opts = {
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
      { '<leader>nb', vim.cmd.DiffviewOpen, noremap = true, desc = 'diffview open' },
    },
  },
  {
    'NeogitOrg/neogit',
    opts = {
      disable_builtin_notifications = true,
      integrations = {
        diffview = true,
      },
    },
    keys = {
      {
        '<leader>ng',
        function()
          require('neogit').open()
        end,
        { noremap = true, silent = true, desc = 'Neogit' },
      },
    },
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
        terminal_colors = true,
        modules = {
          'mini',
          'treesitter',
          'neogit',
        },
      },
    },
    config = function(_, opts)
      require('nightfox').setup(opts)
      vim.cmd('colorscheme terafox')
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = 'green', bold = true })
      vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = 'red', bold = true })
      vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = 'green', bold = true })
      vim.api.nvim_set_hl(0, 'GitSignsCurrentLineBlame', { link = 'Comment' })
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signcolumn = false,
      numhl = true,
      on_attach = function()
        local gs = package.loaded.gitsigns
        vim.keymap.set('n', '<leader>gg', gs.preview_hunk, { desc = 'git preview hunk' })
        vim.keymap.set('n', '<leader>gR', gs.reset_hunk, { desc = 'git reset hunk' })
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk, { desc = 'git stage hunk' })
        vim.keymap.set('n', '<leader>gd', gs.diffthis, { desc = 'git diff hunk' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'git blame_line current' })
        vim.keymap.set('n', '<leader>gB', gs.toggle_current_line_blame, { desc = 'git blame_line toggle' })
        vim.keymap.set('v', '<leader>gR', function()
          gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'git reset hunk' })

        -- Navigation
        vim.keymap.set('n', ']g', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk { target = 'all' }
          end)
          return '<Ignore>'
        end, { expr = true })

        vim.keymap.set('n', '[g', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk { target = 'all' }
          end)
          return '<Ignore>'
        end, { expr = true })
      end,
    },
  },
  {
    'gbprod/yanky.nvim',
    opts = {
      ring = {
        storage = 'memory',
      },
      picker = {
        select = {
          action = require('yanky.picker').actions.set_register('+'),
        },
      },
    },
    keys = {
      { 'y', '<Plug>(YankyYank)', mode = { 'n', 'x' } },
      {
        '<leader>fp',
        '<cmd>YankyRingHistory<cr>',
        mode = { 'n', 'x' },
        noremap = true,
        silent = true,
        desc = 'Pick history (yanky.nvim)',
      },
    },
  },
  { 'ThePrimeagen/refactoring.nvim', event = 'VeryLazy', config = true },
}
