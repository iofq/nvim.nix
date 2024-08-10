vim.cmd('colorscheme terafox')
vim.keymap.set('n', '<leader>aa', '<cmd>AerialToggle!<CR>', { desc = 'Toggle Aerial' })
vim.keymap.set('n', '<leader>nb', vim.cmd.DiffviewOpen, { noremap = true, desc = '[g]it [d]iffview open' })
vim.keymap.set('n', '<leader>t', "<cmd>Trouble diagnostics toggle focus=true filter.buf=0<CR>", { noremap = true, desc = 'Trouble diagnostics' })
