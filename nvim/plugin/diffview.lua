if vim.g.did_load_diffview_plugin then
  return
end
vim.g.did_load_diffview_plugin = true

require('diffview').setup { use_icons = false }
vim.keymap.set('n', '<leader>gdd', vim.cmd.DiffviewOpen, { desc = '[g]it [d]iffview open' })
