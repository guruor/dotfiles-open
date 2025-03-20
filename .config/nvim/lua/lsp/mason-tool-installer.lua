local status_ok, mason = pcall(require, "mason")
if not status_ok then
  return
end

local mason_tool_installer_status_ok, mason_tool_installer = pcall(require, "mason-tool-installer")
if not mason_tool_installer_status_ok then
  return
end

mason.setup {
  PATH = "append",
  ui = {
    border = vim.g.border_style,
  },
}

-- LSP are installed using mason-lspconfig, ./init.lua
-- only ones are not handled by that are mentioned here
-- https://mason-registry.dev/registry/list
local language_servers = {
  "buf-language-server",
  -- 'nil_ls',
  -- 'efm',
  -- you can pin a tool to a particular version
  -- { 'golangci-lint', version = 'v1.47.0' },
  -- you can turn off/on auto_update per tool
  -- { 'bash-language-server', auto_update = true },
}

-- Formatters are mostly installed by mason-conform, ../plugins/configs/conform.lua
local formatters = {
  "gotests",
  "gomodifytags",
}
-- Linters are mostly installed by mason-nvim-lint, ../plugins/configs/nvim-lint.lua
-- only ones are not handled by them are mentioned here
-- https://mason-registry.dev/registry/list
local linters = {
  "staticcheck",
  "editorconfig-checker",
  -- static analysis
  "semgrep",
  -- Security, vulnerabilities, misconfigurations, secret scan
  "trivy",
  "trufflehog", -- leaked secrets
}

local tools = {
  "json-to-struct",
  "impl",
  "jq",
}

-- Debuggers or DAP are installed using mason-dap, ../dbg/init.lua
-- only ones are not handled by that are mentioned here
local debuggers = {
  "go-debug-adapter",
}

local final_tools = vim.list_extend(language_servers, linters)
final_tools = vim.list_extend(final_tools, formatters)
final_tools = vim.list_extend(final_tools, debuggers)
final_tools = vim.list_extend(final_tools, tools)

mason_tool_installer.setup {
  -- a list of all tools you want to ensure are installed upon
  -- start; they should be the names Mason uses for each tool
  ensure_installed = final_tools,

  -- if set to true this will check each tool for updates. If updates
  -- are available the tool will be updated. This setting does not
  -- affect :MasonToolsUpdate or :MasonToolsInstall.
  -- Default: false
  auto_update = true,

  -- automatically install / update on startup. If set to false nothing
  -- will happen on startup. You can use :MasonToolsInstall or
  -- :MasonToolsUpdate to install tools and check for updates.
  -- Default: true
  run_on_start = false,

  -- set a delay (in ms) before the installation starts. This is only
  -- effective if run_on_start is set to true.
  -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
  -- Default: 0
  start_delay = 3000, -- 3 second delay

  -- Only attempt to install if 'debounce_hours' number of hours has
  -- elapsed since the last time Neovim was started. This stores a
  -- timestamp in a file named stdpath('data')/mason-tool-installer-debounce.
  -- This is only relevant when you are using 'run_on_start'. It has no
  -- effect when running manually via ':MasonToolsInstall' etc....
  -- Default: nil
  debounce_hours = 5, -- at least 5 hours between attempts to install/update
}
