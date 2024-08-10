if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

vim.schedule(function()
  require('lualine').setup {
    globalstatus = true,
    extensions = { 'fugitive', 'fzf', 'toggleterm', 'quickfix' },
  }
end)
