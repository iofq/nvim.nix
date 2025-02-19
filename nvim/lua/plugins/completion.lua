return {
  {
    'saghen/blink.cmp',
    event = "VeryLazy",
    dependencies = {
      'saghen/blink.compat',
      'rafamadriz/friendly-snippets',
      'giuxtaposition/blink-cmp-copilot',
      'mikavilpas/blink-ripgrep.nvim'
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuOpen',
        callback = function()
          require("copilot.suggestion").dismiss()
          vim.b.copilot_suggestion_hidden = true
        end,
      })

      vim.api.nvim_create_autocmd('User', {
        pattern = 'BlinkCmpMenuClose',
        callback = function()
          vim.b.copilot_suggestion_hidden = false
        end,
      })
    end,
    opts = {
      sources = {
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
          "copilot"
        },
        providers = {
          ripgrep = {
            module = "blink-ripgrep",
            name = "rg",
            score_offset = -10,
          },
          copilot = {
            name = "copilot",
            module = "blink-cmp-copilot",
            score_offset = 100,
            async = true,
          },
        }
      },
      keymap = {
        ["<C-space>"] = { "show", "select_and_accept" }
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
        accept = {
          auto_brackets = {
            enabled = true
          }
        },
        menu = {
          -- auto show in cmdline
          auto_show = true,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label",       "label_description", gap = 1 },
              { "source_name", "kind",              gap = 1 }
            },
          }
        },
        trigger = {
          show_on_keyword = false,
        }
      },
      appearance = {
        use_nvim_cmp_as_default = true,
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
