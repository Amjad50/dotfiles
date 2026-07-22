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
    },
    config = function()
      local mc = require("minuet.config")

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
              chat_input = suffix_first and mc.default_chat_input or mc.default_chat_input_prefix_first,
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
        notify = "warn",
        enable_predicates = { can_complete },
        blink = {
          enable_auto_complete = true,
        },
        lsp = {
          enabled_ft = {},
          completion = { enable = false },
          inline_completion = { enable = false },
        },
        virtualtext = {
          -- Blink owns automatic AI completion; virtual text remains available
          -- for manual requests without sending duplicate automatic requests.
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
            optional = {
              max_tokens = 96,
              temperature = 0,
            },
          },
        },
      })
    end,
  },
}
