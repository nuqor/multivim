local register_formatter = require("languages").register_formatter

local function format(bufnr)
  require("conform").format {
    bufnr = bufnr,
    formatters = { "stylua" },
  }
end

vim.lsp.enable("emmylua_ls")
vim.lsp.config("emmylua_ls", {
  settings = {},
  on_init = function(client)
    client.config.settings.Lua =
      vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
      })
  end,
})

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
