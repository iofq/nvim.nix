return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    opts = {
      pinned = true,
      win = {
        size = 0.25,
        position = 'right',
        type = 'split'
      },
    },
    keys = {
      {
        'gre',
        '<cmd>Trouble diagnostics toggle<CR>',
        noremap = true,
        desc = 'Trouble diagnostics'
      }
    }
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'folke/snacks.nvim',
      'folke/trouble.nvim',
      'saghen/blink.cmp',
    },
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = require("blink.cmp").get_lsp_capabilities()
      lspconfig.gopls.setup {
        capabilities = capabilities,
        settings = {
          gopls = {
            gofumpt = true,
            codelenses = {
              gc_details = true,
              test = true,
            },
            analyses = {
              unusedvariable = true,
              shadow = true,
            },
            hints = {
              assignVariableTypes = true,
              compositeLiteralFields = true,
              compositeLiteralTypes = true,
              constantValues = true,
              functionTypeParameters = true,
              rangeVariableTypes = true,
              parameterNames = true,
            },
            usePlaceholders = true,
            staticcheck = true,
          },
        },
      }
      lspconfig.jedi_language_server.setup { capabilities = capabilities }
      lspconfig.nil_ls.setup { capabilities = capabilities }
      lspconfig.phpactor.setup { capabilities = capabilities }
      lspconfig.ruby_lsp.setup { capabilities = capabilities }
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              version = 'LuaJIT',
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
              },
            },
          })
        end,
        settings = {
          Lua = {},
        },
      }

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local bufnr = ev.buf
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end
          vim.keymap.set(
            'n',
            'K',
            vim.lsp.buf.hover,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'vim.lsp.buf.hover()' }
          )
          vim.keymap.set(
            'n',
            'grt',
            '<cmd>Trouble lsp toggle focus=true <CR>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'Trouble LSP ' }
          )
          vim.keymap.set(
            'n',
            'grs',
            '<cmd>Trouble lsp_document_symbols toggle win.position=left <CR>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'Trouble LSP symbols' }
          )
          vim.keymap.set(
            'n',
            'grl',
            vim.lsp.codelens.run,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'vim.lsp.codelens.run()' }
          )
          vim.keymap.set('n', 'grh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP hints toggle' })
          -- Auto-refresh code lenses
          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
              group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {}),
              callback = function() vim.lsp.codelens.refresh { bufnr = bufnr } end,
              buffer = bufnr,
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
    opts = {
      notify_no_formatters = false,
      formatters_by_ft = {
        json = { "jq" },
        puppet = { "puppet-lint" },
        ['*'] = { 'trim_whitespace' }
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "last",
      },
    },
  },
  {
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    config = function()
      require("lint").linters_by_ft = {
        docker = { "hadolint" },
        yaml = { "yamllint" },
        puppet = { "puppet-lint" },
        sh = { "shellcheck" },
        go = { "golangcilint" },
        ruby = { "rubocop" },
      }
      vim.api.nvim_command('au BufWritePost * lua require("lint").try_lint()')
    end
  },
}
