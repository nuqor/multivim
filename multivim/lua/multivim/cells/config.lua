function get_config()
  return vim.tbl_extend(
    "force",
    vim.g.multivim_cells or {},
    vim.b[0].multivim_cells or {}
  )
end

--
-- Public
--

local M = {}

function M.get(key)
  local value = get_config()[key]
  if not value then
    vim.notify(key .. " not defined", vim.log.levels.ERROR)
  end
  return value
end

return M
