vim.cmd([[ hi IndentBlanklineChar ctermfg=240 ]])
vim.cmd([[ hi IndentBlanklineContextChar ctermfg=7 ]])
require("indent_blankline").setup {
    show_current_context = true,
    show_current_context_start = true,
}
