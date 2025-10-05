require('mini.basics').setup { mappings = { windows = true } }
require('mini.icons').setup()

vim.schedule(function()
  require('mini.align').setup()
  require('mini.pairs').setup()
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

  require('mini.git').setup()
  vim.keymap.set('n', '<leader>go', function()
    return MiniGit.show_at_cursor()
  end, { noremap = true, desc = 'git show at cursor' })
  vim.keymap.set('n', '<leader>gb', '<Cmd>Git blame -- %<CR>', { desc = 'git blame' })

  local jump = require('mini.jump2d')
  jump.setup {
    view = { n_steps_ahead = 1, dim = true },
    spotter = jump.gen_spotter.vimpattern(),
  }

  local diff = require('mini.diff')
  diff.setup {
    source = {
      require('lib.minidiff_jj').gen_source(),
      diff.gen_source.git(),
    },
  }
  vim.keymap.set('n', '<leader>gp', function()
    MiniDiff.toggle_overlay(0)
  end, { noremap = true, desc = 'git diff overlay' })

  local files = require('mini.files')
  files.setup {
    mappings = {
      go_in_plus = '<CR>',
    },
    windows = {
      preview = true,
      width_preview = 50,
    },
  }
  vim.keymap.set('n', '<leader>nc', function()
    MiniFiles.open(vim.api.nvim_buf_get_name(0), false) -- open current buffer's dir
    MiniFiles.reveal_cwd()
  end, { desc = 'minifiles open' })

  vim.keymap.set('n', '`', function()
    local _, cur_entry_path = pcall(MiniFiles.get_fs_entry().path)
    local cur_directory = vim.fs.dirname(cur_entry_path)
    if cur_directory ~= '' then
      vim.fn.chdir(cur_directory)
    end
  end)

  -- pass file rename events to LSP
  vim.api.nvim_create_autocmd('User', {
    pattern = 'MiniFilesActionRename',
    callback = function(event)
      Snacks.rename.on_rename_file(event.data.from, event.data.to)
    end,
  })
end)
