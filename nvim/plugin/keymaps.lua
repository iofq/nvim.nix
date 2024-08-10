vim.keymap.set("n","gr", "gT", {noremap = true, silent = true})
vim.keymap.set("n","n", "nzz", {noremap = true, silent = true})
vim.keymap.set("n", "N", "Nzz", {noremap = true, silent = true})
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', '<C-f>', '<C-f>zz')
vim.keymap.set('n', '<C-b>', '<C-b>zz')
vim.keymap.set("n","<CR>", "m0i<cr><Esc>`0", {noremap = true, silent = true})
vim.keymap.set({'v', 'i'}, 'wq', '<esc>l', {noremap = true, silent = true})
vim.keymap.set({'n', 'v', 'i'}, 'qwq', '<esc>l<cmd>wqa<CR>', {noremap = true, silent = true})
vim.keymap.set({'n', 'v'}, '<leader>yy', '"+y', {noremap = true, silent = true, desc = "Yank to clip"})
vim.keymap.set({'n', 'v'}, '<leader>yp', '"+p', {noremap = true, silent = true, desc = "Paste from clip"})
vim.keymap.set({'n', 'v'}, '<leader>yd', '"+d', {noremap = true, silent = true, desc = "Delete to clip"})
