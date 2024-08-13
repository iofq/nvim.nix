if vim.g.did_load_plugins_plugin then
  return
end
vim.g.did_load_plugins_plugin = true

-- many plugins annoyingly require a call to a 'setup' function to be loaded,
-- even with default configs

require('neogen').setup {}
vim.keymap.set('n', '<leader>nd', '<cmd>Neogen<CR>', { noremap = true, silent = true, desc = 'Neogen - gen comments' })

require('toggleterm').setup {
  open_mapping = [[<C-\>]],
  direction = 'float',
  close_on_exit = true,
  autochdir = true,
}

require('which-key').setup {
  preset = 'helix',
}
require('trouble').setup {}
require('eyeliner').setup {}
require('dressing').setup {}
require('markview').setup()
require('scope').setup {}
require('neoclip').setup { default_register = '+' }
vim.keymap.set(
  'n',
  '<leader>fp',
  '<cmd>Telescope neoclip<CR>',
  { noremap = true, silent = true, desc = 'Pick clipboard history' }
)
