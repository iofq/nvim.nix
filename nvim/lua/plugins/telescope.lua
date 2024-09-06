return {
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    event = 'VeryLazy',
    build = 'make',
  },
  {
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-treesitter/nvim-treesitter',
      'tiagovla/scope.nvim',
      {
        'gbprod/yanky.nvim',
        config = function()
          local mapping = require("yanky.telescope.mapping")
          require("yanky").setup({
            picker = {
              telescope = {
                mappings = {
                  default = mapping.set_register(
                    require("yanky.utils").get_default_register()
                  ),
                },
              },
            },
            ring = {
              storage = "memory",
            },
          })
          vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
        end,
      },
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      telescope.setup {
        defaults = {
          layout_strategy = 'vertical',
          layout_config = { width = 0.90 },
          prompt_title = false,
          results_title = false,
          preview_title = false,
          vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--hidden',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          preview = { treesitter = true },
          path_display = { 'truncate' },
          mappings = {
            i = {
              ['wq'] = actions.close,
              ['<Esc>'] = actions.close,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-j>'] = actions.move_selection_next,
            },
          },
        },
      }
      telescope.load_extension('fzf')
      telescope.load_extension('scope')
      telescope.load_extension('yank_history')

      local b = require('telescope.builtin')
      -- Fall back to find_files if not in a git repo
      local project_files = function()
        local opts = {} -- define here if you want to define something
        local ok = pcall(b.git_files, opts)
        if not ok then
          b.find_files(opts)
        end
      end

      vim.keymap.set(
        'n',
        '<leader>ff',
        project_files,
        { noremap = true, silent = true, desc = 'Fuzzy find git files' }
      )
      vim.keymap.set(
        'n',
        '<leader>fg',
        b.find_files,
        { noremap = true, silent = true, desc = 'Fuzzy find files' }
      )
      vim.keymap.set(
        'n',
        '<leader>fa',
        b.live_grep,
        { noremap = true, silent = true, desc = 'Fuzzy find grep' }
      )
      vim.keymap.set(
        'n',
        '<leader>f8',
        b.grep_string,
        { noremap = true, silent = true, desc = 'Fuzzy find grep current word' }
      )
      vim.keymap.set(
        'n',
        '<leader>f?',
        b.builtin,
        { noremap = true, silent = true, desc = 'See all pickers' }
      )
      vim.keymap.set(
        'n',
        '<leader>f.',
        b.resume,
        { noremap = true, silent = true, desc = 'Fuzzy find resume' }
      )
      vim.keymap.set(
        'n',
        '<leader>fs',
        b.lsp_document_symbols,
        { noremap = true, silent = true, desc = 'Fuzzy find treesitter objects' }
      )
      vim.keymap.set(
        'n',
        '<leader><leader>',
        '<cmd>Telescope scope buffers<cr>',
        { noremap = true, silent = true, desc = 'Pick buffers (scope.nvim)' }
      )
      vim.keymap.set(
        'n',
        '<leader>fp',
        '<cmd>Telescope yank_history<cr>',
        { noremap = true, silent = true, desc = 'Pick history (yanky.nvim)' }
      )
    end,
  },
}
