return {
  {
    "folke/snacks.nvim",
    dependencies = { "folke/trouble.nvim" },
    lazy = false,
    priority = 1000,
    opts = {
      bigfile = { enabled = true },
      notifier = { enabled = true },
      scope = { enabled = true },
      terminal = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      words = { enabled = true },
      picker = {
        enabled = true,
        matcher = { frecency = true },
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "telescope" or "vertical"
          end
        },
        picker = {
          sources = {
            files = { hidden = true },
            grep = { hidden = true },
            explorer = { hidden = true },
          },
        },
        actions = {
          trouble_open = function(...)
            return require("trouble.sources.snacks").actions.trouble_open.action(...)
          end,
        },
        win = {
          input = {
            keys = {
              ["wq"] = { "close", mode = "i" },
              ["<c-t>"] = { "trouble_open", mode = { "n", "i" },
              },
            }
          },
          list = {
            keys = {
              ["wq"] = { "close", mode = "i" },
            }
          }
        }
      },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
      vim.api.nvim_set_hl(0, 'SnacksPickerDir', { fg = '#cccccc' })
    end,
    keys = {
      { '<C-\\>', function() Snacks.terminal.toggle() end,    mode = { "n", "t" }, noremap = true,         desc = 'terminal open' },
      { 'm',      function() Snacks.words.jump(1, true) end,  noremap = true,      desc = 'next reference' },
      { 'M',      function() Snacks.words.jump(-1, true) end, noremap = true,      desc = 'next reference' },
      {
        '<leader>ff',
        function() Snacks.picker.smart() end,
        { noremap = true, silent = true, desc = 'Fuzzy find files' }
      },
      {
        '<leader>fg',
        function() Snacks.picker.files() end,
        { noremap = true, silent = true, desc = 'Fuzzy find files' }
      },
      {
        '<leader>fa',
        function() Snacks.picker.grep() end,
        { noremap = true, silent = true, desc = 'Fuzzy find grep' }
      },
      {
        '<leader>f8',
        function() Snacks.picker.grep_word() end,
        { noremap = true, silent = true, desc = 'Fuzzy find grep word' }
      },
      {
        '<leader>f?',
        function() Snacks.picker.pickers() end,
        { noremap = true, silent = true, desc = 'See all pickers' }
      },
      {
        '<leader>f.',
        function() Snacks.picker.resume() end,
        { noremap = true, silent = true, desc = 'Fuzzy find resume' }
      },
      {
        '<leader><leader>',
        function() Snacks.picker.buffers() end,
        { noremap = true, silent = true, desc = 'Fuzzy find buffers' }
      },
    }
  }
}
