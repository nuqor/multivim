local config = require("multivim.cells.config")

--
-- Public
--

local M = {}

function M.find_previous_delimiter_line(skip_self)
  assert(type(skip_self) == "boolean")

  local cell_delimiter_regex = config.get("cell_delimiter_regex")
  if not cell_delimiter_regex then
    return nil
  end

  local search_flags = skip_self and "bnW" or "bcnW"
  local line_number = vim.fn.search(cell_delimiter_regex, search_flags)
  return line_number > 0 and line_number or nil
end

function M.find_previous_delimiter_outside_cell()
  local cell_delimiter_regex = config.get("cell_delimiter_regex")
  if not cell_delimiter_regex then
    return nil
  end

  local current_cell_delimiter_line_number =
    M.find_previous_delimiter_line(false)
  if not current_cell_delimiter_line_number then
    return nil
  end

  local line_number = vim.fn.search(
    cell_delimiter_regex,
    "bnW",
    0,
    0,
    function()
      return vim.fn.line(".") == current_cell_delimiter_line_number
    end
  )
  return line_number > 0 and line_number or nil
end

function M.find_next_delimiter_line()
  local cell_delimiter_regex = config.get("cell_delimiter_regex")
  if not cell_delimiter_regex then
    return nil
  end

  local line_number = vim.fn.search(cell_delimiter_regex, "nW")
  return line_number > 0 and line_number or nil
end

function M.is_cell_empty()
  return M.find_previous_delimiter_line(false) + 1
    == M.find_next_delimiter_line()
end

function M.is_cursor_on_delimiter_line()
  return M.find_previous_delimiter_line(false) == vim.fn.line(".")
end

function M.is_cursor_inside_cell()
  return M.find_previous_delimiter_line(false) ~= nil
end

function M.is_delimiter_in_line(line_number)
  local cell_delimiter_regex = config.get("cell_delimiter_regex")
  return vim.regex(cell_delimiter_regex):match_line(0, line_number - 1) ~= nil
end

function M.find_cell_start(include_delimiter_line)
  assert(type(include_delimiter_line) == "boolean")
  local line_number = M.find_previous_delimiter_line(false)
  if not line_number then
    return 1
  end
  return include_delimiter_line and line_number or line_number + 1
end

function M.find_cell_end()
  local line_number = M.find_next_delimiter_line()
  if not line_number then
    return vim.fn.line("$")
  end
  return line_number - 1
end

function M.jump_to_previous_cell()
  local line_number = M.find_previous_delimiter_outside_cell()
  line_number = line_number or 1
  vim.fn.setpos(".", { 0, line_number, 1, 0 })
  return line_number
end

function M.jump_into_previous_cell()
  local line_number = M.jump_to_previous_cell()
  if not M.is_cursor_inside_cell() then
    return
  end
  if M.is_cell_empty() then
    vim.fn.append(line_number, { "" })
  end
  vim.fn.setpos(".", { 0, line_number + 1, 1, 0 })
end

function M.jump_to_next_cell()
  local line_number = M.find_next_delimiter_line()
  if line_number then
    vim.fn.setpos(".", { 0, line_number, 1, 0 })
  else
    vim.notify("No next cell")
  end
  return line_number
end

function M.jump_into_next_cell()
  local line_number = M.jump_to_next_cell()
  if not line_number then
    return
  end
  if M.is_cell_empty() then
    vim.fn.append(line_number, { "" })
  end
  vim.fn.setpos(".", { 0, line_number + 1, 1, 0 })
end

function M.select_cell(include_delimiter_line)
  assert(type(include_delimiter_line) == "boolean")
  local start_line_number = M.find_cell_start(include_delimiter_line)
  local end_line_number = M.find_cell_end()

  vim.fn.setpos("'<", { 0, start_line_number, 1, 0 })
  vim.fn.setpos("'>", { 0, end_line_number, 1, 0 })

  vim.cmd("normal! gv")

  if vim.fn.mode() ~= "V" then
    vim.cmd("normal! V")
  end
end

function M.insert_cell_below()
  local cell_delimiter = config.get("cell_delimiter")
  if not cell_delimiter then
    return
  end

  local cell_end_line_number = M.find_cell_end()
  vim.fn.append(cell_end_line_number, { cell_delimiter, "", "" })
  vim.fn.setpos(".", { 0, cell_end_line_number + 2, 1, 0 })
end

function M.insert_cell_above()
  local cell_delimiter = config.get("cell_delimiter")
  if not cell_delimiter then
    return
  end

  local cell_start_line_number = M.find_cell_start(true)
  local new_lines = { cell_delimiter, "", "" }
  local new_cursor_position = cell_start_line_number + 1

  if not M.find_previous_delimiter_line(false) then
    table.insert(new_lines, cell_delimiter)
  end

  vim.fn.append(cell_start_line_number - 1, new_lines)
  vim.fn.setpos(".", { 0, new_cursor_position, 1, 0 })
end

return M
