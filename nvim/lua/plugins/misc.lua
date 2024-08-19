return {
  {
    'danymat/neogen',
    keys = {
      { '<leader>nd', '<cmd>Neogen<CR>', { noremap = true, silent = true, desc = 'Neogen - gen comments' } },
    },
  },
  {
    'akinsho/toggleterm.nvim',
    event = 'VeryLazy',
    opts = {
      open_mapping = [[<C-\>]],
      direction = 'float',
      close_on_exit = true,
      autochdir = true,
    },
  },
  {
    'jinh0/eyeliner.nvim',
    event = 'VeryLazy',
    config = function()
      vim.api.nvim_set_hl(0, 'EyelinerPrimary', { underline = true })
      vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true })
    end,
  },
  { 'OXY2DEV/markview.nvim', event = 'VeryLazy' },
  { 'tiagovla/scope.nvim', event = 'VeryLazy' },
  {
    'chrisgrieser/nvim-early-retirement',
    event = 'VeryLazy',
    opts = { minimumBufferNum = 6 },
  },
  {
    'AckslD/nvim-neoclip.lua',
    event = 'VeryLazy',
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      default_register = '+',
    },
    config = function(_, opts)
      require('neoclip').setup(opts)
      vim.keymap.set(
        'n',
        '<leader>fp',
        '<cmd>Telescope neoclip<CR>',
        { noremap = true, silent = true, desc = 'Pick clipboard history' }
      )
    end,
  },
  {
    'leath-dub/snipe.nvim',
    event = 'VeryLazy',
    opts = {
      ui = {
        position = 'center',
      },
      sort = 'last',
    },
    config = function(_, opts)
      local snipe = require('snipe')
      snipe.setup(opts)
      vim.keymap.set(
        'n',
        '<leader>fb',
        snipe.open_buffer_menu,
        { noremap = true, silent = true, desc = 'Pick buffers (snipe.nvim)' }
      )
    end,
  },
  {
    'sindrets/diffview.nvim',
    event = 'VeryLazy',
    opts = {
      enhanced_diff_hl = true,
      default_args = {
        DiffviewOpen = { '--imply-local' },
      },
    },
    config = function()
      vim.keymap.set('n', '<leader>nb', vim.cmd.DiffviewOpen, { noremap = true, desc = 'diffview open' })
    end,
  },
  {
    'NeogitOrg/neogit',
    opts = {
      disable_builtin_notifications = true,
      integrations = {
        diffview = true,
        telescope = true,
        fzf_lua = true,
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
    'mbbill/undotree',
    event = 'VeryLazy',
    keys = {
      { '<leader>nu', '<cmd>UndotreeToggle<cr>' },
    },
    config = function()
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SetFocusWhenToggle = 1
    end,
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 10000,
    opts = {
      options = {
        transparent = true,
        terminal_colors = false,
      },
    },
    config = function(_, opts)
      require('nightfox').setup(opts)
      vim.cmd('colorscheme terafox')
      vim.api.nvim_set_hl(0, 'MiniNotifyNormal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'MiniNotifyTitle', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'MiniNotifyBorder', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'MiniMapNormal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'MiniClueNormal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = 'green', bold = true })
      vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = 'red', bold = true })
      vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = 'green', bold = true })
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
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk, { desc = 'git reset hunk' })
        vim.keymap.set('n', '<leader>gb', function()
          gs.blame_line { full = true }
        end, { desc = 'git blame_line' })
        vim.keymap.set('v', '<leader>gr', function()
          gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = 'git reset hunk' })

        -- Navigation
        vim.keymap.set('n', ']g', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })

        vim.keymap.set('n', '[g', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true })
      end,
    },
  },
  {
    'hedyhli/outline.nvim',
    cmd = { 'Outline', 'OutlineOpen' },
    keys = {
      { '<leader>no', '<cmd>Outline<CR>', desc = 'Toggle outline' },
    },
    opts = {
      outline_window = {
        position = 'left',
        width = 30,
        auto_close = true,
      },
    },
  },
}
