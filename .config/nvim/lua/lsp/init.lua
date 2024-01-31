local lspconfig_status_ok, lspconfig = pcall(require, 'lspconfig')
if not lspconfig_status_ok then
    return
end

local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, 'mason-lspconfig')
if not mason_lspconfig_status_ok then
    return
end

local lsp_utils = require "lsp.utils"
local lspconfig_ui = require "lspconfig.ui.windows"
lsp_utils.DiagnosticSignSetup()

-- Adding some lsp related config from kickstart.nvim
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua
require "lsp.mason-tool-installer"

-- Single flag to toggle efm-langserver and null-ls
-- Both serves the same purpose of providing support for external linters and formatters
-- As of now using null-ls as first priority because it provides support for range-formatting as well
vim.g.should_enable_efm = false

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables.
-- Look for server configurations here
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  pyright = require "lsp.servers.pyright",
  gopls = require "lsp.servers.gopls",
  rust_analyzer = require "lsp.servers.rust_analyzer",
  clangd = require "lsp.servers.clangd",
  jsonls = require "lsp.servers.jsonls",
  yamlls = require "lsp.servers.yamlls",
  lua_ls = require "lsp.servers.lua_ls",
  tsserver = require "lsp.servers.tsserver",
  vimls = require "lsp.servers.common",
  cssls = require "lsp.servers.common",
  html = require "lsp.servers.common",
  bashls = require "lsp.servers.common",
  dockerls = require "lsp.servers.common",
  terraformls = require "lsp.servers.common",
  sqlls = require "lsp.servers.common",
  marksman = require "lsp.servers.common",
  bufls = require "lsp.servers.common",
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    local server_config = servers[server_name] or {}
    lspconfig[server_name].setup(server_config)
  end,
}

-- Mason lspconfig doesn't support `nixd` yet
-- To install use: nix-env -iA nixpkgs.nixd
lspconfig.nixd.setup{}

if vim.g.should_enable_efm then
  -- print("Enabling efm-langserver")
  lspconfig.efm.setup(require "lsp.servers.efm")
end

lspconfig_ui.default_options.border = vim.g.border_style
