local M = {}

local config = {
  debounce = 450,
  ignore_filetypes = {},
}

local generations = {}
local request_pending = false
local request_bufnr
local request_generation = 0
local request_started_tick = {}
local queued_after_request = {}
local last_auto_requested_tick = {}
local applied_changedtick = {}
local configured = false

local function ignored_filetype(filetype)
  return vim.tbl_contains(config.ignore_filetypes, filetype)
end

local function eligible(bufnr)
  return vim.api.nvim_buf_is_valid(bufnr)
    and vim.api.nvim_buf_is_loaded(bufnr)
    and vim.bo[bufnr].buftype == ""
    and vim.bo[bufnr].modifiable
    and not vim.bo[bufnr].readonly
    and not ignored_filetype(vim.bo[bufnr].filetype)
end

function M.enabled(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  return eligible(bufnr) and vim.b[bufnr].minuet_duet_auto ~= false
end

local function has_highlight(value, highlight)
  if type(value) ~= "table" then return false end

  for _, item in ipairs(value) do
    if type(item) == "table" then
      if item[2] == highlight or has_highlight(item, highlight) then return true end
    end
  end

  return false
end

function M.review_info(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end

  local duet_ok, duet = pcall(require, "minuet.duet")
  if not duet_ok or not duet.action.is_visible() then
    return { available = false, noop = false }
  end

  local preview = require("minuet.duet.preview")
  local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, preview.ns_id, 0, -1, { details = true })
  local first_changed_row

  for _, extmark in ipairs(extmarks) do
    local details = extmark[4] or {}
    local changed = details.hl_group == "MinuetDuetDelete"
      or has_highlight(details.virt_text, "MinuetDuetAdd")
      or has_highlight(details.virt_lines, "MinuetDuetAdd")

    if changed then
      local row = extmark[2] + 1
      first_changed_row = first_changed_row and math.min(first_changed_row, row) or row
    end
  end

  if not first_changed_row then
    -- Upstream renders only a cursor extmark when the model returns the
    -- editable region unchanged. That is a stopping state, not a review.
    return { available = false, noop = true }
  end

  local current_buffer = bufnr == vim.api.nvim_get_current_buf()
  local first_visible = current_buffer and vim.fn.line("w0") or 0
  local last_visible = current_buffer and vim.fn.line("w$") or -1
  return {
    available = true,
    noop = false,
    line = first_changed_row,
    on_screen = first_changed_row >= first_visible and first_changed_row <= last_visible,
  }
end

function M.predict(force)
  if request_pending then return false end

  local bufnr = vim.api.nvim_get_current_buf()
  local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)
  if not force and last_auto_requested_tick[bufnr] == changedtick then
    return false
  end

  -- An automatic request is idempotent for a particular buffer version.
  -- Manual requests may override this check, but still establish the same
  -- baseline so an automatic request cannot immediately duplicate them.
  last_auto_requested_tick[bufnr] = changedtick
  require("minuet.duet").action.predict()
  return true
end

function M.schedule(bufnr, delay, caused_by_change)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if bufnr == 0 then bufnr = vim.api.nvim_get_current_buf() end
  if not M.enabled(bufnr) then return end

  if request_pending then
    if caused_by_change then
      queued_after_request[bufnr] = vim.api.nvim_buf_get_changedtick(bufnr)
    end
    generations[bufnr] = (generations[bufnr] or 0) + 1
    return
  end

  generations[bufnr] = (generations[bufnr] or 0) + 1
  local generation = generations[bufnr]

  vim.defer_fn(function()
    if generations[bufnr] ~= generation or not M.enabled(bufnr) then return end
    if vim.api.nvim_get_current_buf() ~= bufnr then return end

    if require("minuet.duet").action.is_visible() then return end

    if request_pending then
      if caused_by_change then
        queued_after_request[bufnr] = vim.api.nvim_buf_get_changedtick(bufnr)
      end
      return
    end

    M.predict()
  end, delay == nil and config.debounce or delay)
end

function M.apply()
  local bufnr = vim.api.nvim_get_current_buf()
  local duet = require("minuet.duet")
  local before = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  duet.action.apply()

  local after = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  applied_changedtick[bufnr] = vim.api.nvim_buf_get_changedtick(bufnr)

  -- An unchanged proposal is Minuet's stopping state. Do not immediately ask
  -- for another rewrite; wait until the user edits again.
  if M.enabled(bufnr) and not vim.deep_equal(before, after) then
    M.schedule(bufnr, 250, false)
  end
end

function M.toggle()
  local bufnr = vim.api.nvim_get_current_buf()
  local enabled = not M.enabled(bufnr)
  vim.b[bufnr].minuet_duet_auto = enabled

  if not enabled then
    generations[bufnr] = (generations[bufnr] or 0) + 1
    require("minuet.duet").action.dismiss()
  else
    last_auto_requested_tick[bufnr] = nil
    M.schedule(bufnr, 0)
  end

  vim.notify("Minuet Duet automatic predictions " .. (enabled and "enabled" or "disabled"))
  vim.cmd("redrawstatus")
end

function M.setup(options)
  if configured then return end
  configured = true
  config = vim.tbl_deep_extend("force", config, options or {})

  local group = vim.api.nvim_create_augroup("MinuetDuetAuto", { clear = true })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    callback = function(event)
      local changedtick = vim.api.nvim_buf_get_changedtick(event.buf)
      if applied_changedtick[event.buf] == changedtick then
        applied_changedtick[event.buf] = nil
        return
      end

      applied_changedtick[event.buf] = nil
      M.schedule(event.buf, nil, true)
    end,
    desc = "Minuet Duet: schedule automatic next-edit prediction",
  })

  vim.api.nvim_create_autocmd("InsertLeave", {
    group = group,
    callback = function(event) M.schedule(event.buf, 100) end,
    desc = "Minuet Duet: predict promptly after leaving Insert mode",
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MinuetDuetRequestStarted",
    callback = function()
      request_generation = request_generation + 1
      request_pending = true
      request_bufnr = vim.api.nvim_get_current_buf()
      request_started_tick[request_bufnr] = vim.api.nvim_buf_get_changedtick(request_bufnr)
      queued_after_request[request_bufnr] = nil
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = group,
    pattern = "MinuetDuetRequestFinished",
    callback = function()
      local bufnr = request_bufnr
      local finished_generation = request_generation

      -- RequestFinished fires just before Minuet parses and renders the
      -- response. Keep the request locked while that happens; otherwise a
      -- timer can start a new request and cancel a perfectly good response.
      if bufnr then
        vim.defer_fn(function()
          if finished_generation ~= request_generation then return end

          request_pending = false
          request_bufnr = nil
          if not vim.api.nvim_buf_is_valid(bufnr) then return end

          local review = M.review_info(bufnr)
          if review.noop then require("minuet.duet").action.dismiss() end

          local started_tick = request_started_tick[bufnr]
          local changed_since_start = started_tick
            and vim.api.nvim_buf_get_changedtick(bufnr) ~= started_tick
          local needs_retry = queued_after_request[bufnr] ~= nil or changed_since_start
          request_started_tick[bufnr] = nil
          queued_after_request[bufnr] = nil

          -- Retry exactly once only when real text changed while this request
          -- was running. Clean failures and no-op predictions are stopping
          -- states and wait for the next user edit.
          if needs_retry and M.enabled(bufnr) and not review.available then
            M.schedule(bufnr, 0, false)
          end

          vim.cmd("redrawstatus")
        end, 100)
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(event)
      generations[event.buf] = nil
      request_started_tick[event.buf] = nil
      queued_after_request[event.buf] = nil
      last_auto_requested_tick[event.buf] = nil
      applied_changedtick[event.buf] = nil
    end,
  })
end

return M
