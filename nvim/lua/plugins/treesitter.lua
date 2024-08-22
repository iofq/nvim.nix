return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-context',
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = {},
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KiB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
        autopairs = {
          enable = true,
        },
        matchup = {
          enable = true,
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['aa'] = '@statement.outer',
              ['ia'] = '@parameter.inner',
              ["ik"] = "@assignment.lhs",
              ["ak"] = "@assignment.inner",
              ["iv"] = "@assignment.rhs",
              ["av"] = "@assignment.outer",
            },
          },
          move = {
            enable = true,
            goto_next_start = {
              [']a'] = '@parameter.inner',
              [']f'] = '@function.outer',
              [']]'] = '@block.inner',
            },
            goto_previous_start = {
              ['[a'] = '@parameter.inner',
              ['[f'] = '@function.outer',
              ['[['] = '@block.inner',
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ['s]'] = '@parameter.inner',
            },
            swap_previous = {
              ['s['] = '@parameter.inner',
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

      require('treesitter-context').setup {
        max_lines = 2,
        min_window_height = 50,
      }
    end,
  },
}
