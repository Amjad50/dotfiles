local utils = require('utils')

-- save
utils.kmap('n', '<leader>w', ':w<CR>')

-- remove search highlight
utils.kmap('', '<C-h>', ':nohlsearch<CR>', true, true)

-- lsp navigation
utils.kmap('n', '<C-j>', ":call VSCodeNotify('editor.action.showHover')<CR>", true)
utils.kmap('n', 'cd',    ":call VSCodeNotify('editor.action.revealDefinition')<CR>", true)
-- utils.kmap('n', 'cr',    ":call vscodenotify('editor.action.referenceSearch.trigger')<CR>", true)
utils.kmap('n', 'cr',    ":call VSCodeNotify('editor.action.goToReferences')<CR>", true)

utils.kmap('n', '<leader>c',    ":call VSCodeNotify('workbench.action.gotoSymbol')<CR>", true)

-- lsp diagnostics
utils.kmap('n', '[c', ":call VSCodeNotify('editor.action.marker.next')<CR>", true, true)
utils.kmap('n', ']c', ":call VSCodeNotify('editor.action.marker.prev')<CR>", true, true)

-- lsp renaming
utils.kmap('n', '<leader>rn', ":call VSCodeNotify('editor.action.rename')<CR>", true, true)

-- lsp show actions
utils.kmap('n', '<leader>a', ":call VSCodeNotify('editor.action.quickFix')<CR>", true, true)

-- move between hunks
utils.kmap('n', ']g', ":call VSCodeNotify('workbench.action.editor.nextChange')<CR>")
utils.kmap('n', '[g', ":call VSCodeNotify('workbench.action.editor.previousChange')<CR>")

-- staging, unstaging and undoing
utils.kmap('n', 'gs', ":call VSCodeNotify('git.stageSelectedRanges')<CR>")
--utils.kmap('n', 'gu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>')
utils.kmap('n', 'gr', ":call VSCodeNotify('git.revertSelectedRanges')<CR>")

-- preview
utils.kmap('n', 'gp', ":call VSCodeNotify('workbench.action.editor.previousChange')<CR>")

-- " PLUGIN: FZF
-- utils.kmap('n', '<C-f>', '<cmd>lua require("telescope.builtin").find_files()<CR>', true, true)
-- utils.kmap('n', '<leader>st', '<cmd>lua require("telescope.builtin").git_status()<CR>', true, true)
-- utils.kmap('n', '<leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', true, true)
-- 
-- utils.kmap('n', '<leader>g', '<cmd>lua require("telescope.builtin").git_commits()<CR>', true, true)
-- utils.kmap('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', true, true)
-- 
-- utils.kmap('n', '<leader>c', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', true, true)
-- nnoremap <silent> <Leader>/ :BLines<CR>
-- 
-- nnoremap <silent> <Leader>hh :History<CR>
-- nnoremap <silent> <Leader>h: :History:<CR>
-- nnoremap <silent> <Leader>h/ :History/<CR>
-- 
-- nnoremap <silent> <Leader>M :Maps<CR>
-- nnoremap <silent> <Leader>H :Helptags<CR>
-- 
-- nnoremap <silent> <Leader>c :Vista finder<CR>

-- search results centered
utils.kmap('n', 'n',  'nzz', true, true)
utils.kmap('n', 'N',  'Nzz', true, true)
utils.kmap('n', '*',  '*zz', true, true)
utils.kmap('n', '#',  '#zz', true, true)
utils.kmap('n', 'g*', 'g*zz', true, true)
