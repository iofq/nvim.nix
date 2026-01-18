local map = vim.keymap.set

vim.schedule(function()
  require('mini.align').setup()
  require('mini.surround').setup()
  require('mini.splitjoin').setup { detect = { separator = '[,;\n]' } }

  local ai = require('mini.ai')
  ai.setup {
    n_lines = 300,
    custom_textobjects = {
      i = require('mini.extra').gen_ai_spec.indent(),
      a = ai.gen_spec.treesitter { a = '@parameter.outer', i = '@parameter.inner' },
      f = ai.gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
    },
  }

  local jump = require('mini.jump2d')
  jump.setup {
    mappings = {
      start_jumping = '<leader>s',
    },
    view = { n_steps_ahead = 1, dim = true },
    spotter = jump.gen_spotter.vimpattern(),
  }

  local diff = require('mini.diff')
  diff.setup {
    source = {
      require('iofq.minidiff_jj').gen_source(),
      diff.gen_source.git(),
    },
  }
  map('n', '<leader>gp', MiniDiff.toggle_overlay)

  require('mini.files').setup {
    mappings = { go_in_plus = '<CR>' },
    windows = {
      preview = true,
      width_preview = 50,
    },
  }
  map('n', '<leader>nc', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false) -- open current buffer's dir
  end)
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
      map('n', '<leader>nc', function()
        MiniFiles.synchronize()
        MiniFiles.close()
      end, { buffer = args.data.buf_id })
      map('n', '`', function()
        local _, cur_entry_path = pcall(MiniFiles.get_fs_entry().path)
        local cur_directory = vim.fs.dirname(cur_entry_path)
        if cur_directory ~= '' then
          vim.fn.chdir(cur_directory)
        end
      end, { buffer = args.data.buf_id })
    end,
  })

  -- pass file rename events to LSP
  vim.api.nvim_create_autocmd('User', {
    group = vim.api.nvim_create_augroup('snacks_rename', { clear = true }),
    pattern = 'MiniFilesActionRename',
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
end)
