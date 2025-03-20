-- Conform will run multiple formatters sequentially
-- python = { "isort", "black" },

-- Use a sub-list to run only the first available formatter
-- javascript = { "biome", "dprint", "prettierd", "prettier", stop_after_first = true },

-- TODO: Add support for cbfmt for neorg
-- https://github.com/lukas-reineke/cbfmt/issues/37
--
-- List of supported formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
return {
  formatters_by_ft = {
    go = { "gofmt", "goimports", "goimports-reviser", "gofumpt", "golines" },
    lua = { "stylua" },
    python = { "ruff_format", "ruff_fix" },
    -- As of now biome supports only js, ts and json
    -- https://biomejs.dev/internals/language-support/
    json = { "biome", "dprint", "prettierd", "yq", stop_after_first = true },
    javascript = { "biome", "dprint", "prettierd", stop_after_first = true },
    typescript = { "biome", "dprint", "prettierd", stop_after_first = true },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    bash = { "shfmt" },
    zsh = { "shfmt" },
    cmake = { "cmake_format" },
    css = { "dprint", "prettierd" },
    html = { "dprint", "prettierd" },
    sql = { "sql_formatter" },
    toml = { "taplo" },
    terraform = { "terraform_fmt" },
    yaml = { "yamlfmt", "dprint", "prettierd", "yq", stop_after_first = true },
    nix = { "alejandra", "nixpkgs-fmt", "nixfmt" },
    markdown = { "dprint", "prettierd", "cbfmt" },
    vimwiki = { "dprint", "prettierd", "cbfmt" },
    -- Run formatter on all filetypes
    ["*"] = { "trim_whitespace" },
  },
}
