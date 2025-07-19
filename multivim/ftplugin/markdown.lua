vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require("conform").format()
  end,
})

-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
--   callback = function()
--     print("Call markdownlint")
--     require("lint").try_lint("markdownlint-cli2")
--   end,
-- })
