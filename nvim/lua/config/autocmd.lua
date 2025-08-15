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
      require('quicker').refresh()
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

-- Init treesitter
vim.api.nvim_create_autocmd('FileType', {
  callback = function(event)
    local bufnr = event.buf
    local filetype = vim.api.nvim_get_option_value('filetype', { buf = bufnr })

    if filetype == '' then
      return
    end

    local parser_name = vim.treesitter.language.get_lang(filetype)
    if not parser_name then
      return
    end
    local parser_installed = pcall(vim.treesitter.get_parser, bufnr, parser_name)
    if not parser_installed then
      return
    end

    local function map(lhs, rhs, opts)
      if lhs == '' then
        return
      end
      opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
      vim.keymap.set({ 'v', 'n' }, lhs, rhs, opts)
    end

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    vim.treesitter.start()

    map('[c', function()
      require('treesitter-context').go_to_context(vim.v.count1)
    end, { buffer = bufnr, desc = 'jump to TS context' })
    map(']f', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end, { buffer = bufnr, desc = 'next function def' })
    map('[f', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end, { buffer = bufnr, desc = 'prev function def' })
    map(']a', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr, desc = 'next param def' })
    map('[a', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr, desc = 'prev param def' })
    map('a]', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end, { buffer = bufnr, desc = 'swap next arg' })
    map('a[', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end, { buffer = bufnr, desc = 'swap prev arg' })
  end,
})
