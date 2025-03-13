return {
  {
    'saghen/blink.cmp',
    event = "VeryLazy",
    dependencies = {
      'rafamadriz/friendly-snippets',
      'mikavilpas/blink-ripgrep.nvim'
    },
    opts = {
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
        },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "rg",
            score_offset = -10,
            async = true,
          },
        }
      },
      cmdline = {
        completion = {
          menu = {
            auto_show = true,
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          }
        },
        ghost_text = {
          enabled = true,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label",       "label_description", gap = 1 },
              { "source_name", "kind",              gap = 1 }
            },
          }
        },
        trigger = {
          show_on_keyword = true,
        }
      },
      signature = { enabled = true }
    }
  },
  {
    'L3MON4D3/luasnip',
    event = 'VeryLazy',
    dependencies = { 'rafamadriz/friendly-snippets' },
    config = function()
      local ls = require('luasnip')
      ls.config.set_config {
        history = true,
        updateevents = 'TextChanged, TextChangedI',
      }
      require('luasnip.loaders.from_vscode').lazy_load()

      vim.keymap.set({ 'i', 's' }, '<C-J>', function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-K>', function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end, { silent = true })

      vim.keymap.set({ 'i', 's' }, '<C-L>', function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true })
    end,
  },
}
