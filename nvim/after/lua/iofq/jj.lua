local M = {}

M.is_jj_diffedit_open = function()
  local qf = vim.fn.getqflist()

  local entry = qf[1]
  if not entry or not entry.user_data or not entry.user_data.diff then
    return 0
  else
    return 1
  end
end

M.diffedit = function()
  vim.fn.jobstart('jj diffedit --tool diffview-new')
end
return M
