local M = {}

function M.register_formatter(bufnr, format_callback)
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function(args)
      if vim.b[args.buf].format_on_save then
        format_callback(args.buf)
      end
    end,
  })
  vim.b[bufnr].formatter_callback = format_callback
end

local function format()
  if vim.b.formatter_callback ~= nil then
    vim.b.formatter_callback()
  else
    vim.notify("multivim_format not set")
  end
end

vim.keymap.set("n", "cf", format)

return M
