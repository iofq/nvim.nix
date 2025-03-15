return {
  { 'fang2hou/blink-copilot' },
  {
    'saghen/blink.cmp',
    event = 'VeryLazy',
    dependencies = {
      'rafamadriz/friendly-snippets',
      'mikavilpas/blink-ripgrep.nvim',
      'fang2hou/blink-copilot',
    },
    opts = {
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'omni',
          'ripgrep',
          'copilot',
        },
        providers = {
          ripgrep = {
            module = 'blink-ripgrep',
            name = 'rg',
            score_offset = -30,
            async = true,
          },
          copilot = {
            module = 'blink-copilot',
            name = 'Copilot',
            score_offset = 100,
            async = true,
            opts = {
              max_completions = 3,
              debounce = 500,
              auto_refresh = {
                backward = false,
                forward = false,
              }
            },
          },
        },
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
          window = { border = 'rounded' },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        ghost_text = {
          enabled = false,
        },
        menu = {
          border = 'rounded',
          draw = {
            treesitter = { 'lsp' },
            columns = {
              { 'label',       'label_description', gap = 1 },
              { 'source_name', 'kind',              gap = 1 },
            },
          },
        },
        trigger = {
          show_on_keyword = true,
        },
      },
      signature = { enabled = true },
    },
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
