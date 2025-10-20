require("dependencies").add { source = "rebelot/kanagawa.nvim" }

require("kanagawa").setup {
  theme = "wave",
  colors = {
    theme = {
      all = {
        ui = {
          bg_gutter = "none",
        },
      },
    },
  },
}
