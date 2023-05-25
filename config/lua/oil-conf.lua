local oil = require('oil')
oil.setup({
    columns = {
        "permissions",
        "size"
    },
    view_options = {
        show_hidden = true
    },
    keymaps = {
        ["wq"] = "actions.close"
    }
})
vim.keymap.set("n", "<leader>c", oil.toggle_float, {noremap = true, silent = true});
