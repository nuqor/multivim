local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "nixd"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("nixd")
vim.lsp.config("nixd", {
  settings = {
    formatting = { command = "nixfmt" },
  },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = format_on_save_callback,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "nix",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.b[args.buf].format_on_save = true
  end,
})
