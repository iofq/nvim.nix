---@type vim.lsp.Config
return {
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = true,
        test = true,
      },
      analyses = {
        unusedvariable = true,
        unusedparams = true,
        useany = true,
        unusedwrite = true,
        nilness = true,
        shadow = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        rangeVariableTypes = true,
        parameterNames = true,
      },
      usePlaceholders = true,
      staticcheck = true,
      completeUnimported = true,
      semanticTokens = true,
    },
  },
}
