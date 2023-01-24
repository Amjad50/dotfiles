
-- set colorscheme
-- vim.g.vscode_style = "dark"
--  vim.cmd 'colorscheme vscode'

-- set transparent
-- require('transparent').setup{enable = true}

vim.o.background = "dark"

local c = require('vscode.colors')
require('vscode').setup({
    -- Enable transparent background
    transparent = true,

    -- Enable italic comment
    italic_comments = true,

    -- Disable nvim-tree background color
    disable_nvimtree_bg = true,

    -- Override colors (see ./lua/vscode/colors.lua)
    color_overrides = {
        vscLineNumber = '#eeeeee',
    },

    -- Override highlight groups (see ./lua/vscode/theme.lua)
    group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
    }
})

vim.api.nvim_set_hl(0, 'NonText', { fg = '#808080', bg = c.vscNone })
