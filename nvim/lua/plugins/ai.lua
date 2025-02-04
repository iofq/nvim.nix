return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      panel = { enabled = false },
      suggestion = {
        enabled = true,
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
    "yetone/avante.nvim",
    cmd = "Copilot",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "zbirenbaum/copilot.lua",
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      behavior = {
        auto_suggestions = false, -- TODO
      },
      file_selector = {
        provider = "native", -- TODO snacks once it's ready
      },
      windows = {
        width = 50,
        ask = {
          floating = true
        }
      }
    }
  }
}
