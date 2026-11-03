local map = vim.keymap.set

local function dismiss_duet_prediction()
  local ok, duet = pcall(require, "minuet.duet")
  if not ok then return false end
  if duet.action.is_visible() then
    duet.action.dismiss()
    return true
  end
  return false
end

map({ "n", "x" }, "<leader>w", "<Cmd>w<CR><Esc>", { desc = "Save file" })
map("n", "<leader>q", "<Cmd>confirm qa<CR>", { desc = "Quit all" })
map("i", "<Esc>", function()
  if dismiss_duet_prediction() then return end
  vim.cmd("stopinsert")
end, { desc = "Dismiss Duet prediction or exit insert mode" })
map("n", "<Esc>", function()
  if dismiss_duet_prediction() then return end
  vim.cmd("nohlsearch")
end, { desc = "Clear search / dismiss Duet prediction" })

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

map("v", "<", "<gv")
map("v", ">", ">gv")
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "<leader>xq", function()
  local qf = vim.fn.getqflist({ winid = 0 })
  if qf.winid ~= 0 then vim.cmd("cclose") else vim.cmd("botright copen") end
end, { desc = "Toggle quickfix" })
map("n", "]q", "<Cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", "<Cmd>cprev<CR>zz", { desc = "Prev quickfix" })
map("n", "]Q", "<Cmd>clast<CR>zz",  { desc = "Last quickfix" })
map("n", "[Q", "<Cmd>cfirst<CR>zz", { desc = "First quickfix" })
