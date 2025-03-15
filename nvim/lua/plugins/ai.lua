return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    opts = {
      panel = { enabled = false, },
      suggestion = { enabled = false, },
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
        ["*"] = false,
      }
    }
  },
  {
    "github/copilot.vim",
    cmd = "Copilot",
    event = "BufWinEnter",
    init = function()
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup("github_copilot", { clear = true })
      vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
        group = "github_copilot",
        callback = function(args)
          vim.fn["copilot#On" .. args.event]()
        end,
      })
      vim.fn["copilot#OnFileType"]()
    end,
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
      strategies = {
        chat = { adapter = "copilot", },
        inline = { adapter = "copilot", },
      },
    },
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
        mode = { "n", "v" },
        desc = 'Copilot chat add selection'
      },
      {
        '<leader>aa',
        '<cmd>CodeCompanionActions<CR>',
        noremap = true,
        mode = { "n", "v" },
        desc = 'Copilot inline'
      }
    }

  },
}
