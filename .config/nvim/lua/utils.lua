local utils = {}

-- helper function
function utils.kmap(mode, key, mapping, noremap, silent)
    noremap = noremap or false
    silent = silent or false
    vim.api.nvim_set_keymap(mode, key, mapping, {noremap = noremap, silent = silent})
end


return utils
