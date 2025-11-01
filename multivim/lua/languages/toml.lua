local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "tombi"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("tombi")
vim.lsp.config("tombi", {
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "toml",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
  end,
})
