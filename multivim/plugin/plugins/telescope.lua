local telescope = require("telescope")

telescope.setup {}

telescope.load_extension("fzf")

vim.keymap.set("n", "<C-p>", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers)
vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags)
