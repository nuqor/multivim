require("dependencies").add {
  source = "nvim-telescope/telescope.nvim",
  depends = {
    "nvim-lua/plenary.nvim",
    -- "nvim-telescope/telescope-fzf-native.nvim",
  },
}

-- require("dependencies").add {
--   source = "nvim-telescope/telescope-fzf-native.nvim",
--   hooks = {
--     post_checkout = function()
--       vim.cmd("build")
--     end,
--   },
-- }

local telescope = require("telescope")

telescope.setup {}

-- telescope.load_extension("fzf")

vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
