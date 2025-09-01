local function format(bufnr)
  vim.lsp.buf.code_action {
    context = { only = { "source.organizeImports" } },
    apply = true,
  }
  vim.wait(100)
  vim.lsp.buf.format {
    bufnr = bufnr,
    filter = function(client)
      return client.name == "ruff"
    end,
  }
end

local function format_on_save_callback(args)
  if vim.b[args.buf].format_on_save then
    format(args.buf)
  end
end

vim.lsp.enable("ruff")
vim.lsp.config("ruff", {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = format_on_save_callback,
    })
  end,
})

vim.lsp.enable("pyright")
vim.lsp.config("pyright", {
  on_attach = function(client, bufnr)
    client.handlers["textDocument/publishDiagnostics"] = function(...) end
    vim.lsp.completion.enable(true, client.id, bufnr, {
      autotrigger = true,
      convert = function(item)
        return { abbr = item.label:gsub("%b()", "") }
      end,
    })
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "python",
  callback = function(args)
    vim.opt.tabstop = 4
    vim.opt.softtabstop = 4
    vim.opt.shiftwidth = 4
    vim.b[args.buf].format_on_save = true
  end,
})
