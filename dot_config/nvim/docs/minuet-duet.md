# Minuet Duet

Duet uses the native DeepSeek API and `deepseek-v4-flash`. A local integration
automatically requests a next-edit prediction 450 ms after editing stops. It
rewrites a small editable region around the cursor and presents the result as
an in-buffer diff before making any changes.

The automatic scheduler does not poll or retry continuously. It sends at most
one request for a stable edit, reruns only when the user changed the buffer
during an in-flight request, and stops after an unchanged proposal. Invalid
provider output also stops instead of being retried automatically.

## Keymaps

- `<leader>dp`: predict the next edit.
- `<A-d>`: predict immediately without waiting for the automatic debounce.
- `<leader>da`: apply the visible prediction.
- `<leader>dd`: dismiss the visible prediction.
- `<leader>dt`: toggle automatic Duet predictions for the current buffer.
- `<Tab>`: apply the prediction in Insert or Normal mode. After applying an
  edit, another prediction is scheduled automatically.

The leader key is `,`, so the normal-mode forms are `,dp`, `,da`, `,dd`, and
`,dt`.

Minuet remains registered as a Blink source, but automatic Blink AI requests
are disabled to avoid racing Duet and duplicating API usage. `<A-y>` manually
requests a Minuet-only Blink menu when wanted.

The statusline intentionally omits provider and model names. It shows a compact
idle/automatic state, an animated spinner while Minuet is generating, and
`󰄬 Tab: apply` while a real Duet diff is ready. If its first changed line is
outside the viewport, the status also shows its location, for example `@L42`.
Cursor-only, unchanged predictions are dismissed as a stopping state.

## Benchmark summary

The smoke test used four completion-like edits and four next-edit rename cases
in Rust, TypeScript, Go, and Python. Every recorded response passed Minuet's
strict editable-region and cursor-marker parser.

| Target | Targeted edits | Typical total time | Notes |
| --- | ---: | ---: | --- |
| OpenRouter Qwen3 Coder Next | 7/8 | 0.8–1.8 s | Best at preserving the user's latest edit |
| Native DeepSeek V4 Flash | 6/8 | 1.0–1.8 s | Fast, but invented extra fields in several cases |
| OpenRouter DeepSeek V4 Flash | 6/8 | 1.7–7.2 s | Similar output to native DeepSeek, much slower |
| OpenRouter Gemini 3.1 Flash Lite | 4/8 | 0.9–1.4 s | Fastest, but often reverted the user's edit |

Qwen produced the highest benchmark score, but native DeepSeek is the enabled
default because it was still useful in 6/8 cases, stayed around 1.0–1.8 seconds,
and is substantially cheaper through the direct API.
