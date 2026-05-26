local opt = vim.opt

opt.clipboard = ""
vim.g.autoformat = false

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.termguicolors = true
opt.showmode = false
opt.laststatus = 3
opt.cmdheight = 1
opt.pumheight = 12
opt.pumblend = 0
opt.winblend = 0
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.fillchars = { eob = " ", fold = " ", diff = "╱" }

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.shiftround = true

opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep --no-heading --smart-case"
opt.grepformat = "%f:%l:%c:%m"

opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false
opt.writebackup = false
opt.confirm = true

opt.updatetime = 2000
opt.timeoutlen = 400
opt.ttimeoutlen = 10

opt.foldenable = false
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.completeopt = "menu,menuone,noselect"
opt.shortmess:append("WIcC")
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

opt.mouse = "a"
opt.virtualedit = "block"

vim.g.markdown_recommended_style = 0
