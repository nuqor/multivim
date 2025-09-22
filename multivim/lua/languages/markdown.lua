local function format(bufnr)
  require("conform").format {
    bufnr = bufnr,
    formatters = { "mdformat" },
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
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

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = format_on_save_callback,
    })

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      buffer = args.buf,
      callback = lint_callback,
    })
  end,
})
