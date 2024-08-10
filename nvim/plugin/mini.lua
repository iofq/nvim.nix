if vim.g.did_load_mini_plugin then
  return
end
vim.g.did_load_mini_plugin = true

-- din( dina
require('mini.ai').setup()
-- gc gcc
require('mini.comment').setup()

--    Add surrounding with sa
--    Delete surrounding with sd.
--    Replace surrounding with sr.
--    Find surrounding with sf or sF (move cursor right or left).
--    Highlight surrounding with sh<char>.
--    'f' - function call (string of alphanumeric symbols or '_' or '.' followed by balanced '()'). In "input" finds function call, in "output" prompts user to enter function name.
--    't' - tag. In "input" finds tag with same identifier, in "output" prompts user to enter tag name.
--    All symbols in brackets '()', '[]', '{}', '<>".
--    '?' - interactive. Prompts user to enter left and right parts.
require('mini.surround').setup()

-- :Trim
require('mini.trailspace').setup()
vim.api.nvim_create_user_command('Trim', function()
  require('mini.trailspace').trim()
end, {})

-- prefix \
-- `b` - |'background'|.
-- `c` - |'cursorline'|.
-- `C` - |'cursorcolumn'|.
-- `d` - diagnostic (via |vim.diagnostic.enable()| and |vim.diagnostic.disable()|).
-- `h` - |'hlsearch'| (or |v:hlsearch| to be precise).
-- `i` - |'ignorecase'|.
-- `l` - |'list'|.
-- `n` - |'number'|.
-- `r` - |'relativenumber'|.
-- `s` - |'spell'|.
-- `w` - |'wrap'|.
require('mini.basics').setup {
  mappings = {
    windows = true,
  },
}

-- gS
require('mini.splitjoin').setup {
  detect = {
    separator = '[,;\n]',
  },
}

require('mini.pairs').setup()
vim.cmd([[ hi MiniCursorwordCurrent ctermfg=240 ]])

require('mini.jump2d').setup {
  mappings = { start_jumping = '<leader>s' },
}

indent = require('mini.indentscope')
indent.setup {
  options = { try_as_border = false },
  draw = { delay = 0 },
}
indent.gen_animation.none()
