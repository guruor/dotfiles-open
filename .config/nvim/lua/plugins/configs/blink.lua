return {
  keymap = {
    preset = "default",
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<S-k>"] = { "scroll_documentation_up", "fallback" },
    ["<S-j>"] = { "scroll_documentation_down", "fallback" },
    ["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_and_accept()
        end
      end,
      "snippet_forward",
      "fallback",
    },
    ["<S-Tab>"] = { "snippet_backward", "fallback" },
  },
  cmdline = {
    keymap = {
      preset = "inherit",
      ["<Tab>"] = { "show_and_insert", "select_and_accept" },
      ["<S-Tab>"] = { "show_and_insert", "select_prev" },
    },
    completion = { menu = { auto_show = true } },
  },
  fuzzy = { implementation = "prefer_rust_with_warning" },
  signature = { enabled = true },
  appearance = {
    nerd_font_variant = "mono",
  },
  completion = {
    menu = {
      border = "rounded",
      draw = {
        treesitter = { "lsp" },
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },
      },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 250,
      window = {
        border = "rounded",
      },
    },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "git", "copilot", "dictionary", "dap" },
    per_filetype = {
      sql = { inherit_defaults = true, "dadbod" },
      lua = { inherit_defaults = true, "lazydev" },
      codecompanion = { "codecompanion" },
      ["dap-repl"] = { "dap", score_offset = 200 },
      ["dapui_watches"] = { "dap", score_offset = 200 },
      ["dapui_hover"] = { "dap", score_offset = 200 },
    },
    providers = {
      lsp = {
        name = "Lsp",
        module = "blink.cmp.sources.lsp",
        score_offset = 100, -- the higher the number, the higher the priority
        enabled = true,
        min_keyword_length = 2,
      },
      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
        score_offset = 95,
        -- When typing a path, I would get snippets and text in the
        -- suggestions, I want those to show only if there are no path
        -- suggestions
        fallbacks = { "snippets", "buffer" },
        -- min_keyword_length = 2,
        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          get_cwd = function(context)
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
          show_hidden_files_by_default = true,
        },
      },
      buffer = {
        name = "Buffer",
        module = "blink.cmp.sources.buffer",
        enabled = true,
        score_offset = 95,
        max_items = 3,
        min_keyword_length = 2,
      },
      snippets = {
        name = "Snippets",
        module = "blink.cmp.sources.snippets",
        score_offset = 100,
        enabled = true,
        max_items = 8,
        min_keyword_length = 2,
      },
      dadbod = {
        name = "Dadbod",
        module = "vim_dadbod_completion.blink",
        score_offset = 100,
        min_keyword_length = 2,
      },
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
      copilot = {
        name = "Copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
        min_keyword_length = 5,
      },
      git = {
        name = "Git",
        module = "blink-cmp-git",
        score_offset = 100,
        min_keyword_length = 3,
        opts = {},
      },
      -- brew install wordnet
      dictionary = {
        name = "Dict",
        module = "blink-cmp-dictionary",
        score_offset = 80,
        min_keyword_length = 4,
        max_items = 8,
        opts = {
          dictionary_directories = function()
            return { vim.fn.expand "~/.config/nvim/dictionary" }
          end,
        },
      },
      dap = {
        name = "DAP",
        module = "blink.compat.source",
        enabled = function()
          return require("cmp_dap").is_dap_buffer()
        end,
      },
    },
  },
}
