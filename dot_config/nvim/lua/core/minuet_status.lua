local M = {}

local state = {
  completion = { active = false, finished = 0, total = 1, generation = 0 },
  duet = { active = false, finished = 0, total = 1, generation = 0 },
  spinner_index = 1,
}

local spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_timer

local function redraw()
  vim.schedule(function()
    vim.cmd("redrawstatus")
  end)
end

local function stop_spinner_if_idle()
  if spinner_timer and not state.completion.active and not state.duet.active then
    spinner_timer:stop()
  end
end

local function start_spinner()
  if not spinner_timer or spinner_timer:is_closing() then
    spinner_timer = vim.uv.new_timer()
  end

  spinner_timer:stop()
  spinner_timer:start(0, 80, function()
    state.spinner_index = state.spinner_index % #spinner_symbols + 1
    redraw()
  end)
end

local function spinner()
  return spinner_symbols[state.spinner_index]
end

local function setup_events()
  local group = vim.api.nvim_create_augroup("MinuetStatusline", { clear = true })

  local function register(kind, prefix, finish_delay)
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = prefix .. "RequestStartedPre",
      callback = function(event)
        local current = state[kind]
        current.finished = 0
        current.total = event.data.n_requests or 1
        redraw()
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = prefix .. "RequestStarted",
      callback = function()
        local current = state[kind]
        current.generation = current.generation + 1
        current.active = true
        start_spinner()
        redraw()
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = prefix .. "RequestFinished",
      callback = function()
        local current = state[kind]
        local finished_generation = current.generation

        vim.defer_fn(function()
          if current.generation ~= finished_generation then return end
          current.finished = current.finished + 1
          current.active = current.finished < current.total
          stop_spinner_if_idle()
          redraw()
        end, finish_delay or 0)
      end,
    })
  end

  register("completion", "Minuet")
  -- Duet emits Finished before decoding and rendering its response. Keep the
  -- spinner continuous through that handoff and through an immediate retry.
  register("duet", "MinuetDuet", 150)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = group,
    callback = function()
      if spinner_timer and not spinner_timer:is_closing() then
        spinner_timer:stop()
        spinner_timer:close()
      end
    end,
  })
end

setup_events()

local function duet_review()
  local ok, auto = pcall(require, "core.minuet_duet_auto")
  return ok and auto.review_info() or { available = false }
end

function M.section()
  local narrow = vim.api.nvim_win_get_width(0) <= 75

  -- A ready prediction is actionable even when its preview is outside the
  -- viewport, so never hide this state on narrow windows.
  local review = duet_review()
  if review.available then
    local offscreen = not review.on_screen and (" @L%d"):format(review.line) or ""
    return narrow and ("󰄬 Tab%s"):format(offscreen)
      or ("󰄬 Tab: apply%s"):format(offscreen), "MiniStatuslineModeInsert"
  end

  if narrow then return "", "MiniStatuslineDevinfo" end

  if state.duet.active then
    return "󰙅 " .. spinner(), "MiniStatuslineDevinfo"
  end

  if state.completion.active then
    return "󱗻 " .. spinner(), "MiniStatuslineDevinfo"
  end

  local auto_ok, auto = pcall(require, "core.minuet_duet_auto")
  local duet_auto = auto_ok and auto.enabled() and " · 󰙅 Auto" or ""
  return "󱗻" .. duet_auto, "MiniStatuslineDevinfo"
end

return M
