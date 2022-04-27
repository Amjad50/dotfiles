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



-- Enable diagnostics
--vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
--  vim.lsp.diagnostic.on_publish_diagnostics, {
--    virtual_text = true,
--    signs = true,
--    underline = true,
--    update_in_insert = true,
--  }
--)

-- lsputils handlers
--vim.lsp.handlers['textDocument/codeAction'] = require'lsputil.codeAction'.code_action_handler
--vim.lsp.handlers['textDocument/references'] = require'lsputil.locations'.references_handler
--vim.lsp.handlers['textDocument/definition'] = require'lsputil.locations'.definition_handler
--vim.lsp.handlers['textDocument/declaration'] = require'lsputil.locations'.declaration_handler
--vim.lsp.handlers['textDocument/typeDefinition'] = require'lsputil.locations'.typeDefinition_handler
--vim.lsp.handlers['textDocument/implementation'] = require'lsputil.locations'.implementation_handler
--vim.lsp.handlers['textDocument/documentSymbol'] = require'lsputil.symbols'.document_handler
--vim.lsp.handlers['workspace/symbol'] = require'lsputil.symbols'.workspace_handler
