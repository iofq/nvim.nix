return {
  {
    'echasnovski/mini.nvim',
    dependencies = 'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = false,
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
        '<leader>go',
        function()
          return MiniGit.show_at_cursor()
        end,
        noremap = true,
        desc = 'git show at cursor',
      },
      {
        '<leader>gb',
        '<Cmd>Git blame -- %<CR>',
        noremap = true,
        desc = 'git blame',
      },
      {
        '<leader>gg',
        ':Git ',
        noremap = true,
        desc = 'git command',
      },
      {
        '<leader>fs',
        function()
          require('plugins.lib.session_jj').load()
        end,
        noremap = true,
        desc = 'mini session select',
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
            -- local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              '%<', -- Mark general truncate point
              -- { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineDevinfo', strings = { diagnostics, lsp } },
              { hl = 'MiniStatuslineDevinfo', strings = { search } },
              { hl = mode_hl,                 strings = { mode } },
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
        local ai = require('mini.ai')
        local extra_ai = require('mini.extra').gen_ai_spec
        ai.setup {
          n_lines = 300,
          custom_textobjects = {
            i = extra_ai.indent(),
            g = extra_ai.buffer(),
            u = ai.gen_spec.function_call(),
            a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
            k = ai.gen_spec.treesitter { a = '@assignment.lhs', i = '@assignment.lhs' },
            v = ai.gen_spec.treesitter { a = '@assignment.rhs', i = '@assignment.rhs' },
            f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
            o = ai.gen_spec.treesitter {
              a = { '@block.outer', '@conditional.outer', '@loop.outer' },
              i = { '@block.inner', '@conditional.inner', '@loop.inner' },
            },
          },
        }
        require('mini.align').setup()
        require('mini.bracketed').setup { file = { suffix = 'm' } }
        require('mini.icons').setup()
        require('mini.git').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }

        local sessions = require('mini.sessions')
        sessions.setup {
          file = '',
          autowrite = true,
          verbose = {
            write = false,
          },
        }
        if #vim.fn.argv() == 0 then
          require('plugins.lib.session_jj').load()
        end

        local jump = require('mini.jump2d')
        jump.setup {
          view = { n_steps_ahead = 1, dim = true },
          spotter = jump.gen_spotter.vimpattern(),
        }

        require('plugins.lib.minipairs') {
          modes = { insert = true, command = true, terminal = false },
          skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
          skip_ts = { 'string' },
          skip_unbalanced = true,
          markdown = true,
        }

        local jj = require('plugins.lib.minidiff_jj')
        local diff = require('mini.diff')
        diff.setup {
          options = { wrap_goto = true },
          source = {
            jj(),
            diff.gen_source.git(),
          },
        }
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
            { mode = 'n', keys = '\\' },
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
          },
        }
        local files = require('mini.files')
        files.setup {
          mappings = {
            go_in_plus = '<CR>',
          },
          windows = {
            preview = true,
            width_focus = 30,
            width_preview = 50,
          },
        }
        vim.keymap.set('n', '<leader>nc', files.open, { noremap = true, desc = 'minifiles open' })
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesBufferCreate',
          callback = function(args)
            vim.keymap.set('n', '`', function()
              local cur_entry_path = MiniFiles.get_fs_entry().path
              local cur_directory = vim.fs.dirname(cur_entry_path)
              vim.fn.chdir(cur_directory)
            end, { buffer = args.data.buf_id })
          end,
        })

        local multi = require('mini.keymap').map_multistep
        multi({ 'i' }, '<BS>', { 'minipairs_bs' })
        multi({ 'i', 's' }, '<Tab>', { 'blink_accept', 'vimsnippet_next', 'increase_indent' })
        multi({ 'i', 's' }, '<S-Tab>', { 'vimsnippet_prev', 'decrease_indent' })
      end)
    end,
  },
}
