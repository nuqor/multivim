local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "yamlls"
    end,
  }
end

vim.lsp.enable("yamlls")
vim.lsp.config("yamlls", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = true
    register_formatter(bufnr, format)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "yaml",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end,
})
