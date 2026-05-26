return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_and_accept()
            end
          end,
          "fallback",
        },
      },
      enabled = function()
        return vim.bo.filetype ~= "bigfile" and vim.bo.buftype ~= "prompt"
      end,
      completion = {
        trigger = { show_in_snippet = false },
        list = { selection = { preselect = true, auto_insert = false } },
        menu = { border = "rounded", auto_show = true },
        documentation = { auto_show = true, auto_show_delay_ms = 250, window = { border = "rounded" } },
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "buffer" },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
  },
}
