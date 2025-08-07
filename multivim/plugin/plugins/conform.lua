require("dependencies").add { source = "stevearc/conform.nvim" }

require("conform").setup {
  default_format_opts = {
    lsp_format = "never",
  },
}
