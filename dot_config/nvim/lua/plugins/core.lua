return {
  {
    "ThePrimeagen/99",
    event = "VeryLazy", -- or "BufReadPost" if you want it earlier
    opts = {
      config = function()
        local _99 = require("99")

        local cwd = vim.uv.cwd()
        local basename = vim.fs.basename(cwd)

        _99.setup({
          logger = {
            level = _99.DEBUG,
            path = "/tmp/" .. basename .. ".99.debug",
            print_on_error = true,
          },

          completion = {
            custom_rules = {
              "scratch/custom_rules/",
            },
            source = "cmp",
          },

          md_files = {
            "AGENT.md",
          },
        })
      end,
    },
    keys = {
      {
        "<leader>9f",
        function()
          require("99").fill_in_function()
        end,
        mode = "n",
        desc = "99: Fill in function",
      },
      {
        "<leader>9v",
        function()
          require("99").visual()
        end,
        mode = "v",
        desc = "99: Visual request",
      },
      {
        "<leader>9s",
        function()
          require("99").stop_all_requests()
        end,
        mode = "v",
        desc = "99: Stop all requests",
      },
      {
        "<leader>9fd",
        function()
          require("99").fill_in_function()
        end,
        mode = "n",
        desc = "99: Fill in function (debug)",
      },
    },
  },
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
