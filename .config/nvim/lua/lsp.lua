require("fidget").setup{}

-- vim.o.updatetime = 250
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.lsp.diagnostic.show_line_diagnostics({focusable=false})]]

local lspconfig = require('lspconfig')
local coq = require('coq')

vim.g.coq_settings = {["keymap.recommended"]= false}
vim.cmd [[ino <silent><expr> <CR>    pumvisible() ? (complete_info().selected == -1 ? "\<C-e><CR>" : "\<C-y>") : "\<CR>"]]

lspconfig.pyright.setup(coq.lsp_ensure_capabilities())

require('rust-tools').setup {
    server = coq.lsp_ensure_capabilities(),
}

-- format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

