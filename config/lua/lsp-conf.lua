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
        vim.keymap.set({ 'n', 'v' }, '<leader>ac', vim.lsp.buf.code_action, opts)
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
