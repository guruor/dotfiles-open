return {
  -- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
  linters_by_ft = {
    -- python = { "ruff" },
    -- Vulture detects unused python code
    python = { "vulture" },
    -- revive is not needed when we have golangci_lint
    -- go = { "revive" },
    go = { "golangcilint"  },
    sh = { "shellcheck" },
    bash = { "shellcheck" },
    zsh = { "shellcheck" },
    json = { "biomejs" },

    -- Faster alternative to eslint for JS and TS
    -- javascript = { "eslint_d" },
    javascript = { "biomejs" },
    typescript = { "biomejs" },
    -- markdown = { "typos" },
    markdown = { "vale" },
    vimwiki = { "vale" },
    norg = { "vale" },

    -- diagnostics.dotenv_linter,
    -- env = { "dotenv_linter" },
  },
}
