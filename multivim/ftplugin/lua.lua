vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require("conform").format()
  end,
})
