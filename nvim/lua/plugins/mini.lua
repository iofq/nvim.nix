return {
  {
    'nvim-mini/mini.nvim',
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
        desc = 'git blame',
      },
    },
    config = function()
      require('mini.basics').setup { mappings = { windows = true } }
      require('mini.icons').setup()
      vim.schedule(function()
        local ai = require('mini.ai')
        ai.setup {
          n_lines = 300,
          custom_textobjects = {
            i = require('mini.extra').gen_ai_spec.indent(),
            u = ai.gen_spec.function_call(),
            a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
            f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
          },
        }
        require('mini.align').setup()
        require('mini.pairs').setup()
        require('mini.git').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }

        require('mini.sessions').setup {
          file = '',
          autowrite = true,
          hooks = {
            pre = {
              read = function(session) -- load Dart state *before* buffers are loaded
                vim.cmd('rshada')
                Dart.read_session(session['name'])
              end,
              write = function(session)
                vim.cmd('wshada')
                Dart.write_session(session['name'])
              end,
            },
          },
        }
        require('plugins.lib.session_jj').setup()

        local jump = require('mini.jump2d')
        jump.setup {
          view = { n_steps_ahead = 1, dim = true },
          spotter = jump.gen_spotter.vimpattern(),
        }

        local diff = require('mini.diff')
        diff.setup {
          options = { wrap_goto = true },
          source = {
            require('plugins.lib.minidiff_jj').gen_source(),
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
            miniclue.gen_clues.registers({show_contents = true}),
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
        vim.keymap.set('n', '<leader>nc', function()
          files.open(vim.api.nvim_buf_get_name(0), false) -- open current buffer's dir
          files.reveal_cwd()
        end, { desc = 'minifiles open' })
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesBufferCreate',
          callback = function(args)
            vim.keymap.set('n', '<leader>nc', function()
              files.synchronize()
              files.close()
            end, { buffer = args.data.buf_id })
            vim.keymap.set('n', '`', function()
              local cur_entry_path = MiniFiles.get_fs_entry().path
              local cur_directory = vim.fs.dirname(cur_entry_path)
              if cur_directory ~= '' then
                vim.fn.chdir(cur_directory)
              end
            end, { buffer = args.data.buf_id })
          end,
        })
        vim.api.nvim_create_autocmd('User', {
          pattern = 'MiniFilesActionRename',
          callback = function(event)
            Snacks.rename.on_rename_file(event.data.from, event.data.to)
          end,
        })
      end)
    end,
  },
}
