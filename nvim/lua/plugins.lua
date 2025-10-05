require('dart').setup {
  tabline = {
    label_marked_fg = 'cyan',
  },
}

require('snacks').setup {
  bigfile = { enabled = true },
  terminal = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  styles = {
    notification = {
      wo = { wrap = true },
    },
  },
  picker = {
    enabled = true,
    matcher = {
      frecency = true,
      cwd_bonus = true,
    },
    layout = 'ivy_split',
    sources = {
      grep = { hidden = true },
      lsp_symbols = {
        filter = { default = true },
        layout = 'left',
      },
      smart = {
        multi = {
          { source = 'files', hidden = true },
          { source = 'git_files', untracked = true },
        },
      },
    },
  },
}

vim.keymap.set({ 'n', 't' }, '<C-\\>', function()
  Snacks.terminal.toggle()
end, { desc = 'terminal open' })

vim.keymap.set('n', '<leader>ff', function()
  Snacks.picker.smart()
end, { desc = 'Fuzzy find smart' })

vim.keymap.set('n', '<leader>fa', function()
  Snacks.picker.grep()
end, { desc = 'Fuzzy find grep' })

vim.keymap.set('n', '<leader>f8', function()
  Snacks.picker.grep_word()
end, { desc = 'Fuzzy find grep word' })

vim.keymap.set('n', '<leader>f?', function()
  Snacks.picker.pickers()
end, { desc = 'See all pickers' })

vim.keymap.set('n', '<leader>fu', function()
  Snacks.picker.undo()
end, { desc = 'Pick undotree' })

vim.keymap.set('n', '<leader>fj', function()
  Snacks.picker.jumps()
end, { desc = 'Pick jumps' })

vim.keymap.set('n', '<leader>f.', function()
  Snacks.picker.resume()
end, { desc = 'Fuzzy find resume' })

vim.keymap.set('n', '<leader>fb', function()
  Snacks.picker.buffers()
end, { desc = 'Fuzzy find buffers' })

vim.keymap.set('n', '<leader>fq', function()
  Snacks.picker.qflist()
end, { desc = 'pick quickfix list' })

vim.keymap.set('n', '<leader>jf', function()
  require('lib.snacks_jj').status()
end, { desc = 'pick notifications' })
vim.schedule(function()
  require('nvim-treesitter').setup()
  require('nvim-treesitter-textobjects').setup()
  require('render-markdown').setup()

  require('refactoring').setup()
  vim.keymap.set('n', '<leader>rr', function()
    require('refactoring').select_refactor()
  end, { desc = 'Refactor' })
  vim.keymap.set('n', '<leader>rv', function()
    require('refactoring').refactor('Inline Variable')
  end, { desc = 'Inline Variable' })

  require('quicker').setup()
  vim.keymap.set('n', '<leader>qf', function()
    require('quicker').toggle { max_height = 20 }
  end, { desc = 'Toggle qflist' })

  require('diffview').setup {
    use_icons = false,
    enhanced_diff_hl = true,
    default_args = {
      DiffviewOpen = { '--imply-local' },
    },
    view = {
      merge_tool = {
        layout = 'diff4_mixed',
        disable_diagnostics = true,
      },
    },
    keymaps = {
      view = {
        { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
      },
      file_panel = {
        { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
      },
      file_history_panel = {
        { { 'n' }, 'q', vim.cmd.DiffviewClose, { desc = 'Close Diffview' } },
      },
    },
  }

  vim.keymap.set('n', '<leader>nb', vim.cmd.DiffviewOpen, { desc = 'diffview open' })
  vim.keymap.set('n', '<leader>nH', vim.cmd.DiffviewFileHistory, { desc = 'diffview history' })
  vim.keymap.set('n', '<leader>nh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'diffview history' })

  require('conform').setup {
    notify_no_formatters = false,
    formatters_by_ft = {
      json = { 'jq' },
      lua = { 'stylua' },
      python = { 'ruff' },
      nix = { 'nixfmt' },
      fish = { 'fish_indent' },
      ['*'] = { 'trim_whitespace' },
    },
    format_on_save = function(bufnr)
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      return { timeout_ms = 1500, lsp_format = 'fallback' }
    end,
  }
  vim.keymap.set('n', '\\f', function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify(string.format('Buffer formatting disabled: %s', vim.b.disable_autoformat))
  end, { desc = 'toggle buffer formatting' })
  vim.keymap.set('n', '\\F', function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify(string.format('Global formatting disabled: %s', vim.g.disable_autoformat))
  end, { desc = 'toggle global formatting' })

  require('lint').linters_by_ft = {
    docker = { 'hadolint' },
    yaml = { 'yamllint' },
    sh = { 'shellcheck' },
    go = { 'golangcilint' },
    ruby = { 'rubocop' },
    fish = { 'fish' },
    bash = { 'bash' },
    nix = { 'nix' },
    php = { 'php' },
  }
  vim.api.nvim_create_autocmd({ 'BufWritePost', 'InsertLeave' }, {
    group = vim.api.nvim_create_augroup('lint', { clear = true }),
    callback = function()
      if vim.bo.modifiable then
        require('lint').try_lint(nil, { ignore_errors = true })
      end
    end,
  })

  vim.treesitter.language.register('markdown', 'blink-cmp-documentation')
  require('blink.cmp').setup {
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
              return vim.fn.getcwd() -- use nvim pwd instead of current file pwd
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
            { 'label', 'label_description', gap = 1 },
            { 'source_name', 'kind', gap = 1 },
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
  }
end)
