require("dependencies").add {
  source = "saghen/blink.cmp",
  checkout = "v1.7.0",
  depends = { "rafamadriz/friendly-snippets" },
}

require("blink.cmp").setup {
  completion = {
    menu = {
      border = "rounded",
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
          { "source_name" },
        },
        components = {
          source_name = {
            text = function(ctx)
              return "[" .. ctx.source_name .. "]"
            end,
          },
        },
        treesitter = { "lsp" },
      },
    },
  },
}
