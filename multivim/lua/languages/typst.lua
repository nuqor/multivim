local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "tinymist"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("tinymist")
vim.lsp.config("tinymist", {
  settings = {
    formatterMode = "typstyle",
  },
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "typst",
  callback = function(args)
    vim.b[args.buf].format_on_save = true
  end,
})
