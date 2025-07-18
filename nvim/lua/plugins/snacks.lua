return {
  {
    'folke/snacks.nvim',
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      notifier = {
        enabled = true,
        timeout = 5000,
      },
      styles = {
        notification = {
          wo = { wrap = true },
        },
      },
      terminal = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      words = { enabled = true },
      picker = {
        enabled = true,
        matcher = {
          frecency = true,
          history_bonus = true,
        },
        layout = 'ivy_split',
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
          git_files = { untracked = true },
          lsp_symbols = {
            filter = { default = true },
            layout = 'left',
          },
          smart = {
            multi = {
              'marks',
              { source = 'buffers',   current = false },
              'recent',
              { source = 'files',     hidden = true },
              { source = 'git_files', untracked = true },
            },
          },
        },
        win = {
          input = {
            keys = {
              ['wq'] = { 'close', mode = 'i' },
            },
          },
          list = {
            keys = {
              ['wq'] = { 'close', mode = 'i' },
            },
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
          Snacks.terminal.toggle('$SHELL')
        end,
        mode = { 'n', 't' },
        desc = 'terminal open',
      },
      {
        ']r',
        function()
          Snacks.words.jump(1, true)
        end,
        desc = 'next reference',
      },
      {
        '[r',
        function()
          Snacks.words.jump(-1, true)
        end,
        desc = 'next reference',
      },
      {
        '<leader><leader>',
        function()
          vim.cmd.delmarks { args = { '0-9' } }
          Snacks.picker.smart()
        end,
        desc = 'Fuzzy find smart',
      },
      {
        '<leader>fe',
        function()
          Snacks.explorer()
        end,
        desc = 'snacks explorer',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        desc = 'Fuzzy find git files',
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
        '<leader>fn',
        function()
          Snacks.picker.notifications()
        end,
        desc = 'pick notifications',
      },
      {
        '<leader>fm',
        function()
          require('plugins.lib.snacks').marks()
        end,
        desc = 'pick global marks',
      },
      {
        '<leader>jf',
        function()
          require('plugins.lib.snacks_jj').status()
        end,
        desc = 'pick notifications',
      },
      {
        '<leader>jj',
        function()
          require('plugins.lib.snacks_jj').revs()
        end,
        desc = 'pick notifications',
      },
    },
  },
}
