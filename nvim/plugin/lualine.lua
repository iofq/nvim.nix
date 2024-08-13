if vim.g.did_load_lualine_plugin then
  return
end
vim.g.did_load_lualine_plugin = true

vim.schedule(function()
  require('lualine').setup {
    globalstatus = true,
    extensions = { 'oil', 'trouble', 'aerial', 'fzf', 'toggleterm', 'quickfix' },
    sections = {
      lualine_x = {'filetype'}
    },
    tabline = {
      lualine_a = {'buffers'},
      lualine_z = {'tabs'},
    }
  }
end)
