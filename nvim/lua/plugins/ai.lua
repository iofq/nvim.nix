return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      panel = {
        enabled = true,
        auto_refresh = false,
        keymap = {
          jump_prev = '<C-p>',
          jump_next = '<C-n>',
          accept = '<C-y>',
          toggle = '<M-CR>',
        },
      },
      suggestion = {
        enabled = false,
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
      },
      filetypes = {
        go = true,
        lua = true,
        php = true,
        python = true,
        ruby = true,
        sh = true,
        bash = true,
        javascript = true,
        puppet = true,
        yaml = true,
        markdown = true,
        ['*'] = false,
      },
    },
  },
  {
    'olimorris/codecompanion.nvim',
    cmd = 'Copilot',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'zbirenbaum/copilot.lua',
    },
    opts = {
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
    },
    keys = {
      {
        '<leader>ac',
        '<cmd>CodeCompanionChat Toggle<CR>',
        noremap = true,
        desc = 'Copilot chat toggle',
      },
      {
        '<leader>as',
        '<cmd>CodeCompanionChat Add<CR>',
        noremap = true,
        mode = { 'n', 'v' },
        desc = 'Copilot chat add selection',
      },
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<CR>',
        noremap = true,
        mode = { 'n', 'v' },
        desc = 'Copilot inline',
      },
    },
  },
}
