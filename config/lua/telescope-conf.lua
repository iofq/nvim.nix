local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", telescope.buffers, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ff", telescope.find_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fg", telescope.git_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fv", telescope.command_history, {noremap = true, silent = true})
vim.keymap.set("n", "<leader><leader>", telescope.live_grep, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>8", telescope.grep_string, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fd", telescope.lsp_definitions, {noremap = true, silent = true})
-- fix highlighting
vim.cmd([[ hi telescopeselection ctermfg=242 ctermbg=252 ]])

require("telescope").setup({
    defaults = {
        layout_strategy = "vertical",
        layout_config = { width = .90, },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--hidden",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case"
        },
        mappings = {
            i = {
                ["<esc>"] = require("telescope.actions").close,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<C-j>"] = require("telescope.actions").move_selection_next,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
        },
        git_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--iglob', '!.git', '--hidden' }
        },
    }
})
