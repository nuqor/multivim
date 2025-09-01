local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "yamlls"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("yamlls")
vim.lsp.config("yamlls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = format_on_save_callback,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "yaml",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.b[args.buf].format_on_save = true
  end,
})
