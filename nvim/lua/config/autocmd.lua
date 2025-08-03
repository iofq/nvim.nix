-- create undopath
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
