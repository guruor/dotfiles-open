local status_ok, mason = pcall(require, 'mason')
if not status_ok then
    return
end

local mason_tool_installer_status_ok, mason_tool_installer = pcall(require, 'mason-tool-installer')
if not mason_tool_installer_status_ok then
    return
end

mason.setup {
  ui = {
    border = vim.g.border_style,
  },
}

-- https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md#eslint-lsp
local language_servers = {
  'clangd', 'gopls', 'pyright', 'rust-analyzer', 'vim-language-server', 'json-lsp',
  'yaml-language-server', 'css-lsp', 'html-lsp', 'dockerfile-language-server',
  'terraform-ls', 'typescript-language-server', 'sqlls',
  'vim-language-server', 'lua-language-server',
  'buf-language-server',
  -- 'nil_ls',
  -- 'efm',
  -- you can pin a tool to a particular version
  -- { 'golangci-lint', version = 'v1.47.0' },
  -- you can turn off/on auto_update per tool
  -- { 'bash-language-server', auto_update = true },
}

local linters_and_formatters = {
    "ruff",
    "goimports", "staticcheck",  "json-to-struct", "gotests", "gomodifytags", "golines", "gofumpt", "impl", "revive",
    "jq", "fixjson",
    "prettierd", "markdownlint", "cbfmt",
    "vale",
    "stylua", "luaformatter", "luacheck",
    "vint",
    "shellcheck",
    "yamlfmt",
    "eslint_d", "terraform-ls", "tflint", "editorconfig-checker",
    "sql-formatter",
    "buf",
}

local debuggers = {
    "debugpy", "delve", "go-debug-adapter",
}

local final_tools = vim.list_extend(language_servers, linters_and_formatters)
final_tools = vim.list_extend(final_tools, debuggers)

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

