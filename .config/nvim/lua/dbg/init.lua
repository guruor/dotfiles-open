local dap_status_ok, dap = pcall(require, 'dap')
if not dap_status_ok then
    return
end

local mason_nvim_dap_status_ok, mason_dap = pcall(require, 'mason-nvim-dap')
if not mason_nvim_dap_status_ok then
    return
end

-- https://alpha2phi.medium.com/neovim-dap-enhanced-ebc730ff498b
-- :DIInstall jsnode_dbg
-- :DIInstall go_delve_dbg
mason_dap.setup {
  ensure_installed = { "python", "delve", "codelldb", "js", "node2", "bash" },
  automatic_setup = true,
}

-- Setting log level possible values: TRACE, DEBUG, INFO, WARN, ERROR
dap.set_log_level "TRACE"

require("dbg.lua").setup(dap)
require("dbg.python").setup(dap)
require("dbg.go").setup(dap)
-- DAP setup for rust, c, cpp
require("dbg.lldb").setup(dap)

dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- Setup debugger UI layout
require "dbg.ui"
-- Enable virutal text, requires mfussenegger/nvim-dap-python, overide it with .vscode/launch.json
require("dap-python").setup(vim.fn.expand "~/.pyenv/versions/debugpy/bin/python")

-- Loads configurations from vscode Launch.json, adding it at end so it extends the existing configuration
require("dap.ext.vscode").load_launchjs()
