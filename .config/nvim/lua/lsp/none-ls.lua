local null_ls = require "null-ls"

local diagnostics = null_ls.builtins.diagnostics
-- local code_actions = null_ls.builtins.code_actions
local hover = null_ls.builtins.hover

-- Use this doc to extend existing formatters
-- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTIN_CONFIG.md
null_ls.setup {
  debug = false,
  log_level = "warn", -- "off", "error", "warn", "info", "debug", "trace"
  debounce = 3000,
  default_timeout = 5000,
  border = vim.g.border_style,
  sources = {
    -- ThePrimeagen's refactoring.nvim
    -- code_actions.refactoring,

    -- Static analysis tool for finding bugs and enforcing code standards, similar to sonarqube
    -- Languages supported: "typescript", "typescriptreact", "ruby", "python", "java", "go"
    -- diagnostics.semgrep.with {
    --   extra_args = { "--config", "auto" },
    -- },

    -- Fast linter and formatter for python
    -- Yet to add all the pylint rules in it, it is progressing fast
    require "none-ls.diagnostics.ruff",
    -- Detects unused python code
    -- diagnostics.vulture,

    -- diagnostics.staticcheck,
    -- diagnostics.golangci_lint,
    -- revive is not needed when we have golangci_lint
    -- diagnostics.revive,
    -- diagnostics.gospel,
    -- code_actions.gomodifytags,
    -- code_actions.impl,
    -- require("go.null_ls").gotest(),
    -- require("go.null_ls").gotest_action(),
    -- require("go.null_ls").golangci_lint(),

    -- Faster alternative to eslint for JS and TS
    -- diagnostics.deno_lint,
    require "none-ls.diagnostics.eslint_d",
    -- code_actions.eslint_d,
    -- diagnostics.typos.with {
    --   filetypes = { "markdown", "vimwiki" },
    -- },

    -- Spell and grammer related LSPs
    -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md#vale
    -- Faster alternative to textlint and proselint
    diagnostics.vale.with {
      extra_filetypes = { "vimwiki" },
    },
    -- LanguageTool rust client, which gets suggestions from LanguageTool server
    -- https://github.com/jeertmans/languagetool-rust
    -- diagnostics.ltrs.with {
    --   extra_filetypes = { "vimwiki" },
    -- },
    -- code_actions.ltrs.with {
    --   extra_filetypes = { "vimwiki" },
    -- },

    -- As of now it is not working with lspsaga hover_doc,
    -- use the <leader><L><k> mapping for lsp hover
    hover.dictionary.with {
      extra_filetypes = { "vimwiki" },
    },

    -- Git hunk actions to stage unstage changes
    -- code_actions.gitsigns,

    -- OpenAPI linter for yaml and json
    diagnostics.vacuum,

    -- diagnostics.dotenv_linter,
  },
}
