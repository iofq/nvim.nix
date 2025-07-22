return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context",
        opts = {
          max_lines = 2,
          min_window_height = 50,
        },
      },
      "nvim-treesitter/nvim-treesitter-textobjects",
      "RRethy/nvim-treesitter-textsubjects",
    },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {},
      auto_install = false,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
      matchup = {
        enable = true,
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]a"] = "@parameter.inner",
            ["]f"] = "@function.outer",
          },
          goto_previous_start = {
            ["[a"] = "@parameter.inner",
            ["[f"] = "@function.outer",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["a]"] = "@parameter.inner",
          },
          swap_previous = {
            ["a["] = "@parameter.inner",
          },
        },
      },
    },
  },
}
