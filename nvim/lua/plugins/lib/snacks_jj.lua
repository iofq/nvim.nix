local M = {}

function M.status()
  local function get_files()
    local status_raw = vim.fn.system('jj diff --no-pager --quiet --summary')
    local files = {}

    for status in status_raw:gmatch('[^\r\n]+') do
      local state, text = string.match(status, '^(%a)%s(.+)$')

      if state and text then
        local file = text

        local hl = ''
        if state == 'A' then
          hl = 'SnacksPickerGitStatusAdded'
        elseif state == 'M' then
          hl = 'SnacksPickerGitStatusModified'
        elseif state == 'D' then
          hl = 'SnacksPickerGitStatusDeleted'
        elseif state == 'R' then
          hl = 'SnacksPickerGitStatusRenamed'
          file = string.match(text, '{.-=>%s*(.-)}')
        end

        local diff = vim.fn.system('jj diff ' .. file .. ' --ignore-working-copy --no-pager --stat --git')
        table.insert(files, {
          text = text,
          file = file,
          filename_hl = hl,
          state = state,
          diff = diff,
        })
      end
    end

    return files
  end

  local files = get_files()

  Snacks.picker.pick {
    source = 'jj_status',
    items = files,
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

function M.revs()
  local function jj_new(picker, item)
    picker:close()
    if item then
      if not item.rev then
        Snacks.notify.warn('No branch or commit found', { title = 'Snacks Picker' })
        return
      end
      local cmd = { 'jj', 'new', '-r', item.rev }
      Snacks.picker.util.cmd(cmd, function()
        Snacks.notify('Checking out revision: ' .. item.rev, { title = 'Snacks Picker' })
        vim.cmd.checktime()
        require('plugins.lib.session_jj').load()
      end, { cwd = item.cwd })
    end
  end

  local function jj_rev_cmd(ctx)
    if ctx.item.rev then
      Snacks.picker.preview.cmd({ 'jj', 'show', '--ignore-working-copy', '--git', '-r', ctx.item.rev }, ctx)
    else
      ctx.preview:reset()
      return 'No preview available.'
    end
  end

  local function jj_log(revset)
    if revset == nil then
      revset = '-r "ancestors(@,25)"'
    else
      revset = '-r ' .. revset
    end
    local status_raw = vim.fn.system(
      'jj log --ignore-working-copy '
      .. revset
      ..
      ' --template \'if(root, format_root_commit(self), label(if(current_working_copy, "working_copy"), concat(separate(" ", self.change_id().shortest(8), self.bookmarks()), " | ", if(empty, label("empty", "(empty)")), if(description, description.first_line(), label(if(empty, "empty"), description_placeholder),),) ++ "\n",),)\''
    )
    local lines = {}

    for line in status_raw:gmatch('[^\r\n]+') do
      local sign, rev = string.match(line, '(.)%s(%a+)%s.*')
      table.insert(lines, {
        text = line,
        sign = sign,
        rev = rev,
      })
    end

    return lines
  end

  Snacks.picker.pick {
    source = 'jj_revs',
    layout = 'ivy',
    format = 'text',
    title = 'jj log',
    items = jj_log(),
    confirm = jj_new,
    preview = jj_rev_cmd,
  }
end

return M
