local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then
  return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status_ok then
  return
end

local lsp_utils = require "lsp.utils"
local lspconfig_ui = require "lspconfig.ui.windows"
lsp_utils.DiagnosticSignSetup()

-- Adding some lsp related config from kickstart.nvim
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
require "lsp.mason-tool-installer"

-- Single flag to toggle efm-langserver and none-ls
-- Both serves the same purpose of providing support for external linters and formatters
-- As of now using none-ls as first priority because it provides support for range-formatting as well
vim.g.should_enable_efm = false

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables.
-- Look for server configurations here
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
local servers = {
  -- snyk_ls = require "lsp.servers.common", -- vulnerabilities, open source dependencies
  ast_grep = require "lsp.servers.common", -- polyglot tool for code structural search, lint, rewriting at large scale
  harper_ls = require "lsp.servers.common", -- language checker for developers
  clangd = require "lsp.servers.clangd", -- "c", "cpp", "objc", "objcpp", "cuda", "proto"
  ruff = require "lsp.servers.ruff",
  -- pyright = require "lsp.servers.pyright",
  basedpyright = require "lsp.servers.basedpyright",
  gopls = require "lsp.servers.gopls",
  templ = require "lsp.servers.gopls", -- HTML templating language for Go
  -- rust_analyzer = require "lsp.servers.rust_analyzer", -- Already handled by rustaceanvim
  jsonls = require "lsp.servers.jsonls",
  ts_ls = require "lsp.servers.ts_ls",
  glint = require "lsp.servers.common", -- Handlebars
  yamlls = require "lsp.servers.yamlls",
  gitlab_ci_ls = require "lsp.servers.common",
  -- lua_ls = require "lsp.servers.lua_ls", -- lazydev.nvim is sufficient
  vimls = require "lsp.servers.common",
  cssls = require "lsp.servers.common",
  tailwindcss = require "lsp.servers.common",
  html = require "lsp.servers.common",
  -- htmx = require "lsp.servers.common", -- Causes problem with blink completions for js files
  bashls = require "lsp.servers.common",
  dockerls = require "lsp.servers.common",
  docker_compose_language_service = require "lsp.servers.common",
  terraformls = require "lsp.servers.common",
  sqls = require "lsp.servers.common",
  sqlls = require "lsp.servers.common",
  marksman = require "lsp.servers.common",
  powershell_es = require "lsp.servers.common",
  taplo = require "lsp.servers.common", -- TOML
  texlab = require "lsp.servers.common", -- LaTeX LSP, markdown
  vacuum = require "lsp.servers.common", -- OpenAPI 3, OpenAPI 2 / Swagger linter
  ansiblels = require "lsp.servers.common",
  neocmake = require "lsp.servers.common", -- For Cmake files
  helm_ls = require "lsp.servers.common",
  buf_ls = require "lsp.servers.common",
  lemminx = require "lsp.servers.common", -- XML LSP
  jinja_lsp = require "lsp.servers.common",
}

mason_lspconfig.setup {
  automatic_installation = true,
  ensure_installed = vim.tbl_keys(servers),
  automatic_enable = false,
}

for server_name, server_config in pairs(servers) do
  lspconfig[server_name].setup(server_config)
end

-- Mason lspconfig doesn't support `nixd` yet
-- To install use: nix-env -iA nixpkgs.nixd
lspconfig.nixd.setup {}

if vim.g.should_enable_efm then
  -- print("Enabling efm-langserver")
  lspconfig.efm.setup(require "lsp.servers.efm")
end

lspconfig_ui.default_options.border = vim.g.border_style
