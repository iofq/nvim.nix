return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        opts = {
          max_lines = 2,
          min_window_height = 50,
        },
      },
      'nvim-treesitter/nvim-treesitter-textobjects',
      {
        'aaronik/treewalker.nvim',
        keys = {
          { '<leader>wj',     '<cmd>Treewalker Down<cr>',      silent = true, desc = 'Down (Treewalker)' },
          { '<leader>wk',     '<cmd>Treewalker Up<cr>',        silent = true, desc = 'Up (Treewalker)' },
          { '<leader>wh',     '<cmd>Treewalker Left<cr>',      silent = true, desc = 'Left (Treewalker)' },
          { '<leader>wl',     '<cmd>Treewalker Right<cr>',     silent = true, desc = 'Right (Treewalker)' },
          { '<leader>w<C-J>', '<cmd>Treewalker SwapDown<cr>',  silent = true, desc = 'SwapDown (Treewalker)' },
          { '<leader>w<C-K>', '<cmd>Treewalker SwapUp<cr>',    silent = true, desc = 'SwapUp (Treewalker)' },
          { '<leader>w<C-H>', '<cmd>Treewalker SwapLeft<cr>',  silent = true, desc = 'SwapLeft (Treewalker)' },
          { '<leader>w<C-L>', '<cmd>Treewalker SwapRight<cr>', silent = true, desc = 'SwapRight (Treewalker)' },
        },
      },
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {},
        auto_install = false,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ia'] = '@parameter.inner',
              ['ik'] = '@assignment.lhs',
              ['iv'] = '@assignment.rhs',
              ['is'] = { query = '@local.scope', query_group = 'locals', desc = 'Select language scope' },
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              [']a'] = '@parameter.inner',
              [']f'] = '@function.outer',
              ['}'] = '@statement.outer',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[f'] = '@function.outer',
              ['{'] = '@statement.outer',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['a]'] = '@parameter.inner',
            },
            swap_previous = {
              ['a['] = '@parameter.inner',
            },
          },
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
          },
        },
      }
    end,
  },
}
