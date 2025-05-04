return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    opts = {
      panel = {
        enabled = false,
      },
      suggestion = {
        enabled = false,
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
      'MeanderingProgrammer/render-markdown.nvim',
    },
    opts = {
      strategies = {
        chat = { adapter = 'copilot' },
        inline = { adapter = 'copilot' },
      },
      adapters = {
        ollama = function()
          return require('codecompanion.adapters').extend('ollama', {
            schema = {
              model = { default = 'qwen2.5-coder:1.5b' },
            },
          })
        end,
      },
    },
    keys = {
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
