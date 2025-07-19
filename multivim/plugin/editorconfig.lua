require("editorconfig").properties.format_on_save = function(bufnr, val)
  assert(
    val == "true" or val == "false",
    'format_on_save must be either "true" or "false"'
  )
  vim.b[bufnr].format_on_save = val == "true" and true or false
end
