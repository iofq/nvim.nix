return {
  {
    'saghen/blink.cmp',
    event = 'VeryLazy',
    dependencies = {
      'mikavilpas/blink-ripgrep.nvim',
    },
    opts = {
      enabled = function()
        return not vim.tbl_contains({ 'snacks_picker_input' }, vim.bo.filetype)
      end,
      fuzzy = {
        sorts = {
          'exact',
          'score',
          'sort_text',
        },
      },
      sources = {
        default = {
          'lsp',
          'path',
          'snippets',
          'ripgrep',
          'buffer',
        },
        providers = {
          lsp = {
            fallbacks = {}, -- include buffer even when LSP is active
            score_offset = 10,
          },
          snippets = {
            score_offset = -10,
          },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
          ripgrep = {
            module = 'blink-ripgrep',
            name = 'rg',
            score_offset = -10,
            async = true,
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
          auto_show = true,
          auto_show_delay_ms = 500,
        },
        menu = {
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
      signature = {
        enabled = true,
        trigger = {
          show_on_insert = true,
        },
      },
    },
  },
}
