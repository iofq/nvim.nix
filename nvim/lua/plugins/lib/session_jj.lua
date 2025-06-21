local M = {}
M.load = function()
  local jj_root = vim.system({ 'jj', 'workspace', 'root' }):wait()
  local sessions = require('mini.sessions')

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
  local branch = vim.trim(string.gsub(result.stdout, '[\n*]', ''))
  local root = vim.trim(string.gsub(jj_root.stdout, '\n', ''))
  local jj_sesh = string.gsub(string.format('jj:%s:%s', root, branch), '[./]', '-')
  if jj_sesh ~= '' then
    vim.opt.shadafile = vim.fn.stdpath('data') .. '/myshada/' .. jj_sesh .. '.shada'
    for name, _ in pairs(sessions.detected) do
      if name == jj_sesh then
        vim.ui.select({
          'No',
          'Yes',
        }, { prompt = 'Session found at ' .. jj_sesh .. ', load it?' }, function(c)
          if c == 'Yes' then
            -- load session (buffers, etc) as well as shada (marks)
            sessions.read(jj_sesh)
            vim.cmd('rshada')
            vim.notify('loaded jj session: ' .. jj_sesh)
          end
        end)
        return
      end
    end
    vim.cmd('wshada')
    sessions.write(jj_sesh)
  end
end

return M
