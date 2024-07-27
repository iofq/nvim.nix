--------------------
-- Mini
--------------------
require("mini-conf")

--------------------
-- Toggleterm
--------------------
require("toggleterm").setup{
    open_mapping = [[<C-\>]],
    direction = "float",
    close_on_exit  = true,
}

--------------------
-- Telescope
--------------------
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

--------------------
-- Treesitter
--------------------
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
                ["s]"] = "@parameter.inner",
            },
            swap_previous = {
                ["s["] = "@parameter.inner",
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

--------------------
-- LSP Config
--------------------

-- Setup language servers.
local lspconfig = require('lspconfig')
lspconfig.gopls.setup { on_attach = function(_, bufnr)
    vim.api.nvim_command("au BufWritePre <buffer> lua vim.lsp.buf.format { async = false }")
end
}
lspconfig.pyright.setup {}
lspconfig.nil_ls.setup {}

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
})
-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>da', vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>dd", "<cmd>Telescope lsp_definitions<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>di", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>dt", "<cmd>Telescope lsp_type_definitions<cr>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = bufnr })
        vim.keymap.set('n', '<space>df', function()
            vim.lsp.buf.format { async = true }
        end, opts)
    end,
})

--------------------
-- Git
--------------------
require('gitsigns').setup{
    signcolumn = false,
    numhl = true,
    on_attach = function()
        local gs = package.loaded.gitsigns
        vim.keymap.set("n", "<leader>gg", gs.preview_hunk)
        vim.keymap.set('n', '<leader>gb', function() gs.blame_line{full=true} end)
        vim.keymap.set('n', '<leader>gr', gs.reset_hunk)
        vim.keymap.set('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
         -- Navigation
        vim.keymap.set('n', ']g', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        vim.keymap.set('n', '[g', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})
    end
}

local neogit = require('neogit')
neogit.setup {integrations = {diffview = true}}
vim.keymap.set('n', '<leader>ng', neogit.open)

require("diffview")

--------------------
-- Oil & Undo
--------------------
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

vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>")

--------------------
-- Refactoring
--------------------
require('refactoring').setup({
    prompt_func_return_type = { go = true, },
    prompt_func_param_type = { go = true, },
    show_success_message = true,
})

require("telescope").load_extension("refactoring")
vim.keymap.set(
	{"n"},
	"<leader>rr",
	function() require('telescope').extensions.refactoring.refactors() end
)
--------------------
-- Colors
--------------------

require("rose-pine").setup({
    variant = "moon",
    styles = {
        bold = false,
        italic = false,
        transparency = true,
    },
})
vim.cmd.colorscheme "rose-pine-main"

--------------------
-- include our config last to override
--------------------
require("nvim-conf")
