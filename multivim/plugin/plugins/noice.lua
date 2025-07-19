require("noice").setup {
  -- notify = { enabled = false },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    long_message_to_split = true,
    lsp_doc_border = true,
  },
}
