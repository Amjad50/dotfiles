return {
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      progress = {
        suppress_on_insert = false,
        ignore_done_already = false,
        ignore_empty_message = true,
        display = {
          render_limit = 8,
          done_ttl = 2,
          done_icon = "✓",
          progress_icon = { pattern = "dots", period = 1 },
          progress_style = "WarningMsg",
          group_style = "Title",
          icon_style = "Question",
          priority = 30,
          skip_history = true,
          overrides = { rust_analyzer = { name = "rust-analyzer" } },
        },
      },
      notification = {
        override_vim_notify = false,
        window = { winblend = 0, border = "rounded", relative = "editor" },
      },
    },
  },
}
