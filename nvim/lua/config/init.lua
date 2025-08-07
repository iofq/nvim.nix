vim.opt.autowrite = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.confirm = true
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
vim.cmd('colorscheme iofq')

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
require('config.keymaps')
require('config.autocmd')
