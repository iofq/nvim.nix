require("nvim-treesitter.configs").setup {
    ensure_installed = {},
    highlight = {
        enable = true,
    },
    indent = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aa"] = "@statement.outer",
                ["ia"] = "@parameter.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']]'] = '@function.outer',
                [']a'] = '@parameter.inner',
            },
            goto_previous_start = {
                ['[['] = '@function.outer',
                ['[a'] = '@parameter.inner',
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["P]"] = "@parameter.inner",
            },
            swap_previous = {
                ["P["] = "@parameter.inner",
            },
        }, },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
}
