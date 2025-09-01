require("dependencies").add { source = "nvim-lualine/lualine.nvim" }

require("lualine").setup {
  options = {
    disabled_filetypes = {
      statusline = { "neo-tree" },
    },
  },
  sections = {
    lualine_x = {
      {
        require("noice").api.status.mode.get,
        cond = require("noice").api.status.mode.has,
        color = { fg = "#f5a97f" },
      },
      "encoding",
      "fileformat",
      "filetype",
    },
  },
}
