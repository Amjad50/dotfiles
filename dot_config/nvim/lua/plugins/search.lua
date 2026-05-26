return {
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = "rounded",
        show_title = true,
        should_preview_cb = function(bufnr)
          local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
          return not (fsize > 1024 * 1024)
        end,
      },
      func_map = {
        drop      = "o",
        openc     = "O",
        split     = "<C-s>",
        vsplit    = "<C-v>",
        tab       = "t",
        tabb      = "T",
        ptogglemode = "z,",
        stoggleup = "K",
        stoggledown = "J",
        stogglevm = "<Tab>",
        filter    = "zn",
        filterr   = "zN",
        fzffilter = "zf",
      },
    },
  },

  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader><space>", function() require("fzf-lua").files() end, desc = "Find files" },
      { "<leader>/", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
      { "<leader><leader>", function() require("fzf-lua").buffers() end, desc = "Buffers" },
      { "<leader>fr", function() require("fzf-lua").oldfiles() end, desc = "Recent files" },
      { "<leader>fc", function() require("fzf-lua").commands() end, desc = "Commands" },
      { "<leader>fk", function() require("fzf-lua").keymaps() end, desc = "Keymaps" },
      { "<leader>ss", function() require("fzf-lua").lsp_document_symbols() end, desc = "Doc symbols" },
      { "<leader>sS", function() require("fzf-lua").lsp_live_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>fd", function() require("fzf-lua").diagnostics_document() end, desc = "Diagnostics (buf)" },
      { "<leader>fD", function() require("fzf-lua").diagnostics_workspace() end, desc = "Diagnostics (ws)" },
      { "<leader>fh", function() require("fzf-lua").help_tags() end, desc = "Help tags" },
      { "<leader>f/", function() require("fzf-lua").lgrep_curbuf() end, desc = "Search in buffer" },
      { "<leader>f<leader>", function() require("fzf-lua").resume() end, desc = "Resume" },
    },
    opts = function()
      local actions = require("fzf-lua.actions")
      return {
        winopts = {
          height = 0.85, width = 0.85, row = 0.5, col = 0.5,
          border = "rounded",
          preview = { layout = "flex", flip_columns = 130 },
        },
        defaults = { formatter = "path.filename_first" },
        fzf_opts = { ["--cycle"] = "" },
        keymap = {
          builtin = {
            true,
            ["<C-/>"] = "toggle-help",
            ["<C-d>"] = "preview-page-down",
            ["<C-u>"] = "preview-page-up",
          },
          fzf = {
            true,
            ["ctrl-q"] = "select-all+accept",
            ["ctrl-d"] = "preview-page-down",
            ["ctrl-u"] = "preview-page-up",
          },
        },
        actions = {
          files = {
            true,
            ["enter"]  = actions.file_edit_or_qf,
            ["ctrl-x"] = actions.file_split,
            ["ctrl-v"] = actions.file_vsplit,
            ["ctrl-t"] = actions.file_tabedit,
            ["alt-q"]  = actions.file_sel_to_qf,
            ["alt-l"]  = actions.file_sel_to_ll,
          },
        },
        files = {
          fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules --exclude target",
        },
        grep = {
          rg_opts = "--hidden --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g '!.git/' -g '!node_modules/' -g '!target/'",
        },
      }
    end,
  },
}
