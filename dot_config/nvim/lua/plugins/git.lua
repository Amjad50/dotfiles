return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
        untracked    = { text = "▎" },
      },
      signs_staged_enable = true,
      current_line_blame = false,
      attach_to_untracked = true,
      worktrees = nil,
      on_attach = function(buf)
        if vim.bo[buf].filetype == "bigfile" then return false end
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
        end

        map("n", "]g", function()
          if vim.wo.diff then vim.cmd.normal({ "]c", bang = true }) else gs.nav_hunk("next") end
        end, "Next hunk")
        map("n", "[g", function()
          if vim.wo.diff then vim.cmd.normal({ "[c", bang = true }) else gs.nav_hunk("prev") end
        end, "Prev hunk")

        map("n", "<leader>gs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>gu", gs.undo_stage_hunk, "Undo stage hunk")
        map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>gp", gs.preview_hunk, "Preview hunk")
        map("n", "<leader>gb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>gB", gs.toggle_current_line_blame, "Toggle line blame")

        map("v", "<leader>gs", function()
          gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Stage selection")
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, "Reset selection")
      end,
    },
  },

  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewToggleFiles", "DiffviewRefresh" },
    dependencies = { "nvim-mini/mini.nvim" },
    keys = {
      { "<leader>gd", "<Cmd>DiffviewOpen<CR>", desc = "Diffview working tree" },
      { "<leader>gD", "<Cmd>DiffviewOpen --staged<CR>", desc = "Diffview staged" },
      { "<leader>gq", "<Cmd>DiffviewClose<CR>", desc = "Close diffview" },
      { "<leader>gH", "<Cmd>DiffviewFileHistory %<CR>", desc = "File history" },
      {
        "<leader>gh",
        function()
          local base = vim.fn.input({
            prompt = "Diff against branch: ",
            default = "main",
            completion = "customlist,v:lua.require'util.git'.branch_completion",
          })
          if base == nil or base == "" then return end
          vim.cmd("DiffviewOpen " .. base .. "...HEAD")
        end,
        desc = "Diffview branch review",
      },
    },
    opts = {
      enhanced_diff_hl = true,
      view = {
        default = { layout = "diff2_horizontal" },
        merge_tool = { layout = "diff3_horizontal" },
      },
      keymaps = {
        view = {
          { "n", "?", "<Cmd>h diffview-maps-view<CR>", { desc = "Help" } },
        },
        file_panel = {
          { "n", "?", "<Cmd>h diffview-maps-file-panel<CR>", { desc = "Help" } },
        },
      },
    },
    config = function(_, opts)
      require("diffview").setup(opts)

      local group = vim.api.nvim_create_augroup("user_diffview_scrollsync", { clear = true })

      local function map_mouse(buf)
        local function k(lhs, count, key)
          vim.keymap.set("n", lhs, count .. "<C-" .. key .. ">", { buffer = buf, silent = true, remap = false })
        end
        k("<ScrollWheelDown>", 3, "e")
        k("<ScrollWheelUp>",   3, "y")
        k("<S-ScrollWheelDown>", 10, "e")
        k("<S-ScrollWheelUp>",   10, "y")
      end

      vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
        group = group,
        callback = function(args)
          if vim.wo.diff then
            vim.wo.scrollbind = true
            vim.wo.cursorbind = true
            map_mouse(args.buf)
          end
        end,
      })
    end,
  },
}
