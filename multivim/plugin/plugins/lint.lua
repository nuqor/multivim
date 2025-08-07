require("dependencies").add { source = "mfussenegger/nvim-lint" }

-- vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
--   callback = function()
--     require("lint").try_lint()
--   end,
-- })
