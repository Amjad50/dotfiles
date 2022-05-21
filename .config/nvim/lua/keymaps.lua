local utils = require('utils')

-- disable arrows
utils.kmap('i', '<up>', '<nop>', true)
utils.kmap('i', '<down>', '<nop>', true)
utils.kmap('i', '<left>', '<nop>', true)
utils.kmap('i', '<right>', '<nop>', true)
utils.kmap('n', '<up>', '<nop>', true)
utils.kmap('n', '<down>', '<nop>', true)
utils.kmap('n', '<left>', '<nop>', true)
utils.kmap('n', '<right>', '<nop>', true)

-- switch between tabs
-- TODO:
utils.kmap('', '<C-PageDown>', ':BufferLineCycleNext<CR>', true, true)
utils.kmap('', '<C-PageUp>', ':BufferLineCyclePrev<CR>', true, true)
-- " Switch between tabs
-- noremap <silent> <C-PageDown> :BufferNext<CR>
-- noremap <silent> <C-PageUp> :BufferPrevious<CR>
-- 
-- " Move/order tabs around
-- noremap <silent> <A-PageDown> :BufferMoveNext<CR>
-- noremap <silent> <A-PageUp> :BufferMovePrevious<CR>
utils.kmap('', '<A-PageDown>', ':BufferLineMoveNext<CR>', true, true)
utils.kmap('', '<A-PageUp>', ':BufferLineMovePrev<CR>', true, true)

-- Switch between buffers
utils.kmap('', '<C-Right>', ':bn<CR>', true)
utils.kmap('', '<C-Left>', ':bp<CR>', true)

-- remove search highlight
utils.kmap('', '<C-h>', ':nohlsearch<CR>', true, true)

-- lsp navigation
utils.kmap('n', 'cd',    '<cmd>lua require("telescope.builtin").lsp_definitions()<CR>', true, true)
utils.kmap('n', '<C-j>', '<cmd>lua vim.lsp.buf.hover()<CR>', true, true)
utils.kmap('n', 'ci',    '<cmd>lua require("telescope.builtin").lsp_implementations()<CR>', true, true)
utils.kmap('n', 'cy',    '<cmd>lua require("telescope.builtin").type_definition()<CR>', true, true)
utils.kmap('n', 'cr',    '<cmd>lua require("telescope.builtin").lsp_references()<CR>', true, true)

-- lsp diagnostics
utils.kmap('n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', true, true)
utils.kmap('n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', true, true)

-- lsp renaming
utils.kmap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', true, true)

-- lsp show actions
utils.kmap('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>', true, true)

-- ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
-- ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},
-- nmap ]g <Plug>(GitGutterNextHunk)
-- nmap [g <Plug>(GitGutterPrevHunk)
-- move between hunks
utils.kmap('n', ']g', '<cmd>lua require"gitsigns.actions".next_hunk()<CR>')
utils.kmap('n', '[g', '<cmd>lua require"gitsigns.actions".prev_hunk()<CR>')

-- staging, unstaging and undoing
utils.kmap('n', 'gs', '<cmd>lua require"gitsigns".stage_hunk()<CR>')
utils.kmap('v', 'gs', '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>')
utils.kmap('n', 'gu', '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>')
utils.kmap('n', 'gr', '<cmd>lua require"gitsigns".reset_hunk()<CR>')
utils.kmap('v', 'gr', '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>')

-- preview
utils.kmap('n', 'gp', '<cmd>lua require"gitsigns".preview_hunk()<CR>')

-- nmap gu <Plug>(GitGutterUndoHunk)
-- ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
-- ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
-- ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
-- ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

-- Text objects
-- ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
-- ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
-- " GitGutter maps: main char 'g'
-- 
-- " PLUGIN: FZF
utils.kmap('n', '<C-f>', '<cmd>lua require("telescope.builtin").find_files()<CR>', true, true)
utils.kmap('n', '<leader>st', '<cmd>lua require("telescope.builtin").git_status()<CR>', true, true)
utils.kmap('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>', true, true)
utils.kmap('n', '<leader>f', '<cmd>lua require("telescope.builtin").live_grep()<CR>', true, true)

utils.kmap('n', '<leader>g', '<cmd>lua require("telescope.builtin").git_commits()<CR>', true, true)
utils.kmap('n', '<leader>gb', '<cmd>lua require("telescope.builtin").git_bcommits()<CR>', true, true)

utils.kmap('n', '<leader>c', '<cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', true, true)
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

-- save
utils.kmap('n', '<leader>w', ':w<CR>')

-- search results centered
utils.kmap('n', 'n',  'nzz', true, true)
utils.kmap('n', 'N',  'Nzz', true, true)
utils.kmap('n', '*',  '*zz', true, true)
utils.kmap('n', '#',  '#zz', true, true)
utils.kmap('n', 'g*', 'g*zz', true, true)
