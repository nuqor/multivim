local register_formatter = require("languages").register_formatter

local function format(bufnr)
  require("conform").format {
    bufnr = bufnr,
    formatters = { "stylua" },
  }
end

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "lua",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.b[args.buf].format_on_save = true

    register_formatter(args.buf, format)
  end,
})
