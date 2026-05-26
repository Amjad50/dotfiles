return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-mini/mini.nvim",
    },
    keys = {
      { "<leader>e",  "<Cmd>Neotree toggle reveal<CR>",                       desc = "Explorer (toggle, reveal current file)" },
      { "<leader>E",  "<Cmd>Neotree toggle dir=%:p:h<CR>",                    desc = "Explorer (toggle, current file dir)" },
      { "<leader>fe", "<Cmd>Neotree focus<CR>",                               desc = "Focus explorer" },
      { "<leader>ge", "<Cmd>Neotree git_status reveal toggle<CR>",            desc = "Git explorer" },
      { "<leader>be", "<Cmd>Neotree buffers reveal toggle<CR>",               desc = "Buffer explorer" },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("neotree_start", { clear = true }),
        desc = "Open neo-tree when nvim starts on a directory",
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if vim.fn.isdirectory(bufname) ~= 1 then return end
          vim.api.nvim_del_augroup_by_name("neotree_start")
          require("neo-tree")
          vim.schedule(function()
            require("neo-tree.command").execute({ action = "show", dir = bufname })
          end)
        end,
      })
    end,
    opts = {
      sources = { "filesystem", "buffers", "git_status" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = false,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = { ".git", "node_modules" },
        },
      },
      window = {
        position = "left",
        width = 32,
        mappings = {
          ["l"]     = "open",
          ["h"]     = "close_node",
          ["<CR>"]  = "open",
          ["<Esc>"] = "cancel",
          ["o"]     = "open",
          ["P"]     = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
          ["Y"]     = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path, "c")
            vim.notify("Copied: " .. path)
          end,
          ["O"]     = function(state)
            local node = state.tree:get_node()
            vim.fn.jobstart({ "xdg-open", node.path }, { detach = true })
          end,
          ["<Space>"] = "none",
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            added     = "",
            modified  = "",
            deleted   = "",
            renamed   = "󰁕",
            untracked = "",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      },
    },
  },
}
