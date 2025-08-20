return {
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 4000,
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
      terminal = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = {
        enabled = true,
        jump = { reuse_win = true },
        matcher = {
          frecency = true,
          history_bonus = true,
          cwd_bonus = true,
        },
        layout = 'ivy_split',
        sources = {
          grep = { hidden = true },
          explorer = { hidden = true },
          lsp_symbols = {
            filter = { default = true },
            layout = 'left',
          },
          smart = {
            sort = {
              fields = {
                'score:desc',
                'idx',
                '#text',
              },
            },
            multi = {
              'marks',
              { source = 'buffers', current = false },
              { source = 'files', hidden = true },
              { source = 'git_files', untracked = true },
            },
          },
        },
        win = {
          input = {
            keys = { ['wq'] = { 'close', mode = 'i' } },
          },
          list = {
            keys = { ['wq'] = { 'close', mode = 'i' } },
          },
        },
      },
    },
    keys = {
      {
        '<C-\\>',
        function()
          Snacks.terminal.toggle()
        end,
        mode = { 'n', 't' },
        desc = 'terminal open',
      },
      {
        '<C-/>',
        function()
          Snacks.terminal.toggle('command -v fish >/dev/null && exec fish || exec bash')
        end,
        mode = { 'n', 't' },
        desc = 'terminal open',
      },
      {
        '<leader><leader>',
        function()
          vim.cmd.delmarks { args = { '0-9' } }
          vim.cmd.delmarks { args = { '"' } }
          Snacks.picker.smart()
        end,
        desc = 'Fuzzy find smart',
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.files()
        end,
        desc = 'Fuzzy find files',
      },
      {
        '<leader>fa',
        function()
          Snacks.picker.grep()
        end,
        desc = 'Fuzzy find grep',
      },
      {
        '<leader>f8',
        function()
          Snacks.picker.grep_word()
        end,
        desc = 'Fuzzy find grep word',
      },
      {
        '<leader>f?',
        function()
          Snacks.picker.pickers()
        end,
        desc = 'See all pickers',
      },
      {
        '<leader>fu',
        function()
          Snacks.picker.undo()
        end,
        desc = 'Pick undotree',
      },
      {
        '<leader>fj',
        function()
          Snacks.picker.jumps()
        end,
        desc = 'Pick jumps',
      },
      {
        '<leader>f.',
        function()
          Snacks.picker.resume()
        end,
        desc = 'Fuzzy find resume',
      },
      {
        '<leader>fb',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Fuzzy find buffers',
      },
      {
        'gO',
        function()
          Snacks.picker.treesitter()
        end,
        desc = 'pick treesitter nodes',
      },
      {
        '<leader>fq',
        function()
          Snacks.picker.qflist()
        end,
        desc = 'pick quickfix list',
      },
      {
        '<leader>jf',
        function()
          require('plugins.lib.snacks_jj').status()
        end,
        desc = 'pick notifications',
      },
    },
  },
}
