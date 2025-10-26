local config = require("multivim.cells.config")

-- Constants
local cell_header_hl = "MultivimCellHeader"
local cell_header_hl_base = "SpecialComment"
local cell_sign_name = "MultivimCellName"
local cell_sign_group = "MultivimCellGroup"

-- Create a new highlight group `cell_header_hl` where the foreground
-- color is taken from the `cell_header_hl_base` highlight group.
vim.api.nvim_set_hl(0, cell_header_hl, {
  underline = true,
  fg = vim.fn.synIDattr(
    vim.fn.synIDtrans(vim.fn.hlID(cell_header_hl_base)),
    "fg"
  ),
})

-- Define a new sign with name `cell_sign_name`
vim.fn.sign_define(cell_sign_name, { linehl = cell_header_hl })

-- Iterate over all lines in a buffer and place a sign at every line
-- that matches the cell delimiter regex
local function place_signs_at_cell_delimiter_lines(bufnr)
  local cell_delimiter_regex = config.get("cell_delimiter_regex")
  vim.fn.sign_unplace(cell_sign_group, { buffer = bufnr })
  for lnum = 1, vim.fn.line("$") do
    if vim.regex(cell_delimiter_regex):match_line(bufnr, lnum - 1) then
      vim.fn.sign_place(
        0,
        cell_sign_group,
        cell_sign_name,
        bufnr,
        { lnum = lnum }
      )
    end
  end
end

--
-- Public
--

local M = {}

-- Register buffer-local autocommands for which signs are placed
function M.register(bufnr)
  vim.api.nvim_create_autocmd({
    "TextChanged",
    "TextChangedI",
    "TextChangedP",
    "BufWinEnter",
    "BufWritePost",
    "FileWritePost",
    "BufEnter",
  }, {
    buffer = bufnr,
    callback = function(args)
      place_signs_at_cell_delimiter_lines(args.buf)
    end,
  })
end

return M
