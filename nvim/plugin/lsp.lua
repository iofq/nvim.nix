if vim.g.did_load_lsp_plugin then
  return
end
vim.g.did_load_lsp_plugin = true

-- Setup language servers.
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

lspconfig.gopls.setup { on_attach = function(_, bufnr)
    capabilities = capabilities
    vim.api.nvim_command("au BufWritePre <buffer> lua vim.lsp.buf.format { async = false }")
end
}
lspconfig.pyright.setup { capabilities = capabilities }
lspconfig.nil_ls.setup { capabilities = capabilities }

vim.keymap.set('n', '<leader>de', vim.diagnostic.open_float, {desc = "Toggle diagnostic"})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = "Prev diagnostic"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = "Next diagnostic"})

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
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, noremap = true, silent = true , desc = "LSP hover"})
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, noremap = true, silent = true , desc = "LSP Rename"})
        vim.keymap.set({ 'n', 'v' }, '<leader>da', vim.lsp.buf.code_action, { buffer = ev.buf, noremap = true, silent = true , desc = "LSP code action"})
        vim.keymap.set("n", "<leader>dd", "<cmd>Telescope lsp_definitions<cr>", { buffer = ev.buf, noremap = true, silent = true , desc = "LSP definitions"})
        vim.keymap.set("n", "<leader>di", "<cmd>Telescope lsp_implementations<cr>", { buffer = ev.buf, noremap = true, silent = true , desc = "LSP implementations"})
        vim.keymap.set("n", "<leader>dr", "<cmd>Telescope lsp_references<cr>", { buffer = ev.buf, noremap = true, silent = true , desc = "LSP references"})
        vim.keymap.set("n", "<leader>dt", "<cmd>Telescope lsp_type_definitions<cr>", { buffer = ev.buf, noremap = true, silent = true , desc = "LSP type defs"})
        vim.keymap.set("n", "<leader>ds", "<cmd>Telescope lsp_document_symbols<cr>", { buffer = ev.buf, noremap = true, silent = true , desc = "LSP symbols"})
        vim.keymap.set('n', '<leader>dl', vim.lsp.codelens.run, { buffer = ev.buf, noremap = true, silent = true , desc = "LSP codelens"})
        vim.keymap.set('n', '<space>df', function()
            vim.lsp.buf.format { async = true }
        end,{ buffer = ev.buf, noremap = true, silent = true , desc = "LSP format"})
        -- Auto-refresh code lenses
        if not client then
          return
        end
        local group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client.id), {})
        if client.server_capabilities.codeLensProvider then
          vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufWritePost', 'TextChanged' }, {
            group = group,
            callback = function()
              vim.lsp.codelens.refresh { bufnr = bufnr }
            end,
            buffer = bufnr,
          })
          vim.lsp.codelens.refresh { bufnr = bufnr }
        end
    end,
})

