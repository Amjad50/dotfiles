return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSUpdateSync" },
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "query",
        "bash", "json", "jsonc", "yaml", "toml",
        "markdown", "markdown_inline",
        "html", "css", "javascript", "typescript", "tsx",
        "rust", "python", "dockerfile", "prisma", "regex",
        "nix", "go", "zig", "typst",
      },
      auto_install = false,
      sync_install = false,
      highlight = {
        enable = true,
        disable = function(_, buf)
          return vim.bo[buf].filetype == "bigfile"
        end,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = false },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection    = "<C-Space>",
          node_incremental  = "<C-Space>",
          node_decremental  = "<BS>",
          scope_incremental = false,
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
