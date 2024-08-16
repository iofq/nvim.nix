vim.cmd('colorscheme terafox')
vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = "green", bold = true })
vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = "red", bold = true})
vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = "green", bold = true})
vim.api.nvim_set_hl(0, 'EyelinerPrimary', { underline = true })
vim.api.nvim_set_hl(0, 'EyelinerSecondary', { underline = true })

vim.keymap.set('n', '<leader>aa', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })
vim.keymap.set('n', '<leader>nb', vim.cmd.DiffviewOpen, { noremap = true, desc = '[g]it [d]iffview open' })
vim.keymap.set(
  'n',
  '<leader>de',
  '<cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>',
  { noremap = true, desc = 'Trouble diagnostics' }
)

local ts = require('telescope')
ts.load_extension('aerial')
vim.keymap.set(
  'n',
  '<leader>fs',
  ts.extensions.aerial.aerial,
  { noremap = true, silent = true, desc = 'Fuzzy find treesitter objects' }
)
ts.load_extension("scope")
vim.keymap.set(
  'n',
  '<leader>fb',
  '<cmd>Telescope scope buffers<cr>',
  { noremap = true, silent = true, desc = 'Pick buffers (scope.nvim)' }
)
