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
                ['ac'] = '@comment.outer',
                ['ic'] = '@comment.inner',
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["aa"] = "@call.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']]'] = '@function.outer',
                [']m'] = '@class.outer',
            },
            goto_next_end = {
                [']['] = '@function.outer',
                [']M'] = '@class.outer',
            },
            goto_previous_start = {
                ['[['] = '@function.outer',
                ['[m'] = '@class.outer',
            },
            goto_previous_end = {
                ['[]'] = '@function.outer',
                ['[M'] = '@class.outer',
            },
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<CR>',
            scope_incremental = '<CR>',
            node_incremental = '<TAB>',
            node_decremental = '<S-TAB>',
        },
    },
}
