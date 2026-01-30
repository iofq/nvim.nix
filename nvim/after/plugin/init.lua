vim.cmd('colorscheme iofq')

vim.g.mapleader = ' '
vim.opt.autowrite = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.confirm = true
vim.opt.completeopt = 'menuone,popup,noselect,fuzzy'
vim.opt.diffopt = 'internal,filler,closeoff,inline:char'
vim.opt.expandtab = true -- insert tabs as spaces
vim.opt.inccommand = 'split' -- incremental live completion
vim.opt.laststatus = 1 -- statusline only if split
vim.opt.nrformats:append('alpha') -- let Ctrl-a do letters as well
vim.opt.path:append('**') -- enable fuzzy :find ing
vim.opt.relativenumber = true
vim.opt.shadafile = 'NONE' -- disable shada (unless session)
vim.opt.shiftwidth = 0 -- >> shifts by tabstop
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.showmode = true
vim.opt.signcolumn = 'no'
vim.opt.softtabstop = -1 -- backspace removes tabstop
vim.opt.swapfile = false
vim.opt.tabstop = 2 -- 2 space tabs are based
vim.opt.updatetime = 250 -- decrease update time
vim.opt.virtualedit = 'onemore'
vim.opt.winborder = 'rounded'

-- Configure Neovim diagnostic messages
vim.diagnostic.config {
  virtual_text = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    source = 'if_many',
  },
}

vim.lsp.enable {
  'nixd',
  'phpactor',
  'gopls',
  'lua_ls',
  'basedpyright',
  'csharp_ls',
}

local map = vim.keymap.set
map('n', '\\t', function() -- Switch tab length on the fly
  vim.o.tabstop = vim.o.tabstop == 8 and 2 or 2 * vim.o.tabstop
  vim.notify('tabstop: ' .. vim.o.tabstop)
end)
map({ 'v', 'i' }, 'wq', '<esc>l')
map('v', '<', '<gv')
map('v', '>', '>gv')
map('n', 'n', 'nzz', { noremap = true })
map('n', 'N', 'Nzz', { noremap = true })
map('n', '<C-u>', '<C-u>zz', { noremap = true })
map('n', '<C-d>', '<C-d>zz', { noremap = true })
map('n', 'gq', vim.cmd.bdelete, { noremap = true })
map('n', 'gQ', function()
  vim.cmd('bufdo bdelete')
end, { noremap = true })

vim.cmd.packadd('nvim.difftool')
