local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "nixd"
    end,
  }
end

vim.lsp.enable("nixd")
vim.lsp.config("nixd", {
  settings = {
    formatting = { command = "nixfmt" },
  },
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
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
