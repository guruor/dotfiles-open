-- Conform will run multiple formatters sequentially
-- python = { "isort", "black" },

-- Use a sub-list to run only the first available formatter
-- javascript = { "biome", "dprint", "prettierd", "prettier", stop_after_first = true },

-- TODO: Add support for cbfmt for neorg
-- https://github.com/lukas-reineke/cbfmt/issues/37
--
-- List of supported formatters: https://github.com/stevearc/conform.nvim?tab=readme-ov-file#formatters
--
-- https://biomejs.dev/internals/language-support/
local biome_supported_fts = {
  "astro",
  "css",
  "graphql",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}

local function set_biome_formatter(formatters_by_ft)
  for _, ft in ipairs(biome_supported_fts) do
    formatters_by_ft[ft] = formatters_by_ft[ft] or {}
    table.insert(formatters_by_ft[ft], "biome")
    table.insert(formatters_by_ft[ft], "biome-organize-imports")
  end
end

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
  -- javascript = { "biome", "biome-organize-imports", "dprint", "prettierd", "prettier", stop_after_first = true },
  rust = { "rustfmt" },
  sh = { "shfmt" },
  bash = { "shfmt" },
  zsh = { "shfmt" },
  cmake = { "cmake_format" },
  -- html = { "dprint", "prettierd" },
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
set_biome_formatter(formatters_by_ft)

return {
  formatters_by_ft = formatters_by_ft,
}
