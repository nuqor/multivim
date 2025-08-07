vim.lsp.enable("ruff")
vim.lsp.enable("pyright")

vim.lsp.config("ruff", {
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        local function format()
          vim.lsp.buf.code_action {
            context = { only = { "source.organizeImports" } },
            apply = true,
          }
          vim.wait(100)
          vim.lsp.buf.format { async = false, id = client.id }
        end
        local format_on_save = vim.b[bufnr].format_on_save
        if format_on_save == nil then
          format_on_save = true
        end
        if format_on_save then
          format()
        end
        vim.keymap.set(
          "n",
          "<leader>cf",
          format,
          { noremap = true, buffer = bufnr }
        )
      end,
    })
  end,
})

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
