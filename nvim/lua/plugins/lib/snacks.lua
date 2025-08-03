M = {}
M.diagnostics = function(filter)
  Snacks.picker.diagnostics {
    filter = filter,
    focus = 'list',
    format = function(item, picker)
      P = require('snacks.picker.format')
      local ret = {} ---@type snacks.picker.Highlight[]
      vim.list_extend(ret, P.filename(item, picker))

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
      return ret
    end,
  }
end
return M
