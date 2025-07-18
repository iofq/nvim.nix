M = {}
M.diagnostics = function()
  return {
    finder = 'diagnostics',
    format = function(item, picker)
      local ret = {} ---@type snacks.picker.Highlight[]
      local diag = item.item ---@type vim.Diagnostic
      if item.severity then
        vim.list_extend(ret, P.severity(item, picker))
      end

      local message = diag.message
      ret[#ret + 1] = { message }
      Snacks.picker.highlight.markdown(ret)
      ret[#ret + 1] = { ' ' }

      if diag.source then
        ret[#ret + 1] = { diag.source, 'SnacksPickerDiagnosticSource' }
        ret[#ret + 1] = { ' ' }
      end

      if diag.code then
        ret[#ret + 1] = { ('(%s)'):format(diag.code), 'SnacksPickerDiagnosticCode' }
        ret[#ret + 1] = { ' ' }
      end
      vim.list_extend(ret, P.filename(item, picker))
      return ret
    end,
    sort = {
      fields = {
        'is_current',
        'is_cwd',
        'severity',
        'file',
        'lnum',
      },
    },
    matcher = { sort_empty = true },
    filter = { cwd = true },
  }
end
return M
