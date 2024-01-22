-- Conform will run multiple formatters sequentially
-- python = { "isort", "black" },

-- Use a sub-list to run only the first available formatter
-- javascript = { { "prettierd", "prettier" } },

-- TODO: Add support for cbfmt for neorg
-- https://github.com/lukas-reineke/cbfmt/issues/37
return {
  formatters_by_ft = {
    go = { "gofmt", "goimports", "goimports-reviser", "gofumpt", "golines" },
    lua = { "stylua" },
    python = function(bufnr)
      if require("conform").get_formatter_info("ruff_format", bufnr).available then
        return { "ruff_format" }
      else
        return { "isort", "black" }
      end
    end,
    json = { { "prettierd", "prettier" } },
    markdown = { "prettierd", "cbfmt" },
    vimwiki = { "prettierd", "cbfmt" },
    javascript = { "prettierd" },
    typescript = { "prettierd" },
    rust = { "rustfmt" },
    sh = { "shfmt" },
    cmake = { "cmake_format" },
    css = { "prettierd" },
    html = { "prettierd" },
    sql = { "sql_formatter" },
    toml = { "taplo" },
    terraform = { "terraform_fmt" },
    yaml = { "prettierd" },
    nix = { "alejandra", "nixpkgs-fmt", "nixfmt" },
    -- Run formatter on all filetypes
    ["*"] = { "trim_whitespace" },
  },
}
