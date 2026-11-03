local function can_complete()
  local buf = vim.api.nvim_get_current_buf()
  return vim.bo[buf].buftype == ""
    and vim.bo[buf].modifiable
    and not vim.bo[buf].readonly
    and vim.bo[buf].filetype ~= "bigfile"
end

return {
  {
    "milanglacier/minuet-ai.nvim",
    -- Set up the FileType autocmds before opening a code buffer and avoid a
    -- first-completion load penalty.
    lazy = false,
    keys = {
      {
        "<A-t>",
        function() require("minuet.virtualtext").action.toggle_auto_trigger() end,
        mode = { "n", "i" },
        desc = "Minuet: toggle automatic inline completion",
      },
      {
        "<leader>ap",
        function()
          local minuet = require("minuet")
          local presets = vim.tbl_keys(minuet.presets)
          table.sort(presets)
          vim.ui.select(presets, { prompt = "Minuet preset:" }, function(choice)
            if choice then minuet.change_preset(choice) end
          end)
        end,
        desc = "Minuet: select completion preset",
      },
      {
        "<leader>dp",
        function() require("core.minuet_duet_auto").predict(true) end,
        mode = { "n", "i" },
        desc = "Minuet Duet: predict next edit",
      },
      {
        "<A-d>",
        function() require("core.minuet_duet_auto").predict(true) end,
        mode = { "n", "i" },
        desc = "Minuet Duet: predict next edit now",
      },
      {
        "<leader>da",
        function() require("core.minuet_duet_auto").apply() end,
        mode = { "n", "i" },
        desc = "Minuet Duet: apply predicted edit",
      },
      {
        "<leader>dd",
        function() require("minuet.duet").action.dismiss() end,
        mode = { "n", "i" },
        desc = "Minuet Duet: dismiss predicted edit",
      },
      {
        "<leader>dt",
        function() require("core.minuet_duet_auto").toggle() end,
        mode = { "n", "i" },
        desc = "Minuet Duet: toggle automatic predictions",
      },
      {
        "<Tab>",
        function()
          local duet = require("minuet.duet")
          if duet.action.is_visible() then
            vim.schedule(require("core.minuet_duet_auto").apply)
            return
          end

          vim.api.nvim_feedkeys(vim.keycode("<C-i>"), "n", false)
        end,
        mode = "n",
        desc = "Minuet Duet: apply prediction or jump forward",
      },
    },
    config = function()
      local mc = require("minuet.config")
      local duet_defaults = require("minuet.duet.config")
      local diagnostic_context = require("core.minuet_diagnostics")
      local default_duet_guidelines =
        duet_defaults.provider_options.openai_compatible.system.guidelines

      local function completion_fim_template()
        return {
          prompt = function(context_before_cursor, context_after_cursor, opts)
            local diagnostics = diagnostic_context.render_commented()
            local prompt = mc.default_fim_template.prompt(context_before_cursor, context_after_cursor, opts)
            return diagnostics == "" and prompt or diagnostics .. "\n" .. prompt
          end,
          suffix = mc.default_fim_template.suffix,
        }
      end

      local function completion_chat_input(suffix_first)
        local chat_input = vim.deepcopy(
          suffix_first and mc.default_chat_input or mc.default_chat_input_prefix_first
        )
        chat_input.template = "{{{diagnostics}}}\n" .. chat_input.template
        chat_input.diagnostics = function() return diagnostic_context.render() end
        return chat_input
      end

      local duet_chat_input = vim.deepcopy(
        duet_defaults.provider_options.openai_compatible.chat_input
      )
      local duet_template = duet_chat_input.template
      duet_chat_input.template = function()
        return "{{{diagnostics}}}\n" .. duet_template()
      end
      duet_chat_input.diagnostics = function(context)
        local before_cursor = context.editable_region_before_cursor or ""
        local _, newline_count = before_cursor:gsub("\n", "")
        local row = (context.range and context.range.start_row or 0) + newline_count
        return diagnostic_context.render(context.bufnr, row)
      end

      local function deepseek_fim_preset(options)
        return vim.tbl_deep_extend("force", {
          provider = "openai_fim_compatible",
          request_timeout = 2.5,
          throttle = 500,
          debounce = 200,
          context_window = 10000,
          context_ratio = 0.75,
          n_completions = 1,
          provider_options = {
            openai_fim_compatible = {
              api_key = "DEEPSEEK_API_KEY",
              end_point = "https://api.deepseek.com/beta/completions",
              model = "deepseek-v4-flash",
              name = "Deepseek",
              stream = true,
              template = completion_fim_template(),
              optional = {
                max_tokens = 96,
                temperature = 0,
              },
            },
          },
        }, options or {})
      end

      local function openrouter_preset(model, route, suffix_first)
        return {
          provider = "openai_compatible",
          request_timeout = 2.5,
          throttle = 500,
          debounce = 200,
          context_window = 10000,
          context_ratio = 0.75,
          n_completions = 1,
          provider_options = {
            openai_compatible = {
              api_key = "OPENROUTER_API_KEY",
              end_point = "https://openrouter.ai/api/v1/chat/completions",
              model = model,
              name = "OpenRouter",
              stream = true,
              system = suffix_first and mc.default_system or mc.default_system_prefix_first,
              few_shots = suffix_first and mc.default_few_shots or mc.default_few_shots_prefix_first,
              chat_input = completion_chat_input(suffix_first),
              optional = {
                max_tokens = 96,
                temperature = 0,
                stop = { "<endCompletion>" },
                reasoning = { effort = "none" },
                provider = { sort = route },
              },
            },
          },
        }
      end

      require("minuet").setup({
        provider = "openai_fim_compatible",
        request_timeout = 2.5,
        throttle = 500,
        debounce = 200,
        context_window = 10000,
        context_ratio = 0.75,
        n_completions = 1,
        notify = "error",
        enable_predicates = { can_complete },
        duet = {
          provider = "openai_compatible",
          request_timeout = 15,
          editable_region = {
            lines_before = 6,
            lines_after = 10,
            before_region_filter_length = 30,
            after_region_filter_length = 30,
          },
          non_editable_region = {
            context_window = 12000,
            context_ratio = 0.75,
          },
          preview = {
            cursor = "▌",
          },
          provider_options = {
            openai_compatible = {
              api_key = "DEEPSEEK_API_KEY",
              end_point = "https://api.deepseek.com/chat/completions",
              model = "deepseek-v4-flash",
              name = "Deepseek",
              chat_input = duet_chat_input,
              system = {
                guidelines = function()
                  return default_duet_guidelines()
                    .. [[

8. Use nearby diagnostics to guide a fix when they are relevant to the editable region. Do not change unrelated code merely because a diagnostic is listed.
9. If the code is already coherent and no next edit is needed,
   preserve the editable region verbatim and only retain the cursor marker.
10. Always finish the response with exactly one closing editable-region marker. Never stop before emitting it.]]
                end,
              },
              optional = {
                max_tokens = 4096,
                temperature = 0,
                thinking = { type = "disabled" },
              },
            },
          },
        },
        blink = {
          -- Keep the source available through <A-y>, but avoid racing an
          -- automatic Duet request with a second automatic AI request.
          enable_auto_complete = false,
        },
        lsp = {
          enabled_ft = {},
          completion = { enable = false },
          inline_completion = { enable = false },
        },
        virtualtext = {
          -- Duet owns automatic AI prediction; virtual text remains available
          -- for manual FIM requests without sending duplicate requests.
          auto_trigger_ft = {},
          auto_trigger_ignore_ft = {
            "help",
            "terminal",
            "prompt",
            "TelescopePrompt",
            "snacks_dashboard",
            "dashboard",
            "alpha",
            "lazy",
            "mason",
            "neo-tree",
            "qf",
            "DiffviewFiles",
            "bigfile",
          },
          keymap = {
            accept = "<A-l>",
            accept_line = "<A-j>",
            next = "<A-n>",
            prev = "<A-p>",
            dismiss = "<A-e>",
          },
          show_on_completion_menu = false,
        },
        presets = {
          deepseek_fim_fast = deepseek_fim_preset(),
          deepseek_fim_large_context = deepseek_fim_preset({
            request_timeout = 4,
            throttle = 700,
            debounce = 250,
            context_window = 16000,
            provider_options = {
              openai_fim_compatible = {
                optional = {
                  max_tokens = 128,
                  temperature = 0,
                },
              },
            },
          }),
          openrouter_deepseek_latency =
            openrouter_preset("deepseek/deepseek-v4-flash", "latency"),
          openrouter_deepseek_throughput =
            openrouter_preset("deepseek/deepseek-v4-flash", "throughput"),
          openrouter_deepseek_suffix_first =
            openrouter_preset("deepseek/deepseek-v4-flash", "latency", true),
          openrouter_qwen3_coder =
            openrouter_preset("qwen/qwen3-coder-next", "latency"),
        },
        provider_options = {
          openai_fim_compatible = {
            api_key = "DEEPSEEK_API_KEY",
            end_point = "https://api.deepseek.com/beta/completions",
            model = "deepseek-v4-flash",
            name = "Deepseek",
            stream = true,
            template = completion_fim_template(),
            optional = {
              max_tokens = 96,
              temperature = 0,
            },
          },
        },
      })

      require("core.minuet_duet_auto").setup({
        debounce = 450,
        ignore_filetypes = {
          "help",
          "terminal",
          "prompt",
          "TelescopePrompt",
          "snacks_dashboard",
          "dashboard",
          "alpha",
          "lazy",
          "mason",
          "neo-tree",
          "qf",
          "DiffviewFiles",
          "bigfile",
        },
      })
    end,
  },
}
