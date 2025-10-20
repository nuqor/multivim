local register_formatter = require("languages").register_formatter

local function format(bufnr)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "rust_analyzer"
    end,
  }
end

vim.lsp.enable("rust_analyzer")
vim.lsp.config("rust_analyzer", {
  on_attach = function(client, bufnr)
    register_formatter(bufnr, format)
    vim.keymap.set("n", "<C-i>", function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end)
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "rust",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.b[args.buf].format_on_save = true
  end,
})
