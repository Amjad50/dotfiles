local function aug(name)
  return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug("yank_highlight"),
  callback = function() vim.hl.on_yank({ timeout = 200 }) end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug("last_loc"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = aug("autosave"),
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].filetype == "bigfile" then return end
    if vim.bo[buf].buftype ~= "" then return end
    if not vim.bo[buf].modified then return end
    if vim.bo[buf].readonly then return end
    local name = vim.api.nvim_buf_get_name(buf)
    if name == "" then return end
    pcall(vim.cmd, "silent! update")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = aug("close_with_q"),
  pattern = {
    "help", "lspinfo", "man", "notify", "qf", "query", "checkhealth",
    "DiffviewFiles",
  },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<Cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
