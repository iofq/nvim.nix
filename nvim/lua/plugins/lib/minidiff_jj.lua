local diff = require('mini.diff')
local M = {
  cache = {},
}

M.get_buf_realpath = function(buf_id)
  return vim.loop.fs_realpath(vim.api.nvim_buf_get_name(buf_id)) or ''
end

M.jj_start_watching_tree_state = function(buf_id, path)
  local stdout = vim.loop.new_pipe()
  local args = { 'workspace', 'root', '--ignore-working-copy' }
  local spawn_opts = {
    args = args,
    cwd = vim.fn.fnamemodify(path, ':h'),
    stdio = { nil, stdout, nil },
  }

  local on_not_in_jj = vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(buf_id) then
      M.cache[buf_id] = nil
      return false
    end
    diff.fail_attach(buf_id)
    M.cache[buf_id] = {}
  end)

  local process, stdout_feed = nil, {}
  local on_exit = function(exit_code)
    process:close()

    -- Watch index only if there was no error retrieving path to it
    if exit_code ~= 0 or stdout_feed[1] == nil then
      return on_not_in_jj()
    end

    -- Set up index watching
    local jj_dir_path = table.concat(stdout_feed, ''):gsub('\n+$', '') .. '/.jj/working_copy'
    M.jj_setup_tree_state_watch(buf_id, jj_dir_path)

    -- Set reference text immediately
    M.jj_set_ref_text(buf_id)
  end

  process = vim.loop.spawn('jj', spawn_opts, on_exit)
  M.jj_read_stream(stdout, stdout_feed)
end

M.jj_setup_tree_state_watch = function(buf_id, jj_dir_path)
  local buf_fs_event, timer = vim.loop.new_fs_event(), vim.loop.new_timer()
  local buf_jj_set_ref_text = function()
    M.jj_set_ref_text(buf_id)
  end

  local watch_tree_state = function(_, filename, _)
    if filename ~= 'tree_state' then
      return
    end
    -- Debounce to not overload during incremental staging (like in script)
    timer:stop()
    timer:start(50, 0, buf_jj_set_ref_text)
  end
  buf_fs_event:start(jj_dir_path, { stat = true }, watch_tree_state)

  M.jj_invalidate_cache(M.cache[buf_id])
  M.cache[buf_id] = { fs_event = buf_fs_event, timer = timer }
end
M.jj_set_ref_text = vim.schedule_wrap(function(buf_id)
  if not vim.api.nvim_buf_is_valid(buf_id) then
    return
  end

  local buf_set_ref_text = vim.schedule_wrap(function(text)
    pcall(diff.set_ref_text, buf_id, text)
  end)

  -- NOTE: Do not cache buffer's name to react to its possible rename
  local path = M.get_buf_realpath(buf_id)
  if path == '' then
    return buf_set_ref_text {}
  end
  local cwd, basename = vim.fn.fnamemodify(path, ':h'), vim.fn.fnamemodify(path, ':t')

  -- Set
  local stdout = vim.loop.new_pipe()
  local spawn_opts = {
    args = { 'file', 'show', '--no-pager', '--ignore-working-copy', '-r', '@-', './' .. basename },
    cwd = cwd,
    stdio = { nil, stdout, nil },
  }

  local process, stdout_feed = nil, {}
  process = vim.loop.spawn('jj', spawn_opts, function(exit_code)
    process:close()

    if exit_code ~= 0 or stdout_feed[1] == nil then
      return buf_set_ref_text {}
    end

    -- Set reference text accounting for possible 'crlf' end of line in index
    local text = table.concat(stdout_feed, ''):gsub('\r\n', '\n')
    buf_set_ref_text(text)
  end)

  M.jj_read_stream(stdout, stdout_feed)
end)

M.jj_read_stream = function(stream, feed)
  local callback = function(err, data)
    if data ~= nil then
      return table.insert(feed, data)
    end
    if err then
      feed[1] = nil
    end
    stream:close()
  end
  stream:read_start(callback)
end

M.jj_invalidate_cache = function(cache)
  if cache == nil then
    return
  end
  pcall(vim.loop.fs_event_stop, cache.fs_event)
  pcall(vim.loop.timer_stop, cache.timer)
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
    local cache = M.cache[buf_id]
    M.cache[buf_id] = nil
    M.jj_invalidate_cache(cache)
  end

  local apply_hunks = function(_, _)
    -- staging does not apply for jj
  end

  return {
    name = 'jj',
    attach = attach,
    detach = detach,
    apply_hunks = apply_hunks,
  }
end
return M
