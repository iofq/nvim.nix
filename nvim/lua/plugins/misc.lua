return {
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
  { 'tiagovla/scope.nvim',           event = 'VeryLazy', config = true },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    event = 'VeryLazy',
    opts = {
      file_types = { 'markdown' },
    },
  },
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
      {
        '<leader>nh',
        vim.cmd.DiffviewFileHistory,
        mode = { 'n', 'v' },
        noremap = true,
        desc = 'diffview history',
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
          'native_lsp',
          'diagnostic',
          'modes',
        },
      },
    },
    config = function(_, opts)
      require('nightfox').setup(opts)
      vim.cmd('colorscheme terafox')
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'TablineFill', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'MiniDiffSignAdd', { fg = 'green', bold = true })
      vim.api.nvim_set_hl(0, 'MiniDiffSignDelete', { fg = 'red', bold = true })
      vim.api.nvim_set_hl(0, 'MiniDiffSignChange', { fg = 'green', bold = true })
      vim.api.nvim_set_hl(0, 'BlinkCmpGhostText', { link = 'String' })
    end,
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
