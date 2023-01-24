
vim.g.mapleader = ','

if vim.g.vscode then
    require('vscode_config')
else
    require('sensible_settings')

    require('plugins')

    -- since we have statusline, we don't need vim's showmode
    vim.opt.showmode = false

    require('colors')

    -- require('statusline')

    require('lsp')

    require('keymaps')

end
