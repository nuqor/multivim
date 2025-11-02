local commands = require("multivim.cells.commands")

local M = {}

-- Show fold level in statuscolumn for debugging
-- set statuscolumn=%l\ %{foldlevel(v:lnum)}

function M.foldexpr(line_number)
  if not vim.api.nvim_buf_is_loaded(0) then
    return 0
  end

  -- All lines other than one that contain a delimiter are considered
  -- as cell content and should be foldable.
  local offset = commands.is_delimiter_in_line(line_number) and 0 or 1

  -- Indent of line or, if empty, the previous nonempty line
  local indent = vim.fn.indent(vim.fn.prevnonblank(line_number))
  local indent_level = math.floor(indent / vim.fn.shiftwidth())

  return offset + indent_level
end

return M
