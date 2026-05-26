return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      no_italic = false,
      term_colors = true,
      integrations = {
        gitsigns = true,
        treesitter = true,
        mini = { enabled = true },
        blink_cmp = true,
        fzf = true,
        diffview = true,
        which_key = true,
        native_lsp = { enabled = true },
      },
    },
  },

  {
    "nvim-mini/mini.nvim",
    event = "VeryLazy",
    config = function()
      require("mini.icons").setup()
      require("mini.icons").mock_nvim_web_devicons()

      require("mini.surround").setup()
      require("mini.pairs").setup()
      require("mini.comment").setup()

      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer",    i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
        },
      })

      require("mini.bracketed").setup({
        buffer     = { suffix = "b", options = {} },
        comment    = { suffix = "c", options = {} },
        conflict   = { suffix = "x", options = {} },
        diagnostic = { suffix = "",  options = {} },
        file       = { suffix = "f", options = {} },
        indent     = { suffix = "i", options = {} },
        jump       = { suffix = "j", options = {} },
        location   = { suffix = "l", options = {} },
        oldfile    = { suffix = "o", options = {} },
        quickfix   = { suffix = "q", options = {} },
        treesitter = { suffix = "t", options = {} },
        undo       = { suffix = "u", options = {} },
        window     = { suffix = "w", options = {} },
        yank       = { suffix = "y", options = {} },
      })

      local hi = require("mini.hipatterns")
      hi.setup({
        highlighters = {
          fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
          hack  = { pattern = "%f[%w]()HACK()%f[%W]",  group = "MiniHipatternsHack" },
          todo  = { pattern = "%f[%w]()TODO()%f[%W]",  group = "MiniHipatternsTodo" },
          note  = { pattern = "%f[%w]()NOTE()%f[%W]",  group = "MiniHipatternsNote" },
          hex_color = hi.gen_highlighter.hex_color(),
        },
      })

      require("mini.splitjoin").setup({ mappings = { toggle = "gS" } })

      local statusline = require("mini.statusline")
      statusline.setup({
        use_icons = true,
        content = {
          active = function()
            local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
            local git           = statusline.section_git({ trunc_width = 75 })
            local diff          = statusline.section_diff({ trunc_width = 75 })
            local diagnostics   = statusline.section_diagnostics({ trunc_width = 75 })
            local lsp           = ""
            if vim.api.nvim_win_get_width(0) > 75 then
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients > 0 then
                local names = {}
                for _, c in ipairs(clients) do table.insert(names, c.name) end
                lsp = " " .. table.concat(names, ",")
              end
            end
            local filename      = statusline.section_filename({ trunc_width = 140 })
            local fileinfo      = statusline.section_fileinfo({ trunc_width = 120 })
            local location      = "%2l:%-2v"
            return statusline.combine_groups({
              { hl = mode_hl,                  strings = { mode } },
              { hl = "MiniStatuslineDevinfo",  strings = { git, diff, diagnostics, lsp } },
              "%<",
              { hl = "MiniStatuslineFilename", strings = { filename } },
              "%=",
              { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
              { hl = mode_hl,                  strings = { location } },
            })
          end,
        },
      })
    end,
  },

  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-mini/mini.nvim" },
    keys = {
      { "<S-h>",      "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "<S-l>",      "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "[b",         "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
      { "]b",         "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Pin buffer" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Close non-pinned" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Close buffers to right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>",  desc = "Close buffers to left" },
      { "<leader>1",  "<Cmd>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
      { "<leader>2",  "<Cmd>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
      { "<leader>3",  "<Cmd>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
      { "<leader>4",  "<Cmd>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
      { "<leader>5",  "<Cmd>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
      { "<leader>6",  "<Cmd>BufferLineGoToBuffer 6<CR>", desc = "Buffer 6" },
      { "<leader>7",  "<Cmd>BufferLineGoToBuffer 7<CR>", desc = "Buffer 7" },
      { "<leader>8",  "<Cmd>BufferLineGoToBuffer 8<CR>", desc = "Buffer 8" },
      { "<leader>9",  "<Cmd>BufferLineGoToBuffer 9<CR>", desc = "Buffer 9" },
    },
    opts = {
      options = {
        mode = "buffers",
        always_show_bufferline = true,
        show_close_icon = false,
        show_buffer_close_icons = true,
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diag)
          local icons = { error = " ", warning = " ", info = " " }
          local ret = (diag.error and icons.error .. diag.error .. " " or "")
                   .. (diag.warning and icons.warning .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          { filetype = "neo-tree",       text = "Explorer", text_align = "left", separator = true },
          { filetype = "DiffviewFiles",  text = "Diffview", text_align = "left", separator = true },
        },
        middle_mouse_command = "bdelete! %d",
        separator_style = "slant",
      },
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps (which-key)" },
    },
    opts = {
      preset = "helix",
      delay = 300,
      icons = { mappings = true, rules = false },
      win = { border = "rounded" },
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>l", group = "lsp/mason" },
        { "<leader>r", group = "rename" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>x", group = "diagnostics/qf" },
        { "[",         group = "prev" },
        { "]",         group = "next" },
      },
    },
  },
}
