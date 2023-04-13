-- https://alpha2phi.medium.com/neovim-dap-enhanced-ebc730ff498b
-- :DIInstall jsnode_dbg
-- :DIInstall go_delve_dbg
local dap = require 'dap'
require("mason-nvim-dap").setup({
        ensure_installed = { "python", "delve", "codelldb", "js", "node2", "bash"},
        automatic_setup = true,
})


-- Setting log level possible values: TRACE, DEBUG, INFO, WARN, ERROR
dap.set_log_level("TRACE")

require("dbg.lua").setup(dap)
require("dbg.python").setup(dap)
require("dbg.go").setup(dap)
-- DAP setup for rust, c, cpp
require("dbg.lldb").setup(dap)

dap.configurations.c = dap.configurations.rust
dap.configurations.cpp = dap.configurations.rust

-- Enable virutal text, requires theHamsta/nvim-dap-virtual-text
require("nvim-dap-virtual-text").setup()
vim.g.dap_virtual_text = true
-- Enable virutal text, requires rcarriga/nvim-dap-ui
require("dapui").setup()
-- Enable virutal text, requires mfussenegger/nvim-dap-python, overide it with .vscode/launch.json
require('dap-python').setup(vim.fn.expand "~/.pyenv/versions/debugpy/bin/python")

-- Loads configurations from vscode Launch.json, adding it at end so it extends the existing configuration
require("dap.ext.vscode").load_launchjs()
