return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    keys = {
      {
        'M-\\',
        '<cmd>Copilot panel<CR>',
        noremap = true,
        desc = 'Copilot panel'
      }
    },
    opts = {
      panel = { enabled = true, keymap = { accept = "ga" } },
      suggestion = {
        enabled = true,
        auto_trigger = true,
        keymap = {
          accept = "<M-]>",
          next = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      completion = {
        documentation = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          }
        },
        accept = {
          auto_brackets = {
            enabled = true
          }
        },
      },
      filetypes = {
        go = true,
        lua = true,
        php = true,
        python = true,
        ruby = true,
        sh = true,
        puppet = true,
        yaml = true,
        markdown = true,
        ["."] = false,
      }
    }
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = "Copilot",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "zbirenbaum/copilot.lua",
    },
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            name = "copilot-claude-3.5-sonnet",
            schema = { model = "claude-3.5-sonnet", },
          })
        end
      },
      strategies = {
        chat = { adapter = "copilot-claude-3.5-sonnet", },
        inline = { adapter = "copilot-claude-3.5-sonnet", },
      },
    },
    init = function()
      vim.api.nvim_create_user_command('CC', ':CodeCompanion', {})
    end,
    keys = {
      {
        '<leader>ac',
        '<cmd>CodeCompanionChat Toggle<CR>',
        noremap = true,
        desc = 'Copilot chat toggle'
      },
      {
        '<leader>as',
        '<cmd>CodeCompanionChat Add<CR>',
        noremap = true,
        desc = 'Copilot chat add selection'
      },
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<CR>',
        noremap = true,
        desc = 'Copilot inline'
      }
    }

  },
}
