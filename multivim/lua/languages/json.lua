local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "jsonls"
    end,
  }
end

vim.lsp.enable("jsonls")
vim.lsp.config("jsonls", {
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "json",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end,
})
