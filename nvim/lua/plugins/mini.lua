return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
      require('mini.ai').setup()
      require('mini.comment').setup()
      require('mini.pairs').setup()
      require('mini.statusline').setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode {}
            local git = function()
              local summary = vim.b.gitsigns_head
              if summary == nil then
                return ''
              end
              summary = '~' .. summary

              return summary == '' and '' or summary
            end
            local diff = function()
              local summary = vim.b.gitsigns_status
              if summary == nil then
                return ''
              end

              return summary
            end
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl, strings = { mode } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatusDevinfo', strings = { git(), diff(), diagnostics } },
              { hl = mode_hl, strings = { search } },
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
      vim.opt.showmode = false

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
        },

        clues = {
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      }
      --    Add surrounding with sa
      --    Delete surrounding with sd.
      --    Replace surrounding with sr.
      --    Find surrounding with sf or sF (move cursor right or left).
      --    Highlight surrounding with sh<char>.
      --    'f' - function call (string of alphanumeric symbols or '_' or '.' followed by balanced '()'). In "input" finds function call, in "output" prompts user to enter function name.
      --    't' - tag. In "input" finds tag with same identifier, in "output" prompts user to enter tag name.
      --    All symbols in brackets '()', '[]', '{}', '<>".
      --    '?' - interactive. Prompts user to enter left and right parts.
      require('mini.surround').setup()

      require('mini.trailspace').setup()
      vim.api.nvim_create_user_command('Trim', function()
        require('mini.trailspace').trim()
      end, {})

      -- prefix \
      -- `b` - |'background'|.
      -- `c` - |'cursorline'|.
      -- `C` - |'cursorcolumn'|.
      -- `d` - diagnostic (via |vim.diagnostic.enable()| and |vim.diagnostic.disable()|).
      -- `h` - |'hlsearch'| (or |v:hlsearch| to be precise).
      -- `i` - |'ignorecase'|.
      -- `l` - |'list'|.
      -- `n` - |'number'|.
      -- `r` - |'relativenumber'|.
      -- `s` - |'spell'|.
      -- `w` - |'wrap'|.
      require('mini.basics').setup {
        mappings = {
          windows = true,
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

      -- gS
      require('mini.splitjoin').setup {
        detect = { separator = '[,;\n]' },
      }

      -- Replace text with register 'gr',
      -- Sort text 'gs',
      require('mini.operators').setup()
      require('mini.jump2d').setup { mappings = { start_jumping = '<leader>S' } }

      local indent = require('mini.indentscope')
      indent.setup {
        draw = { delay = 0 },
      }
      indent.gen_animation.none()

      require('mini.notify').setup {
        window = {
          winblend = 0,
          config = {
            anchor = 'SE',
            border = 'double',
            row = vim.o.lines,
          },
        },
      }
    end,
  },
}
