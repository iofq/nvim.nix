vim.opt.autowrite = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.confirm = true
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.cmdheight = 1
vim.opt.diffopt = 'internal,filler,closeoff,inline:char'
vim.opt.expandtab = true  -- insert tabs as spaces
vim.o.foldenable = true
vim.o.foldmethod = 'expr' -- use tree-sitter for folding method
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99
vim.opt.inccommand = 'split'      -- incremental live completion
vim.opt.list = true
vim.opt.nrformats:append('alpha') -- let Ctrl-a do letters as well
vim.opt.path:append('**')         -- enable fuzzy :find ing
vim.opt.relativenumber = true
vim.opt.shadafile = 'NONE'        -- disable shada
vim.opt.shiftwidth = 0            -- >> shifts by tabstop
vim.opt.showmatch = true          -- highlight matching brackets
vim.opt.signcolumn = 'no'
vim.opt.softtabstop = -1          -- backspace removes tabstop
vim.opt.swapfile = false
vim.opt.tabstop = 2               -- 2 space tabs are based
vim.opt.updatetime = 250          -- decrease update time
vim.opt.virtualedit = 'onemore'
vim.opt.winborder = 'single'
vim.cmd('colorscheme iofq')

-- Switch tab length on the fly
vim.keymap.set('n', '\\t', function()
  vim.o.tabstop = vim.o.tabstop == 8 and 2 or 2 * vim.o.tabstop
end, { silent = true, desc = 'toggle tabstop' })

-- autocmd
----------------------------------------
local undopath = vim.fn.stdpath('data') .. 'undo'
vim.api.nvim_create_autocmd('VimEnter', {
  command = 'silent !mkdir -p ' .. undopath,
  group = vim.api.nvim_create_augroup('Init', {}),
})
-- open :h in buffers
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = function(event)
    if vim.bo[event.buf].filetype == 'help' then
      vim.cmd.only()
      vim.keymap.set('n', 'q', vim.cmd.bdelete, { noremap = true, silent = true })
      vim.bo.buflisted = false
    end
  end,
})

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

-- Allow basic deletion in qflist
vim.api.nvim_create_autocmd({ 'FileType' }, {
  pattern = 'qf',
  callback = function()
    vim.keymap.set({ 'n', 'i' }, 'dd', function()
      local ln = vim.fn.line('.')
      local qf = vim.fn.getqflist()
      if #qf == 0 then
        return
      end
      table.remove(qf, ln)
      vim.fn.setqflist(qf, 'r')
      vim.cmd('copen')
      -- move cursor to stay at same index (or up one if at EOF)
      vim.api.nvim_win_set_cursor(vim.fn.win_getid(), { ln < #qf and ln or math.max(ln - 1, 1), 0 })
    end, { buffer = true })
  end,
})

-- random keymaps
vim.keymap.set({ 'v', 'i' }, 'wq', '<esc>l', { noremap = true, silent = true })
vim.keymap.set('n', '<S-l>', vim.cmd.bnext, { noremap = true, silent = true })
vim.keymap.set('n', '<S-h>', vim.cmd.bprev, { noremap = true, silent = true })
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'move selection up' })
vim.keymap.set({ 'v', 'n' }, 'q:', '<nop>')
vim.keymap.set('n', 'gq', vim.cmd.bdelete, { noremap = true, silent = true, desc = 'close buffer' })
vim.keymap.set('n', 'gQ', function()
  vim.cmd('bufdo bdelete')
end, { noremap = true, silent = true, desc = 'close all buffers' })

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('check_reload', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})
