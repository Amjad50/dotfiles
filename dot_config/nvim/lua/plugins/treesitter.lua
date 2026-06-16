local ENSURE_INSTALLED = {
  "lua", "vim", "vimdoc", "query",
  "bash", "json", "yaml", "toml",
  "markdown", "markdown_inline",
  "html", "css", "javascript", "typescript", "tsx",
  "rust", "python", "dockerfile", "prisma", "regex",
  "nix", "go", "zig", "typst",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- The main branch does NOT support lazy-loading; it must load eagerly.
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install(ENSURE_INSTALLED)

      -- Highlighting/indent/fold are no longer toggled via a config table;
      -- they're enabled per-buffer via Neovim's built-in treesitter. Drive
      -- them off FileType so every installed parser lights up automatically.
      local group = vim.api.nvim_create_augroup("treesitter_start", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          if ft == "bigfile" then
            return
          end
          -- Only start when a parser is actually available for this filetype's
          -- language, otherwise vim.treesitter.start() errors.
          local lang = vim.treesitter.language.get_lang(ft)
          if not lang or not pcall(vim.treesitter.language.add, lang) then
            return
          end
          pcall(vim.treesitter.start, buf, lang)

          -- Treesitter-based folding (off by default in master config; opt-in here
          -- the same way — leave fold settings to the user's global opts).
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      { "<leader>ut", "<Cmd>TSContextToggle<CR>", desc = "Toggle sticky context" },
    },
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = "outer",
      mode = "cursor",
      separator = nil,
    },
    config = function(_, opts)
      require("treesitter-context").setup(opts)

      -- Click a line in the sticky-context float to jump to that definition.
      -- The context float is unfocusable, so we use getmousepos() to detect
      -- clicks landing inside it, then map the clicked display row to the
      -- corresponding context range and move the *source* window's cursor.
      local function click_context()
        local pos = vim.fn.getmousepos()
        local win = pos.winid
        -- Only act when the click landed inside a treesitter-context float.
        if win == 0 or not vim.api.nvim_win_is_valid(win) or not vim.w[win].treesitter_context then
          return "<LeftMouse>"
        end

        -- The context float is anchored to the window directly below it.
        local cfg = vim.api.nvim_win_get_config(win)
        local source_win = (cfg.relative == "win") and cfg.win or vim.api.nvim_get_current_win()
        if not source_win or not vim.api.nvim_win_is_valid(source_win) then
          return "<LeftMouse>"
        end

        local ranges = require("treesitter-context.context").get(source_win)
        if not ranges or #ranges == 0 then
          return "<LeftMouse>"
        end

        -- Map the clicked display row (1-based) to a context range, accounting
        -- for multiline contexts that span several displayed rows.
        local get_height = require("treesitter-context.util").get_range_height
        local row = pos.line -- 1-based row within the float
        local acc, target = 0, nil
        for _, r in ipairs(ranges) do
          acc = acc + get_height(r)
          if row <= acc then
            target = r
            break
          end
        end
        if not target then
          return "<LeftMouse>"
        end

        vim.api.nvim_set_current_win(source_win)
        vim.cmd("normal! m'") -- record jump for <C-o>
        vim.api.nvim_win_set_cursor(source_win, { target[1] + 1, target[2] })
        return "<Ignore>"
      end

      vim.keymap.set({ "n", "i", "v" }, "<LeftMouse>", click_context, {
        expr = true,
        replace_keycodes = true,
        desc = "Jump to clicked sticky context",
      })
    end,
  },
}
