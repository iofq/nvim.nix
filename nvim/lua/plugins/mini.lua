return {
  {
    'echasnovski/mini.nvim',
    lazy = false,
    config = function()
      require('mini.basics').setup { mappings = { windows = true, }, }
      require('mini.tabline').setup({
        tabpage_section = 'right',
        show_icons = false,
      })
      require('mini.statusline').setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode {}
            local git = function()
              local g = vim.b.gitsigns_head
              return (g == nil) and '' or g
            end
            local diff = function()
              local g = vim.b.gitsigns_status
              return (g == nil) and '' or g
            end
            local diagnostics = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp = MiniStatusline.section_lsp { trunc_width = 75 }
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            local search = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl,                  strings = { mode } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatusDevinfo', strings = { git(), diff(), diagnostics, lsp } },
              { hl = mode_hl,             strings = { search } },
            }
          end,
          inactive = function()
            local filename = MiniStatusline.section_filename { trunc_width = 140 }
            return MiniStatusline.combine_groups {
              { hl = 'MiniStatuslineFilename', strings = { filename } },
            }
          end,
        },
      }
      vim.schedule(function()
        require('mini.ai').setup()
        require('mini.align').setup()
        require('mini.bracketed').setup()
        require('mini.icons').setup()
        require('mini.surround').setup()
        require('mini.splitjoin').setup { detect = { separator = '[,;\n]' }, }
        require('mini.trailspace').setup()
        vim.api.nvim_create_user_command('Trim', require('mini.trailspace').trim, {})

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
          },
          window = {
            config = { width = 'auto', },
          },
          clues = {
            miniclue.gen_clues.g(),
            miniclue.gen_clues.marks(),
            miniclue.gen_clues.registers(),
            miniclue.gen_clues.windows(),
            miniclue.gen_clues.z(),
          },
        }

        local map = require('mini.map')
        map.setup {
          symbols = {
            scroll_line = '┃',
            scroll_view = '',
          },
          integrations = {
            map.gen_integration.builtin_search(),
            map.gen_integration.diagnostic(),
            map.gen_integration.gitsigns(),
          },
          window = {
            show_integration_count = false,
            winblend = 0,
            width = 5,
          },
        }
        vim.keymap.set('n', '<leader>nm', map.toggle, { noremap = true, desc = 'minimap open' })

        local files = require("mini.files")
        files.setup {
          mappings = {
            go_in_plus = "<CR>"
          },
          windows = {
            preview = true,
            width_focus = 30,
            width_preview = 50,
          }
        }
        vim.keymap.set('n', '<leader>c', files.open, { noremap = true, desc = 'minifiles open' })
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniFilesBufferCreate",
          callback = function(args)
            vim.keymap.set(
              "n",
              "<leader>c",
              function()
                files.synchronize()
                files.close()
              end,
              { buffer = args.data.buf_id }
            )
          end,
        })
        vim.api.nvim_create_autocmd("User", {
          pattern = "MiniFilesBufferCreate",
          callback = function(args)
            vim.keymap.set(
              "n",
              "`",
              function()
                local cur_entry_path = MiniFiles.get_fs_entry().path
                local cur_directory = vim.fs.dirname(cur_entry_path)
                vim.fn.chdir(cur_directory)
              end,
              { buffer = args.data.buf_id }
            )
          end,
        })
      end)
    end,
  },
}
