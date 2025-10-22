local map = vim.keymap.set

require('mini.basics').setup { mappings = { windows = true } }
require('mini.icons').setup()

require('dart').setup {
  tabline = {
    icons = false,
    label_marked_fg = 'cyan',
  },
}

require('snacks').setup {
  bigfile = { enabled = true },
  terminal = { enabled = true },
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  styles = { notification = { wo = { wrap = true } } },
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
        layout = {
          preset = 'left',
          layout = { width = 90, min_width = 90 },
        },
      },
      smart = {
        multi = {
          'buffers',
          { source = 'files', hidden = true },
          { source = 'git_files', untracked = true },
        },
      },
    },
  },
}

map({ 'n', 't' }, '<C-\\>', Snacks.terminal.toggle)
map('n', '<leader>ff', Snacks.picker.smart)
map('n', '<leader><leader>', Snacks.picker.smart)
map('n', '<leader>fa', Snacks.picker.grep)
map('n', '<leader>f8', Snacks.picker.grep_word)
map('n', '<leader>f?', Snacks.picker.pickers)
map('n', '<leader>fu', Snacks.picker.undo)
map('n', '<leader>fj', Snacks.picker.jumps)
map('n', '<leader>f.', Snacks.picker.resume)
map('n', '<leader>fb', Snacks.picker.buffers)
map('n', '<leader>fq', Snacks.picker.qflist)
map('n', '<leader>jf', require('iofq.snacks_jj').status)
map('n', '<leader>jh', function()
  require('iofq.snacks_jj').file_history(vim.api.nvim_buf_get_name(0))
end)

vim.schedule(function()
  require('nvim-treesitter').setup()
  require('nvim-treesitter-textobjects').setup()
  require('nvim-autopairs').setup()

  require('refactoring').setup()
  map('n', '<leader>rr', require('refactoring').select_refactor)
  map('n', '<leader>rv', function()
    require('refactoring').refactor('Inline Variable')
  end)

  require('quicker').setup()
  map('n', '<leader>qf', function()
    require('quicker').toggle { max_height = 20 }
  end)

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
  map('n', '\\f', function()
    vim.b.disable_autoformat = not vim.b.disable_autoformat
    vim.notify(string.format('Buffer formatting disabled: %s', vim.b.disable_autoformat))
  end)
  map('n', '\\F', function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify(string.format('Global formatting disabled: %s', vim.g.disable_autoformat))
  end)

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
  vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
    callback = function()
      require('lint').try_lint(nil, { ignore_errors = true })
    end,
  })

  vim.treesitter.language.register('markdown', 'blink-cmp-documentation')
  require('blink.cmp').setup {
    enabled = function()
      return not vim.tbl_contains({ 'snacks_picker_input' }, vim.bo.filetype)
    end,
    sources = {
      default = { 'lsp', 'path', 'snippets', 'ripgrep', 'buffer' },
      providers = {
        lsp = { fallbacks = {} }, -- include buffer even when LSP is active
        path = { opts = { get_cwd = vim.fn.getcwd } }, -- use nvim pwd instead of current file pwd
        ripgrep = {
          module = 'blink-ripgrep',
          name = 'rg',
          score_offset = -10,
          async = true,
        },
      },
    },
    cmdline = { completion = { menu = { auto_show = true } } },
    completion = {
      documentation = { auto_show = true },
      menu = {
        draw = {
          columns = {
            { 'label', 'label_description', gap = 1 },
            { 'source_name', 'kind', gap = 1 },
          },
        },
      },
    },
    signature = { enabled = true, trigger = { show_on_insert = true } },
  }
end)
