local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>fb", telescope.buffers, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>ff", telescope.find_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fg", telescope.git_files, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fv", telescope.command_history, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fa", telescope.live_grep, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>f8", telescope.grep_string, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>f<BS>", telescope.resume, {noremap = true, silent = true})
vim.keymap.set("n", "<leader>fs", telescope.git_status, {noremap = true, silent = true})

local telescope = require("telescope")
telescope.setup({
    defaults = {
        layout_strategy = "vertical",
        layout_config = { width = .90, },
        prompt_title = false,
        results_title = false,
        preview_title = false,
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
                ["wq"] = require("telescope.actions").close,
                ["<Esc>"] = require("telescope.actions").close,
                ["<C-k>"] = require("telescope.actions").move_selection_previous,
                ["<C-j>"] = require("telescope.actions").move_selection_next,
            },
        },
    },
})
telescope.load_extension("fzf")
