vim.lsp.enable("yamlls")

vim.lsp.config("yamlls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
  end,
})
