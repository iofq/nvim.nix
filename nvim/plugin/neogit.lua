if vim.g.did_load_neogit_plugin then
  return
end
vim.g.did_load_neogit_plugin = true
require("diffview").setup({
  enhanced_diff_hl = true,
  default_args = {
    DiffviewOpen = {"--imply-local"},
  },
})
local neogit = require('neogit')
neogit.setup {
  disable_builtin_notifications = true,
  integrations = {
    diffview = true,
    telescope = true,
    fzf_lua = true,
  },
}
vim.keymap.set('n', '<leader>ng', neogit.open, { noremap = true, silent = true, desc = 'Neogit' })
