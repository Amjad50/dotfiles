return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>li", "<Cmd>LspStatus<CR>",       desc = "LSP: enabled/skipped servers" },
      { "<leader>lI", "<Cmd>checkhealth lsp<CR>", desc = "LSP: full health report" },
      { "<leader>lr", function()
          for _, c in ipairs(vim.lsp.get_clients()) do vim.lsp.stop_client(c.id, true) end
          vim.cmd("edit")
          vim.notify("LSP restarted", vim.log.levels.INFO)
        end, desc = "LSP: restart all clients" },
      { "<leader>lL", "<Cmd>LspLog<CR>",          desc = "LSP: open log" },
    },
    config = function()
      require("core.lsp").enable_available()
    end,
  },

  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog", "MasonUpdate" },
    keys = {
      { "<leader>lm", "<Cmd>Mason<CR>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts = {
      ui = { border = "rounded" },
      max_concurrent_installers = 4,
    },
  },
}
