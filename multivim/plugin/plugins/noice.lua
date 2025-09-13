require("dependencies").add {
  source = "folke/noice.nvim",
  depends = { "MunifTanjim/nui.nvim" },
}

require("noice").setup {
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    long_message_to_split = true,
    -- FIX: Does not seem to work: used vim.opt.winborder = "rounded"
    -- lsp_doc_border = true,
  },
}
