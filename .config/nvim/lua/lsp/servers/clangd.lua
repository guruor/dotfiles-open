local utils = require "utils"
local M = utils.merge({}, require "lsp.servers.common")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#clangd
-- Excluding `proto` filetype, proto will be handled from bufls
M.filetypes = { "c", "cpp", "objc", "objcpp", "cuda" }

return M
