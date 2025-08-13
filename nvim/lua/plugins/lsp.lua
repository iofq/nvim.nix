return {
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
          vim.keymap.set('n', 'gO', function()
            Snacks.picker.lsp_symbols { focus = 'list' }
          end, { buffer = ev.buf, desc = 'LSP symbols' })

          vim.keymap.set('n', 'grh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, { buffer = ev.buf, desc = 'LSP hints toggle' })
          vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'vim.lsp.codelens.run()' })

          vim.keymap.set('n', 'gre', function()
            vim.diagnostic.setloclist()
          end, { buffer = ev.buf, desc = 'LSP buffer diagnostics' })
          vim.keymap.set('n', 'grE', function()
            vim.diagnostic.setqflist()
          end, { buffer = ev.buf, desc = 'LSP diagnostics' })

          vim.keymap.set('n', 'grc', function()
            vim.lsp.buf.incoming_calls()
          end, { buffer = ev.buf, desc = 'LSP incoming_calls' })
          vim.keymap.set('n', 'gro', function()
            vim.lsp.buf.outgoing_calls()
          end, { buffer = ev.buf, desc = 'LSP outgoing_calls' })

          -- Auto-refresh code lenses
          if client:supports_method('textDocument/codeLens') or client.server_capabilities.codeLensProvider then
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
          Snacks.notify(string.format('Buffer formatting disabled: %s', vim.b.disable_autoformat))
        end,
        mode = { 'n', 'x' },
        desc = 'toggle buffer formatting',
      },
      {
        '\\F',
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          Snacks.notify(string.format('Global formatting disabled: %s', vim.g.disable_autoformat))
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
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = vim.api.nvim_create_augroup('lint', { clear = true }),
        callback = function()
          if vim.bo.modifiable then
            require('lint').try_lint()
          end
        end,
      })
    end,
  },
}
