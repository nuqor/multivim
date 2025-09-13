require("dependencies").install_mini_deps()

--
-- Leader keys
-- TODO: does work

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--
-- Keymaps
--

vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set("n", "<leader>w", "<Cmd>w<CR>", { silent = true })
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "gD", vim.lsp.buf.references)
vim.keymap.set("n", "gt", vim.lsp.buf.type_definition)
vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
-- TODO: Add keymap again
-- vim.keymap.set("n", "gd", require("telescope.builtin").lsp_definitions)

--
-- Color scheme
--

-- vim.cmd.colorscheme("catppuccin")

--
-- Global options
--

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.completeopt = "menuone,noselect,popup"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "both"
vim.opt.winborder = "rounded"

--
-- Diagnostics
-- TODO: verify
--

vim.diagnostic.config {
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ", -- Nerd Fonts: \u{ea87}
      [vim.diagnostic.severity.WARN] = " ", -- Nerd Fonts: \u{ea6c}
      [vim.diagnostic.severity.INFO] = " ", -- Nerd Fonts: \u{ea74}
      [vim.diagnostic.severity.HINT] = "󰌶 ", -- Nerd Fonts: \u{db80}\u{df36}
    },
  },
}

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "*",
  callback = function()
    vim.opt.formatoptions:remove { "o" }
  end,
})

--
-- Languages
--

require("languages.lua")
require("languages.nix")
require("languages.yaml")
require("languages.xml")
require("languages.toml")
require("languages.json")
require("languages.markdown")
require("languages.python")
require("languages.rust")
