-- Auto install packer.nvim if not exists
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd [[packadd packer.nvim]]
-- Auto compile when there are changes in plugins.lua
vim.cmd 'autocmd BufWritePost plugins.lua PackerCompile' 

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- syntax
  use {'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function()
      require'nvim-treesitter.configs'.setup {
        ensure_installed = {"rust", "python", "vim", "lua", "glsl", "cpp"},
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
      }
    end
  }
  use {'nvim-treesitter/nvim-treesitter-context',
    config = function()
      require'treesitter-context'.setup {}
    end
  }
  -- provide current function
  use {
	"SmiteshP/nvim-gps",
	requires = "nvim-treesitter/nvim-treesitter",
    config = function()
        require'nvim-gps'.setup()
    end
  }

  -- lsp
  use 'neovim/nvim-lspconfig'
  -- auto completion
  -- use 'ms-jpq/coq_nvim'
  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-nvim-lsp-signature-help'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/cmp-vsnip'
  use 'hrsh7th/vim-vsnip'
  --use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/nvim-cmp'
  -- lsputil
  use 'RishabhRD/popfix'
  use 'RishabhRD/nvim-lsputils'
  -- symbols
  use 'simrat39/symbols-outline.nvim'
  -- fold
  use {'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async'}
  -- rust-tools
  use {
      'simrat39/rust-tools.nvim',
      requires = {'nvim-lua/plenary.nvim'}
  }
  -- lsp status
  use {
    'j-hui/fidget.nvim',
    config = function()
      require"fidget".setup{}
    end
  } 
  -- crates
  use {
    'saecki/crates.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  }
  use {'stevearc/dressing.nvim',
    config = function()
      require('dressing').setup()
    end
  }

  -- icons
  use 'kyazdani42/nvim-web-devicons'

  -- colorschemes
  use 'Mofiqul/vscode.nvim'
  
  -- statusline
  use {'NTBBloodbath/galaxyline.nvim',
    requires = { "kyazdani42/nvim-web-devicons" },
    config = function()
      --require("galaxyline.themes.spaceline")
      require("statusline")
    end
  }

  -- file explorer
  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons', -- optional, for file icon
    },
    config = function() require'nvim-tree'.setup {} end
  }

  --use 'glepnir/galaxyline.nvim'

  -- popup
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'

  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use {'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
        require('telescope').setup {
            defaults = {
                path_display = {
                    smart = {}
                }
            },
            extensions = {
                fzf = {}
            }
        }
    end
  }

  -- git
  use {'lewis6991/gitsigns.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require('gitsigns').setup {
          keymaps = {},
          current_line_blame = true,
          current_line_blame_opts = {
            virt_text = true,
            virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
            delay = 1000,
            ignore_whitespace = true,
          },
          --current_line_blame_formatter = '<abbrev_sha> <author>, <author_time:%Y-%m-%d> - <summary>',
          --update_debounce = 700,
      }
    end
  }

  -- todo
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {}
    end
  }

  -- rust
  --use {'rust-lang/rust.vim'}

  -- bufferline
  use {'akinsho/bufferline.nvim',
    tag = "v2.*",
    requires = 'kyazdani42/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup{
        options = {
          right_mouse_command = "",
          middle_mouse_command = "bdelete! %d",
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false 
        }
      }
    end
  }

  -- trouble
  use {'folke/trouble.nvim',
    requires = { {'kyazdani42/nvim-web-devicons'} },
    config = function()
      require('trouble').setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  -- copilot
  use {'github/copilot.vim'}

  -- movement
  use {'ggandor/leap.nvim',
    config = function()
      local mappings = {
          {{"n", "x", "o"}, "s",  "<Plug>(leap-forward-to)"},
          {{"n", "x", "o"}, "S",  "<Plug>(leap-backward-to)"},
          {{"x", "o"},      "m",  "<Plug>(leap-forward-till)"},
          {{"x", "o"},      "M",  "<Plug>(leap-backward-till)"},
          {{"n", "x", "o"}, ";;", "<Plug>(leap-cross-window)"}
      }
      for _, map in ipairs(mappings) do
        local modes = map[1]
        local lhs = map[2]
        local rhs = map[3]
        for _, mode in ipairs(modes) do
          if force_3f 
            or ((vim.fn.mapcheck(lhs, mode) == "")
            and (vim.fn.hasmapto(rhs, mode) == 0))
          then
            vim.keymap.set(mode, lhs, rhs, {silent = true})
          end
        end
      end
    end
  }

end)
