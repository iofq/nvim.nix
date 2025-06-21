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
        ignore_install = { 'org' },
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
              [']]'] = '@statement.outer',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[f'] = '@function.outer',
              ['[['] = '@statement.outer',
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
