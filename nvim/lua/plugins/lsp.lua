return {
  {
    'folke/trouble.nvim',
    event = 'VeryLazy',
    dependencies = {
      'artemave/workspace-diagnostics.nvim',
    },
    config = function()
      require('trouble').setup()
      vim.keymap.set(
        'n',
        '<leader>de',
        '<cmd>Trouble diagnostics toggle focus=true<CR>',
        { noremap = true, desc = 'Trouble diagnostics' }
      )
      vim.keymap.set(
        'n',
        '<leader>dE',
        '<cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>',
        { noremap = true, desc = 'Trouble diagnostics (currrent buffer)' }
      )
      vim.keymap.set('n', '<leader>dw', function()
        for _, client in ipairs(vim.lsp.get_clients { bufnr = 0 }) do
          require('workspace-diagnostics').populate_workspace_diagnostics(client, 0)
        end
      end, { noremap = true, desc = 'Populate Trouble workspace diagnostics' })
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = 'VeryLazy',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'artemave/workspace-diagnostics.nvim',
    },
    config = function()
      local lspconfig = require('lspconfig')
      lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
        'force',
        lspconfig.util.default_config.capabilities,
        require('cmp_nvim_lsp').default_capabilities()
      )
      lspconfig.gopls.setup {
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
      lspconfig.jedi_language_server.setup {}
      lspconfig.nil_ls.setup {}
      lspconfig.lua_ls.setup {
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
            '<leader>dd',
            '<cmd>Telescope lsp_definitions<cr>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP definitions' }
          )
          vim.keymap.set(
            'n',
            '<leader>di',
            '<cmd>Telescope lsp_implementations<cr>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP implementations' }
          )
          vim.keymap.set(
            'n',
            '<leader>dr',
            '<cmd>Telescope lsp_references<cr>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP references' }
          )
          vim.keymap.set(
            'n',
            '<leader>ds',
            '<cmd>Telescope lsp_document_symbols<cr>',
            { buffer = ev.buf, noremap = true, silent = true, desc = 'LSP symbols' }
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
          require('workspace-diagnostics').populate_workspace_diagnostics(client, bufnr)
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
