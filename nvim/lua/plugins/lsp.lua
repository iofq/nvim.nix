return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    config = true,
    keys = {
      {
        '<leader>de',
        '<cmd>Trouble diagnostics toggle focus=true<CR>',
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
          vim.api.nvim_command('au BufWritePre <buffer> lua vim.lsp.buf.format { async = false }')
          vim.keymap.set(
            'n',
            'K',
            vim.lsp.buf.hover,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP hover' }
          )
          vim.keymap.set(
            'n',
            '<leader>rn',
            vim.lsp.buf.rename,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP Rename' }
          )
          vim.keymap.set(
            { 'n', 'v' },
            '<leader>da',
            vim.lsp.buf.code_action,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP code action' }
          )
          vim.keymap.set(
            'n',
            '<leader>df',
            function() Snacks.picker.lsp_definitions() end,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP definitions' }
          )
          vim.keymap.set(
            'n',
            '<leader>di',
            function() Snacks.picker.lsp_implementations() end,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP implementations' }
          )
          vim.keymap.set(
            'n',
            '<leader>dr',
            function() Snacks.picker.lsp_references() end,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP references' }
          )
          vim.keymap.set(
            'n',
            '<leader>dl',
            vim.lsp.codelens.run,
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP codelens' }
          )
          vim.keymap.set('n', '<leader>dh', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
          end, { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP hints toggle' })
          vim.keymap.set('n', '<space>df', function()
            vim.lsp.buf.format { async = true }
          end, { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP format' })
          -- Auto-refresh code lenses
          if not client then
            return
          end
          local group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
          if client.server_capabilities.codeLensProvider then
            vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
              group = group,
              callback = function()
                vim.lsp.codelens.refresh { bufnr = bufnr }
              end,
              buffer = bufnr,
            })
            vim.lsp.codelens.refresh { bufnr = bufnr }
          end
        end,
      })
      vim.api.nvim_exec_autocmds('FileType', {})
    end,
  },
  {
    'nvimtools/none-ls.nvim',
    event = 'VeryLazy',
    config = function()
      local null = require('null-ls')
      null.setup {
        sources = {
          null.builtins.diagnostics.puppet_lint,
          null.builtins.diagnostics.yamllint,
        },
      }
    end,
  },
}
