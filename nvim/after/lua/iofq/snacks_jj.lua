local M = {}

function M.status()
  local function get_files()
    local status_raw = vim.fn.system('jj diff --no-pager --quiet --summary')
    local files = {}

    for status in status_raw:gmatch('[^\r\n]+') do
      local state, file = string.match(status, '^(%a)%s(.+)$')

      if state and file then
        local hl = ''
        if state == 'A' then
          hl = 'SnacksPickerGitStatusAdded'
        elseif state == 'M' then
          hl = 'SnacksPickerGitStatusModified'
        elseif state == 'D' then
          hl = 'SnacksPickerGitStatusDeleted'
        elseif state == 'R' then
          hl = 'SnacksPickerGitStatusRenamed'
          file = string.match(file, '{.-=>%s*(.-)}')
        end

        local diff = vim.fn.system('jj diff ' .. file .. ' --no-pager --stat --git')
        table.insert(files, {
          file = file,
          filename_hl = hl,
          diff = diff,
        })
      end
    end

    return files
  end

  Snacks.picker.pick {
    source = 'jj_status',
    items = get_files(),
    format = 'file',
    title = 'jj status',
    preview = function(ctx)
      if ctx.item.file then
        Snacks.picker.preview.diff(ctx)
      else
        ctx.preview:reset()
        ctx.preview:set_title('No preview')
      end
    end,
  }
end

function M.file_history(filename)
  local function preview(ctx)
    if ctx.item.rev then
      Snacks.picker.preview.cmd(
        { 'jj', 'log', '--ignore-working-copy', '--git', '-r', ctx.item.rev, '-p', filename },
        ctx
      )
    else
      ctx.preview:reset()
      return 'No preview available.'
    end
  end

  local function confirm(picker, item)
    picker:close()
    local cmd = string.format('jj show --git -r %s', item.rev)
    local out = vim.fn.systemlist(cmd)

    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, out)
    vim.bo[bufnr].bufhidden = 'wipe'
    vim.bo[bufnr].buftype = 'nofile'
    vim.bo[bufnr].filetype = 'diff'
    vim.keymap.set('n', 'q', vim.cmd.bdelete, { buffer = bufnr, noremap = true })

    vim.api.nvim_set_current_buf(bufnr)
  end

  local function get_history(f)
    local status_raw = vim.fn.system(
      'jj log --ignore-working-copy --no-graph'
        .. ' --template \'if(root, format_root_commit(self), label(if(current_working_copy, "working_copy"), concat(separate(" ", self.change_id().shortest(8), self.bookmarks()), " | ", if(empty, label("empty", "(empty)")), if(description, description.first_line(), label(if(empty, "empty"), description_placeholder),),) ++ "\n",),)\''
        .. ' -- '
        .. f
    )
    local lines = {}
    for line in status_raw:gmatch('[^\r\n]+') do
      local rev = string.match(line, '(%w+)%s.*')
      table.insert(lines, {
        text = line,
        rev = rev,
      })
    end
    return lines
  end

  Snacks.picker.pick {
    format = 'text',
    title = 'jj file history for ' .. filename,
    items = get_history(filename),
    preview = preview,
    confirm = confirm,
  }
end
return M
