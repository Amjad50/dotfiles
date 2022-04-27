
vim.opt.encoding = 'utf-8'

-- use gui colors (24 bits)
vim.opt.termguicolors = true

-- numbering
vim.opt.number = true
vim.opt.relativenumber = true

-- tabs stuff
local tabsize = 4
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.shiftwidth = tabsize
vim.opt.tabstop = tabsize
vim.opt.softtabstop = tabsize

-- search and subtitute
vim.opt.incsearch = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.gdefault = true

-- splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- completion
vim.opt.completeopt = 'menuone,noinsert,noselect'

-- signcolumn
vim.opt.signcolumn = 'yes'
vim.cmd 'hi SignColumn ctermbg=NONE guibg=NONE'

-- hover window
vim.cmd 'hi Pmenu ctermbg=gray guibg=Gray'

-- wildmenu
vim.opt.wildmenu = true
-- vim.opt.wildmode (test these modes)

-- clipboard (might change?)
-- for this to work you need to have some tools installed for clipboard support, check (:h clipboard)
vim.opt.clipboard = ''

-- faster updates
vim.opt.updatetime = 200

vim.opt.listchars = 'nbsp:¬,extends:»,precedes:«,trail:•'

vim.opt.colorcolumn = '80'

vim.opt.mouse = 'a'

vim.cmd 'syntax on'

-- netrw tree style
vim.g.netrw_liststyle=3
vim.g.netrw_browse_split=3
vim.g.netrw_preview=1
vim.g.netrw_alto=0
vim.g.netrw_banner=0

-- enable spelling by default for git commit message editing
vim.cmd 'autocmd FileType gitcommit :set spell'
