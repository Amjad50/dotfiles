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
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        ["<CR>"] = {
          function(cmp)
            if cmp.snippet_active() then
              return cmp.accept()
            else
              return cmp.select_and_accept()
            end
          end,
          "snippet_forward",
          "fallback",
        },
      },
      completion = {
        trigger = {
          show_in_snippet = false,
        },
      },
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
    opts = { ensure_installed = { "zig", "go", "nix" } },
  },
  {
    "mrcjkb/rustaceanvim",
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            check = {
              command = "check",
              extraArgs = {},
            },
          },
        },
      },
    },
  },
  {
    "mason.nvim",
    opts = { ensure_installed = { "slint-lsp" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        slint_lsp = {},
      },
    },
  },
}
