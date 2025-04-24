-- Conform will run multiple formatters sequentially
-- python = { "isort", "black" },

-- Use a sub-list to run only the first available formatter
-- javascript = { "biome", "dprint", "prettierd", "prettier", stop_after_first = true },

-- TODO: Add support for cbfmt for neorg
-- https://github.com/lukas-reineke/cbfmt/issues/37
--
-- List of supported formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
local function set_sql_formatter()
  local cwd = vim.fn.getcwd()
  local cwd_final_name = cwd:match "([^/]+)$"

  local dbt_projects_env = tostring(vim.fn.getenv "DBT_PROJECTS_LIST" or "")
  local dbt_projects = {}
  for project in string.gmatch(dbt_projects_env, "([^,]+)") do
    table.insert(dbt_projects, project)
  end

  for _, project_name in ipairs(dbt_projects) do
    if cwd_final_name == project_name then
      return { "sqlfmt" }
    end
  end

  return { "sql_formatter" }
end

local formatters_by_ft = {
  go = { "gofmt", "goimports", "goimports-reviser", "gofumpt", "golines" },
  lua = { "stylua" },
  python = { "ruff_format", "ruff_fix" },
  -- As of now biome supports only js, ts and json
  -- https://biomejs.dev/internals/language-support/
  json = { "biome", "dprint", "prettierd", "yq", stop_after_first = true },
  javascript = { "biome", "biome-organize-imports" },
  typescript = { "biome", "biome-organize-imports" },
  typescriptreact = { "biome", "biome-organize-imports" },
  javascriptreact = { "biome", "biome-organize-imports" },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  zsh = { "shfmt" },
  cmake = { "cmake_format" },
  css = { "dprint", "prettierd" },
  html = { "dprint", "prettierd" },
  toml = { "taplo" },
  terraform = { "terraform_fmt" },
  yaml = { "yamlfmt", "dprint", "prettierd", "yq", stop_after_first = true },
  nix = { "nixpkgs-fmt", "nixfmt" },
  markdown = { "dprint", "prettierd", "cbfmt" },
  vimwiki = { "dprint", "prettierd", "cbfmt" },
  -- Run formatter on all filetypes
  ["*"] = { "trim_whitespace" },
}

formatters_by_ft["sql"] = set_sql_formatter(vim.fn.bufnr())
P(formatters_by_ft)

return {
  formatters_by_ft = formatters_by_ft,
}
