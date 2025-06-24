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
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {},
        auto_install = false,
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        textobjects = {
          move = {
            enable = true,
            goto_next_start = {
              [']a'] = '@parameter.inner',
              [']f'] = '@function.outer',
              [']t'] = '@statement.outer',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[f'] = '@function.outer',
              ['[t'] = '@statement.outer',
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
            node_incremental = 'v',
            node_decremental = '<S-TAB>',
          },
        },
      }
    end,
  },
}
