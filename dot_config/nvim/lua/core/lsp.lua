local M = {}

vim.diagnostic.config({
  severity_sort = true,
  underline = true,
  update_in_insert = false,
  virtual_text = {
    prefix = "●",
    spacing = 2,
    source = "if_many",
  },
  float = { border = "rounded", source = "if_many" },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "E",
      [vim.diagnostic.severity.WARN]  = "W",
      [vim.diagnostic.severity.INFO]  = "I",
      [vim.diagnostic.severity.HINT]  = "H",
    },
  },
})

M.servers = {
  rust_analyzer = {},
  ts_ls = {},
  clangd = {},
  jsonls = {},
  yamlls = {},
  taplo = {},
  dockerls = {},
  tailwindcss = {},
  prismals = {},
  marksman = {},
  nil_ls = {},
  nixd = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        diagnostics = { globals = { "vim" } },
        telemetry = { enable = false },
        hint = { enable = false },
      },
    },
  },
  gopls = {},
  zls = {},
  tinymist = {},
  slint_lsp = {},
  pyrefly = {},
}

local function first_executable(candidates)
  for _, c in ipairs(candidates) do
    if vim.fn.executable(c) == 1 then return c end
  end
  return nil
end

local cmd_fallbacks = {
  ts_ls       = { "typescript-language-server" },
  jsonls      = { "vscode-json-language-server", "vscode-json-languageserver" },
  yamlls      = { "yaml-language-server" },
  tailwindcss = { "tailwindcss-language-server" },
  dockerls    = { "docker-langserver", "docker-language-server" },
  prismals    = { "prisma-language-server" },
  lua_ls      = { "lua-language-server" },
  nil_ls      = { "nil" },
  slint_lsp   = { "slint-lsp" },
  tinymist    = { "tinymist" },
}

function M.binary_for(name)
  local ok, cfg = pcall(function() return vim.lsp.config[name] end)
  if ok and cfg and cfg.cmd and type(cfg.cmd) ~= "function" then
    return cfg.cmd[1]
  end
  return cmd_fallbacks[name] and cmd_fallbacks[name][1] or nil
end

function M.find_executable(name)
  local ok, cfg = pcall(function() return vim.lsp.config[name] end)
  if ok and cfg and cfg.cmd and type(cfg.cmd) ~= "function" then
    return vim.fn.executable(cfg.cmd[1]) == 1 and cfg.cmd[1] or nil
  end
  return first_executable(cmd_fallbacks[name] or {})
end

function M.enable_available()
  local enabled, skipped = {}, {}
  for name, opts in pairs(M.servers) do
    pcall(vim.lsp.config, name, opts)
    if M.find_executable(name) then
      table.insert(enabled, name)
    else
      table.insert(skipped, { name = name, bin = M.binary_for(name) })
    end
  end
  if #enabled > 0 then vim.lsp.enable(enabled) end
  vim.g.lsp_enabled_servers = enabled
  vim.g.lsp_skipped_servers = skipped
end

vim.api.nvim_create_user_command("LspStatus", function()
  local lines = { "Enabled servers:" }
  for _, n in ipairs(vim.g.lsp_enabled_servers or {}) do
    table.insert(lines, "  ✓ " .. n)
  end
  table.insert(lines, "")
  table.insert(lines, "Skipped (binary missing):")
  for _, s in ipairs(vim.g.lsp_skipped_servers or {}) do
    table.insert(lines, "  ✗ " .. s.name .. (s.bin and " (need: " .. s.bin .. ")" or ""))
  end
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, {})

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local buf = args.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
    end

    map("n", "gd", vim.lsp.buf.definition, "Goto def")
    map("n", "gD", vim.lsp.buf.declaration, "Goto decl")
    map("n", "gI", vim.lsp.buf.implementation, "Goto impl")
    map("n", "gy", vim.lsp.buf.type_definition, "Goto type")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "gr", function()
      local ok, fzf = pcall(require, "fzf-lua")
      if ok then fzf.lsp_references() else vim.lsp.buf.references() end
    end, "References")
    map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
    map("n", "<leader>cd", vim.diagnostic.open_float, "Diagnostic float")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count =  1 }) end, "Next diagnostic")
    map("n", "<leader>uh", function()
      local on = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
      vim.lsp.inlay_hint.enable(not on, { bufnr = buf })
    end, "Toggle inlay hints")
  end,
})

return M
