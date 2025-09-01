local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "lemminx"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("lemminx")
vim.lsp.config("lemminx", {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = format_on_save_callback,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "xml",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.b[args.buf].format_on_save = true
  end,
})
