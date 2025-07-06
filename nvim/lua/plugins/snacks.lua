return {
  {
    'folke/snacks.nvim',
    dependencies = {
      'folke/trouble.nvim',
    },
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      bufdelete = { enabled = true },
      quickfile = { enabled = true },
      notifier = { enabled = true },
      terminal = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      words = { enabled = true },
      picker = {
        enabled = true,
        matcher = { frecency = true },
        layout = {
          preset = function()
            return vim.o.columns >= 120 and 'telescope' or 'vertical'
          end,
        },
        sources = {
          files = { hidden = true },
          grep = { hidden = true },
          explorer = { hidden = true },
          git_files = { untracked = true },
          smart = {
            multi = { 'buffers', 'recent', 'files' },
          },
        },
        actions = {
          trouble_open = function(...)
            return require('trouble.sources.snacks').actions.trouble_open.action(...)
          end,
        },
        win = {
          input = {
            keys = {
              ['wq'] = { 'close', mode = 'i' },
              ['<c-t>'] = { 'trouble_open', mode = { 'n', 'i' } },
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
    config = function(_, opts)
      require('snacks').setup(opts)
      vim.api.nvim_set_hl(0, 'SnacksPickerDir', { fg = '#cccccc' })
    end,
    keys = {
      {
        '<C-\\>',
        function()
          Snacks.terminal.toggle()
        end,
        mode = { 'n', 't' },
        noremap = true,
        desc = 'terminal open',
      },
      {
        '<C-/>',
        function()
          Snacks.terminal.toggle('$SHELL')
        end,
        mode = { 'n', 't' },
        noremap = true,
        desc = 'terminal open',
      },
      {
        ']r',
        function()
          Snacks.words.jump(1, true)
        end,
        noremap = true,
        desc = 'next reference',
      },
      {
        '[r',
        function()
          Snacks.words.jump(-1, true)
        end,
        noremap = true,
        desc = 'next reference',
      },
      {
        '\\z',
        function()
          if Snacks.dim.enabled then
            Snacks.dim.disable()
          else
            Snacks.dim.enable()
          end
        end,
        noremap = true,
        desc = 'next reference',
      },
      {
        'gq',
        function()
          Snacks.bufdelete()
        end,
        noremap = true,
        silent = true,
      },
      {
        'gQ',
        function()
          Snacks.bufdelete.other()
        end,
        noremap = true,
        silent = true,
      },
      {
        '<leader>ff',
        function()
          Snacks.picker.smart()
        end,
        noremap = true,
        desc = 'Fuzzy find files',
      },
      {
        '<leader>fe',
        function()
          Snacks.explorer()
        end,
        noremap = true,
        desc = 'snacks explorer',
      },
      {
        '<leader>fg',
        function()
          Snacks.picker.git_files()
        end,
        noremap = true,
        silent = true,
        desc = 'Fuzzy find files',
      },
      {
        '<leader>fa',
        function()
          Snacks.picker.grep()
        end,
        noremap = true,
        silent = true,
        desc = 'Fuzzy find grep',
      },
      {
        '<leader>f8',
        function()
          Snacks.picker.grep_word()
        end,
        noremap = true,
        silent = true,
        desc = 'Fuzzy find grep word',
      },
      {
        '<leader>f?',
        function()
          Snacks.picker.pickers()
        end,
        noremap = true,
        silent = true,
        desc = 'See all pickers',
      },
      {
        '<leader>fu',
        function()
          Snacks.picker.undo()
        end,
        noremap = true,
        silent = true,
        desc = 'Pick undotree',
      },
      {
        '<leader>fj',
        function()
          Snacks.picker.jumps()
        end,
        noremap = true,
        silent = true,
        desc = 'Pick jumps',
      },
      {
        '<leader>f.',
        function()
          Snacks.picker.resume()
        end,
        noremap = true,
        silent = true,
        desc = 'Fuzzy find resume',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        noremap = true,
        silent = true,
        desc = 'Fuzzy find buffers',
      },
      {
        '<leader>fn',
        function()
          Snacks.picker.notifications()
        end,
        noremap = true,
        silent = true,
        desc = 'pick notifications',
      },
      {
        '<leader>fm',
        function()
          vim.cmd.delmarks { args = { '0-9' } }
          Snacks.picker.pick {
            finder = 'vim_marks',
            format = 'file',
            ['local'] = false,
            global = true,
            actions = {
              markdel = function(picker)
                for _, item in ipairs(picker:selected()) do
                  vim.cmd.delmarks { args = { item.label } }
                end
                vim.cmd('wshada')
                picker.list:set_selected()
                picker.list:set_target()
                picker:find()
              end,
            },
            win = {
              input = {
                keys = {
                  ['<c-x>'] = { 'markdel', mode = { 'n', 'i' } },
                },
              },
              list = {
                keys = { ['dd'] = 'markdel' },
              },
            },
          }
        end,
        noremap = true,
        silent = true,
        desc = 'pick global marks',
      },
      {
        '<leader>jf',
        function()
          require('plugins.lib.snacks_jj').status()
        end,
        noremap = true,
        silent = true,
        desc = 'pick notifications',
      },
      {
        '<leader>jj',
        function()
          require('plugins.lib.snacks_jj').revs()
        end,
        noremap = true,
        silent = true,
        desc = 'pick notifications',
      },
    },
  },
}
