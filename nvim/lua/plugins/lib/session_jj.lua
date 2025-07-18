local M = {}
local sessions = require('mini.sessions')

M.get_id = function()
  local jj_root = vim.system({ 'jj', 'workspace', 'root' }):wait()

  if jj_root.code ~= 0 then
    return
  end

  local result = vim
      .system({
        'jj',
        'log',
        '-r',
        'latest(heads(::@ & bookmarks()))',
        '--template',
        'bookmarks',
        '--no-pager',
        '--no-graph',
      })
      :wait()
  local branch = vim.trim(string.gsub(result.stdout, '[\n*]', ''))             -- trim newlines and unpushed indicator
  local root = vim.trim(string.gsub(jj_root.stdout, '\n', ''))
  local id = string.gsub(string.format('jj:%s:%s', root, branch), '[./]', '-') -- slugify
  return id
end

M.check_exists = function(id)
  for name, _ in pairs(sessions.detected) do
    if name == id then
      return true
    end
  end
  return false
end

M.load = function()
  local id = M.get_id()
  if id == '' then
    return
  end
  vim.opt.shadafile = vim.fn.stdpath('data') .. '/myshada/' .. id .. '.shada'
  if M.check_exists(id) then
    vim.ui.select({
      'Yes',
      'No',
    }, { prompt = 'Session found at ' .. id .. ', load it?' }, function(c)
      if c == 'Yes' then
        -- load session (buffers, etc) as well as shada (marks)
        sessions.read(id)
        vim.cmd('rshada')
        Snacks.notify('loaded jj session: ' .. id)
      end
    end)
  else
    vim.cmd('wshada') -- create session if it did not exist
    sessions.write(id)
  end
end

return M
