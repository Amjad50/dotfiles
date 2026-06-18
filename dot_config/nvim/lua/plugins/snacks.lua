return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile     = { enabled = true, notify = false, size = 1.5 * 1024 * 1024 },
      quickfile   = { enabled = true },
      statuscolumn = { enabled = true },
      input       = { enabled = true },
      notifier    = { enabled = true, timeout = 3000, style = "compact" },
      words       = { enabled = true, debounce = 200 },
      bufdelete   = { enabled = true },
      rename      = { enabled = true },
      toggle      = { enabled = true },
      gitbrowse   = { enabled = true },
      indent      = {
        enabled = true,
        indent  = { char = "│", only_scope = false, only_current = false },
        scope   = { enabled = true, char = "│", underline = false, animate = { enabled = false } },
        animate = { enabled = false },
      },
      lazygit     = {
        configure = true,
        win = { width = 0, height = 0, border = false, backdrop = false },
        config = {
          gui = {
            screenMode = "normal",
            sidePanelWidth = 0.25,
            theme = {
              unstagedChangesColor = { "red" },
            },
          },
          git = {
            paging = {
              colorArg     = "always",
              pager        = "delta --paging=never --line-numbers --hyperlinks --hyperlinks-file-link-format=\"lazygit-edit://{path}:{line}\"",
              useConfig    = false,
            },
          },
        },
      },
    },
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end,           desc = "Lazygit" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,  desc = "Lazygit (file history)" },
      { "<leader>gl", function() Snacks.lazygit.log() end,       desc = "Lazygit log (cwd)" },
      { "<leader>gO", function() Snacks.gitbrowse() end,         desc = "Git: open in browser",        mode = { "n", "v" } },
      { "<leader>bd", function() Snacks.bufdelete() end,         desc = "Delete buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end,   desc = "Delete other buffers" },
      { "<leader>rN", function() Snacks.rename.rename_file() end, desc = "Rename file (LSP-aware)" },
      { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "<leader>un", function() Snacks.notifier.hide() end,     desc = "Dismiss notifications" },
      { "]]",         function() Snacks.words.jump(vim.v.count1) end,  desc = "Next reference",     mode = { "n", "t" } },
      { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference",     mode = { "n", "t" } },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.option("wrap",           { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("spell",          { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("conceallevel",   { off = 0, on = 2, name = "Conceal" }):map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.indent():map("<leader>ui")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
