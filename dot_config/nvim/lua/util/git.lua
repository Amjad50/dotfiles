local M = {}

function M.branch_completion(arglead)
  local out = vim.fn.systemlist("git branch --all --format='%(refname:short)' 2>/dev/null")
  local result = {}
  for _, b in ipairs(out) do
    b = b:gsub("^origin/", "")
    if b ~= "" and (arglead == "" or b:lower():find(arglead:lower(), 1, true)) then
      table.insert(result, b)
    end
  end
  return result
end

return M
