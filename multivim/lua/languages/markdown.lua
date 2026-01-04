local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "rumdl"
    end,
  }
end

vim.lsp.enable("rumdl")
vim.lsp.config("rumdl", {
  on_attach = function(_client, bufnr)
    register_formatter(bufnr, format)
  end,
})

vim.lsp.enable("marksman")

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  callback = function(_args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end,
})
