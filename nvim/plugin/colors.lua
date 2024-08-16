if vim.g.did_load_colors_plugin then
  return
end
vim.g.did_load_colors_plugin = true

require('nightfox').setup {
  options = {
    transparent = true, -- Disable setting background
    terminal_colors = false, -- Set terminal colors (vim.g.terminal_color_*) used in `:terminal`
  },
}
