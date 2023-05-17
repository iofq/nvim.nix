require('mini.comment').setup()
require('mini.move').setup()
require('mini.surround').setup()
require('mini.splitjoin').setup({
    detect =  {
        separator = '[,;\n]'
    }
})

require('mini.pairs').setup()
vim.cmd([[ hi MiniCursorwordCurrent ctermfg=240 ]])

require('mini.jump2d').setup({
    mappings = { start_jumping = '<leader>s' }
})

indent = require('mini.indentscope')
indent.setup({
    options = { try_as_border = false },
    draw =  { delay = 0 }
})
indent.gen_animation.none()
