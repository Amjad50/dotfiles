local M = {}

local defaults = {
  radius = 80,
  max_items = 6,
  max_message_chars = 240,
  max_chars = 1200,
}

local severity_names = {
  [vim.diagnostic.severity.ERROR] = "ERROR",
  [vim.diagnostic.severity.WARN] = "WARN",
}

local function clean(value, max_chars)
  local text = tostring(value or ""):gsub("[%c]+", " "):gsub("%s+", " ")
  text = vim.trim(text)

  if vim.fn.strchars(text) > max_chars then
    return vim.fn.strcharpart(text, 0, max_chars - 1) .. "…"
  end

  return text
end

local function cursor_row(bufnr)
  if bufnr == vim.api.nvim_get_current_buf() then
    return vim.api.nvim_win_get_cursor(0)[1] - 1
  end

  return 0
end

function M.collect(bufnr, row, options)
  options = vim.tbl_extend("force", defaults, options or {})
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  row = row or cursor_row(bufnr)

  if not vim.api.nvim_buf_is_valid(bufnr) then return {} end

  local items = {}
  for _, diagnostic in ipairs(vim.diagnostic.get(bufnr)) do
    local distance = math.abs((diagnostic.lnum or 0) - row)
    if severity_names[diagnostic.severity] and distance <= options.radius then
      table.insert(items, {
        diagnostic = diagnostic,
        distance = distance,
      })
    end
  end

  table.sort(items, function(left, right)
    if left.distance ~= right.distance then return left.distance < right.distance end

    local left_severity = left.diagnostic.severity or math.huge
    local right_severity = right.diagnostic.severity or math.huge
    if left_severity ~= right_severity then return left_severity < right_severity end

    if left.diagnostic.lnum ~= right.diagnostic.lnum then
      return left.diagnostic.lnum < right.diagnostic.lnum
    end

    return (left.diagnostic.col or 0) < (right.diagnostic.col or 0)
  end)

  local result = {}
  for index = 1, math.min(#items, options.max_items) do
    table.insert(result, items[index].diagnostic)
  end

  return result
end

local function diagnostic_line(diagnostic, options)
  local location = string.format("line %d:%d", (diagnostic.lnum or 0) + 1, (diagnostic.col or 0) + 1)
  local label = severity_names[diagnostic.severity] or "DIAGNOSTIC"
  local origin = clean(diagnostic.source, 40)
  local code = clean(diagnostic.code, 40)

  if origin ~= "" then label = label .. " " .. origin end
  if code ~= "" then label = label .. "/" .. code end

  return string.format(
    "- %s [%s] %s",
    location,
    label,
    clean(diagnostic.message, options.max_message_chars)
  )
end

function M.render(bufnr, row, options)
  options = vim.tbl_extend("force", defaults, options or {})
  local diagnostics = M.collect(bufnr, row, options)
  if #diagnostics == 0 then return "" end

  local lines = {
    "<nearby_diagnostics>",
    "Cached editor diagnostics near the cursor; use only when relevant:",
  }

  for _, diagnostic in ipairs(diagnostics) do
    local line = diagnostic_line(diagnostic, options)
    local candidate = table.concat(vim.list_extend(vim.deepcopy(lines), { line, "</nearby_diagnostics>" }), "\n")
    if vim.fn.strchars(candidate) > options.max_chars then break end
    table.insert(lines, line)
  end

  if #lines == 2 then return "" end
  table.insert(lines, "</nearby_diagnostics>")
  return table.concat(lines, "\n")
end

function M.render_commented(bufnr, row, options)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local rendered = M.render(bufnr, row, options)
  if rendered == "" then return "" end

  local commentstring = vim.bo[bufnr].commentstring
  if not commentstring or not commentstring:find("%%s") then commentstring = "# %s" end

  local commented = {}
  for line in rendered:gmatch("[^\n]+") do
    table.insert(commented, (commentstring:gsub("%%s", function() return line end, 1)))
  end

  return table.concat(commented, "\n")
end

return M
