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

return M
