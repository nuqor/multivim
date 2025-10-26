local commands = require("multivim.cells.commands")
local highlights = require("multivim.cells.highlights")

--
-- Public
--

local M = {}

function M.send_cell()
  vim.fn["slime#store_curpos"]()
  commands.select_cell(false)
  vim.fn["slime#send_op"]("", 1)
end

function M.send_cell_and_jump_into_next()
  M.send_cell()
  commands.jump_into_next_cell()
end

function M.register(bufnr, config)
  highlights.register(bufnr)

  vim.b[bufnr].multivim_cells = config or {}

  vim.keymap.set({ "v", "o" }, "ic", function()
    commands.select_cell(false)
  end, { buffer = bufnr })

  vim.keymap.set({ "v", "o" }, "ac", function()
    commands.select_cell(true)
  end, { buffer = bufnr })

  vim.keymap.set("n", "<C-c><C-c>", M.send_cell)
  vim.keymap.set("n", "<C-c><C-n>", M.send_cell_and_jump_into_next)
  vim.keymap.set("n", "<C-c><C-j>", commands.jump_into_next_cell)
  vim.keymap.set("n", "<C-c><C-k>", commands.jump_into_previous_cell)
  vim.keymap.set("n", "<C-c><C-a>", commands.insert_cell_above)
  vim.keymap.set("n", "<C-c><C-b>", commands.insert_cell_below)
end

return M
