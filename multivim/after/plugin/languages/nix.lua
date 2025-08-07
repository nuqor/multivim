vim.lsp.enable("nixd")

vim.lsp.config("nixd", {
  settings = {
    formatting = { command = "nixfmt" },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format { async = false, id = client.id }
      end,
    })
  end,
})
