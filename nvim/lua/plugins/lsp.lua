return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    opts = {
      pinned = true,
      focus = true,
      follow = false,
      auto_close = false,
      win = {
        size = 0.33,
        position = 'right',
        type = 'split',
      },
    },
    keys = {
      {
        'gre',
        '<cmd>Trouble diagnostics toggle<CR>',
        desc = 'Trouble diagnostics',
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    config = function()
      vim.lsp.enable {
        'nil_ls',
        'phpactor',
        'gopls',
        'lua_ls',
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end
          vim.keymap.set('n', 'grg', '<cmd>Trouble lsp toggle<CR>', { buffer = ev.buf, desc = 'Trouble LSP' })
          vim.keymap.set(
            'n',
            'gO',
            '<cmd>Trouble lsp_document_symbols win.position=left<CR>',
            { buffer = ev.buf, desc = 'Trouble LSP symbols' }
          )
          vim.keymap.set('n', 'grd', function()
            Snacks.picker.lsp_definitions { focus = 'list' }
          end, { buffer = ev.buf, desc = 'LSP definition' })
          vim.keymap.set('n', 'grr', function()
            Snacks.picker.lsp_references { focus = 'list' }
          end, { buffer = ev.buf, desc = 'LSP definition' })
          vim.keymap.set('n', 'grh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, { buffer = ev.buf, desc = 'LSP hints toggle' })
          vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'vim.lsp.codelens.run()' })

          -- Auto-refresh code lenses
          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
              group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', ev.buf, client.id), {}),
              callback = function()
                vim.lsp.codelens.refresh { bufnr = ev.buf }
              end,
              buffer = ev.buf,
            })
            vim.lsp.codelens.refresh()
          end
        end,
      })
      vim.api.nvim_exec_autocmds('FileType', {})
    end,
  },
  {
    'stevearc/conform.nvim',
    event = 'VeryLazy',
    keys = {
      {
        '\\f',
        function()
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        end,
        mode = { 'n', 'x' },
        desc = 'toggle buffer formatting',
      },
      {
        '\\F',
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end,
        mode = { 'n', 'x' },
        desc = 'toggle global formatting',
      },
    },
    opts = {
      notify_no_formatters = false,
      formatters_by_ft = {
        json = { 'jq' },
        puppet = { 'puppet-lint' },
        lua = { 'stylua' },
        python = { 'ruff' },
        nix = { 'alejandra' },
        fish = { 'fish_indent' },
        ['*'] = { 'trim_whitespace' },
      },
      format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = 'last' }
      end,
      default_format_opts = {
        timeout_ms = 1500,
        lsp_format = 'fallback',
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function()
      require('lint').linters_by_ft = {
        docker = { 'hadolint' },
        yaml = { 'yamllint' },
        puppet = { 'puppet-lint' },
        sh = { 'shellcheck' },
        go = { 'golangcilint' },
        ruby = { 'rubocop' },
        fish = { 'fish' },
        bash = { 'bash' },
        nix = { 'nix' },
        php = { 'php' },
      }
      vim.api.nvim_command('au BufWritePost * lua require("lint").try_lint()')
    end,
  },
}
