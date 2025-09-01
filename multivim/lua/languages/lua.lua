local function format(bufnr)
  require("conform").format {
    bufnr = bufnr,
    formatters = { "stylua" },
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "lua",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.b[args.buf].format_on_save = true

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.bufnr,
      callback = format_on_save_callback,
    })
  end,
})
