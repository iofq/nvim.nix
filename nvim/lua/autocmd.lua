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

    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    pcall(vim.treesitter.start, bufnr)

    vim.keymap.set({'v','n'}, ']]', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects')
    end, { buffer = bufnr, desc = 'next function def' })
    vim.keymap.set({'v','n'}, '[[', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects')
    end, { buffer = bufnr, desc = 'prev function def' })
    vim.keymap.set({'v','n'}, ']a', function()
      require('nvim-treesitter-textobjects.move').goto_next_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr, desc = 'next param def' })
    vim.keymap.set({'v','n'}, '[a', function()
      require('nvim-treesitter-textobjects.move').goto_previous_start('@parameter.inner', 'textobjects')
    end, { buffer = bufnr, desc = 'prev param def' })
    vim.keymap.set({'v','n'}, ']A', function()
      require('nvim-treesitter-textobjects.swap').swap_next('@parameter.inner')
    end, { buffer = bufnr, desc = 'swap next arg' })
    vim.keymap.set({'v','n'}, '[A', function()
      require('nvim-treesitter-textobjects.swap').swap_previous('@parameter.inner')
    end, { buffer = bufnr, desc = 'swap prev arg' })
  end,
})

-- Init LSP
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    vim.keymap.set('n', 'gO', function()
      Snacks.picker.lsp_symbols { focus = 'list' }
    end, { buffer = ev.buf, desc = 'LSP symbols' })

    vim.keymap.set('n', 'grh', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end, { buffer = ev.buf, desc = 'LSP hints toggle' })
    vim.keymap.set('n', 'grl', vim.lsp.codelens.run, { buffer = ev.buf, desc = 'vim.lsp.codelens.run()' })

    vim.keymap.set('n', 'gre', function()
      vim.diagnostic.setloclist()
    end, { buffer = ev.buf, desc = 'LSP buffer diagnostics' })
    vim.keymap.set('n', 'grE', function()
      vim.diagnostic.setqflist()
    end, { buffer = ev.buf, desc = 'LSP diagnostics' })

    -- Auto-refresh code lenses
    if client:supports_method('textDocument/codeLens') or client.server_capabilities.codeLensProvider then
      vim.lsp.codelens.refresh { bufnr = ev.buf }
      vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
        callback = function()
          vim.lsp.codelens.refresh { bufnr = ev.buf }
        end,
        buffer = ev.buf,
      })
    end
  end,
})
