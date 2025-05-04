return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    dependencies = { 'folke/snacks.nvim' },
    keys = {
      {
        '<leader>gp',
        function()
          MiniDiff.toggle_overlay(0)
        end,
        noremap = true,
        desc = 'git diff overlay',
      },
      {
        '<leader>gr',
        function()
          return MiniDiff.operator('reset') .. 'gh'
        end,
        noremap = true,
        desc = 'git diff reset',
      },
      {
        '<leader>gd',
        function()
          return MiniGit.show_at_cursor()
        end,
        noremap = true,
        desc = 'git show at cursor',
      },
      {
        '<leader>gb',
        '<Cmd>vert Git blame -- %<CR>',
        noremap = true,
        desc = 'git blame',
      },
      {
        '<leader>gg',
        ':Git ',
        noremap = true,
        desc = 'git command',
      },
    },
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
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local diff = MiniStatusline.section_diff { trunc_width = 75, icon = '' }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl,                  strings = { mode } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatusDevinfo', strings = { diff, diagnostics, lsp } },
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
        require('mini.operators').setup {
          replace = {
            prefix = 'gR',
          },
        }
        require('mini.pairs').setup {
          modes = { insert = true, command = true, terminal = false },
          skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
          skip_ts = { 'string' },
          skip_unbalanced = true,
          markdown = true,
        }
        require('mini.git').setup()
        local align_blame = function(au_data)
          if au_data.data.git_subcommand ~= 'blame' then
            return
          end

          -- Align blame output with source
          local win_src = au_data.data.win_source
          vim.wo.wrap = false
          vim.fn.winrestview { topline = vim.fn.line('w0', win_src) }
          vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0 })

          -- Bind both windows so that they scroll together
          vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
        end
        vim.api.nvim_create_autocmd('User', { pattern = 'MiniGitCommandSplit', callback = align_blame })

        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }
        require('mini.diff').setup { options = { wrap_goto = true } }
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
            map.gen_integration.diff(),
          },
          window = {
            show_integration_count = false,
          },
        }

        vim.keymap.set('n', '<leader>nm', map.toggle, { noremap = true, desc = 'minimap open' })

        local multi = require('mini.keymap').map_multistep
        local combo = require('mini.keymap').map_combo

        combo({ 'i', 'c', 'x', 's' }, 'wq', '<BS><BS><Esc>l')
        multi({ 'i', 's' }, '<Tab>', { 'blink_accept', 'vimsnippet_next', 'jump_after_close', 'jump_after_tsnode' })
        multi({ 'i', 's' }, '<S-Tab>', { 'vimsnippet_prev', 'jump_before_open', 'jump_before_tsnode' })
      end)
    end,
  },
}
