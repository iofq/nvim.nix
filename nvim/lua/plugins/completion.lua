return {
  {
    'saghen/blink.cmp',
    event = 'VeryLazy',
    dependencies = {
      'mikavilpas/blink-ripgrep.nvim',
      'fang2hou/blink-copilot',
    },
    opts = {
      sources = {
        default = {
          'lsp',
          'path',
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
                forward = true,
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
      signature = { enabled = true },
    },
  },
}
