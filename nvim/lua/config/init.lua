vim.opt.backspace = 'indent,eol,start'
vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
vim.opt.expandtab = true -- insert tabs as spaces
vim.opt.inccommand = 'split' -- incremental live completion
vim.opt.list = true
vim.opt.nrformats:append('alpha') -- let Ctrl-a do letters as well
vim.opt.path:append('**') -- enable fuzzy :find ing
vim.opt.relativenumber = true
vim.opt.shadafile = 'NONE' -- disable shada
vim.opt.shiftwidth = 0 -- >> shifts by tabstop
vim.opt.showmatch = true -- highlight matching brackets
vim.opt.showmode = true
vim.opt.signcolumn = 'no'
vim.opt.spell = false
vim.opt.softtabstop = -1 -- backspace removes tabstop
vim.opt.swapfile = false
vim.opt.tabstop = 2 -- 2 space tabs are based
vim.opt.updatetime = 250 -- decrease update time
vim.opt.virtualedit = 'onemore'
vim.opt.wrap = true
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

-- Switch tab length on the fly
vim.keymap.set('n', '\\t', function()
  vim.o.tabstop = vim.o.tabstop == 2 and 4 or 2
end, { silent = true, desc = 'toggle tabstop' })

-- autocmd
----------------------------------------
local undopath = '~/.local/share/nvim/undo'
vim.api.nvim_create_autocmd('VimEnter', {
  command = 'silent !mkdir -p ' .. undopath,
  group = vim.api.nvim_create_augroup('Init', {}),
})
-- open :g in buffers
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function(event)
    if vim.bo[event.buf].filetype == 'help' then
      vim.cmd.only()
      vim.keymap.set('n', 'q', vim.cmd.bdelete, { noremap = true, silent = true })
      vim.bo.buflisted = true
    end
  end,
})

-- Configure Neovim diagnostic messages
local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. ' %s', diagnostic.message)
end
vim.diagnostic.config {
  virtual_text = {
    prefix = '',
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic('󰅚', diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic('⚠', diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic('ⓘ', diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic('󰌶', diagnostic)
      end
      return prefix_diagnostic('■', diagnostic)
    end,
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

-- random keymaps
vim.keymap.set('n', 'gq', vim.cmd.bdelete, { silent = true })
vim.keymap.set('n', 'gr', 'gT', { noremap = true, silent = true })
vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.keymap.set({ 'v', 'i' }, 'wq', '<esc>l', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>x', '"rd', { remap = true, silent = true })