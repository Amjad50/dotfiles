return {
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = "*",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<Tab>"] = {
          function(cmp)
            local ok, suggestion = pcall(require, "supermaven-nvim.completion_preview")
            if
              ok
            and suggestion.has_suggestion()
            and vim.api.nvim_buf_get_option(0, "modifiable")
            and not vim.api.nvim_buf_get_option(0, "readonly")
          then
              vim.schedule(function()
                local accept_ok, accept_err = pcall(suggestion.on_accept_suggestion)
                if not accept_ok then
                  vim.schedule(function()
                    if cmp.snippet_active() then
                      cmp.accept()
                    else
                      cmp.select_and_accept()
                    end
                  end)
                  vim.notify(
                    ("Supermaven accept failed: %s"):format(accept_err),
                    vim.log.levels.WARN,
                    { title = "Supermaven" }
                  )
                end
              end)
              return true
            end

            if cmp.snippet_active() then
              return cmp.accept()
            end
            return cmp.select_and_accept()
          end,
          "snippet_forward",
          "fallback",
        },
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
