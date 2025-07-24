local Dart = {}
local M = {}

-- table of {bufnr = int, mark = string}
M.state = {}

Dart.setup = function(config)
  config = M.setup_config(config)
  M.apply_config(config)
  M.create_autocommands()
  M.create_default_hl()

  _G.Dart = Dart
end

M.config = {
  -- list of characters to use to mark 'pinned' buffers
  -- the characters will be chosen for new pins in order
  marklist = { 'a', 's', 'd', 'f', 'q', 'w', 'e', 'r' },
  -- list of characters to use to mark recent buffers
  -- we track the last #buflist opened buffers to display on the left side of the tabline
  buflist = { 'z', 'x', 'c' },

  mappings = {
    mark = '<leader>mm',
    jump = '<leader>m',
    pick = '<leader>mp',
    next = '<S-l>',
    prev = '<S-h>',
  },
}

M.setup_config = function(config)
  M.config = vim.tbl_deep_extend('force', M.config, config or {})
  return M.config
end

M.apply_config = function(config)
  -- built list of all marks (buf + pin) to sort tabline by
  M.order = {}
  for i, key in ipairs(vim.list_extend(vim.deepcopy(config.buflist), config.marklist)) do
    M.order[key] = i
  end

  vim.opt.showtabline = 2
  vim.opt.tabline = '%!v:lua.Dart.gen_tabline()'

  -- setup keymaps
  local function map(mode, lhs, rhs, opts)
    if lhs == '' then
      return
    end
    opts = vim.tbl_deep_extend('force', { silent = true }, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map('n', config.mappings.mark, Dart.mark, { desc = 'Dart: mark current buffer' })
  map('n', config.mappings.jump, function()
    Dart.jump(vim.fn.getcharstr())
  end, { desc = 'Dart: jump to buffer' })
  map('n', config.mappings.pick, Dart.pick, { desc = 'Dart: pick buffer' })
  map('n', config.mappings.next, Dart.next, { desc = 'Dart: next buffer' })
  map('n', config.mappings.prev, Dart.prev, { desc = 'Dart: prev buffer' })
end

M.create_autocommands = function()
  local group = vim.api.nvim_create_augroup('Dart', {})

  -- cleanup deleted buffers
  vim.api.nvim_create_autocmd('BufDelete', {
    group = group,
    callback = function(args)
      M.del_by_bufnr(args.buf)
    end,
  })

  -- track last n opened buffers
  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'BufAdd' }, {
    group = group,
    callback = function(args)
      M.shift_buflist(args.buf)
    end,
  })

  -- Clickable tabs
  vim.api.nvim_exec2(
    [[function! SwitchBuffer(buf_id, clicks, button, mod)
        execute 'buffer' a:buf_id
      endfunction]],
    {}
  )
end

-- Use Mini Tabline for default highlights, since it's well supported by many colorschemes
-- override the foreground for labels to be more visible
M.create_default_hl = function()
  local set_default_hl = function(name, opts)
    opts.default = true
    vim.api.nvim_set_hl(0, name, opts)
  end

  local override_label = function(hl, link)
    local prev = vim.api.nvim_get_hl(0, { name = link })
    vim.api.nvim_set_hl(0, hl, { bg = prev.bg, fg = 'orange', bold = true })
  end

  -- Current selection
  set_default_hl('DartCurrent', { link = 'MiniTablineCurrent' })
  override_label('DartCurrentLabel', 'MiniTablineCurrent')

  -- Current selection if modified
  set_default_hl('DartCurrentModified', { link = 'MiniTablineModifiedCurrent' })
  override_label('DartCurrentLabelModified', 'MiniTablineModifiedCurrent')

  -- Visible but not selected
  set_default_hl('DartVisible', { link = 'MiniTablineVisible' })
  override_label('DartVisibleLabel', 'MiniTablineVisible')

  -- Visible and modified but not selected
  set_default_hl('DartVisibleModified', { link = 'MiniTablineModifiedVisible' })
  override_label('DartVisibleLabelModified', 'MiniTablineModifiedVisible')

  -- Fill
  set_default_hl('DartFill', { link = 'MiniTablineFill' })
end

M.get_state_by_field = function(field, value)
  for _, m in ipairs(M.state) do
    if m[field] == value then
      return m
    end
  end
end

M.state_from_bufnr = function(bufnr)
  return M.get_state_by_field('bufnr', bufnr)
end

M.state_from_mark = function(mark)
  return M.get_state_by_field('mark', mark)
end

M.del_by_bufnr = function(bufnr)
  for i, m in ipairs(M.state) do
    if m.bufnr == bufnr then
      table.remove(M.state, i)
      return
    end
  end
end

M.should_show = function(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr) -- buffer exists and is loaded
    and vim.api.nvim_buf_is_loaded(bufnr)
    and vim.bo[bufnr].buflisted -- don't show hidden buffers
    and vim.bo[bufnr].buftype == '' -- don't show pickers, prompts, etc.
    and vim.api.nvim_buf_get_name(bufnr) ~= '' -- don't show unnamed files
end

M.next_unused_mark = function()
  for _, m in ipairs(M.config.marklist) do
    if not M.state_from_mark(m) then
      return m
    end
  end
  return 'Z'
end

M.shift_buflist = function(bufnr)
  if M.state_from_bufnr(bufnr) or not M.should_show(bufnr) then
    return
  end

  local buflist = M.config.buflist

  -- if there's a free buflist mark, set it
  for _, mark in ipairs(buflist) do
    if not M.state_from_mark(mark) then
      M.mark(bufnr, mark)
      return
    end
  end

  -- if not, shift buflist right and set new buffer to element 1
  for i = #buflist, 2, -1 do
    local mark = M.state_from_mark(buflist[i])
    local next = M.state_from_mark(buflist[i - 1])
    mark.bufnr = next.bufnr
  end
  M.state_from_mark(buflist[1]).bufnr = bufnr
end

-- param direction -1 for prev, 1 for next
M.cycle_tabline = function(direction)
  local cur = vim.api.nvim_get_current_buf()
  for i, m in ipairs(M.state) do
    if cur == m.bufnr then
      local next = ((i + direction - 1) % #M.state) + 1 -- wrap around list
      if M.state[next] then
        vim.api.nvim_set_current_buf(M.state[next].bufnr)
        return
      end
    end
  end
end

M.gen_tabpage = function()
  local n_tabpages = vim.fn.tabpagenr('$')
  if n_tabpages == 1 then
    return ''
  end
  return string.format('%%= Tab %d/%d ', vim.fn.tabpagenr(), n_tabpages)
end

M.gen_tabline_item = function(item)
  local bufnr = item.bufnr
  local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':t')
  local is_current = bufnr == vim.api.nvim_get_current_buf()
  local modified = vim.bo[bufnr].modified and 'Modified' or ''

  local hl_label = is_current and 'DartCurrentLabel' or 'DartVisibleLabel'
  local label = item.mark ~= '' and item.mark .. ' ' or ''
  local hl = is_current and 'DartCurrent' or 'DartVisible'
  local content = filename ~= '' and filename or '*'

  return {
    bufnr = bufnr,
    hl_label = hl_label .. modified,
    label = label,
    hl = hl .. modified,
    content = content,
  }
end

M.format_tabline_item = function(item)
  local click = string.format('%%%s@SwitchBuffer@', item.bufnr)
  return string.format('%%#%s#%s %s%%#%s#%s %%X', item.hl_label, click, item.label, item.hl, item.content)
end

M.mark = function(bufnr, mark)
  if not bufnr then
    bufnr = vim.api.nvim_get_current_buf()
  end
  if not M.should_show(bufnr) then
    return
  end
  if not mark then
    mark = M.next_unused_mark()
  end

  local exists = M.state_from_bufnr(bufnr)
  if not exists then
    table.insert(M.state, { bufnr = bufnr, mark = mark })
  elseif vim.tbl_contains(M.config.buflist, exists.mark) then
    exists.mark = mark -- allow for re-marking buffers in the buflist
  else
    return -- skip sort if no change
  end
  table.sort(M.state, function(a, b)
    return (M.order[a.mark] or 998) < (M.order[b.mark] or 999)
  end)
  vim.cmd.redrawtabline()
end

Dart.state = M.state
Dart.mark = M.mark

Dart.jump = function(mark)
  local m = M.state_from_mark(mark)
  if m and m.bufnr then
    vim.api.nvim_set_current_buf(m.bufnr)
  end
end

Dart.pick = function()
  local prompt = { 'Jump to buffer:' }
  for _, mark in ipairs(M.state) do
    local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(mark.bufnr), ':t')
    table.insert(prompt, string.format('  %s → %s', mark.mark, name))
  end

  local selected = vim.fn.input(table.concat(prompt, '\n') .. '\n> ')
  Dart.jump(selected)
end

Dart.next = function()
  M.cycle_tabline(1)
end

Dart.prev = function()
  M.cycle_tabline(-1)
end

Dart.gen_tabline = function()
  local items = {}
  local center = 1
  local cur = vim.api.nvim_get_current_buf()
  local columns = vim.o.columns

  for i, m in ipairs(M.state) do
    if M.should_show(m.bufnr) then
      table.insert(items, M.gen_tabline_item(m))
      if m.bufnr == cur then
        center = i
      end
    else
      M.del_by_bufnr(m.bufnr)
    end
  end

  local function width(tabline)
    return vim.api.nvim_strwidth(table.concat(
      vim.tbl_map(function(m)
        return string.format(' %s %s ', m.label, m.content)
      end, tabline),
      ''
    )) + 3 -- save room for trunc
  end

  local result = { items[center] }
  local left = center - 1
  local right = center + 1
  local trunc_left = false
  local trunc_right = false

  while left >= 1 or right <= #items do
    local added = false

    if left >= 1 then
      table.insert(result, 1, items[left])
      if width(result) >= columns then
        table.remove(result, 1)
        trunc_left = true
      else
        left = left - 1
        added = true
      end
    end
    if right <= #items then
      table.insert(result, items[right])
      if width(result) >= columns then
        table.remove(result)
        trunc_right = true
      else
        right = right + 1
        added = true
      end
    end
    if not added then
      break
    end
  end

  return (trunc_left and '%#DartVisibleLabel# < ' or '')
    .. table.concat(vim.tbl_map(M.format_tabline_item, result), '')
    .. (trunc_right and '%#DartVisibleLabel# > ' or '')
    .. '%X%#DartFill#'
    .. M.gen_tabpage()
end

return Dart
