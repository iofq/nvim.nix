if vim.g.did_load_oil_plugin then
  return
end
vim.g.did_load_oil_plugin = true

local oil = require('oil')
oil.setup {
  watch_for_changes = true,
  columns = {
    'permissions',
    'size',
  },
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['wq'] = 'actions.close',
  },
}
vim.keymap.set('n', '<leader>c', oil.toggle_float, { noremap = true, silent = true })
vim.keymap.set('n', '<leader>u', '<cmd>UndotreeToggle<cr>')
vim.g.undotree_ShortIndicators = 1
vim.g.undotree_SetFocusWhenToggle = 1
