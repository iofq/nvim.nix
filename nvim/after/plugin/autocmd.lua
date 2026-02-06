local cmd = vim.api.nvim_create_autocmd
-- open :h in buffers
cmd('FileType', {
  group = vim.api.nvim_create_augroup('help', { clear = true }),
  pattern = 'help',
  callback = function(_)
    vim.cmd.only()
    vim.keymap.set('n', 'q', vim.cmd.bdelete, { noremap = true })
    vim.bo.buflisted = false
  end,
})

-- resize splits if window got resized
cmd({ 'VimResized' }, {
  group = vim.api.nvim_create_augroup('resize_splits', { clear = true }),
  callback = function()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. vim.fn.tabpagenr())
  end,
})

-- Check if we need to reload the file when it changed
cmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = vim.api.nvim_create_augroup('check_reload', { clear = true }),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- Configure difftool buffers
cmd('FileType', {
  pattern = 'qf',
  group = vim.api.nvim_create_augroup('difftool', { clear = true }),
  callback = function(event)
    local function exec(fmt, str)
      return os.execute(string.format(fmt, str))
    end
    local function refresh()
      local qf = vim.fn.getqflist()

      local entry = qf[1]
      if not entry or not entry.user_data or not entry.user_data.diff then
        return nil
      end

      local ns = vim.api.nvim_create_namespace('nvim.difftool.hl')
      vim.api.nvim_buf_clear_namespace(event.buf, ns, 0, -1)
      for i, item in ipairs(qf) do
        local path = vim.fn.fnamemodify(item.user_data.right, ':t')
        local hl = 'Added'
        if
          exec('git diff --quiet -- %s', path) ~= 0
          or exec('git ls-files --error-unmatch -- %s > /dev/null 2>&1', path) ~= 0
        then
          hl = 'Removed'
        end
        vim.hl.range(event.buf, ns, hl, { i - 1, 0 }, { i - 1, -1 })
      end
    end
    vim.keymap.set('n', 'gh', function()
      local idx = vim.api.nvim_win_get_cursor(0)[1]
      local qf = vim.fn.getqflist()
      local filename = qf[idx].user_data.rel

      if exec('git diff --quiet --cached -- %s', filename) ~= 0 then
        exec('git restore --quiet --staged -- %s', filename)
      else
        exec('git add -- %s', filename)
      end
      refresh()
    end)
    vim.schedule(refresh)
  end,
})

-- open conflicts in qflist
cmd('BufWinEnter', {
  callback = function(event)
    if not vim.wo.diff then
      return
    end

    local items = {}
    while true do
      local found = vim.fn.search('^<<<<<<<', 'W')
      if found == 0 then
        break
      end
      local line = vim.api.nvim_buf_get_lines(event.buf, found - 1, found, false)[1]
      table.insert(items, { bufnr = event.buf, lnum = found, text = line })
    end

    if #items > 1 then
      vim.fn.setqflist(items, 'r')
      vim.schedule(function()
        vim.cmd(string.format('%dcopen', math.min(10, #items)))
      end)
    end
  end,
})

-- Init treesitter
cmd('FileType', {
  group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
  callback = function(event)
    local bufnr = event.buf

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    pcall(vim.treesitter.start, bufnr)

    vim.keymap.set({ 'v', 'n' }, ']]', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end, { buffer = bufnr })
    vim.keymap.set({ 'v', 'n' }, '[[', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end, { buffer = bufnr })
    vim.keymap.set({ 'v', 'n' }, ']a', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr })
    vim.keymap.set({ 'v', 'n' }, '[a', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr })
    vim.keymap.set({ 'v', 'n' }, ']A', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end, { buffer = bufnr })
    vim.keymap.set({ 'v', 'n' }, '[A', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end, { buffer = bufnr })
  end,
})

-- Init LSP
cmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    vim.keymap.set('n', 'gO', function()
      Snacks.picker.lsp_symbols { focus = 'list' }
    end, { buffer = ev.buf })

    vim.keymap.set('n', 'grh', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = ev.buf })
    vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { buffer = ev.buf })

    vim.keymap.set('n', 'gre', vim.diagnostic.setloclist, { buffer = ev.buf })
    vim.keymap.set('n', 'grE', vim.diagnostic.setqflist, { buffer = ev.buf })

    if client:supports_method('textDocument/codeLens') or client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.enable(true, { bufnr = ev.buf })
    end
  end,
})
