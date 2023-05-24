require('gitsigns').setup{
    signs = {
        add = { text = '✓'},
        change = { text = '↔'},
        delete = { text = '✗'},
    },
    signcolumn = auto,
    on_attach = function()
        vim.wo.signcolumn = "yes"
        vim.cmd [[ hi SignColumn ctermbg=none]]
        vim.cmd [[ hi GitSignsAdd ctermbg=none]]
        vim.cmd [[ hi GitSignsDelete ctermbg=none]]
        vim.cmd [[ hi GitSignsChange ctermbg=none]]
    end
}

require("neogit").setup({
    disable_context_highlighting = true
})
vim.cmd [[ hi DiffAdd ctermbg=none ]]
vim.cmd [[ hi DiffDelete ctermbg=none ]]
vim.cmd [[ hi DiffContext ctermbg=none ]]
vim.cmd [[ hi NeogitHunkHeader ctermbg=none ]]
vim.cmd [[ hi NeogitHunkHeader ctermbg=none ]]

require("rose-pine").setup({
    variant = "moon",
    disable_background = true,
    disable_float_background = true
})

vim.cmd.colorscheme "rose-pine"
