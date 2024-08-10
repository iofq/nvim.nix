if vim.g.did_load_telescope_plugin then
  return
end
vim.g.did_load_telescope_plugin = true

local telescope = require('telescope.builtin')

-- Fall back to find_files if not in a git repo
local project_files = function()
  local opts = {} -- define here if you want to define something
  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

vim.keymap.set(
  'n',
  '<leader><leader>',
  telescope.buffers,
  { noremap = true, silent = true, desc = 'Fuzzy find buffers' }
)
vim.keymap.set('n', '<leader>ff', project_files, { noremap = true, silent = true, desc = 'Fuzzy find git files' })
vim.keymap.set('n', '<leader>fg', telescope.find_files, { noremap = true, silent = true, desc = 'Fuzzy find files' })
vim.keymap.set(
  'n',
  '<leader>fc',
  telescope.command_history,
  { noremap = true, silent = true, desc = 'Fuzzy find command_history' }
)
vim.keymap.set('n', '<leader>fa', telescope.live_grep, { noremap = true, silent = true, desc = 'Fuzzy find grep' })
vim.keymap.set(
  'n',
  '<leader>f8',
  telescope.grep_string,
  { noremap = true, silent = true, desc = 'Fuzzy find grep current word' }
)
vim.keymap.set(
  'n',
  '<leader>fs',
  telescope.treesitter,
  { noremap = true, silent = true, desc = 'Fuzzy find treesitter objects' }
)
vim.keymap.set('n', '<leader>fq', telescope.quickfix, { noremap = true, silent = true, desc = 'Fuzzy find quickfix' })
vim.keymap.set('n', '<leader>f<BS>', telescope.resume, { noremap = true, silent = true, desc = 'Fuzzy find resume' })

local telescope = require('telescope')
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
    preview = {
      treesitter = true,
    },
    path_display = {
      'truncate',
    },
    mappings = {
      i = {
        ['wq'] = require('telescope.actions').close,
        ['<Esc>'] = require('telescope.actions').close,
        ['<C-k>'] = require('telescope.actions').move_selection_previous,
        ['<C-j>'] = require('telescope.actions').move_selection_next,
      },
    },
  },
}
telescope.load_extension('fzf')
