return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  {
    "snacks.nvim",
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
        virt_text_priority = 100,
        use_focus = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        middle_mouse_command = function(n)
          Snacks.bufdelete(n)
        end,
        always_show_bufferline = true,
      },
    },
  },
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron", "zig", "go", "nix" } },
  },
}
