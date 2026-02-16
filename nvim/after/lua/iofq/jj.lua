local M = {}
M.is_jj_diffedit_open = function()
  local entry = vim.fn.getqflist[1]
  if not entry or not entry.user_data or not entry.user_data.diff then
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do -- close all /tmp buffers
      if vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':p'):match('/tmp/jj%-diff.*') then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end
    return 0
  else
    return 1
  end
end

M.diffedit = function(opts)
  opts = opts or { args = '' }
  vim.fn.jobstart('jj diffedit --tool difftool ' .. opts.args)
end

vim.api.nvim_create_user_command('Diffedit', M.diffedit, { nargs = '*' })
return M
