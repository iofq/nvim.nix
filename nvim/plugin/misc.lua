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
}

require('which-key').setup {
  preset = 'helix',
}
