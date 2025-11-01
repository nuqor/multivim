local localconf = require("multivim.localconf")

local M = {}

function M.register_formatter(bufnr, format_callback)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function(args)
      if localconf.get("format_on_save", bufnr) then
        format_callback(args.buf)
      end
    end,
  })
  vim.b[bufnr].multivim_format = format_callback
end

local function format()
  if vim.b.multivim_format then
    vim.b.multivim_format()
  else
    vim.notify("multivim_format not set")
  end
end

vim.keymap.set("n", "cf", format)

return M
