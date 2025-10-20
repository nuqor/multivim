local register_formatter = require("languages").register_formatter

local function format(bufnr)
  require("conform").format {
    bufnr = bufnr,
    formatters = { "mdformat" },
  }
end

local function lint_callback(args)
  require("lint").try_lint("markdownlint")
end

vim.lsp.enable("marksman")

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  callback = function(args)
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.b[args.buf].format_on_save = true

    register_formatter(args.buf, format)

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      buffer = args.buf,
      callback = lint_callback,
    })
  end,
})
