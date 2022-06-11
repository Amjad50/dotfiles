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
  use 'ms-jpq/coq_nvim'
  -- lsputil
  use 'RishabhRD/popfix'
  use 'RishabhRD/nvim-lsputils'
  -- symbols
  use 'simrat39/symbols-outline.nvim'
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
  -- use 'christianchiarulli/nvcode-color-schemes.vim'
  -- use 'Th3Whit3Wolf/one-nvim'
  use 'xiyaowong/nvim-transparent'

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
          diagnostics_update_in_insert = true
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

  use {'github/copilot.vim'}

end)
