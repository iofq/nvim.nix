if vim.g.did_load_treesitter_plugin then
  return
end
vim.g.did_load_treesitter_plugin = true

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
  },
  indent = {
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
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']]'] = '@function.outer',
        [']a'] = '@parameter.inner',
      },
      goto_previous_start = {
        ['[['] = '@function.outer',
        ['[a'] = '@parameter.inner',
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
  max_lines = 3,
}
