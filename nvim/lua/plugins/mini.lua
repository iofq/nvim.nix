return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    dependencies = { 'folke/snacks.nvim' },
    config = function()
      require('mini.basics').setup { mappings = { windows = true } }
      require('mini.tabline').setup {
        tabpage_section = 'right',
        show_icons = false,
      }
      require('mini.statusline').setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode {}
            local git = function()
              local g = vim.b.gitsigns_head
              return (g == nil) and '' or g
            end
            local diff = function()
              local g = vim.b.gitsigns_status
              return (g == nil) and '' or g
            end
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl,                  strings = { mode } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatusDevinfo', strings = { git(), diff(), diagnostics, lsp } },
              { hl = mode_hl,             strings = { search } },
            }
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            return MiniStatusline.combine_groups {
              { hl = 'MiniStatuslineFilename', strings = { filename } },
            }
          end,
        },
      }
      vim.schedule(function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.bracketed').setup()
        require('mini.icons').setup()
        require('mini.jump2d').setup { mappings = { start_jumping = '<leader>S' } }
        require('mini.operators').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }

        local miniclue = require('mini.clue')
        miniclue.setup {
          triggers = {
            { mode = 'n', keys = '<Leader>' },
            { mode = 'n', keys = 'g' },
            { mode = 'n', keys = "'" },
            { mode = 'n', keys = '`' },
            { mode = 'n', keys = '"' },
            { mode = 'n', keys = '<C-w>' },
            { mode = 'n', keys = 'z' },
            { mode = 'n', keys = ']' },
            { mode = 'n', keys = '[' },
          },
          window = {
            config = { width = 'auto' },
          },
          clues = {
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
            { mode = 'n', keys = '<Leader>wj',     postkeys = '<Leader>w', desc = 'TS Down' },
            { mode = 'n', keys = '<Leader>wk',     postkeys = '<Leader>w', desc = 'TS Up' },
            { mode = 'n', keys = '<Leader>wh',     postkeys = '<Leader>w', desc = 'TS Left' },
            { mode = 'n', keys = '<Leader>wl',     postkeys = '<Leader>w', desc = 'TS Right' },
            { mode = 'n', keys = '<Leader>w<C-J>', postkeys = '<Leader>w', desc = 'Swap TS Down' },
            { mode = 'n', keys = '<Leader>w<C-K>', postkeys = '<Leader>w', desc = 'Swap TS Up' },
            { mode = 'n', keys = '<Leader>w<C-H>', postkeys = '<Leader>w', desc = 'Swap TS Left' },
            { mode = 'n', keys = '<Leader>w<C-L>', postkeys = '<Leader>w', desc = 'Swap TS Right' },
          },
        }

        local map = require('mini.map')
        map.setup {
          symbols = {
            scroll_line = '┃',
            scroll_view = '',
          },
          integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diagnostic(),
            map.gen_integration.gitsigns(),
          },
          window = {
            show_integration_count = false,
            winblend = 0,
            width = 5,
          },
        }
        vim.keymap.set('n', '<leader>nm', map.toggle, { noremap = true, desc = 'minimap open' })
      end)
    end,
  },
}
