require("fidget").setup{}
local cmp = require("cmp")

local lspconfig = require('lspconfig')

cmp.setup {
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'vsnip' },
    { name = 'crates' },
  }, {
    { name = 'buffer' },
  }),
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true
}
local capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

lspconfig.pyright.setup {
    capabilities = capabilities,
}
require('rust-tools').setup {
    server = {
        capabilities = capabilities,
    }
}
lspconfig.omnisharp.setup {
  cmd = { "/usr/bin/mono", "/usr/lib/omnisharp/OmniSharp.exe", "--languageserver" , "--hostPID", tostring(vim.fn.getpid()), "-z" };
  root_dir = lspconfig.util.root_pattern("*.sln");
}
lspconfig.clangd.setup {
  capabilities = capabilities,
}
lspconfig.julials.setup {
  capabilities = capabilities,
}

-- format on save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.formatting_sync()]]

-- enable fold
vim.o.foldcolumn = '1'
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
require('ufo').setup()

