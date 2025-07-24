local M = {}
M.marklist = { 'a', 's', 'd', 'f', 'g', 'q', 'w', 'e', 'r', 't' }

-- table of {bufnr = int, mark = string}
M.state = {}

M.setup = function()
  M.order = {}
  for i, key in ipairs(M.marklist) do
    M.order[key] = i
  end
  vim.api.nvim_create_autocmd('BufDelete', {
    group = vim.api.nvim_create_augroup('Tabline', {}),
    callback = function(args)
      for i, m in ipairs(M.state) do
        if m.bufnr == args.buf then
          table.remove(M.state, i)
        end
      end
    end,
  })
end

local function get_mark_entry(field, value)
  for _, m in ipairs(M.state) do
    if m[field] == value then
      return m
    end
  end
end

M.state_from_bufnr = function(bufnr)
  return get_mark_entry('bufnr', bufnr)
end

M.state_from_mark = function(mark)
  return get_mark_entry('mark', mark)
end

M.get_state = function()
  return vim.tbl_deep_extend('force', {}, M.state)
end

M.next_unused_mark = function()
  for _, m in ipairs(M.marklist) do
    if not M.state_from_mark(m) then
      return m
    end
  end
  return 'Z'
end

M.mark = function()
  local cur = vim.api.nvim_get_current_buf()
  if not M.state_from_bufnr(cur) then
    table.insert(M.state, { bufnr = cur, mark = M.next_unused_mark() })
    table.sort(M.state, function(a, b)
      return (M.order[a.mark] or 998) < (M.order[b.mark] or 999)
    end)
    vim.cmd.redrawtabline()
  end
end

M.jump = function(mark)
  local m = M.state_from_mark(mark)
  if m.bufnr then
    vim.api.nvim_set_current_buf(m.bufnr)
  end
end

-- param direction -1 for prev, 1 for next
M.jump_marklist = function(direction)
  local marked = M.get_state()
  local cur = vim.api.nvim_get_current_buf()

  for i, m in ipairs(marked) do
    if cur == m.bufnr then
      local next = ((i + direction - 1) % #vim.tbl_keys(marked)) + 1 -- wrap around list
      if marked[next] then
        vim.api.nvim_set_current_buf(marked[next].bufnr)
        return
      end
    end
  end
  -- fallback to buffers if no match
  vim.cmd(direction == 1 and 'bnext' or 'bprev')
end

M.gen_tabline = function()
  local marked = M.get_state()
  local pinned = {}

  local function should_show(bufnr)
    return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted
  end

  if #marked == 0 then
    return MiniTabline.make_tabline_string()
  end

  -- always show current buffer at beginning of tabline
  local cur = vim.api.nvim_get_current_buf()
  if not M.state_from_bufnr(cur) and should_show(cur) then
    table.insert(pinned, M.format_tabline_item { bufnr = cur, mark = '' })
  end

  for _, m in ipairs(marked) do
    if should_show(m.bufnr) then
      table.insert(pinned, M.format_tabline_item(m))
    end
  end

  -- Join with filler in between
  return table.concat(pinned, '') .. '%X%#MiniTablineFill#' .. M.gen_tabpage()
end

M.gen_tabpage = function()
  local n_tabpages = vim.fn.tabpagenr('$')
  if n_tabpages == 1 then
    return ''
  end
  return string.format('%%= Tab %s/%s ', vim.fn.tabpagenr(), n_tabpages)
end

M.format_tabline_item = function(item)
  local bufnr = item.bufnr
  local mark = item.mark

  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
  local label = filename ~= '' and filename or '[No Name]'

  local function truncate(str, max_len)
    return #str > max_len and str:sub(1, max_len - 1) .. '…' or str
  end

  local is_current = bufnr == vim.api.nvim_get_current_buf()
  local hl = is_current and '%#MiniTablineCurrent#' or '%#MiniTablineVisible#'
  local hl_label = is_current and '%#MiniTablineCurrentLabel#' or '%#MiniTablineVisibleLabel#'
  local mark_label = mark ~= '' and truncate(mark .. ' ', 20) or ''
  return string.format('%s%%1@v:lua.MiniTablineSwitchBuffer@ %s%s%s%s', hl_label, mark_label, hl, label, ' %X')
end

return M
