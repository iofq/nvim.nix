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

return M
