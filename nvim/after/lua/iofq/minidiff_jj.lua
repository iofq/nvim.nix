local diff = require('mini.diff')
local M = {
  cache = {},
}

M.get_buf_realpath = function(buf_id)
  local path = vim.loop.fs_realpath(vim.api.nvim_buf_get_name(buf_id)) or ''
  local cwd, basename = vim.fn.fnamemodify(path, ':h'), vim.fn.fnamemodify(path, ':t')
  return path, cwd, basename
end

M.jj_start_watching_tree_state = function(buf_id, path)
  local on_not_in_jj = vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(buf_id) then
      M.cache[buf_id] = nil
      return false
    end
    diff.fail_attach(buf_id)
    M.cache[buf_id] = {}
  end)

  vim.system(
    { 'jj', 'workspace', 'root', '--ignore-working-copy' },
    {cwd = vim.fn.fnamemodify(path, ':h')},
    function(obj)
      if obj.code ~= 0 then
        return on_not_in_jj()
      end

      -- Set up index watching
      local root = obj.stdout:gsub('\n+$', '') .. '/.jj/working_copy/tree_state'
      local buf_fs_event = vim.loop.new_fs_event()

      buf_fs_event:start(root, { stat = true }, function()
        M.jj_set_ref_text(buf_id)
      end)
      M.cache[buf_id] = { fs_event = buf_fs_event }

      -- Set reference text immediately
      M.jj_set_ref_text(buf_id)
    end
  )
end

M.jj_set_ref_text = vim.schedule_wrap(function(buf_id)
  if not vim.api.nvim_buf_is_valid(buf_id) then
    return
  end

  local buf_set_ref_text = function(text)
    pcall(diff.set_ref_text, buf_id, text)
  end

  -- react to possible rename
  local path, cwd, basename = M.get_buf_realpath(buf_id)
  if path == '' then
    return buf_set_ref_text {}
  end

  vim.system(
    { 'jj', 'file', 'show', '--no-pager', '--ignore-working-copy', '-r', '@-', './' .. basename },
    { cwd = cwd },
    vim.schedule_wrap(function(obj)
      if obj.code ~= 0 then return buf_set_ref_text {} end
      buf_set_ref_text(obj.stdout:gsub('\r\n', '\n'))
    end)
  )
end)

M.jj_invalidate_cache = function(buf_id)
  pcall(vim.loop.fs_event_stop, M.cache[buf_id].fs_event)
  M.cache[buf_id] = nil
end

M.gen_source = function()
  local attach = function(buf_id)
    -- Try attaching to a buffer only once
    if M.cache[buf_id] ~= nil then
      return false
    end
    -- - Possibly resolve symlinks to get data from the original repo
    local path = M.get_buf_realpath(buf_id)
    if path == '' then
      return false
    end

    M.cache[buf_id] = {}
    M.jj_start_watching_tree_state(buf_id, path)
  end

  local detach = function(buf_id)
    M.jj_invalidate_cache(buf_id)
  end


  return {
    name = 'jj',
    attach = attach,
    detach = detach,
    apply_hunks = function(_, _) end -- staging does not apply for jj
  }
end
return M
