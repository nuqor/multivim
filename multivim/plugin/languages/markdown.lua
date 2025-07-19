vim.lsp.enable("marksman")

require("conform").setup {
  formatters_by_ft = { markdown = { "mdformat" } },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "markdown",
  callback = function(args)
    print("Opened markdown buffer")
    vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
      buffer = args.buf,
      callback = function()
        print("Call markdownlint")
        require("lint").try_lint("markdownlint")
      end,
    })
  end,
})
