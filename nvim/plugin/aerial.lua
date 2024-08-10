if vim.g.did_load_aerial_plugin then
  return
end
vim.g.did_load_aerial_plugin = true

require('aerial').setup {
  default_direction = 'left',
  autojump = true,
  on_attach = function(bufnr)
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end,
}