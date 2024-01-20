require('gitsigns').setup{
    signcolumn = false,
    numhl = true,
    on_attach = function()
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "<leader>gg", gs.preview_hunk)
        vim.keymap.set('n', '<leader>gs', gs.stage_hunk)
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk)
        vim.keymap.set('v', '<leader>gs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        vim.keymap.set('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
        vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk)
        vim.keymap.set('n', '<leader>gS', gs.stage_buffer)
        vim.keymap.set('n', '<leader>gR', gs.reset_buffer)
        vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end)
        vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame)
        vim.keymap.set('n', '<leader>gd', gs.diffthis)
        vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end)
        vim.keymap.set('n', '<leader>gt', gs.toggle_deleted)
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
