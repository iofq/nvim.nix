if vim.g.did_load_gitsigns_plugin then
  return
end
vim.g.did_load_gitsigns_plugin = true

vim.schedule(function()
  require('gitsigns').setup{
      signcolumn = false,
      numhl = true,
      on_attach = function()
          local gs = package.loaded.gitsigns
          vim.keymap.set("n", "<leader>gg", gs.preview_hunk, {desc = "git preview hunk"})
          vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end, {desc = "git blame_line"})
          vim.keymap.set('n', '<leader>gr', gs.reset_hunk, {desc = "git reset hunk"})
          vim.keymap.set('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "git reset hunk"})
           -- Navigation
          vim.keymap.set('n', ']g', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true})

          vim.keymap.set('n', '[g', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true})
      end
  }
end)
